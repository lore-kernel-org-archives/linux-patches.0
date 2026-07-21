Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B3B248F57;
	Tue, 21 Jul 2026 15:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649232; cv=none; b=RCHIgDWXQAiYCV5WgLYK7LWLcOYj+XcIYP4jt4umT1OFDW+03nRzHyFJWBQBgNcvVc2S92EMBpNrrHRN2arTmSmiE3+0Zxc8fsXZFOZkH3wsi9KTn3VCW30PdZwJgzM5t80lg7KlZFdx2Wr2LCVc4tI0Blm45AxkqC1IfZgF5vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649232; c=relaxed/simple;
	bh=nr7UzEKnuIcW5lLQFbOzJYUryDgk6WFZsS3MJZ525tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5ZehjuL7JHcXPTqeMQNJ4YsN3kjDpKENvVohng8c3EZM40I5tyL6Bmf2VurJ+MKQUuulc0zm6O0VJ+zTTYROYzCuoIkFtZayYUrmOqo8tIF8XALgtczYWdWKWcOpnEwTAJdB3iS02bcZhmhX+WFuksKqzVgVcLeoiwqKg92rqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h98OZRoi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h98OZRoi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08251F000E9;
	Tue, 21 Jul 2026 15:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649231;
	bh=tq4JyND/D5gt1pz7ZKmaxYAtq1e+eMN+H5l9+ueSCR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h98OZRoiH5WsbBJQfgf2G4UPv6q809sn2kcvs5XklJ0ZkGoO6jGudPw/EgXb+yGDc
	 1fs+F2PDzWv8RHImrrOZHiBi/pi05Rpl17r4X1+r+/Ya44rznoU1VTwN3XF/FyZDaw
	 IZdXN/SDeuKhEIkUkfj2rjm4DPX/F0zF4rRDDlNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0498/2077] IB/cm: Fix av cm device leak on an error path in cm_init_av_by_path()
Date: Tue, 21 Jul 2026 17:02:51 +0200
Message-ID: <20260721152604.558725040@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6ab9a0aee1ec60..1a2c2775b14d56 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -530,6 +530,7 @@ static int cm_init_av_by_path(struct sa_path_rec *path,
 	struct rdma_ah_attr new_ah_attr;
 	struct cm_device *cm_dev;
 	struct cm_port *port;
+	u16 pkey_index;
 	int ret;
 
 	port = get_cm_port_from_path(path, sgid_attr);
@@ -538,12 +539,10 @@ static int cm_init_av_by_path(struct sa_path_rec *path,
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
@@ -558,6 +557,8 @@ static int cm_init_av_by_path(struct sa_path_rec *path,
 	if (ret)
 		return ret;
 
+	av->pkey_index = pkey_index;
+	cm_set_av_port(av, port);
 	av->timeout = path->packet_life_time + 1;
 	rdma_move_ah_attr(&av->ah_attr, &new_ah_attr);
 	return 0;
@@ -2184,8 +2185,10 @@ static int cm_req_handler(struct cm_work *work)
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



