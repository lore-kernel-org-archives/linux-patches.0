Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AB81DFE13;
	Wed,  6 Nov 2024 12:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895913; cv=none; b=id8aAXbbLHUOOJheif93CYv2/92h9nR8QcaoukO+YBRZ9sBuaaYfDcLEKcOQyhMjpcMXiMS8S9grA6xQAWn2ZdVD5FaS92fMSQM38wnLSuT0lG4MJL3opUjTozWqKUnVK/qOVdmeU6mesoua0CR4Pu+b12AViq9BjeRUJ1PkNKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895913; c=relaxed/simple;
	bh=64SKhd+1AjkBMuSfrjckG2pNEfv1nwlHoTs+AfzB9Ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cWXLhnp3kixhP76oVch7fbDc4y9VohJM0TTlj15PVlNRS39e0sxUAsX4j+T4qptqWMAZCVpjs0MsylRfT7clgG5usrZylKm1qJ2s06huVNERsm45NDwaza8MD7n95SXIWr93rCkkJWh42eUHamPGROluSVRBzIrkNQYbW7+gAVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2eyfSOV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2eyfSOV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142EFC4CECD;
	Wed,  6 Nov 2024 12:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895912;
	bh=64SKhd+1AjkBMuSfrjckG2pNEfv1nwlHoTs+AfzB9Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W2eyfSOVlXsjW7N1LXrRmzdAUZssiAPf3fWvMYoJ8MMcHqCN7LRD5edD2qDLzhzh1
	 najo+9W+2t9p0Om+b6aDq7Z/Y2Us7OrPZKlD19EP2Qn23Gfh/XG/72SWxuDPZm9+M+
	 6565JMeGlgfy4wEu7MBNgt9lauee9IbQPwDS6N7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksei Vetrov <vvvvvv@google.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 026/245] ASoC: dapm: fix bounds checker error in dapm_widget_list_create
Date: Wed,  6 Nov 2024 13:01:19 +0100
Message-ID: <20241106120319.877041349@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

From: Aleksei Vetrov <vvvvvv@google.com>

[ Upstream commit 2ef9439f7a19fd3d43b288d38b1c6e55b668a4fe ]

The widgets array in the snd_soc_dapm_widget_list has a __counted_by
attribute attached to it, which points to the num_widgets variable. This
attribute is used in bounds checking, and if it is not set before the
array is filled, then the bounds sanitizer will issue a warning or a
kernel panic if CONFIG_UBSAN_TRAP is set.

This patch sets the size of the widgets list calculated with
list_for_each as the initial value for num_widgets as it is used for
allocating memory for the array. It is updated with the actual number of
added elements after the array is filled.

Signed-off-by: Aleksei Vetrov <vvvvvv@google.com>
Fixes: 80e698e2df5b ("ASoC: soc-dapm: Annotate struct snd_soc_dapm_widget_list with __counted_by")
Link: https://patch.msgid.link/20241028-soc-dapm-bounds-checker-fix-v1-1-262b0394e89e@google.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-dapm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index e39df5d10b07d..1647b24ca34d7 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -1147,6 +1147,8 @@ static int dapm_widget_list_create(struct snd_soc_dapm_widget_list **list,
 	if (*list == NULL)
 		return -ENOMEM;
 
+	(*list)->num_widgets = size;
+
 	list_for_each_entry(w, widgets, work_list)
 		(*list)->widgets[i++] = w;
 
-- 
2.43.0



