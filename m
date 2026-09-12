Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032474BEE3C;
	Sat, 12 Sep 2026 16:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231220; cv=none; b=GDOQvqB/mEcusCIdrAKKLOLHQwBmO2Dz/MlLV94LJLfSnTknpqszmGMfY6BLysKimdXOdB0U/ki+MSQBP9cwoKPIvCdm6S8upl2gCUnHuLjGi/ccfuaWvCDxx0JEhwlfkRXDe63JxcUckpTxgpFOhAw+e+kM4tFSvmJ14JIak7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231220; c=relaxed/simple;
	bh=ZKJk63+ZEftv+Qx336ZPCiQXjbOFm350uGfxt4SUAio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5XvsyoxFXGkxTYajkh0Ktcwc6lQU9twodGBm1dTd/5tvJLAnZn/v3aR5RkP4exNcWYCBli1gmRYBzqNbbXZ/2XhQ5rSc9lNGFRgWujPOH71NZ40w/iZLlt/EoPplsrSKnm8wynpGfJOYLdQbT1f0KICGqMrBR/BoYVC+GOqRpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AtKtRRN0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AtKtRRN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25C51F000FF;
	Sat, 12 Sep 2026 16:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231218;
	bh=WG0VW0ckbvtAzVd8YlxEpAKYhWaVP7ZrL6SXybpDrHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AtKtRRN0pzHvA3QSdUNEQleNBLrzc0oGku4A9NUpW9VlkZkMr03BOuxfm4uwdppWO
	 U1peSxdntm5F2/dZRnxNbAl5C/VanAUCjvzsKO+V1OpgqL2Qn6prddHzftG2GwnUCA
	 lF3ep8Mz499CN4Bp+q2H43QjVWu2nzzEQZAc04YM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorijn van der Graaf <jorijnvdgraaf@catcrafts.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0953/1191] ASoC: qcom: q6apm: keep the graph start count in sync with the DSP
Date: Sat, 12 Sep 2026 09:01:21 +0200
Message-ID: <20260912065609.627880175@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jorijn van der Graaf <jorijnvdgraaf@catcrafts.net>

[ Upstream commit daa7ffd765ae67a83e77dae32c66ce2d6d995d19 ]

q6apm_graph_start() increments start_count even when APM_CMD_GRAPH_START
fails, leaving the graph counted as running while the DSP never started
it. A later start - a retried prepare, or a resume after a failed start -
then finds a non-zero count, skips the command and returns success with
no data flowing.

Count the graph only once the DSP has accepted the start. The count then
stays at zero for a graph that never started, so also stop decrementing
below zero in q6apm_graph_stop(): the compressed free path stops
unconditionally, and a negative count would make the next start skip the
command in the same way.

Fixes: 5477518b8a0e ("ASoC: qdsp6: audioreach: add q6apm support")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Jorijn van der Graaf <jorijnvdgraaf@catcrafts.net>
Link: https://patch.msgid.link/20260726211226.94059-1-jorijnvdgraaf@catcrafts.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6apm.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/q6apm.c b/sound/soc/qcom/qdsp6/q6apm.c
index 586ee4c7ff6d8..f9ee8bbe35f25 100644
--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -682,14 +682,17 @@ EXPORT_SYMBOL_GPL(q6apm_graph_prepare);
 int q6apm_graph_start(struct q6apm_graph *graph)
 {
 	struct audioreach_graph *ar_graph = graph->ar_graph;
-	int ret = 0;
+	int ret;
 
-	if (ar_graph->start_count == 0)
+	if (ar_graph->start_count == 0) {
 		ret = audioreach_graph_mgmt_cmd(ar_graph, APM_CMD_GRAPH_START);
+		if (ret)
+			return ret;
+	}
 
 	ar_graph->start_count++;
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(q6apm_graph_start);
 
@@ -697,6 +700,9 @@ int q6apm_graph_stop(struct q6apm_graph *graph)
 {
 	struct audioreach_graph *ar_graph = graph->ar_graph;
 
+	if (ar_graph->start_count == 0)
+		return 0;
+
 	if (--ar_graph->start_count > 0)
 		return 0;
 
-- 
2.53.0



