Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063701;
	b=uAQ8mY/gm09sjRDPaCPL+iBYRTCHJqCyQNxriGzgNZHaWHi2/UbZQC7aFQgir1JeDSx/
	 yLdM7Z2Ph8akaMYD7cJ/hdwsXXFhZHiWSWBBVR1WBCPagJB8D9REdgWUhdMM5bpay4PTi
	 KAnRh8RWdZiyTPXuexBRhvE2D2zhe2dOxCCrXGAr1pkK6Bpi6w086xg9IP+LMvd0KEt5N
	 x61Mcq6FYjDDfZ1iC79ZEu+Km+T61NhRglg/ptSRocV2fRIXuMRrrtY3J9Rgxmix03ZI3
	 gQwLG4y/+mC2ZXxonhv/8CkfQRkx+biNZcbZpQf3+zyNe73QtikU9t5AAB/AsqAgDSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063701;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hstaBIEo0dzr/Ed784izEB9o3RvtNiiUIROxtb7kKZ4=;
	b=NoLjA8/bEqWF7mQmPDb0xGwJs3EznpXeKibLp3/6AjKD3fUZbhpSBlD2AjbA74IpsM70
	 pdQpewomtWWpgYGZClyRefNsVi/GnC/wPtozFS2K7tzH8j16z7beUAXhA6LVht1HiXHEV
	 RSed5SgqnUzgHcmMUiPKbPcQFNUQ3DC92y79KKMtzlVKxdU5SsYe5fA5v3MpVMhyBl9/Y
	 Ry64p6HCsBwziyBBgfY+e3P9/mvatNzfQ/bxoDNKTotKCHq9M6V2qrNG95eolH9T99qsU
	 3K07uhQymo1p1ro96IXj/Zp+qbuvx7CwwHddHCi67fcEDsABfZkVC+Y4x31ajC3Bb/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i7oVD2L6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61DC60A6F61;
	Sat,  7 Nov 2026 15:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i7oVD2L6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8411F0089F;
	Sat,  7 Nov 2026 15:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063700;
	bh=hstaBIEo0dzr/Ed784izEB9o3RvtNiiUIROxtb7kKZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i7oVD2L6omz9uYfdgKuQhcAoje/dNOm9fuPi5BhK4bRHXEMSt2KeYxsyQ8LH/fGyW
	 QKuLY35qChD4xCSjEr32naD/tBKHVNuNMgz0IafWQ+WGMxzp3HaYpfSzw1PmDGM9ce
	 KgRwx/btQsUQBC4Wu7BwbYvTUSgdCWQELaMqLw1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 767/869] ceph: fix out-of-bounds read in ceph_netfs_issue_op_inline()
Date: Sat,  7 Nov 2026 08:57:29 -0500
Message-ID: <20261107134918.722770761@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Guanglei Zhu <zhugl3@xiaopeng.com>

[ Upstream commit cdbb60f00f87297a9db2652847dfc0eaaf3c45aa ]

The read offset is validated against i_size but never against
inline_len, and the two fields come from the MDS independently.  When
a read starts past the end of the inline data, the subtraction

	len = min_t(size_t, iinfo->inline_len - subreq->start, subreq->len);

underflows and min_t() ends up with subreq->len, so copy_to_iter()
reads past the end of the inline buffer straight into the user
buffer.  A malicious or buggy MDS reporting a short inline payload
together with an inflated i_size can thus leak kernel heap memory to
userspace.

Bail out with -ENODATA when the offset is not within the inline
data.

Cc: stable@vger.kernel.org
Fixes: 5b19f1eba459 ("ceph: make ceph_netfs_issue_op() handle inlined data")
Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index cfbd88412f047..f58eba5456e36 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -314,6 +314,12 @@ static bool ceph_netfs_issue_op_inline(struct netfs_io_subrequest *subreq)
 		return false;
 	}
 
+	if (subreq->start >= iinfo->inline_len) {
+		ceph_mdsc_put_request(req);
+		err = -ENODATA;
+		goto out;
+	}
+
 	len = min_t(size_t, iinfo->inline_len - subreq->start, subreq->len);
 	err = copy_to_iter(iinfo->inline_data + subreq->start, len, &subreq->io_iter);
 	if (err == 0) {
-- 
2.53.0



