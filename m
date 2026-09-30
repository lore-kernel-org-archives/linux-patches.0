Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F1733E345;
	Wed, 30 Sep 2026 16:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786099; cv=none; b=GyHPJNQ6pp78rKCeRUteM4qTEwytpyeaIS+mbaMExMTAe/8RIG95RwfFCz7MhnVkPGrHW3/zcGaixt711DqFVMfQOxI2c+3le0jJtN/pHgJEtErdsul85Egx/XAImmuzeCfcd3XqdC/NJQ50s8U7sEGQEttq4SjsxoZX8k0Iz04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786099; c=relaxed/simple;
	bh=HXjw1Yc0MEe9Qw9uaRwU31vjo32vWYyieKvQ90BDeE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfUZZqXKf2wtPMhmuct4Hql2F4V7xFQzzB4HGRMIp/u1Qm3m2oQEJgX4hi9tvBn/YM6KZ1qOV2M64UUcnI0syNGUWmCeWgPpbRivWdOpV0820ItnqZ6HKO+dDL8M3CprxfVbPvwGGxYAShzBxFwOdqyx5xoWk+bwIXzdrcyvH/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=osVzcXmQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="osVzcXmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208131F000FF;
	Wed, 30 Sep 2026 16:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786098;
	bh=jmlGDxmoZxo0jRddsWGeULjQ8pPf8TabzNsqYXkCzBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=osVzcXmQlTHe3FG9XSsiC6dhsFjgSPk33pCtBdyjywr8GV3GFlgvUwncRbAiE0Usl
	 pu3GCkrLt6LWn9bk/+KYkEAMtQbJcR3kCIIJYSvr3Xh5qlcLPTKUET/4XLZUEeJRFV
	 I5mss/1E8ZAULVrl6tbEjCPE6l7DaWc+e/6N+29s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 743/982] Input: rmi_smbus - fix out-of-bounds read in rmi_smb_write_block()
Date: Wed, 30 Sep 2026 17:24:39 +0200
Message-ID: <20260930152432.714568611@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 51cfe54f815ae175c7d1126b983d4d7c89715004 upstream.

When chunking writes into SMBus blocks in rmi_smb_write_block(), the
loop calculates block_len using the original total length (len) instead
of the remaining length (cur_len).

If len is greater than 32 bytes (SMB_MAX_COUNT), block_len remains 32
for every iteration, even on the final partial chunk where fewer than 32
bytes remain. This causes smb_block_write() to read 32 bytes from the
advanced data buffer pointer, reading past the end of the input buffer.

Fix this by calculating block_len using cur_len and advancing the buffer
and address pointers by block_len.

Fixes: 82264d0cf7ae ("Input: synaptics-rmi4 - add SMBus support")
Cc: stable@vger.kernel.org
Reported-by: sashiko-bot@kernel.org
Assisted-by: LLM
Link: https://patch.msgid.link/anLFSMKSoKyyZ272@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/rmi4/rmi_smbus.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/input/rmi4/rmi_smbus.c
+++ b/drivers/input/rmi4/rmi_smbus.c
@@ -140,7 +140,7 @@ static int rmi_smb_write_block(struct rm
 	u8 commandcode;
 	struct rmi_smb_xport *rmi_smb =
 		container_of(xport, struct rmi_smb_xport, xport);
-	int cur_len = (int)len;
+	size_t cur_len = len;
 
 	mutex_lock(&rmi_smb->page_mutex);
 
@@ -148,7 +148,7 @@ static int rmi_smb_write_block(struct rm
 		/*
 		 * break into 32 bytes chunks to write get command code
 		 */
-		int block_len = min_t(int, len, SMB_MAX_COUNT);
+		int block_len = min_t(size_t, cur_len, SMB_MAX_COUNT);
 
 		retval = rmi_smb_get_command_code(xport, rmiaddr, block_len,
 						  false, &commandcode);
@@ -161,9 +161,9 @@ static int rmi_smb_write_block(struct rm
 			goto exit;
 
 		/* prepare to write next block of bytes */
-		cur_len -= SMB_MAX_COUNT;
-		databuff += SMB_MAX_COUNT;
-		rmiaddr += SMB_MAX_COUNT;
+		cur_len -= block_len;
+		databuff += block_len;
+		rmiaddr += block_len;
 	}
 exit:
 	mutex_unlock(&rmi_smb->page_mutex);


