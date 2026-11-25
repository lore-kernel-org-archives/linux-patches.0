Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625933;
	b=0CiFuFS3M3AhdSn7RokQbW/AzJeqtS93csMFwGE+2Sod2mRL8Pvax/64c70Y6OAFW9Q6
	 PyFgaFD2NhNTvDCgZ7I80UulLFSeozFQdnpMCPpFPsE1Hjd2DoaK/P44mzbYoTO6mRe5y
	 hIg6TA92KyNtjEZByRItIwkdgJMl38r0RROVPCD+M0wbP8oTC0gydHmRZXwWjHQ4byTaG
	 vOfCZ2N2piYrfZaBOOQec+GHEpHJsJbrAhE7QNvyZid1Ck4QhEiUrywOsQq8CgbyoTjV8
	 /wePqzE8//Z5KBuTxuFOADGlkJr2MNvKbHHI/lAWlxWUxPdpIE6wNruwxN0cxFxVMrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625933;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UD3fYAIm94C1Ecb9jhI/Uf9GFneNd+oLeVVYuWt+p60=;
	b=mEresYxNZ8ViHNzeTA6RxqRaui49Fq0v0S4qKU+Kyh+mK8g8TUdF12jWhe55+s7H27Gs
	 ts2QePBjvPcczJ0IT4+TB5Y58x+Ovcq41k808ZaVijMsOMBwYreOpLZKM3bM6FekVYyNm
	 qq8C0vgjASo/OisAAKbtBBu72izGGkvMFDSvTfZHZneUVnEii8RsJFIXa4QpcBnuRoN5+
	 NrbxPw4XqNn1TtYb+36N+5p0xGmOXn1vMwoxvNH23WpvfcttfOE5Vov93xY+AXxvAE9zm
	 MrQpE9oENU2STVwV1D/+jMQ6Ba6FBm4BvR2rksWzb/QYqbFE7uE+5GWwy7ih4PDoeYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v52LiU4T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B86606A31E;
	Wed, 25 Nov 2026 16:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v52LiU4T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6ACD1F000C0;
	Wed, 25 Nov 2026 16:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625933;
	bh=UD3fYAIm94C1Ecb9jhI/Uf9GFneNd+oLeVVYuWt+p60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v52LiU4TOJ1ohHu02s2sxcO8kftoVAgpRetZitWwVqBdlHDSv6R7KkixgW75JnvKm
	 F86JTqMSqgUkEvFrjiU4aKig9aVaZq22Rf5LZVUSHI2IsBUkwLX342bI7MHUcT3FZc
	 7lUve3QeGw3ahN2A0I/+HEIRsN+D1kgrqpkaIVSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.12 677/816] ovl: do not always clear absolute_redirect
Date: Wed, 25 Nov 2026 15:37:05 +0100
Message-ID: <20261125143904.850839846@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giuseppe Scrivano <giuseppe@scrivano.org>

commit 477449a7a5fd1b2fe973fe2978b0c921115a65f3 upstream.

ovl_check_redirect() clears d->absolute_redirect before it checks that
the path element has a redirect xattr.  An element without one, such as
an intermediate directory in a lower layer, then clears the flag set by
the absolute redirect of a metacopy file found in a higher layer.  The
lookup of the data in the data-only layers is not deferred any more and
the lookup fails with -EIO:

  # l2/f: metacopy, redirect "/dir/file"; l1/dir/ exists, no "file"
  mount -t overlay none -o metacopy=on,redirect_dir=on,\
        lowerdir+=l2,lowerdir+=l1,datadir+=data m
  cat m/f   # Input/output error

Set d->absolute_redirect only when a redirect xattr was read.

Fixes: 5436ab0a864e ("ovl: implement lookup in data-only layers")
Closes: https://sashiko.dev/#/bug/linux-2cc24e0b-fbdc-4cf1-aded-cfd19c2918ee
Cc: stable@vger.kernel.org
Signed-off-by: Giuseppe Scrivano <giuseppe@scrivano.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/namei.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -38,13 +38,12 @@ static int ovl_check_redirect(const stru
 	char *buf;
 	struct ovl_fs *ofs = OVL_FS(d->sb);
 
-	d->absolute_redirect = false;
 	buf = ovl_get_redirect_xattr(ofs, path, prelen + strlen(post));
 	if (IS_ERR_OR_NULL(buf))
 		return PTR_ERR(buf);
 
-	if (buf[0] == '/') {
-		d->absolute_redirect = true;
+	d->absolute_redirect = buf[0] == '/';
+	if (d->absolute_redirect) {
 		/*
 		 * One of the ancestor path elements in an absolute path
 		 * lookup in ovl_lookup_layer() could have been opaque and


