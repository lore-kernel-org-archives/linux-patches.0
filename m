Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD543A900B;
	Sat, 17 Oct 2026 17:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256999; cv=none; b=sZrMVAy3IlDglkpli+TshwjBJ5SQefjHm07uP17BjlOAUzuv2/wAfatRYop4TVYVqU+j4fNChQYdtTErUc7EH5ZqsH9dhuH1R+1R5MfAVJwNkygckQP7DMYdU4zDnY4R4FC+B+sZC6oZEkoTx131zWDyHReuy0wNMxLiTo5JP2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256999; c=relaxed/simple;
	bh=3f7g/zk56rdIiYArv43cMOiveym0sAZTvaQqiAxIRZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5UspSCYBXHS+6xZLr6dErzkCHcGGcI2GwjUzHEWku32AlRMITGr0QMSt9Z6tDgI0tKwCW09NmjrMmE4X5F6EejKqqDqohgvmStHQqvJ1cHEUhI1nKy2OsYRQvNg8gWa6Da9TefwInEqfF0i++Hgo+AJxWyKdHB4InIRU54GP2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jQit0g54; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jQit0g54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C2F1F000C4;
	Sat, 17 Oct 2026 17:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256997;
	bh=4N4uKuVflvqG3McaY0IirLcqViqv91DCa6oUROc0wVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jQit0g54IYe3qZMkYLdWTL941KGfS4STxWxFfR1SHOJ2938p4EGrx06ryF9m7zPsn
	 PYJthXrCrWE2ec2QeVvxEX3cromCMz+WV/iuY0OxxBnutbDrlsIWVhPctarkLhDyPi
	 zG7yFugvr3axRz/03tGxd04nyA7VE8mVMOH01mz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0418/1674] ASoC: SOF: ipc4-topology: Harden loops for looking up ALH copiers
Date: Sat, 17 Oct 2026 17:44:50 +0200
Message-ID: <20261017160441.858878346@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 6fd60136d256b3b948333ebdb3835f41a95ab7ef ]

Other, non DAI copier widgets could have the same  stream name (sname) as
the ALH copier and in that case the copier->data is NULL, no alh_data is
attached, which could lead to NULL pointer dereference.
We could check for this NULL pointer in sof_ipc4_prepare_copier_module()
and avoid the crash, but a similar loop in sof_ipc4_widget_setup_comp_dai()
will miscalculate the ALH device count, causing broken audio.

The correct fix is to harden the matching logic by making sure that the
1. widget is a DAI widget - so dai = w->private is valid
2. the dai (and thus the copier) is ALH copier

[ Backport to 6.6.y: Apply both widget-kind and ALH-type predicates to
  the target loops; the newer node_type local is absent and unused by
  this implementation. ]

Fixes: a150345aa758 ("ASoC: SOF: ipc4-topology: add SoundWire/ALH aggregation support")
Reported-by: Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>
Link: https://github.com/thesofproject/sof/pull/9652
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20250206084642.14988-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-topology.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/ipc4-topology.c b/sound/soc/sof/ipc4-topology.c
index 18096aefce13f..8911c075251ca 100644
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -577,10 +577,16 @@ static int sof_ipc4_widget_setup_comp_dai(struct snd_sof_widget *swidget)
 		}
 
 		list_for_each_entry(w, &sdev->widget_list, list) {
-			if (w->widget->sname &&
+			struct snd_sof_dai *alh_dai;
+
+			if (!WIDGET_IS_DAI(w->id) || !w->widget->sname ||
 			    strcmp(w->widget->sname, swidget->widget->sname))
 				continue;
 
+			alh_dai = w->private;
+			if (alh_dai->type != SOF_DAI_INTEL_ALH)
+				continue;
+
 			blob->alh_cfg.device_count++;
 		}
 
@@ -1692,11 +1698,13 @@ sof_ipc4_prepare_copier_module(struct snd_sof_widget *swidget,
 			 */
 			i = 0;
 			list_for_each_entry(w, &sdev->widget_list, list) {
-				if (w->widget->sname &&
+				if (!WIDGET_IS_DAI(w->id) || !w->widget->sname ||
 				    strcmp(w->widget->sname, swidget->widget->sname))
 					continue;
 
 				dai = w->private;
+				if (dai->type != SOF_DAI_INTEL_ALH)
+					continue;
 				alh_copier = (struct sof_ipc4_copier *)dai->private;
 				alh_data = &alh_copier->data;
 				blob->alh_cfg.mapping[i].device = alh_data->gtw_cfg.node_id;
-- 
2.53.0



