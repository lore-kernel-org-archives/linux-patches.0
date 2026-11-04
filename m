Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828897;
	b=Bd1FmMIc6C+6a+7mLxFxn2c5DzErl92tjFNeZq/GMlaYXj3LfYv9F7p46fT1xYYXX/OR
	 u4geBOXivRPvpAlv+Yut4d4/GX3xn+3YdH2glmMovWma8fO8lSCEvgXYcRfRl03told6X
	 4kY5ofTX44s37d7Or39p0EtMMYkiG9+gVLU8VAu2njXGQtbUO4gGFr2ih5ODYzPvXzUSN
	 XCENKiQqZlU/QfbIBLe8cDM/IIkVM7I75tKZOA1nW+xRuq9q+d5zKvLzj2X4O+OC2JubC
	 Od0m+BwL4swt89FGHuCkZBGYRVU4cArWKhq2NfAXz23loh1PTKqnNh3ukJ96yj2yQMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zILiSdDdvmOKPHZyVmO1OSYBffzkdKuHg7MVH9mTiR4=;
	b=0lHtWpq7B70XwdhtWfDyfmUF81foWqINzYhLR6nU9OkMQsLjRXbu99Y2U+tZRyvo7Ei0
	 Msv9FmmX/jyy6N0GTpWODLrtMjgvgEegrVL1U4X0QkIQveZ7rKUtgmex5S5p+v7bXrBVz
	 pHhBw6M03bl8QaBktejnTQ8/pzH5w3FrzYeSZmzTEZo5sThORBOpGtiqZ6z6AsfV9tj5g
	 ndanmQsAS3zcxg2FmHGDEpvKLg3feK3Ec8hlmVMZlN2SjpbbvdM7Ld4tZ3FWjGXbhae9U
	 eU5FEsko25aDZAmweXx9Oit8CGVwUHjydeEUnB9pBJHBFsQSRJChSZdlTSsmhUx97ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jAoqY2cd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BE9606A33A;
	Wed,  4 Nov 2026 21:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jAoqY2cd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35EF31F0093A;
	Wed,  4 Nov 2026 21:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828897;
	bh=zILiSdDdvmOKPHZyVmO1OSYBffzkdKuHg7MVH9mTiR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jAoqY2cdAPSJeeIEYftGBOfYkhQhW1XNNBI+A1JeI209otwq4uI+gTjDrxJlIOyrT
	 qZbp8CPsNQeQskzR+h6Rrp+A4GT+/fzsIwmTuwwArsd9dGAW1rLHf05sTAG9izzw22
	 NAaxk7iiXbWbjq6vdbTKEMpqewAPa10vUcVKVrWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 304/547] xfs: fix buffer overruns in xfs_ioc_attr_list
Date: Wed,  4 Nov 2026 16:08:08 -0500
Message-ID: <20261104211046.844921914@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 0b9081a774ee7b9dff1e9ac3765b73c1d6bba5b2 upstream.

When we converted the al_offset array in struct xfs_attrlist into a VLA,
the size of the object shrank by 4 bytes.  Unfortunately, the buffer
size validation in the attrlist ioctl wasn't updated to notice this, so
the al_offset[0] assignment blindly writes off the end of the buffer.
LOLLM noticed the omitted check and complained.

Cc: stable@vger.kernel.org # v6.5
Fixes: 371baf5c9750a2 ("xfs: convert flex-array declarations in struct xfs_attrlist*")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_handle.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_handle.c
+++ b/fs/xfs/xfs_handle.c
@@ -409,7 +409,7 @@ xfs_ioc_attr_list(
 	void				*buffer;
 	int				error;
 
-	if (bufsize < sizeof(struct xfs_attrlist) ||
+	if (bufsize < struct_size(alist, al_offset, 1) ||
 	    bufsize > XFS_XATTR_LIST_MAX)
 		return -EINVAL;
 


