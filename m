Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EE21EEF8;
	Thu, 13 Jun 2024 12:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282044; cv=none; b=T3Wm8/Okjslh7W65fcC+TiS78VqkgH+rpo6OBYmlw0VyD0jd6FprIM6AdVx0DiPjSP8WjKBiumVhhPmz0+MK85wsTJ9PEIIQbcNtMWaFkLqae60FjohvuX5A641iVd3ODJkg0yvSio4r/B8DHYma1WS7kXWs0n1fW8jpOIWFVs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282044; c=relaxed/simple;
	bh=KksKceKykC8BSjbFySXyD2hwBxHcBsFq/9IArbmx4rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQIMHwLL8m094j20NewM6RnraR7w+ras42e/czQiKqRWaDq5Nory/r0RzRG96mIpJyRDSaiyBkXhQSMQqol1eWy+VjgbFKzTT+YfPL19hZtsRyfY2uM3WWeDpmcucXZ5b7it4TvCog9yepnaSaPhZ7/TW/do1WS95T1NEQv7Pg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P1RrDtxU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P1RrDtxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36501C32786;
	Thu, 13 Jun 2024 12:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282044;
	bh=KksKceKykC8BSjbFySXyD2hwBxHcBsFq/9IArbmx4rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P1RrDtxUn/4R6NBO3jzuARVIEWyEjG+Anpqgh09ECzcKFnrXAoWKDzV63NZzOXVQj
	 YsekDuLXNd/diFNocoKHBExmtN41+IIKuk8m7dYnFVenfdECIbW4VAgdXnlFZM0+w/
	 W2/w2qL+lJdTz1+xiIViJRQucoeX614cGrEAJ1Lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 143/402] ASoC: tracing: Export SND_SOC_DAPM_DIR_OUT to its value
Date: Thu, 13 Jun 2024 13:31:40 +0200
Message-ID: <20240613113307.713076239@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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



