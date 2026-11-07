Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065394;
	b=zwVo7+WbRmmBfhTo6qGHZx42dIh4DBF8oF7uKsAe9Q4Qi9Jc/jKN/4yEpnmdH34AZG6k
	 6jb7fOFT4kwPqpSnllihVXUNhhgLXFakRODTYYDJ808IoF0Rqkkwe2hQxx1aAP7Pwa4Iz
	 nWGSzfi5NxcSnwp5dFOoViy0wlr472izBNuDDSE9i0Wh6oYu/XLOsNqpnQwQMgfd7FBaO
	 YVQseFz/9PXvOmYZma9lFBdC3ztO8FooCe8DFTe7mqCbZ5d25al0z3vQQg8J8Sp/FhGl8
	 WoZBAAe8eRgv/R+XDn9hHFbvLWo+FZz9w+16j86Ik9zLRIMMDsXgdRuGQC8/UWRTYnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065394;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lP5q7ed8U+YVrEqyTsRGEHd4xqcI6KrsRKPufg3Vn7o=;
	b=s984we9Xo7sdhtAqdWVhNMzmqNlX6ebauI8/s7pEqnCMGswAEnipcQZKE2OzTdtrxU5y
	 od9IKNxw5nIIvpauz02jipxOzZ7+9oRMwObOKWCrnV0dFj59645t/iprNbFVMdtOiGZYT
	 I/+pyLh5YyqA9DEPbda86r/IB9Ewcd4Tt03OIXJ1ymHgc2G1YNrANWzGDKtHAqa4YhGx2
	 Le/C9O887HMG0GV3DLpugFLaSqDGVYkn6SmEc6fLMVps1y1kVSlJd1fAtr08ywiOw8nGR
	 S0Ps/qFu8s+NDOcj1mkysCHvxjjDkTFqk6z5X+w7+vny3nSJ/OzLPi+mhp/2AZUsQNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tC+OGgNv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EDD606A32C;
	Sat,  7 Nov 2026 15:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tC+OGgNv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3F21F0089F;
	Sat,  7 Nov 2026 15:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065393;
	bh=lP5q7ed8U+YVrEqyTsRGEHd4xqcI6KrsRKPufg3Vn7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tC+OGgNvxFk1OYP/jQ55qZoUfwSQufYs8GBgSJeN5p0DMlpKuUUv1h2lcrqqq4cWr
	 /qQgXCfxtGOryeC4r5haDZv+d8hwMQXNaRSEv21uxzSZAAOKhabAz7AEWeQmNxIsmD
	 txfAFV0iHMN86eE9DcP6+H1oFxFciewDEbObxqEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1116/1257] ceph: fix out-of-bounds read in ceph_netfs_issue_op_inline()
Date: Sat,  7 Nov 2026 08:56:52 -0500
Message-ID: <20261107135010.069400410@linuxfoundation.org>
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
index e598b2d424ec1..286eff8849dfd 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -322,6 +322,12 @@ static bool ceph_netfs_issue_op_inline(struct netfs_io_subrequest *subreq)
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



