Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591387;
	b=RBY2BHL83EPyJtgDQNGBKRwwHaqVzY7+wILe605pR8DcBZtiIApMopq1GXgyU3sPEm/b
	 gCTqCjpgMh6zQ0pH3/xLnqATOq6yRhFHBMBTYz9INHkcN3YVtNzwQApbbkjTNm+HtpzZT
	 qO+sDQ4FRXfD4GjBBux3nIrPeUaI2mIHprzT9IT3YQnMOIq2cc79Q4o3yUjvVqEYMWqLG
	 TArZxiCMgK0+9HqHAQqSWVsFnhvbsWIaiKtsRGUfM3sUxrHYr/d0wt+ovFY3bYd01Bvoj
	 inHG2Mj9LiFa6AQhsU/ACLoyGraL37lRIABcRTxqlMqjSOrTLCpwh8z+AQaKcln49uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591387;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jk4S2SOYP6ZvcgKtYFH7gEFj+7p848lgjeHueNaj5rE=;
	b=pFVwQbNWJd4u+eomZopHC0huUo6iJ2vvn7rI4sYY/BbBt45C/iOG1IdPiUodoD57eJPi
	 CgAh0ITwYKoFq+q34XSXoWTxEm7XIpCGDXhDjtSvBTF0c1hVBv3ocP6bBx3oLlX5nmjkH
	 D+vf4AINrlJssYBuOoZ06fy3/HKGVF1dJO3h5XSuopmEN4n4PdJ3l7DSzLP5rrK7DJY9q
	 HiUsShN92okBguF4Z03abu0LNp6vMBoQMlIlbM+T0lm0ets5tVyD4bAoJgiH7rpGPsfPy
	 pRhHonv4vtOMKCvZazCu74T5oeM0DCdxJdyrHJsVRDPkRRMg3y5QVS1N38M5UgEYANg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Du18QOov;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2670F607A5C8;
	Fri, 13 Nov 2026 17:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Du18QOov
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B691F000C4;
	Fri, 13 Nov 2026 17:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591387;
	bh=jk4S2SOYP6ZvcgKtYFH7gEFj+7p848lgjeHueNaj5rE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Du18QOovjsoQ2HtlawOtwelN7erAb3fR47OyZjmbK0I8FVPolDXvO3NHaTMzS82pr
	 gq74MwK1KrY1SqfZNzVCRCoccRBMgD5vePpQDwFvmAuaXT/44C5dgq7Bg+OzlnXCwV
	 sqNWblss7wRBDPqazMMU57oGI5vZBCcNVYTyeslw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Markuze <amarkuze@redhat.com>,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 488/670] ceph: fix longname buffer overflow in ceph_fname_to_usr()
Date: Fri, 13 Nov 2026 10:50:52 -0500
Message-ID: <20261113153828.472576824@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
[ sashal: adjusted context for the struct fscrypt_str temporary buffer and %ld inode formatting ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/crypto.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index f955a37d6b17d..97fa6b821d5e8 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -389,6 +389,7 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 	struct fscrypt_str iname;
 	char *name = fname->name;
 	int name_len = fname->name_len;
+	int dst_len;
 	int ret;
 
 	if (WARN_ON_ONCE(tname && is_vmalloc_addr(tname->name)))
@@ -464,6 +465,9 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 		iname.len = fname->ctext_len;
 	}
 
+	/* oname->len is overwritten by the decryption below */
+	dst_len = oname->len;
+
 	_oname.name = unlikely(is_vmalloc_addr(oname->name)) ?
 			tname->name : oname->name;
 	_oname.len = oname->len;
@@ -481,6 +485,10 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 
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



