Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045779;
	b=Ue8OYN+ITip+JodSKroooLePFPoEXpdPk3R7JTTnZUBR2GfofKyOL6QvT/8XxtNEqEfD
	 kzYmPz1pTM3JShiy5/eTyWmHU/m2RH94ku44d+KntypTx5d9zDzT9RV6VO6zDC+yLE/T7
	 c6+8szdYKXqXtvbbEFyyZaX4ADwIExrREi6Rj33NNLSdQSw8YbZuxO7VqDh5ZmsmjSnvi
	 MkfEEoCsgFOawogT6Xkm9TI9WbAKXLDdYQov2m2FfDCPWiopcRcXJLY51whs6qsswLwPs
	 ofZfPCZVLAREccrHCIPV+oWiKnr7WKAEmSBEza3Wobs8IQaoSgiFTWxiqCYoC4uDVAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045779;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w4cums/DzwWfquaIzQ9kD/phJmJ8ZIFS38KNEDDC2sI=;
	b=ion2RZsv/wh6lQSk8yV5fjMvVBKLB23MR8dHBkCUYg+YO3kfHchKvueu6LlSGMMOCo/i
	 y/S54PlGDnE9P3ZaH5zXuxjLSaxb3mj02E8h/Th364HCb9h/9F+qsSMczz2U0y8tU0twU
	 ROL4bBDPvrTmjGEbPcPLxZ328/o0hOzVg3deMGA8AD0+rS1lfIbwsY4ZIgMDKH35gCDes
	 Rn4sRsjDiVohcYCkzatFMiTIHDH5HkV+qHtbiGDnG4+gVyUSTFSAlCv9N0WiH1hg2p741
	 8N2yuuz8PzNySxd5diiKac8QTZl3SwN1gYCUwHAE8V9RprVsONAgavlGdaGfVL9DL0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SqqezXOR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46886606A31C;
	Wed, 18 Nov 2026 23:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SqqezXOR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0161F000C4;
	Wed, 18 Nov 2026 23:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045779;
	bh=w4cums/DzwWfquaIzQ9kD/phJmJ8ZIFS38KNEDDC2sI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SqqezXORtUhWVP81BCHrRrnowtBc7Z8eDHG4hR3tofGvVr2URDH9kuLIQcQEnlD3K
	 5xLDs6JH48Ib1iu3JPuVTSfqfXDd7uSOkH+6tELRA63i39QXCCT1oqgLLovK9n++zV
	 FsNBBdXFnD2/vGR6KUUPhrgSpz9XEIzWe3qgWgAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1046/2857] ceph: fix out-of-bounds read in ceph_netfs_issue_op_inline()
Date: Wed, 18 Nov 2026 15:34:40 +0100
Message-ID: <20261118150239.257694181@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9f664a991049d..823462f07fc3a 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -312,6 +312,12 @@ static bool ceph_netfs_issue_op_inline(struct netfs_io_subrequest *subreq)
 		return false;
 	}
 
+	if (subreq->start >= iinfo->inline_len) {
+		ceph_mdsc_put_request(req);
+		err = -ENODATA;
+		goto out;
+	}
+
 	len = min_t(size_t, iinfo->inline_len - subreq->start, subreq->len);
 	iov_iter_xarray(&iter, ITER_DEST, &rreq->mapping->i_pages, subreq->start, len);
 	err = copy_to_iter(iinfo->inline_data + subreq->start, len, &iter);
-- 
2.53.0



