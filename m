Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB1135F61E;
	Sat, 12 Sep 2026 07:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196959; cv=none; b=ExMMIKMsXWaTuiSmeMyIr6dAlskrkWQSXCg60DJJhygscJe9qoP47scT2PFBTGCnXbhxIZawzixhW37LYR+L/g9VPoSPLjB0qvp1pNLHa2+iUoF/+5YOo46ERn4yrOsPKZkFyJFRiaAI75stgTEOFQy2yv1p+N8sonjhppSca1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196959; c=relaxed/simple;
	bh=dqJBMckxGsgK6uRcrU1wiS8zdJ8oFiGlwOoIBtedcXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTuNk9PAQjr0hDSxa5FRlN22FSDYiNvPCe3WoeQuRcrNVh0l4HgwQKLrUbAiXP4qPfHW6L9hS0uvUcNURrP8qMrQHzacYtNoqm7FJp5CPeMAvhfr6k9up9c86K84ueNqMrcEiJdc7RgtN7cb61aU5JeYtDEOGZgTaggxlJC4dVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ezo9SqO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ezo9SqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244001F00893;
	Sat, 12 Sep 2026 07:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196958;
	bh=x8t8j3uxf+P6LuHoLlcxeFVLtFvJrFIJHTDb0+5jw0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ezo9SqOqtFuiLRKo2BXbNVD9wcAigq9PY9Rog/vfJZM7AOMPZPYDi49YY0gcKU5n
	 T217YLzVkbBQddk7/D1xIp+RPzmB7VQGUysCc/dOX6eWEztPrJlaYSWfae7fSW2gCj
	 Rh8QP5e5bBsESa/K0E+kt0wm6/1r/vfOdwUvOKSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Mert Seftali <mertsftl@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0072/1815] ASoC: SOF: ipc4-topology: Return error for invalid number of formats
Date: Sat, 12 Sep 2026 08:30:22 +0200
Message-ID: <20260912065650.705726991@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mert Seftali <mertsftl@gmail.com>

[ Upstream commit 11e828cd6b0f283ebe9dc6b4cffd38e3321e7725 ]

When the number of input or output formats is zero,
sof_ipc4_widget_setup_comp_src() and sof_ipc4_widget_setup_comp_asrc()
print an error and jump to the cleanup label. At that point 'ret' is
still 0, because the earlier sof_ipc4_get_audio_fmt() call succeeded, so
the function returns success and the caller never finds out that the
widget setup actually failed.

Set ret to -EINVAL before the goto so the error gets reported.

Fixes: 21a5adffad46 ("ASoC: SOF: ipc4-topology: Validate the number of in/out formats for src/asrc")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202606111431.Uky3T0tF-lkp@intel.com/
Signed-off-by: Mert Seftali <mertsftl@gmail.com>
Link: https://patch.msgid.link/20260614124019.19259-1-mertsftl@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-topology.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/sof/ipc4-topology.c b/sound/soc/sof/ipc4-topology.c
index 6fdfb667cce8d..8f37fbdd3f7fa 100644
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -1127,6 +1127,7 @@ static int sof_ipc4_widget_setup_comp_src(struct snd_sof_widget *swidget)
 			"Invalid number of formats: input: %d, output: %d\n",
 			src->available_fmt.num_input_formats,
 			src->available_fmt.num_output_formats);
+		ret = -EINVAL;
 		goto err;
 	}
 
@@ -1179,6 +1180,7 @@ static int sof_ipc4_widget_setup_comp_asrc(struct snd_sof_widget *swidget)
 			"Invalid number of formats: input: %d, output: %d\n",
 			asrc->available_fmt.num_input_formats,
 			asrc->available_fmt.num_output_formats);
+		ret = -EINVAL;
 		goto err;
 	}
 
-- 
2.53.0



