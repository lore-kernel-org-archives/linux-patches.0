Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590609;
	b=t5g/pw8Yoek/oJks+h5dDHE66+eFxZLCN5SylHREJy7g9Vmslg/M93/EhUTCrI/Uacuk
	 Hfvq0IEJdLaHq+aCSgHBx/IG9aOyxnYv4iRpXrkdL3qjGKEeEieDtq5rDTZ0LK4lF15vo
	 rOlNXzTxRELt+kNiHJvpF7RopvotSG48jrwgaaKtA3AbeqUrqR+YCkkfgYHsf8UyxYBje
	 Am0oD+pxJF/VDLb+kbI8Avi1nLLf3uXGXZ3EY/cJyiI/CqBEuiiba4j2Qo5FBF2l5X2pd
	 IZajtWzbmfAOF4oQAX5CHQ10Sqzu10wK2zubwX/JUG0o96SVyycxz7j6XMS4E7TUaCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590609;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zfbAyWvdlTGPCogsZIsnMY4w0tY5eCqBDonvvXhUScA=;
	b=M/2f+WBqkzkxvdVXJeCzItfpOorztDUK09rz6/XxUAaKw99zRq3K5kiCsxd8GParI/8n
	 vwWWdjbxdE9cdBWnfyHicgJMQZfuYDVuCxy077Xs08DfRdbLmQZVBfHGsmsaOPF5QJ84p
	 aggSq5G2OIJJ4SfSwOEW0wtXgftc3dlQ2lw+Ku0F6FxpgHRuq7vsUTPIk6TNiVcGZAuW7
	 Vhy6wCJcx5lv5k3fuOOgpp4+WvFe3ryDTE6imo4HZBHr+mZOpc2fE/ry/ukqRLkj8cqxY
	 RmKOyV8Ra0POMcCS5/fFgMBs795jHGWXj/+qzMYBFjrtePqZ/rT+3MRx0S0noueAuPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tgXsV2Ye;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268EB607584C;
	Fri, 13 Nov 2026 17:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tgXsV2Ye
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14331F000C6;
	Fri, 13 Nov 2026 17:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590608;
	bh=zfbAyWvdlTGPCogsZIsnMY4w0tY5eCqBDonvvXhUScA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tgXsV2YeJnVe++u6QNkU1xgexPLC1fg70+8fAJVNMGxOHaX58lgpMSWkjPRNZCk3t
	 c4D92icRhj5Rkl4F0yzIHqO3fRMa3CWJ/faZ9R7Xwszf/0UvsVhRdKWBvCLeF6CyAJ
	 fWwR5F1HRg9wPKFOpIYi/4pcgorNh71qwK7lMmkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Markuze <amarkuze@redhat.com>,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 536/686] ceph: fix longname buffer overflow in ceph_fname_to_usr()
Date: Fri, 13 Nov 2026 10:51:09 -0500
Message-ID: <20261113153839.397113636@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
[ sashal: adjusted context to preserve tname->name access because tname is a struct fscrypt_str pointer rather than an unsigned char pointer ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/crypto.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index f23ba5c148780..eaf12c9c86ee5 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -370,6 +370,7 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 	struct fscrypt_str iname;
 	char *name = fname->name;
 	int name_len = fname->name_len;
+	int dst_len;
 	int ret;
 
 	if (WARN_ON_ONCE(tname && is_vmalloc_addr(tname->name)))
@@ -445,6 +446,9 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 		iname.len = fname->ctext_len;
 	}
 
+	/* oname->len is overwritten by the decryption below */
+	dst_len = oname->len;
+
 	_oname.name = unlikely(is_vmalloc_addr(oname->name)) ?
 			tname->name : oname->name;
 	_oname.len = oname->len;
@@ -462,6 +466,10 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 
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



