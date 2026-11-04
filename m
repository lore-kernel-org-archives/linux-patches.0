Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831540;
	b=VM67QRgwZ847mPOvatNNaKfjo6dfaka72OTp1R7EjTxD3x82QH+Jc9XYrZlECszM9Dzr
	 QXKLl/VdcS3bmLPp3A9nYIsiNa2K0BuVPNx7UdJADOqyk8omM+oLRkJ/VpxlxtxOFoKSW
	 tR25K6cc/L71YasX9EZ2hpfinjVru+olO+A0RRodIWOkXSI3JXX9zXQAC3haRLloU7Nc8
	 jvXP7S5G0fNBs2yTCa76Sz0ABDDzfnh6PYS0mm2/sk3bbGv5BeNuQ5g3tK+8Tr/yCiroH
	 /8lOhDLnGTIgbyoUwg6UzCE2kpYp8N+UBhDc5YD0P/UGWrqu4BZhvTZhKmTfBlT8Kyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831540;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F8c8aDOvLRM4JQ/2tPVZDLR+zJCuMAt3mB+vc6ox/1Y=;
	b=SDd6I8mhtk2I9uuxTJAMOl5kw8V5R859rsy6rGjaqqHftLK9cdDZvfI2JwEx8Qi97YbE
	 tbetXk24CuEFTaIT1dvh5K+r8d+mrmpkv9c906wRnhFw2c/mnwSVVPAzs9ZBx3WuUY+rg
	 Vh5uFN0OKsAMNi5KVKWjQv5pG9wEeh95epd3qLlu70WUTMNPwkNdbuSc2ul5jVSri52Sc
	 WIo0o7NNtQCgOUQZR2clOzPeJxaRnv+S30nQeK2Ede4uARmDvIvHUouaK6NRNSVSE2DTo
	 /h6Ft9K3A/ZFh9T4wxJYX4hK3UXZ71MeDIYefTAO/hd5eVV4mEbRqEseu9jmAkOl1pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RPC3R4ex;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C222606A334;
	Wed,  4 Nov 2026 22:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RPC3R4ex
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E809F1F000C1;
	Wed,  4 Nov 2026 22:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831540;
	bh=F8c8aDOvLRM4JQ/2tPVZDLR+zJCuMAt3mB+vc6ox/1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RPC3R4exarEFs7wkjgXdT7M9m4O2XKfTd8cvnRtzM4EKFP7WJwaLc3fp8v1jgs2gx
	 ro+GR1f/0YFdAZVmAfH0XOTlZSHNolN0Um2UF+LfjsXJX1EKpz5arH+Ec/80jXfjy9
	 NxrkdKfgwgyQwSzOQAnYIbJafbOfaSiPPgQG2B+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.18 0767/1005] ovl: fix a torn path in ovl_get_redirect()
Date: Wed,  4 Nov 2026 16:08:20 -0500
Message-ID: <20261104211104.888455951@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
@@ -1007,7 +1007,19 @@ static char *ovl_get_redirect(struct den
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
@@ -1020,13 +1032,13 @@ static char *ovl_get_redirect(struct den
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


