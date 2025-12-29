Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D12233343B;
	Mon, 29 Dec 2025 16:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025885; cv=none; b=ZgbXhhh6F40Hh0HuJbpo3RGikRRbsfm9z56crrb64fZ923BmXHxgI0hbBRONGeb9UL+W7kAutVuBBGU9S/emDYLF7VUX5J40r9Xv2o1yeLpRngMC3897fIe+naJpBm693SktEaA+Eehos+vKWln+X3JeN3aKvuRY86iwBFCt4kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025885; c=relaxed/simple;
	bh=OMAKTWVuHyhoYAuxVbbasqVvne8cNmZYwUB0iIx0y8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyh5ZctjUMTsEXJw/Y/OKUSSqTfiDL+uIrW6YC+uZHGbKfn72Mg/XIF7AB5tVPr/EFftN3Bk97wCjENlC3cv5Co84YHysxA6+yUxzLq5iuAFUAhYwTKyleG23Rk6viNLAZxXoLFDP6LxwmWttU2QwB9tUkh92rfVPn4k1PBzEpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nV6GbGh2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nV6GbGh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBC1C19421;
	Mon, 29 Dec 2025 16:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025885;
	bh=OMAKTWVuHyhoYAuxVbbasqVvne8cNmZYwUB0iIx0y8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nV6GbGh2JoHAWKUSMB9Pi18HsuAOWeAxMNma7FWflRoKRUQ90f/+01IAo4Kqjq0eT
	 4rW938MvdcgghqlzHJXPC/pQc33guWbGOcCl+0vW8iPHFiSKlPBY9iWaS+oPd8vlWe
	 53f0m4iF4fUUBc4vlEbQ5IfaJWab7P3JN9EfCuZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 371/430] NFSD: Clear TIME_DELEG in the suppattr_exclcreat bitmap
Date: Mon, 29 Dec 2025 17:12:53 +0100
Message-ID: <20251229160737.976882411@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit ad3cbbb0c1892c48919727fcb8dec5965da8bacb upstream.

>From RFC 8881:

5.8.1.14. Attribute 75: suppattr_exclcreat

> The bit vector that would set all REQUIRED and RECOMMENDED
> attributes that are supported by the EXCLUSIVE4_1 method of file
> creation via the OPEN operation. The scope of this attribute
> applies to all objects with a matching fsid.

There's nothing in RFC 8881 that states that suppattr_exclcreat is
or is not allowed to contain bits for attributes that are clear in
the reported supported_attrs bitmask. But it doesn't make sense for
an NFS server to indicate that it /doesn't/ implement an attribute,
but then also indicate that clients /are/ allowed to set that
attribute using OPEN(create) with EXCLUSIVE4_1.

The FATTR4_WORD2_TIME_DELEG attributes are also not to be allowed
for OPEN(create) with EXCLUSIVE4_1. It doesn't make sense to set
a delegated timestamp on a new file.

Fixes: 7e13f4f8d27d ("nfsd: handle delegated timestamps in SETATTR")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsd.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -547,8 +547,14 @@ static inline bool nfsd_attrs_supported(
 #define NFSD_SUPPATTR_EXCLCREAT_WORD1 \
 	(NFSD_WRITEABLE_ATTRS_WORD1 & \
 	 ~(FATTR4_WORD1_TIME_ACCESS_SET | FATTR4_WORD1_TIME_MODIFY_SET))
+/*
+ * The FATTR4_WORD2_TIME_DELEG attributes are not to be allowed for
+ * OPEN(create) with EXCLUSIVE4_1. It doesn't make sense to set a
+ * delegated timestamp on a new file.
+ */
 #define NFSD_SUPPATTR_EXCLCREAT_WORD2 \
-	NFSD_WRITEABLE_ATTRS_WORD2
+	(NFSD_WRITEABLE_ATTRS_WORD2 & \
+	~(FATTR4_WORD2_TIME_DELEG_ACCESS | FATTR4_WORD2_TIME_DELEG_MODIFY))
 
 extern int nfsd4_is_junction(struct dentry *dentry);
 extern int register_cld_notifier(void);


