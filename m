Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623518;
	b=durDEanWJCsDiAre2vCX/3lFkHZBTl4rb0OECHsxFlb8KqSQ29aixeytwNYKUFD6KcWN
	 9wxvQgzSehpO3k1+1UQ+dFpXDvNHEmtDxzbdxKfWcaQGOA7YqsHwkuaL/K2IrsJRcp/PE
	 NH5XG+Q/4rWymABF4ePGuJDF6XIBVApDVzpN+4W4BEPscWQ9WIG9FFi/Qux86gnI7QFTO
	 yKHm1kYQ/IHxhBlHRQ+7suw9ZlmuxMb8R7By/KhwWpqyAoyuxKv85p7cTUgMxRXxmI1De
	 IhoItAhCrsSEzK+Jg+QEWGNkIR6Japuad4n02PCpYtfmIvZMthG3t669HRMASi1T/AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623518;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cvD8xmYwAMSi5sanuLY3X/SZpIsCeL7WBKtcVFXKykM=;
	b=cP6zuE/xmETF5S0GX472N8vGnjWqAP1Z1tQVjxr4eX1YgKnLhlClXWCYIS94EaIS4cRx
	 oZeNj47lTT6wxy9YjFVQb4oQgF9iYg0P34BVmhJyp5u8ZJru9o6GS56GUSBnS+o+o+dYq
	 3nPTzHbABXqg2coblenLTBZeyPpC8fNWy2RGp0Na0YPg3uek352BA26pbVrdTysZCyJGf
	 aY0HFd2T6mDRSQ5FHs966sUyGtMK7khVkQ9S2DpkrbkOJ3uJIiFHTj/064Jiyh4AYRwA/
	 P4LmNJC2SL0flwI59c4PSWzk/F0bcZIQCnDz10v4KJ2EJAJAgsxV5W8URveywfZ3Sug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=swcuc9qi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A8F606A31E;
	Wed, 25 Nov 2026 16:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=swcuc9qi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A781F000CF;
	Wed, 25 Nov 2026 16:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623518;
	bh=cvD8xmYwAMSi5sanuLY3X/SZpIsCeL7WBKtcVFXKykM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=swcuc9qi/Mb8lcczChBzzIlEaxKOlNAHOIJ1uHh4zAoacVSIYhFxCXMda0nquvIOo
	 l+Bz0wPjby0K/J1tOBuiuymGsYG0dVmfLszE9BvwgXtljxfjC9Z0QzrhXq+DPCAtHL
	 xCd6Q/89uuF9hrqqVnpfeCVq1EtvHqDgz41NQuWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.18 831/990] ovl: do not always clear absolute_redirect
Date: Wed, 25 Nov 2026 15:36:38 +0100
Message-ID: <20261125143841.501183768@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


