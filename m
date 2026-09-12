Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E79C221F26;
	Sat, 12 Sep 2026 11:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211040; cv=none; b=dNZld8Rar3p05KfYF8RNm7ozzfe2ccqYRbaUEArTgjYoCtCXVHzOYK2bEzhEVGnLyZJBGGdkwU5Tiq57bH7oyMyDLn7hxydUZw8CRLCTROAe1ePH9ZkGhnvTDvMde1IZRFO3hJsTa6lV6+NgtXOE1MXP7sxwQtDwAqR6JjTiwFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211040; c=relaxed/simple;
	bh=Zh9Owti6hysKIsdL6mcmChWfB9jRt2NIuYGsqkgZWKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uT9qvk0HOra8Cey4wUX3iqMfq2ChhRXKMEeXDfXLJ8U1f3UHBo9IKW/W+207dGF58eKoX8MgtIZtJ1AWVM8ZgWcLXlsJXY6JRadNKDOvi1cFqU8GavMa0jvJmxNyxQM8mhoIDbFxGkwtyX+Fy3isUy0tYIOKnjfEfQJLyrU5iEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tScWP2Bj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tScWP2Bj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCCB1F000FF;
	Sat, 12 Sep 2026 11:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211039;
	bh=20lCtHjN18oFWtOomlKlEVweXqgJFHODdhkIGFgq8g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tScWP2BjoBfGnIfjMXX8WSXeeNdwPLOFsy6mXwvHgkXdKiQUNa1ncNTTXlXaEe/tz
	 F/KYkjUIPWAkyTchIZ6kNo/YldwF/xr1e+TeJ4VaP8PRm2lWsitUtI2npZoituxGik
	 vSkXgrdmG9JSRtqY/C6+t5KPONCFuCI76vOfP8dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorijn van der Graaf <jorijnvdgraaf@catcrafts.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1106/1518] ASoC: qcom: q6apm: keep the graph start count in sync with the DSP
Date: Sat, 12 Sep 2026 08:54:35 +0200
Message-ID: <20260912065648.470293282@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6326649ba31b4..16b2e227a6f13 100644
--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -700,14 +700,17 @@ EXPORT_SYMBOL_GPL(q6apm_graph_prepare);
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
 
@@ -715,6 +718,9 @@ int q6apm_graph_stop(struct q6apm_graph *graph)
 {
 	struct audioreach_graph *ar_graph = graph->ar_graph;
 
+	if (ar_graph->start_count == 0)
+		return 0;
+
 	if (--ar_graph->start_count > 0)
 		return 0;
 
-- 
2.53.0



