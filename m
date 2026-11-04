Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828865;
	b=lMjsrJTU8lteQXWqxyQlc50lXqQRrx2k/jDa/eNRuDP578ft9MHOrw1hCPaPO1A3wqsG
	 Cat+RwArNk83bfgBhSy3tgzSjMj4+f8xiDCEElkWr6l9LeBgX5un2g2VDLllM8o+t8gSA
	 dADD2KgqNdu9XB0gpxTUAuL6AXHK3/bzKhVqi2+dZE6LWItBS2SteiZKC3mVAZr3To58o
	 X5mL7ML7uqpW5jfS4e4gmxmU3TFZvIwJmkQZnUHO7RwKzFN6nwdJL/0b++PtC5IfX3qB0
	 OqG678TO+GZGdV8NA7FBt3PJuM7sHC93R8gClV3w6IEhIQvqgyULe8LCIoAivw+KRcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828865;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EKhZiU21y8chWqT6+i1Pr/ZxK/ZcqRi7Bz5XMJ6FRuU=;
	b=qRp3lfwnn3H1IEk+g6+ofuTHJBeakGhqajbwREr4ODGULcNXuQJMuj0A2ZZ5BD7Jf/XQ
	 cX8K/0finy+idhEVv77zUNmKVJqYWpa2Il9l1uu4XIHS9eLnueyY8d9OhM5Y2W7eTVkzZ
	 kpuHtNo8nRkvC5ZmzB2o/HsBOAuR9/8lbmcnIRnTAXaPsV24ho35xb9zQsDT7/ccGCeze
	 jqPVVnC9Zto7yctDgHGGUeziyh5J0vd/6wT5yHu0+DwIC9cHQjdy2FxIBjA1nB1CovvWQ
	 Sq92Wfxd0vRbWftoGbV5zossnKfog3Crf5JJjKYdU+OdvdV8+Qs/oj4vj8cAIpp7nxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mLEg2xxo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F456070F27;
	Wed,  4 Nov 2026 21:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mLEg2xxo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA4F1F000C1;
	Wed,  4 Nov 2026 21:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828864;
	bh=EKhZiU21y8chWqT6+i1Pr/ZxK/ZcqRi7Bz5XMJ6FRuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mLEg2xxojVtqXj1rHy3pA0zJ6wWpKowuM413WyRqoafzpr/thziYa9Yhxb4nRoamN
	 9+ScP+oKL/gnIs2cnyyuxiOUYWKqXaEWUPFBeDjtYFwdMRuBLInYW0P0fLa4QbMJn5
	 OyrESwKeh19OiZ8DiPbKHJhzpEb/EpYzNnmpphYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 7.3 289/547] ovl: do not copy up a dentry that was removed
Date: Wed,  4 Nov 2026 16:07:53 -0500
Message-ID: <20261104211046.414500018@linuxfoundation.org>
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

commit f635192ad223d2009ee640b63adf5ce3198aa338 upstream.

A change to a removed file through an open descriptor replaces whatever
has its old name in the upper layer.

Copy up must only create a name in the upper directory, never replace
one. After an unlink, an rmdir or a rename over a lower dentry, a
dentry that an open file keeps alive still has its old parent and name,
but in the upper directory that name is now a whiteout or a new object.
ovl_copy_up_workdir() renames the copy over it, which brings back the
removed object and destroys whatever took its name.

An unprivileged user opened a lower FIFO and unlinked it, root created
a file at that name, and fchmod on the old descriptor replaced the file
of root with the FIFO.

Fix this by looking up the target name of the rename in
ovl_copy_up_workdir() with LOOKUP_EXCL, so that copy up fails with
-EEXIST if the name is taken, as copy up with O_TMPFILE already does
when it links the copy to the name.

Fixes: e9be9d5e76e3 ("overlay filesystem")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[amir: use LOOKUP_EXCL instead of relying on d_unhashed()]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/copy_up.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -812,9 +812,10 @@ static int ovl_copy_up_workdir(struct ov
 	rd.old_parent = c->workdir;
 	rd.new_parent = c->destdir;
 	rd.flags = 0;
-	err = start_renaming_dentry(&rd, 0, temp,
+	/* The name may have been taken since lookup, never replace it */
+	err = start_renaming_dentry(&rd, LOOKUP_EXCL, temp,
 				    &QSTR_LEN(c->destname.name, c->destname.len));
-	if (err) {
+	if (err && err != -EEXIST) {
 		/* temp or workdir moved underneath us? map to -EIO */
 		err = -EIO;
 	}


