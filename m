Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1255143892;
	Thu, 13 Jun 2024 12:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281087; cv=none; b=Q0QQqdr1S8sdsKgaZc1pRqfgaF7d1GABnmFr/ZpZMQWBxZDpbH0f/hZwBSkaoVgwaLzo7qUrY7szsANk0J7bOqvZQOQiLtPl4dFfBTNjv9b5rPlPHdvnesCWQij/xdJEdJ51UewWJjZ0gYfVjY9oZJn4gyuBjFBe8fw+CNpEikQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281087; c=relaxed/simple;
	bh=GsNLnoOa+OkZmrFCj9/Feh/VfZP/ie8lmroC9kmIg3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lzx39nK1wPT2wMURrho8TSyyPtoiOKrEsmvc9sQgnOnzT7qnMVCCgD+F088vyj05UwFHgk6FVFs5k7KFz6ap0d2pZEfRZdGFwrV4rgNtKy/JxpbEKxnOA0C2zSi0QdpSMkbOId7Pl6TUlZgOa3b8uiiM9HpYYsdzPTFSePNGwVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tcQUmssk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tcQUmssk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6482AC2BBFC;
	Thu, 13 Jun 2024 12:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281086;
	bh=GsNLnoOa+OkZmrFCj9/Feh/VfZP/ie8lmroC9kmIg3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tcQUmsskFjIHR9bKOXYJ8nBEZd8z8qiCQO2H9USM80/AkSb9gQUJT1RpKGTtEuhaA
	 rxo8y4hQREt3KHg5ih7dqmnb88ud3poI3u+qxm5KhCWVjyXvhO+gRYBkICxnMMNG/M
	 a2ScG9cAN6PwtQWMqSMTvAkedcGmXgId7W0CGTs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/317] ASoC: tracing: Export SND_SOC_DAPM_DIR_OUT to its value
Date: Thu, 13 Jun 2024 13:32:04 +0200
Message-ID: <20240613113251.651292697@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 40c300fe704da..f62d5b7024261 100644
--- a/include/trace/events/asoc.h
+++ b/include/trace/events/asoc.h
@@ -11,6 +11,8 @@
 #define DAPM_DIRECT "(direct)"
 #define DAPM_ARROW(dir) (((dir) == SND_SOC_DAPM_DIR_OUT) ? "->" : "<-")
 
+TRACE_DEFINE_ENUM(SND_SOC_DAPM_DIR_OUT);
+
 struct snd_soc_jack;
 struct snd_soc_card;
 struct snd_soc_dapm_widget;
-- 
2.43.0



