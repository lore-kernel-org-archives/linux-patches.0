Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828869;
	b=whcg0p+PR2opkDYaqZc+vDfCfSRqexpWuCStfsdIlfYPkAJt+ZpvIesQrZMaj8q6msFD
	 kMJnm9dsWL6ImzE8fqvyLAAJrusL+voDAE8c/a0QEw1Stp1dKcxHxLQU92Orviq6B12xc
	 uKE/SH85FV682R3Mv73rFio0482X8EeGHFJQm9KdVNnKLm1cIkksKgULH3Ctx/4zHpoHf
	 hB7C+cit6TL6Lbknw3OIJrepcdyk3XgyYR8iL8Bcw2o6nQLnXyEqKxFrXnRMHTKN0gy3U
	 e5HqheXyfHC/nKUbpjue9vPA77U82QUx8sYAeUqYoq9HZrIXZF/njHzKXJrjyaiCvug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828869;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RICI02i4HTJ8+uE0oLjcANzh4K5cChoEKslvZJVFyM4=;
	b=mfZeB5kcJ3azhQAYljlwCvAvfVNM2JX7Qq1pe5kxJ/PYIUcU+PaO06yYE6KqIMvTWvEQ
	 nWsDKaon3Gb7fRZiCLAF8qJ+Gkw13jKziR8XHgPnB87e1auIUr7xEQpDgkOdIKxPxI/dY
	 3IZnAUGkZlwRhqHhAvNmwBsDAfIRym3yAq7hdlkJsQ3HkqQUlyaFPhfmzE4t5duPv2tVx
	 mGqDViaE4z8GvwhEBu3Tp90VYKHCsOr/es4evYiTcAR7W6Z1PIaAkNgn4mHQRj0rN2Xbk
	 L0iYNsDeqHCUi3EBDMCREoB/54y9m6e2dQtszeOfbTmPm4dW2YekZ7SymKkzFB2rBaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VL+hXr22;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F61B6070400;
	Wed,  4 Nov 2026 21:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VL+hXr22
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE8B1F00919;
	Wed,  4 Nov 2026 21:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828869;
	bh=RICI02i4HTJ8+uE0oLjcANzh4K5cChoEKslvZJVFyM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VL+hXr22slPtc3kcqDYxss46/z6PV0+y38e/oGcsFdkA20GQqmABE6MQixNclB5Dk
	 UnYGRRgYuDpTjLECiaGt+c+VWZDv6dnsFp88EJwxJ7YCcceMo156xzQ+S9tWAN0MiS
	 D4SN1/u/W7/r5a7D8C4PWeTXBNfb6OGtwKch4e+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 7.3 291/547] ovl: fix a torn path in ovl_get_redirect()
Date: Wed,  4 Nov 2026 16:07:55 -0500
Message-ID: <20261104211046.471568214@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1027,7 +1027,19 @@ static char *ovl_get_redirect(struct den
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
@@ -1040,13 +1052,13 @@ static char *ovl_get_redirect(struct den
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


