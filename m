Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90831C4613;
	Tue,  8 Oct 2024 12:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391690; cv=none; b=t3rN5n02hiVBY8yXukpXmaeyYsW9RQ1SBtgRoR+o58DCPxaV0bzL6PoFB65k5nfafk/aJCDko0lxAVxk/DjsMQhOGw4GEAmHCUDlVX+x9qB6wukSalxie9sEaplOzdYrWtIX3P2vVtkHh5ECV1T+O5fq0y29pj2/Ha/JPOjrbhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391690; c=relaxed/simple;
	bh=naqgGlKr1lFQBIan/75/kfYIR2JWPBk4PY9fR0BeL0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8bCz/gFth9Hj/8md7r0VwEid/5VbY2oyJjCkFAKlqVJKT+SNaZP8+Q/eikamO0Fh6f0fJ/Xdy98BRAT16TKfrRNmXUbciHOY7Y6wQFsHhLkeD05WpahAzF8+gQWKxkSnqg3+rYz0Mn59CQd1NN72XEnufjv1jI+ZLbNpVaJqzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vqM9f6uN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vqM9f6uN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FCCC4CEC7;
	Tue,  8 Oct 2024 12:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391689;
	bh=naqgGlKr1lFQBIan/75/kfYIR2JWPBk4PY9fR0BeL0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vqM9f6uNdIismT08h2aExyVY10/WLTYKxKKSC9HC0bHQvaVTu/JTBI3saIuclDr6d
	 gJ19J6qfTr5Fx+PVstZtJpugJB5+hVSsv0Q45Thvycog7t8A2AKt4zpMD81Z/Jqax+
	 SxipibdvqXimbc77x73sO6H4Ah5Q8Ild7hjDlZN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sasha Levin <sashal@kernel.org>,
	Raghavendra Kakarla <quic_rkakarla@quicinc.com>
Subject: [PATCH 6.11 193/558] pmdomain: core: Use dev_name() instead of kobject_get_path() in debugfs
Date: Tue,  8 Oct 2024 14:03:43 +0200
Message-ID: <20241008115709.945285674@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 9094e53ff5c86ebe372ad3960c3216c9817a1a04 ]

Using kobject_get_path() means a dynamic memory allocation gets done, which
doesn't work on a PREEMPT_RT based configuration while holding genpd's raw
spinlock.

To fix the problem, let's convert into using the simpler dev_name(). This
means the information about the path doesn't get presented in debugfs, but
hopefully this shouldn't be an issue.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Tested-by: Raghavendra Kakarla <quic_rkakarla@quicinc.com>  # qcm6490 with PREEMPT_RT set
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://lore.kernel.org/r/20240527142557.321610-4-ulf.hansson@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pmdomain/core.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/pmdomain/core.c b/drivers/pmdomain/core.c
index ca7f780582cf4..95b30d35e0b42 100644
--- a/drivers/pmdomain/core.c
+++ b/drivers/pmdomain/core.c
@@ -3210,7 +3210,6 @@ static int genpd_summary_one(struct seq_file *s,
 		[GENPD_STATE_OFF] = "off"
 	};
 	struct pm_domain_data *pm_data;
-	const char *kobj_path;
 	struct gpd_link *link;
 	char state[16];
 	int ret;
@@ -3243,17 +3242,10 @@ static int genpd_summary_one(struct seq_file *s,
 	}
 
 	list_for_each_entry(pm_data, &genpd->dev_list, list_node) {
-		kobj_path = kobject_get_path(&pm_data->dev->kobj,
-				genpd_is_irq_safe(genpd) ?
-				GFP_ATOMIC : GFP_KERNEL);
-		if (kobj_path == NULL)
-			continue;
-
-		seq_printf(s, "\n    %-50s  ", kobj_path);
+		seq_printf(s, "\n    %-50s  ", dev_name(pm_data->dev));
 		rtpm_status_str(s, pm_data->dev);
 		perf_status_str(s, pm_data->dev);
 		mode_status_str(s, pm_data->dev);
-		kfree(kobj_path);
 	}
 
 	seq_puts(s, "\n");
@@ -3422,23 +3414,14 @@ static int devices_show(struct seq_file *s, void *data)
 {
 	struct generic_pm_domain *genpd = s->private;
 	struct pm_domain_data *pm_data;
-	const char *kobj_path;
 	int ret = 0;
 
 	ret = genpd_lock_interruptible(genpd);
 	if (ret)
 		return -ERESTARTSYS;
 
-	list_for_each_entry(pm_data, &genpd->dev_list, list_node) {
-		kobj_path = kobject_get_path(&pm_data->dev->kobj,
-				genpd_is_irq_safe(genpd) ?
-				GFP_ATOMIC : GFP_KERNEL);
-		if (kobj_path == NULL)
-			continue;
-
-		seq_printf(s, "%s\n", kobj_path);
-		kfree(kobj_path);
-	}
+	list_for_each_entry(pm_data, &genpd->dev_list, list_node)
+		seq_printf(s, "%s\n", dev_name(pm_data->dev));
 
 	genpd_unlock(genpd);
 	return ret;
-- 
2.43.0



