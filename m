Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623475;
	b=btQKwDu/L9AyCP8vIJJ1BHv2JX+yGGZaQR7dMDOyYy/lmZFaGz0vu8rkq3RD7fyWt/+2
	 wpOm0DE8yAQ/dhULmmyMhOpW4sFww0MC+qhGMNGHjZLQDKnHQKPYnd46iQehEQ9yjPDhp
	 yg5vlogcANjeJgBh1vbiZPFHdKL3EOa32oyjKmQfntDlBd+e2BHDvKj8+1pzqs5EtwCF3
	 Wc6KGGHrAsa6hnAtTofkvwx4DIXkYU2hHzIJTxeugqGCHBkKVplmgMUydZgb359lIiL8O
	 KFas5vEhkquO5tcffBs1ISqtWyoWLJl7jAZ59jRknp44wgGWZ03c3Yk0ctmGarQ9aWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JBH2mbfLViEe66QyO/vg3DM8ockD2C6TFpnN5C00bvc=;
	b=E4ykJBpDZkPL4RwSsUyEhP0jSSlv+WDRh3o2xMWy8wQZtKKnTbq8OEReRhDZgPHV9Wxh
	 JdUzr9yRPqCoetwiQs5z3vo212irsZBDjkzfMlnWK2vdMi2By8j7akeTFB9n7VEmK3uHX
	 tZGmnCzTtH7q92zl5So98F0qUqRY8OubKmWCt6w0xSzY8uknNdgJ+2hQjmOuo7iw6IVMn
	 oRfa8hN4eanU6/0OCnqSp/79XrbBIykQx1S3SRMz3+n7sik2YFvdYtGiI+ArHtNC7VNHL
	 l8YULxRSRDoX+4gxV7YSaFCuO0LxmCjLVt9392VskJdPyN2fWawQZ03i/6SabFTCk6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xlxqP55g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD7E606A31E;
	Wed, 25 Nov 2026 16:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xlxqP55g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AFA91F000CF;
	Wed, 25 Nov 2026 16:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623474;
	bh=JBH2mbfLViEe66QyO/vg3DM8ockD2C6TFpnN5C00bvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xlxqP55g+HrQqr8myhJa0Xqul3DOZrYLnH+4nJpXaWvjY75cN5UdA+AfteVsllZP0
	 +hEClsm1xcrOVTpb1kwyr4wtdl8hS4bDsjwePy76KG067o4dHPmGLr/we+rViaCYo6
	 P6x5xqJfydvdcMyGsD3neUcsxivIoVeSelkb73VE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.18 835/990] ovl: do not allow nfs_export with data-only layers
Date: Wed, 25 Nov 2026 15:36:42 +0100
Message-ID: <20261125143841.591595984@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

commit fba955b070d13e2fdac097577ce3c6ffbeda4ea9 upstream.

Since data-only layers no longer require metacopy=on, which conflicts
with nfs_export=on, an overlay with data-only layers can be mounted
with nfs_export=on.

Decoding a file handle of a lower metacopy file whose data is in a
data-only layer builds the inode only from the decoded lower dentry,
without the lazy lowerdata redirect, so the data of the file would be
read from the metacopy file in the lower layer.

Fail the mount with explicit nfs_export=on and data-only layers and
otherwise disable nfs_export with data-only layers.

Fixes: 5ef7bcdeecc9 ("ovl: relax redirect/metacopy requirements for lower -> data redirect")
Cc: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/params.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -945,6 +945,16 @@ int ovl_fs_params_verify(const struct ov
 		}
 	}
 
+	/* Resolve nfs_export -> !data-only layers dependency */
+	if (config->nfs_export && ctx->nr_data) {
+		if (set.nfs_export) {
+			pr_err("NFS export is not supported with data-only layers\n");
+			return -EINVAL;
+		}
+		pr_info("disabling nfs_export due to data-only layers\n");
+		config->nfs_export = false;
+	}
+
 	/* Resolve nfs_export -> index dependency */
 	if (config->nfs_export && !config->index) {
 		if (!config->upperdir &&


