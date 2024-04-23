Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE22B144D34;
	Tue, 23 Apr 2024 21:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908617; cv=none; b=fu02S4ZNVs4rOLSdXnN7BS1Uu21JZj7EYF3l/zlu7qAagz3JhvqWvO84DKsSP8HazFiRR0WgCkKBpaWmhG7nHSZs2XUtSEJDNn7+sFri9R2lEjwHhYW93cmqUAOt/vF6k8dkDWTeD2ZsPfi5UcvpKz0mQ8q4OB5ku3wH3OUe+oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908617; c=relaxed/simple;
	bh=+vaw1aOFdaP5F9H/cin+7MIpPGDPkx8IdMONAuIPqek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kwSImzzMyFz2IXAZ5vEK/RKreYBqChVaCtzrySoypQDhLofGF1qWXe2Kyt1EXMjDOmEzPzW6Kq5Z79IMRqHHVDmGGghck6XSNAQmWzBwE34X5L5/CbCL5WeelRqrKaNNB77LZrs4UNHRWjeLGkSQ+H7mMDXGTJckAc+/eDsOvjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l1sKtoTd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l1sKtoTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB20C116B1;
	Tue, 23 Apr 2024 21:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908617;
	bh=+vaw1aOFdaP5F9H/cin+7MIpPGDPkx8IdMONAuIPqek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l1sKtoTdaVxXPMdpyeS7Htb524ITD7S0VWcPPsNbQFSYP08HDuY2h3iAwGrbGdSkk
	 BMaAa4cMxc7VNsH8cugK+KLKy96bhx6adaQrSpqAshjaxPNf+nfW/leOAp2rkll9uI
	 H/crYsHNHI4v+RTdbImpWsoAYaJ2zRISkGV94a7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Tipton <quic_mdtipton@quicinc.com>,
	Rob Clark <robdclark@chromium.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/158] interconnect: Dont access req_list while its being manipulated
Date: Tue, 23 Apr 2024 14:38:47 -0700
Message-ID: <20240423213858.675063680@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

From: Mike Tipton <quic_mdtipton@quicinc.com>

[ Upstream commit de1bf25b6d771abdb52d43546cf57ad775fb68a1 ]

The icc_lock mutex was split into separate icc_lock and icc_bw_lock
mutexes in [1] to avoid lockdep splats. However, this didn't adequately
protect access to icc_node::req_list.

The icc_set_bw() function will eventually iterate over req_list while
only holding icc_bw_lock, but req_list can be modified while only
holding icc_lock. This causes races between icc_set_bw(), of_icc_get(),
and icc_put().

Example A:

  CPU0                               CPU1
  ----                               ----
  icc_set_bw(path_a)
    mutex_lock(&icc_bw_lock);
                                     icc_put(path_b)
                                       mutex_lock(&icc_lock);
    aggregate_requests()
      hlist_for_each_entry(r, ...
                                       hlist_del(...
        <r = invalid pointer>

Example B:

  CPU0                               CPU1
  ----                               ----
  icc_set_bw(path_a)
    mutex_lock(&icc_bw_lock);
                                     path_b = of_icc_get()
                                       of_icc_get_by_index()
                                         mutex_lock(&icc_lock);
                                         path_find()
                                           path_init()
    aggregate_requests()
      hlist_for_each_entry(r, ...
                                             hlist_add_head(...
        <r = invalid pointer>

Fix this by ensuring icc_bw_lock is always held before manipulating
icc_node::req_list. The additional places icc_bw_lock is held don't
perform any memory allocations, so we should still be safe from the
original lockdep splats that motivated the separate locks.

[1] commit af42269c3523 ("interconnect: Fix locking for runpm vs reclaim")

Signed-off-by: Mike Tipton <quic_mdtipton@quicinc.com>
Fixes: af42269c3523 ("interconnect: Fix locking for runpm vs reclaim")
Reviewed-by: Rob Clark <robdclark@chromium.org>
Link: https://lore.kernel.org/r/20240305225652.22872-1-quic_mdtipton@quicinc.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/interconnect/core.c b/drivers/interconnect/core.c
index 50bac2d79d9b5..68edb07d4443e 100644
--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -176,6 +176,8 @@ static struct icc_path *path_init(struct device *dev, struct icc_node *dst,
 
 	path->num_nodes = num_nodes;
 
+	mutex_lock(&icc_bw_lock);
+
 	for (i = num_nodes - 1; i >= 0; i--) {
 		node->provider->users++;
 		hlist_add_head(&path->reqs[i].req_node, &node->req_list);
@@ -186,6 +188,8 @@ static struct icc_path *path_init(struct device *dev, struct icc_node *dst,
 		node = node->reverse;
 	}
 
+	mutex_unlock(&icc_bw_lock);
+
 	return path;
 }
 
@@ -792,12 +796,16 @@ void icc_put(struct icc_path *path)
 		pr_err("%s: error (%d)\n", __func__, ret);
 
 	mutex_lock(&icc_lock);
+	mutex_lock(&icc_bw_lock);
+
 	for (i = 0; i < path->num_nodes; i++) {
 		node = path->reqs[i].node;
 		hlist_del(&path->reqs[i].req_node);
 		if (!WARN_ON(!node->provider->users))
 			node->provider->users--;
 	}
+
+	mutex_unlock(&icc_bw_lock);
 	mutex_unlock(&icc_lock);
 
 	kfree_const(path->name);
-- 
2.43.0



