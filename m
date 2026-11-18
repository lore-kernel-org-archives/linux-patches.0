Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051769;
	b=i6yj6Fan87Lk/NNOHTkxJDRhl6M/AlxAu4gdruJuxFvTvl1qCk/GV68SESUtxuWj3utS
	 qmDuyX3otJ+PzGAQ4JTGrewY7dHPYvGK9ypdCHlgSKKF0zzUIPLWVGuGo0Efqm0QdXBHt
	 uQ7QOtAbu7Ds5KCqgrRB4lZV3X+vED/uXh6fPFXpn8tlXwgFCA/o+oOdGKeo7VZAobNG5
	 Qp7zPxQ52ficva7pxGPK1pVclTERYUMWt5csrFP2lg+2pkRoF0J7UGutxgpVcIGheo2hB
	 5u9/BT40ZI7xHHdTon4w68vwVy4AhhKmVWWyxm3bO5xn6NL3Ol8VeEOppyQ5w5vUJvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Os33ECVvj31bSyv48Wrb9Uy3XwxrA7JQRGNTTnvLJYo=;
	b=yjXTLfgg6HtDlq4xTAwX6sZ2QEIbUN5YYKwVDWdOt4Fa+d1agqithShj6lxfko41YC/3
	 jSR66/rraSv3xzQ3iNfKkOvCCLZRrSYauFc5B6hTwCgL1s2FZYxBZt3Z3Yzn/B1qS2I5f
	 nLTxSxeIoz0zDuTThsuHBXZJQ+kSWST0ywXd++y8V4IQT/upC5aC5oNThbe7fqCH5iDTP
	 a4sHhIe1Li4FC0dcjFbqHZPBF7S77FW++kiawSr1WOQO9wEgSsucf01GS5pXrdbuzD+lc
	 FmWhDDQmb9hTK+aA/ThuHAqVvDCyA6F2iUMs/EQZEoQQezviWFaHRv2hFz26RSbwmGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lr+UEsW7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F778606A31C;
	Thu, 19 Nov 2026 01:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lr+UEsW7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20751F000C4;
	Thu, 19 Nov 2026 01:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051769;
	bh=Os33ECVvj31bSyv48Wrb9Uy3XwxrA7JQRGNTTnvLJYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lr+UEsW7tYul2P3hOspfpTOwxA4dtDhFT/Eul6SAcN3LSSge04MYZGIz8472LXGKR
	 Me8AOBw+5Aszu7deXfKPUS8LFlv8NXIchdPnfHbKdkvsj5Uw0RpGrwEt7OSPwSol7r
	 Bafo6hFsfSVl36dtv3566ryYA3vGrIFtdLK9bC3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.15 0327/2214] ovl: fix a torn path in ovl_get_redirect()
Date: Wed, 18 Nov 2026 15:33:23 +0100
Message-ID: <20261118150023.405098021@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

commit 2001cd7ca5560198131e46c6ca3c3472b06145c2 upstream.

A hard link of a metacopy file that races with a rename of an ancestor
stores a redirect to the wrong lower file.

Each component of an absolute redirect must be the name that a dentry
has in the parent that the walk continues with. ovl_get_redirect()
copies the name under d_lock and calls dget_parent() after the unlock,
and the callers for a hard link hold no lock that stops a rename across
directories. A rename between the two steps combines the old name with
the new parent.

With delays in ovl_get_redirect(), an unprivileged user hard-linked a
metacopy file while renaming its ancestor to another directory, the
stored redirect named another lower path, and after a remount the file
showed the data of a root-only file.

Fix this by taking the parent first and checking it again under d_lock.

Fixes: e04527fefba6 ("ovl: fix dentry leak in ovl_get_redirect")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/dir.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -995,7 +995,19 @@ static char *ovl_get_redirect(struct den
 		const char *name;
 		int thislen;
 
+		/*
+		 * A rename can move d to another directory at any time.  Hold
+		 * d_lock to copy the name that d has in this very parent, or
+		 * else the path mixes the old name with the new parent.
+		 */
+		tmp = dget_parent(d);
 		spin_lock(&d->d_lock);
+		if (unlikely(tmp != d->d_parent)) {
+			spin_unlock(&d->d_lock);
+			dput(tmp);
+			continue;
+		}
+
 		name = ovl_dentry_get_redirect(d);
 		if (name) {
 			thislen = strlen(name);
@@ -1008,13 +1020,13 @@ static char *ovl_get_redirect(struct den
 		if (thislen + (name[0] != '/') > buflen) {
 			ret = ERR_PTR(-EXDEV);
 			spin_unlock(&d->d_lock);
+			dput(tmp);
 			goto out_put;
 		}
 
 		buflen -= thislen;
 		memcpy(&buf[buflen], name, thislen);
 		spin_unlock(&d->d_lock);
-		tmp = dget_parent(d);
 
 		dput(d);
 		d = tmp;


