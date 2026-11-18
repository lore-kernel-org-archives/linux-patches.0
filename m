Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038207;
	b=TY80Vall3nb1Lfpa3Q0lWuzUNIkjEFV+hm83FqaCJPtqbRiWvD5FhyF95y20ijfI5GT9
	 BpXZSSikEnL8T7quPUuPB2CTSDReqJ2e+Ua3shxfYEkc95kq6x8q8JbBQipVG3jPmRxpI
	 CqTTNkDk+Nh2OfwGXiPc5Vtvsesv4n4H2wHwQqo0M7jyly+KJnCQ9WYrzcoiBSXmlunfd
	 lV+awCSpLEgcXCAoSaSb+SA+SZBIG1t3kBMYX2vHBi4P5snIUJd3Y+fnqsC29P+Hx7Zp0
	 QYa8EHe6UJ46DEQxC7JlkqZsW2Ncz4kvGPvBRjKIB+rxh9ZBWA+ELmcBEkJHVqqcDQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hJqufHZ9BMMXfBKes1oTO0Cy/f9cL+qEQJTXtXkE/I8=;
	b=BqR4FfAsI/DEqX1pt75+lU2F2taryO/ulD65haGbIFGJy02dLkphup1kkcPwG0MQU8Ea
	 IA4c4ofs4w2TEOMwybDnDr9BkCscoT8QKUJ3nQ/ziuVo2ft5hXKEMO12VjP+KDrHs7s91
	 TmOm8zsoFj8iuRQUY/uyY6Nia6FkkM0X8RdB7bri7S9Wp5xKvo6eM6Lwe9KG44G+9iBHo
	 LZTeI/CAoUcKZ6BEqOtJHQcoHORMQ+vKTKQESQcvK0EfhKFythxoEsPLz1U+ajzo8BGQb
	 3OzemX+58GmOScYnfrNmZHMBv2et3Cz4THL/PIROXWIR39dz6oUj9kPFV90PBYgK6NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BS6emr6l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0233606A320;
	Wed, 18 Nov 2026 21:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BS6emr6l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4841F000C4;
	Wed, 18 Nov 2026 21:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038207;
	bh=hJqufHZ9BMMXfBKes1oTO0Cy/f9cL+qEQJTXtXkE/I8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BS6emr6l8mMZXCSkkopUcYIfZiwWC1dhUG23/OXUa4a9h8cSrjhu1W/O117pIX46u
	 mjgMFiL6C7EBIsmVhpCCJYJ1R8Z7DZjJ5sAOMJ/M9/jDwiyK1JldfyCbYjNNOb9DO4
	 VJRbQxlc2Y1ENnlxReppmlmVb+K3bUCpL3RjFk4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Markuze <amarkuze@redhat.com>,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1664/3318] ceph: fix longname buffer overflow in ceph_fname_to_usr()
Date: Wed, 18 Nov 2026 15:38:06 +0100
Message-ID: <20261118150411.702508323@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiangshan Yi <yijiangshan@kylinos.cn>

[ Upstream commit 71975d6e0db17646102488cf54480fda9de0f7a7 ]

Snapshot longname reconstruction formats "_<name>_<inode>" via snprintf()
and memcpy()s the result into oname->name.  Checking the length against
NAME_MAX only protects the LOOKUPNAME/export callers, whose buffer is
allocated with fscrypt_fname_alloc_buffer(NAME_MAX).  The readdir path
points oname->name straight at the altname in the MDS reply, whose
capacity is altname_len; the reconstructed name can exceed that while
still fitting under NAME_MAX, overflowing the in-place destination.

Save the actual oname->len before the decryption overwrites it, and fail
with -ENAMETOOLONG when the reconstructed name would not fit.

Cc: stable@vger.kernel.org
Fixes: dd66df0053ef ("ceph: add support for encrypted snapshot names")
Suggested-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
[ sashal: Adjusted context for the fscrypt_str temporary buffer and %ld inode formatting. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/crypto.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index 62f33516e8bb6..9eb7f5ae3e58c 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -388,6 +388,7 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 	struct fscrypt_str iname;
 	char *name = fname->name;
 	int name_len = fname->name_len;
+	int dst_len;
 	int ret;
 
 	if (WARN_ON_ONCE(tname && is_vmalloc_addr(tname->name)))
@@ -463,6 +464,9 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 		iname.len = fname->ctext_len;
 	}
 
+	/* oname->len is overwritten by the decryption below */
+	dst_len = oname->len;
+
 	_oname.name = unlikely(is_vmalloc_addr(oname->name)) ?
 			tname->name : oname->name;
 	_oname.len = oname->len;
@@ -480,6 +484,10 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 
 		name_len = snprintf(tmp_buf, sizeof(tmp_buf), "_%.*s_%ld",
 				    oname->len, oname->name, dir->i_ino);
+		if (name_len > dst_len) {
+			ret = -ENAMETOOLONG;
+			goto out;
+		}
 		memcpy(oname->name, tmp_buf, name_len);
 		oname->len = name_len;
 	}
-- 
2.53.0



