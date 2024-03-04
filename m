Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132CE78B4C;
	Mon,  4 Mar 2024 21:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589161; cv=none; b=NmiWItE17y4xv+6xdHIfimd8IiH7AL3LsFAIVHVecocGVN10+DD4Wqcib2qrXhwSe/B5Vb1wdVww5wctvq9280DihkX04GxcBdvcDunWROFChWJYfRjTcQWMPr+jVLGiSNSjEh3uCCjIIGyAbdrAVF+hjMWn1w/RnBuj5Lip+mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589161; c=relaxed/simple;
	bh=5BN0ttHZ0vMpne5hNf+XTwnw18pUEYEv3gelzx0Rx+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCy+d+JoBc3yhsm4NGgj+owHiQhgDorJsHf+255QDdydtMvO7bsxrw/IeZKjZMT/4e02yNrbgG4KtC7e3la9FvzRd+VM35zVv+QBxS0hNqZSgMQqzvKhM6v5pZu3oBeSfjwR9T7eYds0t+lf9wZjnAGBHZaJMVPNRjLcFtIoTOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YoKgGtnf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YoKgGtnf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974FEC433C7;
	Mon,  4 Mar 2024 21:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589160;
	bh=5BN0ttHZ0vMpne5hNf+XTwnw18pUEYEv3gelzx0Rx+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YoKgGtnfNv4jj/t7mpiKlsX8PNIrRDlp3PovUWc7Hfs+vZMpai7maSQixniRSaeSk
	 45rfqoDqs211QB+BC1+HhZl7WVd3rIFcB7VL7YQx6xezx0f8hA0diDY2Pb9DieQkFo
	 jFw8Nnt1USrtsoUetKL3AHZio+YnoStYGk/vp1xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 204/215] Revert "interconnect: Fix locking for runpm vs reclaim"
Date: Mon,  4 Mar 2024 21:24:27 +0000
Message-ID: <20240304211603.466168110@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit ee42bfc791aa3cd78e29046f26a09d189beb3efb which is
commit af42269c3523492d71ebbe11fefae2653e9cdc78 upstream.

It is reported to cause boot crashes in Android systems, so revert it
from the stable trees for now.

Cc: Rob Clark <robdclark@chromium.org>
Cc: Georgi Djakov <djakov@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/core.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -29,7 +29,6 @@ static LIST_HEAD(icc_providers);
 static int providers_count;
 static bool synced_state;
 static DEFINE_MUTEX(icc_lock);
-static DEFINE_MUTEX(icc_bw_lock);
 static struct dentry *icc_debugfs_dir;
 
 static void icc_summary_show_one(struct seq_file *s, struct icc_node *n)
@@ -636,7 +635,7 @@ int icc_set_bw(struct icc_path *path, u3
 	if (WARN_ON(IS_ERR(path) || !path->num_nodes))
 		return -EINVAL;
 
-	mutex_lock(&icc_bw_lock);
+	mutex_lock(&icc_lock);
 
 	old_avg = path->reqs[0].avg_bw;
 	old_peak = path->reqs[0].peak_bw;
@@ -668,7 +667,7 @@ int icc_set_bw(struct icc_path *path, u3
 		apply_constraints(path);
 	}
 
-	mutex_unlock(&icc_bw_lock);
+	mutex_unlock(&icc_lock);
 
 	trace_icc_set_bw_end(path, ret);
 
@@ -971,7 +970,6 @@ void icc_node_add(struct icc_node *node,
 		return;
 
 	mutex_lock(&icc_lock);
-	mutex_lock(&icc_bw_lock);
 
 	node->provider = provider;
 	list_add_tail(&node->node_list, &provider->nodes);
@@ -997,7 +995,6 @@ void icc_node_add(struct icc_node *node,
 	node->avg_bw = 0;
 	node->peak_bw = 0;
 
-	mutex_unlock(&icc_bw_lock);
 	mutex_unlock(&icc_lock);
 }
 EXPORT_SYMBOL_GPL(icc_node_add);
@@ -1137,7 +1134,6 @@ void icc_sync_state(struct device *dev)
 		return;
 
 	mutex_lock(&icc_lock);
-	mutex_lock(&icc_bw_lock);
 	synced_state = true;
 	list_for_each_entry(p, &icc_providers, provider_list) {
 		dev_dbg(p->dev, "interconnect provider is in synced state\n");


