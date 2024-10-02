Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391091D0DE9;
	Wed,  2 Oct 2024 14:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880070; cv=none; b=WYKoLT123+LELtyjPf8vczGrsxtoH4P5sMHwiI3WM9bqnXJunvB7/7OglKkDc1ZF9mu1a5k08AHZjTJ8QP9GssIzUQSx4yUn7HOUp59S9yj2Qm4oyqaTTT8TBKjJyXjvBCFRhyopcuOSXgAiLdytJv0XTjVwWYkYBx/26rCbZB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880070; c=relaxed/simple;
	bh=88qp9JKaxJWa6pQ5ru4iaVFv5/wPmupTWvkpxfZvmMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKotBcqz5041VPI856SLHklf1czr9YLQultBJ1E3hGisiVil5DrlmloGplU9GC7vKecRL+1nJjmzAWaW17mz4w02CvvFm5hSL5bS8w41S/NC50Dk9N2qjBICXjal7dN7GvmXRsbVlseOAvCoBYmWhtmNQka797yLstSzfAaREwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bFFpLwA8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bFFpLwA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FD0C4CEC2;
	Wed,  2 Oct 2024 14:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880070;
	bh=88qp9JKaxJWa6pQ5ru4iaVFv5/wPmupTWvkpxfZvmMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFFpLwA8IzUuGGR4VrxSWigiAl7Sm+eDkkvfc9pk1psG0JNJD5vOXUX2BJgdPMyVm
	 EpYOpYbCqwft0J7iDPZX3XZ48MHIH5vQg4XGtaK9Gxcis33xBUBTEbXszM6KoJAe/Q
	 baCeZrs2lgc6RL7P9nnFoiKuQvXboWA1L3txyFjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Md Haris Iqbal <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Grzegorz Prajsner <grzegorz.prajsner@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 303/538] RDMA/rtrs-clt: Reset cid to con_num - 1 to stay in bounds
Date: Wed,  2 Oct 2024 14:59:02 +0200
Message-ID: <20241002125804.376956355@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
index 75d3a27dea9a0..82aa47efb8078 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -2342,6 +2342,12 @@ static int init_conns(struct rtrs_clt_path *clt_path)
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



