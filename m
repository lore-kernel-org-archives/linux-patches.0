Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC5F19B3CA;
	Thu,  6 Jun 2024 14:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683376; cv=none; b=UzXsWh7AdKeFCzAqG82bWyJiSQtcGkC0fMIEs+GWjiV/5zKjs3ePc+RDAo5SyPc/RWg2JKPxmXlgw2O3A+TrL2vOz6ZBq3zMoMPHwGJ7Dn2EJoahdbCnpsLrgVeOgJk1Gz8XxthOqp33JVq9Sxn4+0YRsEMUXeNOeocQglb2xSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683376; c=relaxed/simple;
	bh=2fY7OeN3E92U3PxTkQF1JADwruU45qREv8zCdwemmBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r6vAn5OqcgU/S+Da/Bj18BFbwXr0Z3bTwKLwc8j4jHpuSl8B5Fh+bm90dFQVAdVsB408wQ1NstrhVRsQ+uqiZqmSLU4VEUQtqfy7TQW7QcREqoU6xRJkB4UsFqzbQMKdWLA4fPojfZTncOaHv5w6MqGP6ORFNLL8oB+LXnZpJJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3YgwUVg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3YgwUVg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DBFDC2BD10;
	Thu,  6 Jun 2024 14:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683376;
	bh=2fY7OeN3E92U3PxTkQF1JADwruU45qREv8zCdwemmBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w3YgwUVgxnfcoW61gfUPwj9xG3dWpU9i5dW5CQoyiJpvvHpdRXH+WFCn2zk5w3SVV
	 k3HQq6u98UR3unGgAECS8rphJeZ8GY8jqd6JC6pFH7HBRhdyg36yF7K92txvh+rmNQ
	 wGMdtRRsIMOD48r4cRT/vomg9N8kcqHa2jgbDW9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 318/744] ASoC: tracing: Export SND_SOC_DAPM_DIR_OUT to its value
Date: Thu,  6 Jun 2024 15:59:50 +0200
Message-ID: <20240606131742.628732346@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 58300f8d6a48e58d1843199be743f819e2791ea3 ]

The string SND_SOC_DAPM_DIR_OUT is printed in the snd_soc_dapm_path trace
event instead of its value:

   (((REC->path_dir) == SND_SOC_DAPM_DIR_OUT) ? "->" : "<-")

User space cannot parse this, as it has no idea what SND_SOC_DAPM_DIR_OUT
is. Use TRACE_DEFINE_ENUM() to convert it to its value:

   (((REC->path_dir) == 1) ? "->" : "<-")

So that user space tools, such as perf and trace-cmd, can parse it
correctly.

Reported-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Fixes: 6e588a0d839b5 ("ASoC: dapm: Consolidate path trace events")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Link: https://lore.kernel.org/r/20240416000303.04670cdf@rorschach.local.home
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/asoc.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/trace/events/asoc.h b/include/trace/events/asoc.h
index 4d8ef71090af1..97a434d021356 100644
--- a/include/trace/events/asoc.h
+++ b/include/trace/events/asoc.h
@@ -12,6 +12,8 @@
 #define DAPM_DIRECT "(direct)"
 #define DAPM_ARROW(dir) (((dir) == SND_SOC_DAPM_DIR_OUT) ? "->" : "<-")
 
+TRACE_DEFINE_ENUM(SND_SOC_DAPM_DIR_OUT);
+
 struct snd_soc_jack;
 struct snd_soc_card;
 struct snd_soc_dapm_widget;
-- 
2.43.0



