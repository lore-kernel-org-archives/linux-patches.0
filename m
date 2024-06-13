Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1AE145B07;
	Thu, 13 Jun 2024 11:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279915; cv=none; b=BnscvDECIr7TZKGUJZxFhbU8+BelQa8MAJk5q1/A3VvqIE7UrMKOHGP79Ox1YSpwpGHftXe+MXAdLQDeE2baiBLtgp10UD3jWkwrWhZnJgfnTb6+PBHz75U1yzU2pb35yXATjfPrnuED+IT1KIGNmHwfVqI2CTgxkJeEwAlOFjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279915; c=relaxed/simple;
	bh=mZ8cWQuQ2SDlTnegmB5phbcFeVgIUzEBxmi8Xs06TEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XspGWFAPzPtW7NIemyfDij+7gjzReVQzMuopevOPdf3A1H5ffzP3JClIeI4M3RBv3iafo8ziNvI1EpIyk3ctdZGj2vLmf/4a8i4gfCWLFyAmpW0UBr9RQPE+bR21dNJ+mGB3AcDOxaajOyCiJL09keq9m/B/JUZsNEkm3dvoOwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B3Tcvfq0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B3Tcvfq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50B0C2BBFC;
	Thu, 13 Jun 2024 11:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279915;
	bh=mZ8cWQuQ2SDlTnegmB5phbcFeVgIUzEBxmi8Xs06TEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B3Tcvfq0OtOdZFPJZ1S5cnclEyOKp3xuBnRtXepsTzhvqRCGmhgkXUpCNmqQBZpj6
	 s6wwloyalvlUSVNX1iv9Vlv1EcdWG5PCoMKkH7ytWD3M+C5jDDA40y60f4rMZLFkfX
	 yCAFSyC4GMp3D6ApqKQmSoeL3NNbpUBkS9qt1nlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 079/202] ASoC: tracing: Export SND_SOC_DAPM_DIR_OUT to its value
Date: Thu, 13 Jun 2024 13:32:57 +0200
Message-ID: <20240613113230.823661363@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



