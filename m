Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F021B96D;
	Thu, 18 Jan 2024 10:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575093; cv=none; b=uYqEpnjjMy58+pheQghL6qMgGb1/9+XxZSNuGwy+6VglGH2f9ErJu+OCzqSh2aGBunpoMU6O4UTY9c74RQqcLojF0Yib/v9EGq73zI3YKRG3B1qQLpAvpj0vTj0qa43Mbm0JwfLkZWxBOkzNWlTUTbWZrZVrOZXuxKjmkcAQLsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575093; c=relaxed/simple;
	bh=D2XuAGC7vTjqBDX5t4AMt5BdPKdJPUGsVa34aQffAL8=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=PEIk7rvUJFZe6xiCt11T+35Vv63a6cdCO8jVluonqxJwvPPFePXxZqpFHCBVa6aniTRUMsSq/iUOQE1JRb0rH6HOM0/RWNxPdjVN1Sdn3VTjFS2Pxq77mgf4iFZXgamtLVgyqkQvtu8OHNH5Oxx5eXG9a2IgE/glqbA5ujC0kXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GXwclD5X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GXwclD5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13184C433C7;
	Thu, 18 Jan 2024 10:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575093;
	bh=D2XuAGC7vTjqBDX5t4AMt5BdPKdJPUGsVa34aQffAL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GXwclD5XdNrJBMJAt74u1SPSmbEyZRCDCojSTI+tBqYDkUitsdlEoe1rPwZs+sWyl
	 oIuHDIAs8I02O7GZs8ahHrq7FuAEcjKogs8i3V35MW2UyEqXwCRXvUAcBk2j2Isqgn
	 bZ2U0mNqHVrmnmStnXZ+JhGLts8tAiBGRsEuZ8/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.6 001/150] f2fs: explicitly null-terminate the xattr list
Date: Thu, 18 Jan 2024 11:47:03 +0100
Message-ID: <20240118104320.100026486@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

commit e26b6d39270f5eab0087453d9b544189a38c8564 upstream.

When setting an xattr, explicitly null-terminate the xattr list.  This
eliminates the fragile assumption that the unused xattr space is always
zeroed.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/xattr.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -754,6 +754,12 @@ retry:
 		memcpy(pval, value, size);
 		last->e_value_size = cpu_to_le16(size);
 		new_hsize += newsize;
+		/*
+		 * Explicitly add the null terminator.  The unused xattr space
+		 * is supposed to always be zeroed, which would make this
+		 * unnecessary, but don't depend on that.
+		 */
+		*(u32 *)((u8 *)last + newsize) = 0;
 	}
 
 	error = write_all_xattrs(inode, new_hsize, base_addr, ipage);


