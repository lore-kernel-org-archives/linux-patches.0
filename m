Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061612;
	b=lvS9FM4SMH5hfnqKB/xOdi0lf9FAW9RH3xjAdKEvlnlrRijzlLvQZsOPCq9lrzIm5Qf7
	 9zZmL3Ehhj6NnumNVtYJZ/ibDadW/559U0QbNL31A1mSE2aKVTuKQiRoBOhebeShySna5
	 wRN/hTy9ow+XnGg+L3vWdyLujsMp9T/m+yDddP4VFrfYDfKFvkvwULTm2+iF2bKRAPFbq
	 wt4K1D1jvfkmkr3BfFklwKl/JveAKLWh9hUWengigF3FGknxlk1Udx33y4F+LSzMzX/ZO
	 Uifo9/VLZNuxdKmXBNk5Qj6lBYGo8Pf7HzHr1vA1Lq4tWn1PLO4GthPPzwGUCWZZqug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061612;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KR27npR65Hvv4Op9vGecEG7EGEO49h2+B2PwZC+yCD0=;
	b=JMC8EOnXh840yHRFCCRQd/zBW9RPqqOM5zAhCDNNUbgcsS6nLy19Hp4o2wiItoVlJHnK
	 kL5OeizVPMNYVOGR4S2IxYbvi8zOaQCiwhbWsH/W+vM3Z6ewa3a7MrKjqbOS+ZrddksAy
	 DR+zmAjS/pY4/cRfzrpnVsHQPDwQf+gX2MCUKdVhjooiHX625GB/sWUNhKUfT8rbbJkzk
	 ZMXSWwfVKj9NGUCSfOYCVBPr49vJ/lYmbur2uUE1LbF1FtxKR8aa5yip0LLgisuvVPbO9
	 zpmDGhnYBJqKvwR6uZH5nmJ1NvgsELJd/RzxcW4BX+KWqt89GTInAJfZa4e465IfRDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NKmRmRXC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB16606A326;
	Sat,  7 Nov 2026 14:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NKmRmRXC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02BF1F0089F;
	Sat,  7 Nov 2026 14:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061612;
	bh=KR27npR65Hvv4Op9vGecEG7EGEO49h2+B2PwZC+yCD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NKmRmRXCMSlXZdXcPCYToOMzvWMwI39RExSUYu48u94dhcQ6d/i+DD3CFFdvHLnKX
	 +XMv7xXG7g9z8y8UXWkEZlHXE6dHZ7VZmYFHfJWI+r4QMThlWIrY68uP9TyH4RrgNb
	 jh9s3778fo2D1ntLkUvPyv1Le4Re+QZ5nz3lAKNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.12 0682/1536] ovl: fix a torn path in ovl_get_redirect()
Date: Sat,  7 Nov 2026 08:44:58 -0500
Message-ID: <20261107135016.640699346@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
@@ -980,7 +980,19 @@ static char *ovl_get_redirect(struct den
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
@@ -993,13 +1005,13 @@ static char *ovl_get_redirect(struct den
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


