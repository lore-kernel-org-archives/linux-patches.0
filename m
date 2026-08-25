Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3748471433;
	Tue, 25 Aug 2026 13:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666018; cv=none; b=Mt9PaFxw9QD4DPpasxrLwYaLMKt6E96KZwSFT7l2MHNLq7Vr7yVeqAxKR2i99AWiR/cWeLw/PQTPZYibMdV80SP83RNWoKPnBx1ZV2g5pdSxOHdtTbuqpnM9o75qqhNqBrvlNZ3XSuhfsQvmXa+qhq1s6vcRJmiKSb0nc49yy0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666018; c=relaxed/simple;
	bh=UOk1DWwO2ZopsLoHzbtP4YhbZ39HsnRMr6fcR3vZ5u8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4H4zkRVvqDI5ijmGJ56p++03TFt9ZOzBzpyNjruwtNRV7M0Oxojlgo0zw7dfWwifaldniHW5FRLuWhj6Gc9eC3r6Mox9tfv7x7ewcQyLOS68ZjGDQ05PM9WdloNsJyBDdNE+w8tV/rFV6bKCbS2Y3hfQa1Fd3NLbtw9vSJUVz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NcoRQtWU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NcoRQtWU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E5E1F000E9;
	Tue, 25 Aug 2026 13:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666016;
	bh=a1F2CWQXfUj++gQTe784YDapLT0y+QQY9mn+MmYAT+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NcoRQtWUcz5gbTaV+HKxRwri6idatW5PhDvsLMS6+WiUESRWvZT4eX1M3Zk53D2u3
	 /VrN279uiqpkweEaFR2CKStIm+C29wVrmL3jPt2Rgp/Hb6CqQLLPXQ8X1tojuBZ7Zb
	 LRoz4lhmLSFyDWuZNxjZegmKIFHmAoUoqKsDwD3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.1 57/79] nvmet-auth: zero the AUTH_RECEIVE response buffer
Date: Tue, 25 Aug 2026 15:26:37 +0200
Message-ID: <20260825132543.933098103@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 3ddcfb013322aa37eaa7a0d344b73079c38dfa21 upstream.

nvmet_execute_auth_receive() allocates the response buffer with kmalloc()
sized by the host-supplied AUTH_RECEIVE allocation length, but the
DH-HMAC-CHAP builders write only a fixed-size message into it. The full
allocation length is then copied to the wire by nvmet_copy_to_sgl(), so a
remote initiator receives the bytes past the built message -- up to nearly
a page of uninitialized slab -- during the pre-authentication handshake.

Allocate the buffer with kzalloc() so the unwritten tail is zeroed before
it is sent; conforming responses are unaffected.

Fixes: db1312dd9548 ("nvmet: implement basic In-Band Authentication")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/fabrics-cmd-auth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -469,7 +469,7 @@ void nvmet_execute_auth_receive(struct n
 		return;
 	}
 
-	d = kmalloc(al, GFP_KERNEL);
+	d = kzalloc(al, GFP_KERNEL);
 	if (!d) {
 		status = NVME_SC_INTERNAL;
 		goto done;


