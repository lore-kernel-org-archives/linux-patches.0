Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D07145B09;
	Tue, 27 Feb 2024 13:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041904; cv=none; b=nREwMohHH/nrbQTXYBinZxa4MyFiIBBE5tI1rbskqHtTPZyKr+tSHz1xNSLHXvXyQNOuVPMWIpYvu3PLmTURxuhZcPUx44+QLNRToey07ZpsveEdPnlfT3oPVbDrcU+lBnBiHIblG4jifvBMNy3SiwaqgrEgG8H5j9xWNMpaMPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041904; c=relaxed/simple;
	bh=ww8tlzF9oFykSevwdHAHrjf2SU6CqJrNT8O1LhqbeV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MiLAYWaSiD/90m0Ux8B/U8MCeISlL4QiqZDoud0UJ1RNT3fa9hwoJVhRap3bi8JX3jwY9pIOaqWh9WuACnUfps53nVZyIlXLfHR0gmj17rYbkvq6y2kzAVokwMe1FoyAXQeaSMsHxZFZgIEmXxLO+x06KwR7HvUI9eo3ijZLKxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPdgAIEK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPdgAIEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E338DC433F1;
	Tue, 27 Feb 2024 13:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041904;
	bh=ww8tlzF9oFykSevwdHAHrjf2SU6CqJrNT8O1LhqbeV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZPdgAIEKlMgTUSZrSMZjpQ8fnJe2DNVVuSCo8oM2uw/1PhezE9UzsA5YZJThtoSs5
	 ybHGgbqEWL93PVYvDxNUBJgzbEz7nXxvtegSR/KcpImhcqphn4K52wN1GewesoPzbQ
	 8BMbG02A0u68Af9tF6B1b2VbRtpSMatefQwM2ixU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 110/299] libceph: fail sparse-read if the data length doesnt match
Date: Tue, 27 Feb 2024 14:23:41 +0100
Message-ID: <20240227131629.416904870@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bf9823956758c..f703fb8030de2 100644
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



