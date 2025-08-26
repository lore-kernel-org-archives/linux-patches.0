Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0D8341642;
	Tue, 26 Aug 2025 11:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207206; cv=none; b=UV1MSd+o15jc5V4JSXUqWND6UYfD5Gn/5AIQt7DjPKphLc4mg+P7IyP166TKIXqP7xrJEpQGwGOtOmC8biGSeNxecWYcL4X+SC2QcYPUjduPpyF8SBag8NEXlaWAKkG3dIzzaq1DmT1Jg5CV98mVhTnH7+++nip4L66CLuys39s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207206; c=relaxed/simple;
	bh=c2Ie9KciATxhc+er+Elv0LSLRr08g10SBi7cwvpwxPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LpuLMyx1b6xc3/jyyinhHE9sT/rfVV1KD5qNe0OoDvcPRgq8bL0x82aILdATGq8E2bhDNDlpfNIXZmoliXDUxspQ3WeT6grTbIz7vL9tuGzYnVRZFSZI+TTAA/xkTC6vOlO83tA7eExDUMJAkagkkMnVy7e7kuhiekWTH8QKdAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJa6ScnA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJa6ScnA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30CAC4CEF1;
	Tue, 26 Aug 2025 11:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207206;
	bh=c2Ie9KciATxhc+er+Elv0LSLRr08g10SBi7cwvpwxPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gJa6ScnAS5vnmlkwMBUDxvCcF2c9vfRQIBbYSS+e4MCsooiHlB8MUyI0xOc6xjNKl
	 ncxo4SLKDLlfToZ+ncgVGmu3F0G97jizU3kFozGoDmH9ylkbOWyPSIOllkLUrTAZnA
	 w89USpH4LbMOrcxBtrJiJBkdQBniof3JNJx7hkeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.16 092/457] mtd: spinand: propagate spinand_wait() errors from spinand_write_page()
Date: Tue, 26 Aug 2025 13:06:16 +0200
Message-ID: <20250826110939.652326665@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -688,7 +688,10 @@ int spinand_write_page(struct spinand_de
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


