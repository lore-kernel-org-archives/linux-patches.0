Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D057470124;
	Tue, 25 Aug 2026 13:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665512; cv=none; b=aNDCr3qydEJU6iLIskkrf/63AEca+tMSDcD1UxICqC8ygyBADJPJMzNqPZbe3nIJh5fH5/L4LAgClMNKyDZAvI6hZf+TZ8xg+PC7sP1FFG1fpJa8RI7BD4jDetePia/Zb4llTr71JiZLDRI1Gf5B9wtRL0tGf3dw2qx5Pp1owFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665512; c=relaxed/simple;
	bh=sfVukHQ1+uykjuy8SmQpsw11X49KcH4xx0ZXniYko/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pb0Ex1VFjYN5kEXH/8Xk5LyPpR/R7AcQ5MKS1U+bjCoNW8TZsjF2p/1je5mn9nYjdMTjFcUG1r96999ChxDaCvSFqUklK5Pr8w8Fo9+5+PlYVWV441JCf8xvlKhddIbLCidAfJ8kKw9Ldes1aDmN0viC8DavzhiJ8+OwRMc1sK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2jWD04sH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2jWD04sH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58BEC1F000E9;
	Tue, 25 Aug 2026 13:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665510;
	bh=pqX3GBN7iMCfrLZ8MebV6B2/hqcEKe1c+2smjBdnm4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2jWD04sH2EN+bTgwTw5AgN8dXitlfQow+G901N6BIZN3drkFcrBEmTC4ouP4aqkcs
	 g4eVlYd78GfG4B7dDSKxvXe/UsxAJUdjM0toQNmz9BZ8mJrLl8C/EY74f9iZrU6Vfu
	 K+rGltLTcHKNU0UjN+mLb4QRQsDzeQ3VXtBngbyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.12 49/77] nvmet-auth: zero the AUTH_RECEIVE response buffer
Date: Tue, 25 Aug 2026 15:26:11 +0200
Message-ID: <20260825132543.483376591@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -509,7 +509,7 @@ void nvmet_execute_auth_receive(struct n
 		return;
 	}
 
-	d = kmalloc(al, GFP_KERNEL);
+	d = kzalloc(al, GFP_KERNEL);
 	if (!d) {
 		status = NVME_SC_INTERNAL;
 		goto done;


