Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062571;
	b=z0ho5Mqtx4nHdyiYYq7v1NQ9b3O1Lcrwt5cWyN3LEAhyh4novBGkjJShE+o/R3spFGOD
	 ZfW9+JCmnqfX9G3DKKfsl39BFNj2xpk9ZuVn4J+vG8xA8k8EUvSANFhTtrnsGSd346lQL
	 /nYSTwpyJB873O+IGp+UxRRLc4tmAFIndSSdIfUFFMxutIhhjkntZPmWexRZuufoBlkRn
	 reakI69dWCJgl8WOwCi5Mt1Rl322PRgCwdoYInvWNyiCGAOGCOlbKg7lY0pXHaFBLNCKB
	 teatWymFoCJQ8gCqUPUPp6ADA9Rd2WvlNEdoCYBfUDPJhzNpi+2F9MWOIk5BymoyCqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062571;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hRoR+uhaQEn/JTWamCHYEpVzkyx9zCQOJLgRh2qiWv4=;
	b=z4kbhArq8NFE84opnTIK3l9hWzPwrKZExRa7l249U18VeDkorhECr3iV5xPaXv3GRtaB
	 b06RSGi+K2NRVNn8RyIx31fdTHD2AtH5Lc4NID8unUgfnUsuEHTW/N8HcDlZYJnFYvwB+
	 PlK3K+/pNcOyySmk4e6KqT8n6iYcJQne24oNPuulPcTaa1iPC5PxNCJMD4k4ffBv49hy0
	 FKO9TZLeMe7UssQcf9/yERyVGuTI/XRFT/ypHg9AkNCEGjCSQRcjXfR5XmZMbELLBGLMG
	 FEBWLVBfFswzBcC0N9TG8FZedU0zxPZCK/l1MTYWqBh8wufSU71WUQsuos5j2Lwawcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mzFwnu3Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DB9606A32D;
	Sat,  7 Nov 2026 14:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mzFwnu3Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868451F0089F;
	Sat,  7 Nov 2026 14:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062570;
	bh=hRoR+uhaQEn/JTWamCHYEpVzkyx9zCQOJLgRh2qiWv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mzFwnu3YOSVhzJByt4SQd/JJMX6Cpfjg0D0ayKADLAKUlOtQqHL4zlckcseKxervp
	 QPOY0ubDO+7sMxlyVZZXrCO1KBz5spmP6RIay545WLvozQ4wxrMzLFcBNdXqgWSWfq
	 R6nb9XyMIoapwwbSqLtcc2WRedJ62+1HvgQGL90w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1454/1536] ceph: fix out-of-bounds read in ceph_netfs_issue_op_inline()
Date: Sat,  7 Nov 2026 08:57:50 -0500
Message-ID: <20261107135038.678609759@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 5e0f83adc4590..a9eda19ae3c5b 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -304,6 +304,12 @@ static bool ceph_netfs_issue_op_inline(struct netfs_io_subrequest *subreq)
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



