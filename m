Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828860;
	b=Z+Wt1jsqrvJdY0FClDGs12iRzzW8ogHzLZZHiW7PSzYaVh8dP2OurYEI4RpMYeh21haz
	 ARGo8RgaNgezJtO9wov27hMALcE2xtT3tvWXcWcyNX+IKXqymwIfsDcZXxdi5wNpXUQSs
	 i0BVstWicfLr5sD0A0UD4uRFFy8e7LTATr5sh5uKf7q3DZP9/z49yUDuIiiypzfs4JgeE
	 8A0zB3rIuwJQ9afFOfb525hKVbHf7NUTkuH5/lQ3I3xOKGIRt2/N1wcct9UYxGFPRFC7h
	 nGARcH84Qh3r7igSUfqXH/IQYOFKR0wenNN5hCA8iXkY8Ei/gfPjnjzQb/Y3k+L0FfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q1wKGDY5NlUIbaI4S9DGXUEf50U4dH4TEjRmHq9sX/U=;
	b=ZcrXXmsQTJtHpVmV6w32WTkwMJ6D8Sa/6HEwjlnZJ7QonuyqoQm5wfRl5+rvyNuHJP4W
	 zC/qY6BoL+2KwzhCGDpQvWigvTLiuZonPrAGbw7k8sQPn4yvOAObr0QmRCVSnRDCwKhEH
	 em4maAdKyjbuh5tsuqUKLDen1khJnG5/Q9JmGVX7YCiKt2hpuHr8LYwyYfplRMfSGLRvG
	 6mr2RUTVDytltKYI7/MO2D3rPG24hp81Dqhv4wPDpWBEMx+O5WBCsaPIJcDFEh1T06iqh
	 m4XsVEvlmlLQWRlNWKnZmJc4RXydWKI0cljiZt2fDx2MOpdu4pyNaUK0IrEXFNzo9pQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=leCheBjQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F326070F18;
	Wed,  4 Nov 2026 21:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=leCheBjQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193721F000C1;
	Wed,  4 Nov 2026 21:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828860;
	bh=Q1wKGDY5NlUIbaI4S9DGXUEf50U4dH4TEjRmHq9sX/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=leCheBjQBXzyyHgLS5149SoTrOH77CN+GrS6G8hNLYGq7gJ2ymRJYWnw2Kl4gGRLK
	 lwT7nYOdJPtgkx8U0hRA3z2ctR+yqGBkmnF+nHUGbGjWDN9aNuyKYAVQcud0ZtjzG2
	 +PUyw8sFeF7MKxdGmryRKDL7thpyHAc9455Hzi9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 7.3 286/547] ovl: always encode the origin fh when index is enabled
Date: Wed,  4 Nov 2026 16:07:50 -0500
Message-ID: <20261104211046.327284425@linuxfoundation.org>
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

commit 949f9d8a5580c77a45fa759123367682aba4d173 upstream.

On an overlay with index=on,nfs_export=on, copy up of a directory
crashes the kernel once an LSM has started to deny CAP_DAC_READ_SEARCH
to the mounter, the task that mounted the overlay. The mount and the LSM
policy change require root. After that, any user who can write to a
directory that exists only in a lower layer triggers the oops by doing
so.

Before a file or directory that exists only in a lower layer is changed
for the first time, overlayfs copies it to the writable upper layer.
This is called copy up.

On copy up, ovl_get_origin_fh() encodes the file handle of the lower
inode, called the origin. It returns NULL if ovl_can_decode_fh() says
that the lower filesystem cannot decode handles. Whether the callers can
handle NULL depends on the index option:

- Without an index, NULL is fine: the callers store an empty origin
  xattr.
- With index enabled, overlayfs keeps entries for copied up inodes in an
  internal index directory. The name of an index entry is derived from
  the handle, so ovl_get_origin_fh() must return a handle or an error.

The mount only enables the index if ovl_can_decode_fh() succeeds for all
layers, but the result can change later. The function checks the export
operations of the filesystem and capable(CAP_DAC_READ_SEARCH). Copy up
runs with the mounter's credentials, and an LSM can start to deny the
capability to those credentials after the mount. ovl_get_origin_fh()
then returns NULL with index enabled.

This goes wrong in two callers:

- With nfs_export=on, copy up of a directory creates an index entry for
  the directory. ovl_create_index() passes the NULL handle to
  ovl_get_index_name_fh(), which dereferences it.
- If the result changes while mount(2) is still running,
  ovl_get_indexdir() passes a NULL from ovl_get_origin_fh() to
  ovl_verify_set_fh() in the same way.

Before the commit in the Fixes tag, these two callers encoded the handle
themselves, without consulting ovl_can_decode_fh().

Reproduced with a BPF LSM program that started to deny the capability
after the mount. An unprivileged touch in a directory that had not been
copied up yet oopsed in ovl_get_index_name_fh(). With this patch the
touch succeeds and the directory gets its index entry.

Fix this by calling ovl_can_decode_fh() in ovl_get_origin_fh() only when
index is disabled.

Fixes: 5b02bfc1e7e3 ("ovl: do not encode lower fh with upper sb_writers held")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/copy_up.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -476,8 +476,12 @@ struct ovl_fh *ovl_get_origin_fh(struct
 	 * When lower layer doesn't support export operations store a 'null' fh,
 	 * so we can use the overlay.origin xattr to distignuish between a copy
 	 * up and a pure upper inode.
+	 *
+	 * With index enabled, mount already found that all layers can decode
+	 * file handles.  Do not ask again, because an LSM may change its answer
+	 * about CAP_DAC_READ_SEARCH and index users cannot cope with a 'null' fh.
 	 */
-	if (!ovl_can_decode_fh(origin->d_sb))
+	if (!ofs->config.index && !ovl_can_decode_fh(origin->d_sb))
 		return NULL;
 
 	return ovl_encode_real_fh(ofs, d_inode(origin), false);


