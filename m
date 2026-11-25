Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623441;
	b=XIsgkeqzfq94Vf+cniu9QFEQVMGFwpT0aW6aYyFsrYkJNEbgLb5M5PR2M78wbkZWhH4O
	 +4fzUb1ZXACOfLQgI7cjykn+Xehw6Y8sw+jxZX/8HkZBefdDNLOOJbxW0ZPWMrbuLVS5x
	 qKwDafGP+KP2Yonzezt0zrMK1SsnYgf/sfh6Oj6inImoPNozOCGBy9HDB5Ffj1h4unjoD
	 JYcoXHw2HiCx/4ijPs4sOAoNp2F3Rj1pet7Bvu/BvUyV5c7CUy9uu9u/n1Ulk7hzoYfqQ
	 5glJiju0CEN+RCwFT4rVOZmmrhV2/dGdbHYOHCWqGVfk729E7gOZtpyfI7VU++GIZCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623441;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gXgEqI3TWURW7FxXOXIdRTFuxO3FCG7niomXMfqE1JQ=;
	b=txkRNu5ij+5pVIShMmlYvTIJXmnrISX0ZJTq9JR2IxlPSxOwP4KM+Nq0w7XQ9LDI7q4y
	 jJOFtuz2dz3Azf4kxQ4kdUSLA7ai1lyV6rF1qfMT9cnxmCvV1nm/cWtziaxmE6+cmze+5
	 RMW2zNetneBkgAz+4bTl9GQxxv9mg5tfqUvp329s0rXU8JsNJ/jdRIhitTJhBTtpjfWNt
	 DD5zZQ0795mmlVI+UGpDFCs4WzWiMe6b+wjmT6PFpZvrl+Y8T6fkD7QowS9JCcxafAibk
	 WM9to56gXohMgot5CaTLjLBxIroar0kyxVst5B6J4++ctHRiBj70YHUkEnIpnII3HKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=obpRDeDl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C1E606A321;
	Wed, 25 Nov 2026 16:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=obpRDeDl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7381F000CA;
	Wed, 25 Nov 2026 16:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623441;
	bh=gXgEqI3TWURW7FxXOXIdRTFuxO3FCG7niomXMfqE1JQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=obpRDeDlpgBMKDjypWk+/6vbj8ZRWH/UMROsk8Yv3FxINkIJIiP83a7+ZyX3UIaR6
	 vMz89dCD4Eorb1Y7CjRRwpEdQ91KwX1LlXnY0GJGYmDi4kcKmgmLX2BQxEH82135UN
	 pp3vnpPfnkykfWN2exxYwIoZld+2rtr9cQfFqQTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.18 834/990] ovl: return EIO if the lowerdata is missing
Date: Wed, 25 Nov 2026 15:36:41 +0100
Message-ID: <20261125143841.568926601@linuxfoundation.org>
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

commit 0d5e729c515f4ae4eacc179dbcf350d9b499a161 upstream.

The data of a metacopy file that redirects to a data-only layer is
looked up when the file is opened, and the error of the lookup is
returned as is.  If the data file is missing, open() fails with ENOENT
even though the file is there and stat() works.

This can be an integrity problem when using composefs: a data file that
is changed or has the wrong fs-verity digest is reported with EIO, but
a missing one is not reported, the file just looks like it does not
exist, e.g. a configuration file that overrides the defaults.

Return EIO as it is already done in ovl_lookup() when no lower data is
found for a metacopy file.  ENOMEM is not changed.

Fixes: 42dd69ae1af4 ("ovl: implement lazy lookup of lowerdata in data-only layers")
Cc: stable@vger.kernel.org
Signed-off-by: Giuseppe Scrivano <giuseppe@scrivano.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/namei.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1047,6 +1047,14 @@ out:
 out_err:
 	pr_warn_ratelimited("lazy lowerdata lookup failed (%pd2, err=%i)\n",
 			    dentry, err);
+	/*
+	 * The data of a metacopy file is missing or is not a regular file in
+	 * the data-only layers: the layers are corrupted.  Do not return the
+	 * error of the lookup (e.g. ENOENT) to the caller, it would make the
+	 * file look like it does not exist.
+	 */
+	if (err != -ENOMEM)
+		err = -EIO;
 	goto out;
 }
 


