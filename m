Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2CE55102A;
	Mon, 11 Dec 2023 18:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/RSb9rU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49917C433C7;
	Mon, 11 Dec 2023 18:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320465;
	bh=2VFz+LDirqqTM8g46pjGFwYrQtUe6/HzXU9klTV+U9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/RSb9rU6q7CgG08rSimf458JPI12st4xQM6afHoI1DZ1Kfoubf9TQwZLGUOfeUFY
	 8wn8j5Jh0ZfA7+A9WAiHFpMB2i4QJLuNyHUlAimvrKCoLhgsNYt02xPF5tPvFLC0ar
	 Bk9omslkqNXvC3+iS1nd+nagOlGVEIVjOHsskoOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>,
	Md Haris Iqbal <haris.iqbal@ionos.com>,
	Grzegorz Prajsner <grzegorz.prajsner@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/194] RDMA/rtrs-clt: Start hb after path_up
Date: Mon, 11 Dec 2023 19:21:01 +0100
Message-ID: <20231211182039.662597721@linuxfoundation.org>
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

From: Jack Wang <jinpu.wang@ionos.com>

[ Upstream commit 3e44a61b5db873612e20e7b7922468d7d1ac2d22 ]

If we start hb too early, it will confuse server side to close
the session.

Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Reviewed-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Signed-off-by: Grzegorz Prajsner <grzegorz.prajsner@ionos.com>
Link: https://lore.kernel.org/r/20231120154146.920486-3-haris.iqbal@ionos.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index a67f58359de9e..1bad7fc3231f4 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -2346,8 +2346,6 @@ static int init_conns(struct rtrs_clt_path *clt_path)
 	if (err)
 		goto destroy;
 
-	rtrs_start_hb(&clt_path->s);
-
 	return 0;
 
 destroy:
@@ -2621,6 +2619,7 @@ static int init_path(struct rtrs_clt_path *clt_path)
 		goto out;
 	}
 	rtrs_clt_path_up(clt_path);
+	rtrs_start_hb(&clt_path->s);
 out:
 	mutex_unlock(&clt_path->init_mutex);
 
-- 
2.42.0



