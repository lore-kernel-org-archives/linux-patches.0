Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFEB1C6AB;
	Mon,  4 Mar 2024 21:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589386; cv=none; b=nn6U4hYShyU2Ywb1Xrr+Yuw4R8HpktJUxPD9N5ARO1XwhnGiXeBjSBgMp4yr+zVHo0nNlVMAdCBfCyJK3uW7pIqp+LYtKBdoupjetSSUvygNEKcnJX4VfdZRot4IP6411RB563nfmAHvfyKGOk6DcKPiLkPNhLkEQ3uZvcY/mIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589386; c=relaxed/simple;
	bh=wpvfc7qKOplwDNrV0bPGSTgSANZojuQgqKXThjbP2Oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XdhemJP7D1QnnqtaTcoG8IXiWt20kp2LiGnXOzMgcUzEAtxocx1kZwaPbZhVYhZMYlapt6lXuc8OtNqI4yGAgb0NeMpia1K6J44O+/0uw8Uj7AvYS7MPlovNkfga40h75ao7aJaaDvgBCody5EPtlthPC8TSUNoNOgt0e57t6nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WOXh/Pg5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WOXh/Pg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51ED3C433F1;
	Mon,  4 Mar 2024 21:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589386;
	bh=wpvfc7qKOplwDNrV0bPGSTgSANZojuQgqKXThjbP2Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WOXh/Pg5kjZjSslRQPa2J2CiHB2Kjxx5eNH2gvZogmW/PgIpDJUJ+Zy+fo6XTpOf/
	 cqEJf30XxkfhE0BtLsrczCNh7O34AaRTrtAWX2+AzPf2j/As1nUxMMCAqx72/yB6L+
	 tE2wiO70W9fY+ygx1bhvPoKD086fuBd0ARF1d8PM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 77/84] Revert "interconnect: Fix locking for runpm vs reclaim"
Date: Mon,  4 Mar 2024 21:24:50 +0000
Message-ID: <20240304211544.972827465@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 9be2957f014d91088db1eb5dd09d9a03d7184dce which is
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
@@ -30,7 +30,6 @@ static LIST_HEAD(icc_providers);
 static int providers_count;
 static bool synced_state;
 static DEFINE_MUTEX(icc_lock);
-static DEFINE_MUTEX(icc_bw_lock);
 static struct dentry *icc_debugfs_dir;
 
 static void icc_summary_show_one(struct seq_file *s, struct icc_node *n)
@@ -637,7 +636,7 @@ int icc_set_bw(struct icc_path *path, u3
 	if (WARN_ON(IS_ERR(path) || !path->num_nodes))
 		return -EINVAL;
 
-	mutex_lock(&icc_bw_lock);
+	mutex_lock(&icc_lock);
 
 	old_avg = path->reqs[0].avg_bw;
 	old_peak = path->reqs[0].peak_bw;
@@ -669,7 +668,7 @@ int icc_set_bw(struct icc_path *path, u3
 		apply_constraints(path);
 	}
 
-	mutex_unlock(&icc_bw_lock);
+	mutex_unlock(&icc_lock);
 
 	trace_icc_set_bw_end(path, ret);
 
@@ -972,7 +971,6 @@ void icc_node_add(struct icc_node *node,
 		return;
 
 	mutex_lock(&icc_lock);
-	mutex_lock(&icc_bw_lock);
 
 	node->provider = provider;
 	list_add_tail(&node->node_list, &provider->nodes);
@@ -998,7 +996,6 @@ void icc_node_add(struct icc_node *node,
 	node->avg_bw = 0;
 	node->peak_bw = 0;
 
-	mutex_unlock(&icc_bw_lock);
 	mutex_unlock(&icc_lock);
 }
 EXPORT_SYMBOL_GPL(icc_node_add);
@@ -1126,7 +1123,6 @@ void icc_sync_state(struct device *dev)
 		return;
 
 	mutex_lock(&icc_lock);
-	mutex_lock(&icc_bw_lock);
 	synced_state = true;
 	list_for_each_entry(p, &icc_providers, provider_list) {
 		dev_dbg(p->dev, "interconnect provider is in synced state\n");


