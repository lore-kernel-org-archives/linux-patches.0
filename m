Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E742622DFB8;
	Tue, 26 Aug 2025 13:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215588; cv=none; b=qLpjWnCPOELEeIbQ8Ep3XJ3DGQ+3uBO3ICNvvxy5xUY8EkUDf0Ilq1mX6up1RQ1mXtqCUrFQ4NuFB65y9PoejfdVGJQagwPtEfVERmiDYFLd0OgwG9yu5PBUBnLmVHqv0EeuHNOwdHnOYdNUtOfSfFe1K8oC3xHYjhlAkThVt8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215588; c=relaxed/simple;
	bh=tRib6fS2SSXKfQuHnkB/FTosCmI1VY99MlyMQbF3Y/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GS52khOOXKH1pMSuMQuwOwhNMzNxrcmEwyg6YVtXWLrgpP1CMNZKJ5/2j/GPAgHgBwxJ+AybEpeBpAPtPRqTZNU4XNGto9bYYXqsqt1Jnobb0C5A6NlTWZGtl0N4GBWCyWG8ngOcJG5RJM7mJdS7irAVSKdHSfcRrXVCljuABxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oGoqdYb/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oGoqdYb/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE63C4CEF1;
	Tue, 26 Aug 2025 13:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215587;
	bh=tRib6fS2SSXKfQuHnkB/FTosCmI1VY99MlyMQbF3Y/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oGoqdYb/gZB+CWTvjUsvuiYN5GNWpz13SA+2pS21JjyEktedaSPh63dS5HH9ubtUc
	 WnOMStmdEutmH7maJ8/yRHeLHOkDTRp3XaDyHOE1zhLjiFCJ/Py4r8W/eYef3oxjfE
	 5qZA2ikR/lXgnZphmOGjgCMSlyerX7tKBQlyFBR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Xiwen <forbidden405@outlook.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.15 089/644] i2c: qup: jump out of the loop in case of timeout
Date: Tue, 26 Aug 2025 13:03:00 +0200
Message-ID: <20250826110948.706648747@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Xiwen <forbidden405@outlook.com>

commit a7982a14b3012527a9583d12525cd0dc9f8d8934 upstream.

Original logic only sets the return value but doesn't jump out of the
loop if the bus is kept active by a client. This is not expected. A
malicious or buggy i2c client can hang the kernel in this case and
should be avoided. This is observed during a long time test with a
PCA953x GPIO extender.

Fix it by changing the logic to not only sets the return value, but also
jumps out of the loop and return to the caller with -ETIMEDOUT.

Fixes: fbfab1ab0658 ("i2c: qup: reorganization of driver code to remove polling for qup v1")
Signed-off-by: Yang Xiwen <forbidden405@outlook.com>
Cc: <stable@vger.kernel.org> # v4.17+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250616-qca-i2c-v1-1-2a8d37ee0a30@outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-qup.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-qup.c
+++ b/drivers/i2c/busses/i2c-qup.c
@@ -452,8 +452,10 @@ static int qup_i2c_bus_active(struct qup
 		if (!(status & I2C_STATUS_BUS_ACTIVE))
 			break;
 
-		if (time_after(jiffies, timeout))
+		if (time_after(jiffies, timeout)) {
 			ret = -ETIMEDOUT;
+			break;
+		}
 
 		usleep_range(len, len * 2);
 	}


