Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45555102A;
	Mon, 11 Dec 2023 18:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OA6Y89y+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5E1C433C7;
	Mon, 11 Dec 2023 18:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320473;
	bh=jnQ2J7AQgssEzVkT3yus6SHmP1Uf4zmxRHmp/t56gao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OA6Y89y+RefcszDc2Oa5G0cqHE9CxtKppdzqkmXDlf4xwlnwGect2nP56e11GhbD/
	 7rlUU9EQGBmQkMnk2j58T/d3roCiOQPu8wr+J2lnNLKry6+4rv1oKe9UrIpVUdk17S
	 VtYKZp5iQmEb7pR/2Ac1tOif7pHZt6pzZ7YWejUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Md Haris Iqbal <haris.iqbal@ionos.com>,
	Santosh Kumar Pradhan <santosh.pradhan@ionos.com>,
	Grzegorz Prajsner <grzegorz.prajsner@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/194] RDMA/rtrs-srv: Destroy path files after making sure no IOs in-flight
Date: Mon, 11 Dec 2023 19:21:04 +0100
Message-ID: <20231211182039.797838738@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Md Haris Iqbal <haris.iqbal@ionos.com>

[ Upstream commit c4d32e77fc1006f99eeb78417efc3d81a384072a ]

Destroying path files may lead to the freeing of rdma_stats. This creates
the following race.

An IO is in-flight, or has just passed the session state check in
process_read/process_write. The close_work gets triggered and the function
rtrs_srv_close_work() starts and does destroy path which frees the
rdma_stats. After this the function process_read/process_write resumes and
tries to update the stats through the function rtrs_srv_update_rdma_stats

This commit solves the problem by moving the destroy path function to a
later point. This point makes sure any inflights are completed. This is
done by qp drain, and waiting for all in-flights through ops_id.

Fixes: 9cb837480424 ("RDMA/rtrs: server: main functionality")
Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Signed-off-by: Santosh Kumar Pradhan <santosh.pradhan@ionos.com>
Signed-off-by: Grzegorz Prajsner <grzegorz.prajsner@ionos.com>
Link: https://lore.kernel.org/r/20231120154146.920486-6-haris.iqbal@ionos.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 091db0853a6fb..e978ee4bb73ae 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1537,7 +1537,6 @@ static void rtrs_srv_close_work(struct work_struct *work)
 
 	srv_path = container_of(work, typeof(*srv_path), close_work);
 
-	rtrs_srv_destroy_path_files(srv_path);
 	rtrs_srv_stop_hb(srv_path);
 
 	for (i = 0; i < srv_path->s.con_num; i++) {
@@ -1557,6 +1556,8 @@ static void rtrs_srv_close_work(struct work_struct *work)
 	/* Wait for all completion */
 	wait_for_completion(&srv_path->complete_done);
 
+	rtrs_srv_destroy_path_files(srv_path);
+
 	/* Notify upper layer if we are the last path */
 	rtrs_srv_path_down(srv_path);
 
-- 
2.42.0



