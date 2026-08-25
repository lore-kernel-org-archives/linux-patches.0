Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AFD386C3B;
	Tue, 25 Aug 2026 13:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665233; cv=none; b=brjBQ0cmP+5WKx8WwzEhX0JqYCFdgty76gEEzNvfGR6uIXdNT4+u0XvbOOlCMARPnyJJbMAjytd38CvCUGa0tT4iL4krX/q0SXO5AGn2qrLAmYax/QR1rg+RdxS+dOFMMfg1DPtkBM37D+LmSbsG09IaBU1wZzELHFN4KkG9JVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665233; c=relaxed/simple;
	bh=DMRCYq7dhHLYxRpV0iC6lNRfGRTQfUeLWc7aTscmaM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGWyeN99mHhjAKGeb+MsLgx4Z5eLdK0gdPtK7/t0Ogem5TxTn/T0VWh5vxzyiXuylut2/DfbAQqXHjZwxasHFnnnKSWjvxkeRJvT5tITFPorPy6P96yLL+QthsOZO3H+CeebG4YmTnhTbsSyiCsFGROgC09BvqpWT994mQKNy+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EcJB1yaS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EcJB1yaS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399D71F000E9;
	Tue, 25 Aug 2026 13:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665232;
	bh=fhraT2G6r8ZLS0dckLacyuvdD4W5iqOXYr2twTL4kDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EcJB1yaSjme67FBSTGGUNTEQnRW/NV0wtIH3onRKwy5Ka5ZHtDbjrtVUvyjduhTio
	 yqE1ZHu2jfnOs1vtU9XVHofs3lqA/yzhKrv8qgmSvICjRRhkLPXIAF6sainALzsqMv
	 mZbubrvKnRa8C6gfBV7qUzfERjyNaJtvs8+/C7cE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 51/94] nvmet-auth: zero the AUTH_RECEIVE response buffer
Date: Tue, 25 Aug 2026 15:25:47 +0200
Message-ID: <20260825132543.908927574@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -558,7 +558,7 @@ void nvmet_execute_auth_receive(struct n
 		return;
 	}
 
-	d = kmalloc(al, GFP_KERNEL);
+	d = kzalloc(al, GFP_KERNEL);
 	if (!d) {
 		status = NVME_SC_INTERNAL;
 		goto done;


