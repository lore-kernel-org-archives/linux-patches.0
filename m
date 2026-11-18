Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044609;
	b=nqy8H8XYgDG36piz3wNWX3OM/dXHTT+jAlomvq72CiTVEpszDxcGxqDnT5r+JecvX/b5
	 Qzo4LK/o79GY5M/SsaTFCBqCsr7kSXsPgbGkB9vwD43pYt9H60p39EYLjIkH3d9rfrdL8
	 hey6yIPmAP1QGtECRhdY99J+7hkJyBELLKMLgYLvFakN3Z9gwTFtWMeu5d4TsvQ8zQ9xZ
	 IE2krPjqi7xRYfOIxqsBTvugUI6wgw+VXPugd39YjRWVmntiG2uNZ/vvInJI+MYNeg5Em
	 oM4ERhokWGB2gLndxGJehf/IlIPN5Xv2vw9zneNpjHwP0dflCJBcChRkKUDrLaxifOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044609;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aGWjuvnwH6KS0PPh8emE7jqfyBza5XdakCnfhFLWrYk=;
	b=CK73LDIGjSxblcGEfGOZnDTtusY4Tl08hbSExbTfFF/Cl21t/xzS87o0tOXkhc42HM6X
	 0MhwvH72OJQ3ipuBcp8koqCg5SVQNHFD1l9qFDYjDTrjw+oeMVvHnIZe3Psz5GCHnD7uW
	 BsxA0sH1LuqrWgjMlcBlVpehnN9ENRCNgmH5HxZm1oZiPzsYNmh8oPPn8AGqWGPtauK+u
	 6J7EY/oUAh0mPqP58N+GMheOtvVyQCk+Yc8G4iTYQFM5Crr4OB9yR897Pe+MGBcwj4HO4
	 i3IDeKhGlUbIneAD13IwnpknPer04nyT4HTtXp60Gh1hHvhwnSlll/bZOVcMXoI9PQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f4pGr8bV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F44B606A325;
	Wed, 18 Nov 2026 23:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f4pGr8bV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843921F000C4;
	Wed, 18 Nov 2026 23:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044609;
	bh=aGWjuvnwH6KS0PPh8emE7jqfyBza5XdakCnfhFLWrYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f4pGr8bVuoym2bxmsWhCjBOMvhqD0c/w+6PjunfXccpCM7y52JEp3jA1tAulXcRqE
	 BCqnuLL8Idum1lrDXIwVKCP/7oq5FEmQfWPnIAG8sJPKzS4y4V/NdAWmV2mMz9e4f+
	 BCxkX4IKaSLqzdplJRt64KtItazjwdW+3HGQXYmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.1 0578/2857] ovl: fix a torn path in ovl_get_redirect()
Date: Wed, 18 Nov 2026 15:26:52 +0100
Message-ID: <20261118150222.296273447@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -991,7 +991,19 @@ static char *ovl_get_redirect(struct den
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
@@ -1004,13 +1016,13 @@ static char *ovl_get_redirect(struct den
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


