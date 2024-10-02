Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04351D0BB1;
	Wed,  2 Oct 2024 13:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876377; cv=none; b=MryD9OIjK6Nlrc5SxbUr8FP492ya5yS4YiwO1shyttnQB+50Rsc1CnbSL2Gi2VBLENH2EReRWY5hiB5Sp1oZWDSUZhhpKvU95GA4MZ5xgx+Rv3+DtTT/5XmiZhScOOxtLX1eRVML5TcbbwfODUlkLbK/doVxtIiIdQ8HFfGQS6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876377; c=relaxed/simple;
	bh=soCiNiwcPT6CAFGb9p/5lr0s0d7ifN6uwAx1q1wzafg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h18FTkaYUvOtoqcfaL+vn9xBmIGwbuqSVTR9ON1SKNlMEBD3KA1eufcCle8LqdDnCcRFpThmFygJSzusabZEJTSsDI1e40WaHJSbMq8f6G+KLSXiwQ/JZXPuDV9cYjB+k4ALpyg1X5n/wdjttMUQeD4iJNI9MrD28OYrj2JpZkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ei0MQm9P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ei0MQm9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C23C4CEC5;
	Wed,  2 Oct 2024 13:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876377;
	bh=soCiNiwcPT6CAFGb9p/5lr0s0d7ifN6uwAx1q1wzafg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ei0MQm9PQ1AXWapvGMgth65wkiTY/FxnLeAy4XP7y0XMMlvng7XndtFzZhCOFdyHO
	 lc41ypf7CMw6p+6I91iDbjrCGSZpUywDiHitkgwNfUi2dJoWZ8sCij5L65OdRQDWEo
	 iEi+tpDXk3kWizUyRQdGDpdlSRNyirj5m/NMAiF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Md Haris Iqbal <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Grzegorz Prajsner <grzegorz.prajsner@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 392/695] RDMA/rtrs-clt: Reset cid to con_num - 1 to stay in bounds
Date: Wed,  2 Oct 2024 14:56:30 +0200
Message-ID: <20241002125838.103207883@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Md Haris Iqbal <haris.iqbal@ionos.com>

[ Upstream commit 3e4289b29e216a55d08a89e126bc0b37cbad9f38 ]

In the function init_conns(), after the create_con() and create_cm() for
loop if something fails. In the cleanup for loop after the destroy tag, we
access out of bound memory because cid is set to clt_path->s.con_num.

This commits resets the cid to clt_path->s.con_num - 1, to stay in bounds
in the cleanup loop later.

Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Grzegorz Prajsner <grzegorz.prajsner@ionos.com>
Link: https://patch.msgid.link/20240821112217.41827-7-haris.iqbal@ionos.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 9936a3354b478..84d2dfcd20af6 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -2347,6 +2347,12 @@ static int init_conns(struct rtrs_clt_path *clt_path)
 		if (err)
 			goto destroy;
 	}
+
+	/*
+	 * Set the cid to con_num - 1, since if we fail later, we want to stay in bounds.
+	 */
+	cid = clt_path->s.con_num - 1;
+
 	err = alloc_path_reqs(clt_path);
 	if (err)
 		goto destroy;
-- 
2.43.0



