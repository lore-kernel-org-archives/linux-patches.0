Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BE713B295;
	Tue, 27 Feb 2024 13:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040901; cv=none; b=NUEiVSczmx6eXk9vSrKKl2bF6snGi70Ey1cTb2u+1W2cwWQqKoyRQSPgaNauWWe6EpIK+8Rl01vagUg5mAJf8SX2NlfOqq8WRCVWse9eqSyhSkSNQHCVbgRihO2FmI07S7tqVXLvysm02AaAdTQEhqGNiXIAykwgtoVJE8Ez5FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040901; c=relaxed/simple;
	bh=QaD7yTwpYZn9PP3o5qjlRVAjVG5WblvraR3M8p74XAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FFS2IWgU0/y+62UykDlDCo7EA3h6cy0hDxMd6STDf44H3u14+9Xz3fmpjqva1D6Vn9dZw1OUzxFG00NU4thIMNfH3DN8XGPUxsAHQXa5Zqhy1YeA4iv+digJdoskEOyhcJMgAMVVIRcznC8sS+cPnGGfxk1OhUy56ioqSTxVVrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VpL7KyrY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VpL7KyrY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CC0C433F1;
	Tue, 27 Feb 2024 13:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040901;
	bh=QaD7yTwpYZn9PP3o5qjlRVAjVG5WblvraR3M8p74XAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VpL7KyrYThE5eS16O5TdnJVKlmkPcoiMTBlkeoTMqWJUPihib9+FOnWwRlWPxFV1G
	 TuWkmJQDc2mYoZHUKlm+67JfC/5W9Rne78cpefzkGlasgLBOWeJgv/BUSh2VvqIo8E
	 Nk/IGw2IbKXwk4wBwISs3TxMGgw2z6qRZmF32ur0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 122/334] libceph: fail sparse-read if the data length doesnt match
Date: Tue, 27 Feb 2024 14:19:40 +0100
Message-ID: <20240227131634.410492896@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit cd7d469c25704d414d71bf3644f163fb74e7996b ]

Once this happens that means there have bugs.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ceph/osd_client.h |  3 ++-
 net/ceph/osd_client.c           | 18 +++++++++++++++---
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index b8610e9d2471f..5edf9fffa0973 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -45,6 +45,7 @@ enum ceph_sparse_read_state {
 	CEPH_SPARSE_READ_HDR	= 0,
 	CEPH_SPARSE_READ_EXTENTS,
 	CEPH_SPARSE_READ_DATA_LEN,
+	CEPH_SPARSE_READ_DATA_PRE,
 	CEPH_SPARSE_READ_DATA,
 };
 
@@ -64,7 +65,7 @@ struct ceph_sparse_read {
 	u64				sr_req_len;  /* orig request length */
 	u64				sr_pos;      /* current pos in buffer */
 	int				sr_index;    /* current extent index */
-	__le32				sr_datalen;  /* length of actual data */
+	u32				sr_datalen;  /* length of actual data */
 	u32				sr_count;    /* extent count in reply */
 	int				sr_ext_len;  /* length of extent array */
 	struct ceph_sparse_extent	*sr_extent;  /* extent array */
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 8d9760397b887..3babcd5e65e16 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5856,8 +5856,8 @@ static int osd_sparse_read(struct ceph_connection *con,
 	struct ceph_osd *o = con->private;
 	struct ceph_sparse_read *sr = &o->o_sparse_read;
 	u32 count = sr->sr_count;
-	u64 eoff, elen;
-	int ret;
+	u64 eoff, elen, len = 0;
+	int i, ret;
 
 	switch (sr->sr_state) {
 	case CEPH_SPARSE_READ_HDR:
@@ -5909,8 +5909,20 @@ static int osd_sparse_read(struct ceph_connection *con,
 		convert_extent_map(sr);
 		ret = sizeof(sr->sr_datalen);
 		*pbuf = (char *)&sr->sr_datalen;
-		sr->sr_state = CEPH_SPARSE_READ_DATA;
+		sr->sr_state = CEPH_SPARSE_READ_DATA_PRE;
 		break;
+	case CEPH_SPARSE_READ_DATA_PRE:
+		/* Convert sr_datalen to host-endian */
+		sr->sr_datalen = le32_to_cpu((__force __le32)sr->sr_datalen);
+		for (i = 0; i < count; i++)
+			len += sr->sr_extent[i].len;
+		if (sr->sr_datalen != len) {
+			pr_warn_ratelimited("data len %u != extent len %llu\n",
+					    sr->sr_datalen, len);
+			return -EREMOTEIO;
+		}
+		sr->sr_state = CEPH_SPARSE_READ_DATA;
+		fallthrough;
 	case CEPH_SPARSE_READ_DATA:
 		if (sr->sr_index >= count) {
 			sr->sr_state = CEPH_SPARSE_READ_HDR;
-- 
2.43.0



