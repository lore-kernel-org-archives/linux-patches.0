Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065393;
	b=ev+w0/Tj8JpcsE9N1rISXsfXQs3hy/YjVWjjqsbNPzbguk/Oz6NxS0hHkjCatRSsJYfs
	 d+Ef61OK8rHp/z18DpYG+ehJ9ss4ErrdtEL3JaASgCIO0kt4in0t67rDC8XBL4mREmkxb
	 nVxqn8KKNehgf7lq8GLj5UGYizAC+bmg9uFekiqRFAZo145YaPaHY+uLTKXMjhwzuPL7A
	 r0yYDd7ybqsN5sm493k1jkvWZj2w9G4jSmatAivvzobkSdTrfsvE1EVcqqtv0KrRCMJtD
	 cqOcEFr4tppBISFeWKyq96Gsp0j6QU0Imo/qIVtkaaPbqTGk2t43DzIxW4IuXYQ+byA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065393;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i9CRWeVaJskknFoeFAQw4hkniHpcE7WKDUoKfE4LmXQ=;
	b=20QAVYQ8nDUGYfRp/n/uo/GQjAlC+gX/KfaZ6Fpu4VjsGq4nYW40/hSakf/tsgHY770F
	 qdkxcWQWJU8L8pEys/9O2OSI0NQfn/UFOW3Hwrij4aPObQuCEDLzTJfz0/qs+bY5GBv0s
	 7l1FJ5RFON/77W68gcezmafT3SKcCuRg9XcoeZIazn/J3J005RzMzx9nmIlfaBeznkzRG
	 jsVh/c/HaG26ylb69DBJRuNQuDOuqnQy0f2+FkOYMRoKrrJfrl6+qlEekiidBQOW8mmtm
	 viOcDmcDWq9fEHXpEQStRfM1TYpiuEJYYcm2hd0konxdiG512IURgVXtCPETMf/ATTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Hk3ebfh/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05396606A32C;
	Sat,  7 Nov 2026 15:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hk3ebfh/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F271F0089F;
	Sat,  7 Nov 2026 15:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065392;
	bh=i9CRWeVaJskknFoeFAQw4hkniHpcE7WKDUoKfE4LmXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hk3ebfh/384wxDx9AeQg4WbJQQsE3u9SK+4lLFjn/GNQ2cpMJf6HAEZ/D9VCy84ii
	 eSXeChWx3GzLtQIHJ342h5YJsv2QXscIaz5juMa2/CWL+1p9JrGuMGKBP8Ac1jhRrD
	 Wkn+0pEFDsf3Hb5Ze+gnD42+sYqp+1rWDna+8W20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Markuze <amarkuze@redhat.com>,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1115/1257] ceph: fix longname buffer overflow in ceph_fname_to_usr()
Date: Sat,  7 Nov 2026 08:56:51 -0500
Message-ID: <20261107135010.042226063@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/crypto.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index bc0a097a4cea9..845b69ba890c3 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -313,6 +313,7 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, unsigned char *tname,
 	struct fscrypt_str iname;
 	char *name = fname->name;
 	int name_len = fname->name_len;
+	int dst_len;
 	int ret;
 
 	if (WARN_ON_ONCE(tname && is_vmalloc_addr(tname)))
@@ -387,6 +388,9 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, unsigned char *tname,
 		iname.len = fname->ctext_len;
 	}
 
+	/* oname->len is overwritten by the decryption below */
+	dst_len = oname->len;
+
 	_oname.name = unlikely(is_vmalloc_addr(oname->name)) ? tname : oname->name;
 	_oname.len = oname->len;
 
@@ -403,6 +407,10 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, unsigned char *tname,
 
 		name_len = snprintf(tmp_buf, sizeof(tmp_buf), "_%.*s_%llu",
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



