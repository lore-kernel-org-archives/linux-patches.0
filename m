Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469CA1CFEA9;
	Tue, 15 Oct 2024 11:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992858; cv=none; b=F0sRjW7QvJl43/XkdcA8P98XbxrZ+43ZN5Crhz4vKTkeTHOizEeQUWLe64/lij2Zh1ZqkSM0TlwWsJ8I0BltsAM94kwszDZc6zsir8FeY2XAeOlvXB1YeV1DYBPoFz37Sw2gtqLK+KocmhPGCIORbU1o7aK8xlVsv/DvYV8r+cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992858; c=relaxed/simple;
	bh=YgHB+ZsBzuE3qLMRKiW0IHXqhVg4+HBB84niqm7up38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBFfEVeOIgBkEg/LQjBXItjW1607+l4EwcVFbA1ylcxbuLEYt0To+afRaN+HUjPzeJ/S4xPA252hM0cs4fZW/0ExP5cuTt4/UcM7rI9NUultXPYaLzEdQgnBPxn3SRxBt+ZBrDTbW3La3w8CujmSYfwOjVIvuLVptcfUihCbmRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvkvvrtY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvkvvrtY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F8BC4CEC6;
	Tue, 15 Oct 2024 11:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992858;
	bh=YgHB+ZsBzuE3qLMRKiW0IHXqhVg4+HBB84niqm7up38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvkvvrtYD/Z1ximjmDcTfBgHrfvxMktwf+VCGreWtu/aDc+J8q7yj2tqpVaQNtTmz
	 jQcTDvnlmdoyRTZ07poueeOtz51ygGuFRZ5eN38VSA06Wq0489X6eBcbmXAkcrquTD
	 u6+lDXMmIgrT/AcgnKh+epNVtmlgyXfTtHI+Fo9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Md Haris Iqbal <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Grzegorz Prajsner <grzegorz.prajsner@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 239/691] RDMA/rtrs-clt: Reset cid to con_num - 1 to stay in bounds
Date: Tue, 15 Oct 2024 13:23:07 +0200
Message-ID: <20241015112449.842796270@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8f496c88bfe7e..e8f5a1f104cfa 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -2338,6 +2338,12 @@ static int init_conns(struct rtrs_clt_path *clt_path)
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



