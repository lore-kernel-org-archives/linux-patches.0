Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036914;
	b=UC7f9G9oWbFm0b9fHIGaWc402Sf9l6MAtGhaAyd7XHbpwG2JOBRlQKDWd2tQbwsjjxBZ
	 Cl/dqgG6PbN3uYoV2gHyc+id/pO8K0a5Tdzi5IXtIhdI3wgdudLwLlqqTLxs7zu5tCicd
	 jPCvUZCPnISHoq6NnBrc85WLcWBnyFYsbsbb0/OhFGFwlwZw0/X64qgnwj4HzYMyG5bSB
	 dJQSQnlv7gnavwHedlCOBaX2FkM1YV5ce4SnfmG/zuU3Okpc4MIP/1o3P7qpKspn5vCYu
	 SuHDexwn4dhgtTHbn3EpA7nC1UlxIFTYwcbK3Yncjoh8mJoRztNwyFzpDarF1DYIs5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036914;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aBs3fFcU0qJiRTDvvQv9XXz1xap0788tj1i13rOk52c=;
	b=qCOB2xDgGdGnhARl2EbklY+ZPAsdRivA1BjKqnjoeAN/8mt4f3Z2DdsaqxeWPOg4EiYq
	 v66NiH/rH2EDlqkwjMZMy54zoUixS6aE+mCdLtZgEjdwKa+tTBbOuCXldbcIfyKXZgHaA
	 Z4dL3o4sTXf6DGcACy5WuZpsQACK+Xxhl0XfHWL/6gz9TjFUDpn04BenHtiBjqQlYtvzs
	 HXLpROXa8xcg/fGSfNqNNBcI+PxprYM9QXmw+D6PZJo9430Wn5LG9BOvN/V+e/dBaMyDf
	 y4DmQ8/GHS5zjj0RnvB9HB/JLigQgzLAsMbxCLD9Y574KS0MyNG0B+ABfZItk6LBeDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L4jwFWru;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B995606A320;
	Wed, 18 Nov 2026 21:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L4jwFWru
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B4C1F000C4;
	Wed, 18 Nov 2026 21:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036914;
	bh=aBs3fFcU0qJiRTDvvQv9XXz1xap0788tj1i13rOk52c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L4jwFWruwt/RiS6l5e9XBRmMhT3xLs1y4O06gmi+duLFHkJSrSL6Mp6BtAVFwUMPG
	 dAxi4ZDJqZU/ql+M1CEp95IXq9I2JEUBnHy8cEr779vTLJq2wQYwYGL1fIIR/iRXcp
	 exA2UaDxVG4RWYedx8u+bFltMb3ECUeonLfOvQgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1227/3318] ceph: fix out-of-bounds read in ceph_netfs_issue_op_inline()
Date: Wed, 18 Nov 2026 15:30:49 +0100
Message-ID: <20261118150356.991148022@linuxfoundation.org>
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
index a5b21f4481946..a5773ed323d7a 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -330,6 +330,12 @@ static bool ceph_netfs_issue_op_inline(struct netfs_io_subrequest *subreq)
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



