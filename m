Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C6435C682;
	Tue, 21 Jul 2026 22:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671596; cv=none; b=lpMbZnONTP1ZXX7QfFYO5oyFbCGx9OJJhpD+LIT2jOvAogTrAsVBZXB7fTvgrf9upSdrcz1BV4lluKHy0WKTwU0Ea597xXDNB7oUn14d7g9jt6fFp7avrDjOzMBKMsbxrga87joKNTKD/F17KdybyU0LMTadSDUe4Nm+ducdrcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671596; c=relaxed/simple;
	bh=YpyXSYcaFclqY6eZDjsM+SvogIKHq7lUmdWuwI0F1po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ImBydP6mIH/LRD5jLLlRPp8JjMFw4opFvXvnjgmgEuGR9I4jyGrzB4w8iOp+55M576zcouRvUsHoFvMzX10NRwE3yS/sY/zMxnCUAPaUSctEyvTWESZ0fb+i5u/Tdb6MlyMRFmWU7BHWwcFcgAbjgpVMQ6ZnvzuVtnak2VEKeWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Flyq7lLD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Flyq7lLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3341F000E9;
	Tue, 21 Jul 2026 22:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671595;
	bh=iJTHS70pm8WHFoKV4Z+X8wdZi711TGopWGK8MbjkSjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Flyq7lLDRh9R4DQq/bTASsLm9BOo3ZOB1Fa5bJXLyNwXGxhxUg3c80cjQD0DzGdci
	 6P6Mh0ocANndqUf6VZ88iaeuSlPcT+ts0ihSyOd09IMMpk1yIPyexhVGeuXygW1Q5g
	 DEvh2nXpV1NZcPbYVXRFBRYDwVfUJlUrHVnyt7/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 304/843] IB/cm: Fix av cm device leak on an error path in cm_init_av_by_path()
Date: Tue, 21 Jul 2026 17:18:59 +0200
Message-ID: <20260721152412.866580383@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 9b2207bc5cdb955bdae34b3eec80f04979e17081 ]

Codex pointed out that cm_init_av_by_path() can call cm_set_av_port()
which takes a reference on the cm device, but then can immediately return
error if ib_init_ah_attr_from_path() fails.

Since callers like ib_send_cm_req() put the av on the stack this leaks
that cm device reference.

Re-order cm_init_av_by_path() so it doesn't touch the av until it has done
all its failable work, and then update the av in one shot so it is either
left alone or fully init'd.

Sashiko also pointed out that the cm_destroy_av() prior to
cm_init_av_by_path() is harmful as it leaves the AV broken in the error
case and thus the REJ won't send. Since cm_init_av_by_path() is now atomic
it is safe to delete the cm_destroy_av(). On succees the av from
cm_init_av_for_response() is cleaned up by cm_init_av_by_path(), on
failure the 'goto rejected' guarentees the av is destroyed during
ib_destroy_cm_id().

Fixes: 76039ac9095f ("IB/cm: Protect cm_dev, cm_ports and mad_agent with kref and lock")
Link: https://patch.msgid.link/r/0-v1-38292501f539+14f-ib_cm_av_leak_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cm.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 5dc864cec9f838..e93287b969f762 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -513,6 +513,7 @@ static int cm_init_av_by_path(struct sa_path_rec *path,
 	struct rdma_ah_attr new_ah_attr;
 	struct cm_device *cm_dev;
 	struct cm_port *port;
+	u16 pkey_index;
 	int ret;
 
 	port = get_cm_port_from_path(path, sgid_attr);
@@ -521,12 +522,10 @@ static int cm_init_av_by_path(struct sa_path_rec *path,
 	cm_dev = port->cm_dev;
 
 	ret = ib_find_cached_pkey(cm_dev->ib_device, port->port_num,
-				  be16_to_cpu(path->pkey), &av->pkey_index);
+				  be16_to_cpu(path->pkey), &pkey_index);
 	if (ret)
 		return ret;
 
-	cm_set_av_port(av, port);
-
 	/*
 	 * av->ah_attr might be initialized based on wc or during
 	 * request processing time which might have reference to sgid_attr.
@@ -541,6 +540,8 @@ static int cm_init_av_by_path(struct sa_path_rec *path,
 	if (ret)
 		return ret;
 
+	av->pkey_index = pkey_index;
+	cm_set_av_port(av, port);
 	av->timeout = path->packet_life_time + 1;
 	rdma_move_ah_attr(&av->ah_attr, &new_ah_attr);
 	return 0;
@@ -2175,8 +2176,10 @@ static int cm_req_handler(struct cm_work *work)
 				 cm_id_priv->av.ah_attr.roce.dmac);
 	work->path[0].hop_limit = grh->hop_limit;
 
-	/* This destroy call is needed to pair with cm_init_av_for_response */
-	cm_destroy_av(&cm_id_priv->av);
+	/*
+	 * cm_init_av_by_path() will internally pair with the above
+	 * cm_init_av_for_response() if it succeeds.
+	 */
 	ret = cm_init_av_by_path(&work->path[0], gid_attr, &cm_id_priv->av);
 	if (ret) {
 		int err;
-- 
2.53.0



