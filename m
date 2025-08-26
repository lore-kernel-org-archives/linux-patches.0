Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785862D191E;
	Tue, 26 Aug 2025 13:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214880; cv=none; b=R43hzK8cJHZ9oAwO69iGSgGLmb+xb00UTuH2grcJPYl3PQO1yR4ZrNJLLGIKMdofk2Cph8Je3WM8dCDuPKSn9QZzScUZraB6GAcTkITSPAwFvmU1IU9ke1XM1t5tftp9ns9jDBJ8Agg0ikFpsXt7fw0tLijDDSdgWTUluLPaycU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214880; c=relaxed/simple;
	bh=N0aIvJx2MYzbdC083oa3y6jCUtO6dmNImfDktXtIp+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCw4OVHe6C+WOlq1w47w3J2b+zMj2Ngg+ucbfBNz0jBWl23Dib2x8yqAsPM4nILIcwoLKKAhbR9weQAVxWEMJkVBhBONg+rnCmzi4UOKVKxqL6OTQHUOpZJlLwhSg11rIdjvBjKUQc63ynzeqEEorq+vKpXtVATsNzFFq69tWp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WqNSxFTd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WqNSxFTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DBABC113D0;
	Tue, 26 Aug 2025 13:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214880;
	bh=N0aIvJx2MYzbdC083oa3y6jCUtO6dmNImfDktXtIp+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WqNSxFTd5DQ2QsiFoB4UefMzjPQhHMAyGpghn+W2R7+aodNPYhU7elkFwWG5PRLAB
	 bUg1KeXOKGq7QLpujJ45EKlxZJSBTPFBWU6fO2ksEV88YzDKbp2NuuPcqsLsS0cBpH
	 DvhJTzk/WLK0wWGs4RmZI4FBqIn+JeNTjt1413hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 304/482] mtd: spinand: propagate spinand_wait() errors from spinand_write_page()
Date: Tue, 26 Aug 2025 13:09:17 +0200
Message-ID: <20250826110938.310579828@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

commit 091d9e35b85b0f8f7e1c73535299f91364a5c73a upstream.

Since commit 3d1f08b032dc ("mtd: spinand: Use the external ECC engine
logic") the spinand_write_page() function ignores the errors returned
by spinand_wait(). Change the code to propagate those up to the stack
as it was done before the offending change.

Cc: stable@vger.kernel.org
Fixes: 3d1f08b032dc ("mtd: spinand: Use the external ECC engine logic")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/spi/core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -624,7 +624,10 @@ static int spinand_write_page(struct spi
 			   SPINAND_WRITE_INITIAL_DELAY_US,
 			   SPINAND_WRITE_POLL_DELAY_US,
 			   &status);
-	if (!ret && (status & STATUS_PROG_FAILED))
+	if (ret)
+		return ret;
+
+	if (status & STATUS_PROG_FAILED)
 		return -EIO;
 
 	return nand_ecc_finish_io_req(nand, (struct nand_page_io_req *)req);


