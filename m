Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8759D29D26D;
	Fri,  3 Oct 2025 16:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759507612; cv=none; b=PCM+v2eVUuPmOrWHy+bqzjtC3i68dpZy4o9tIIwgTvXV5H8tMY/qvKcsjVMuZyY2BfXpUpnY6RywAo+rFiYsbXqa6YpuypRj9e8kRlnUD0LiybCW822XjuoeUqDHbrSBj3KEV+j8OovMzJ8TegSgP+qQ/4CyOPMbU6NYvMOtt8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759507612; c=relaxed/simple;
	bh=gv2oQ4XKnQBU6sHTHiRcs4SPgfN4AQWLgE9x1csf3J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KgsWfS2++/QBjKFgMA9P4KM5uuQjtbvD80zChKL90VM8dyU2IwceZ/sXu4YDKChg2fMfh3kOt4RYaftwDo62CSAf1tQvpMhKTg+rdkiMQWaUl06UFq0L18nAcQ3P00Q7+HWidhvuhF2e6nJqVXa5rAiDsj+76bdRBbGSgxYgBO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nH9OzK3V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nH9OzK3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3A3C4CEF5;
	Fri,  3 Oct 2025 16:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759507611;
	bh=gv2oQ4XKnQBU6sHTHiRcs4SPgfN4AQWLgE9x1csf3J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nH9OzK3Vn6pfLwgjaFqfSIDbcmGlgQr9DvnE1vje6Qq9T/tMsH6Z0zQzMqvbrUeMW
	 NyiZOf+3ArViqfAuyzlhF2GWhRVZStq2VkDwq8UnUgxB1rihhBi9cR7L0t/swA6NIm
	 mOR7OydRjLXHKz/g8KLC8yP6+QEZSoIbX5GFyuXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.17 15/15] ASoC: qcom: audioreach: fix potential null pointer dereference
Date: Fri,  3 Oct 2025 18:05:39 +0200
Message-ID: <20251003160400.431999275@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251003160359.831046052@linuxfoundation.org>
References: <20251003160359.831046052@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

commit 8318e04ab2526b155773313b66a1542476ce1106 upstream.

It is possible that the topology parsing function
audioreach_widget_load_module_common() could return NULL or an error
pointer. Add missing NULL check so that we do not dereference it.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Stable@vger.kernel.org
Fixes: 36ad9bf1d93d ("ASoC: qdsp6: audioreach: add topology support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20250825101247.152619-2-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/topology.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/qcom/qdsp6/topology.c
+++ b/sound/soc/qcom/qdsp6/topology.c
@@ -587,8 +587,8 @@ static int audioreach_widget_load_module
 		return PTR_ERR(cont);
 
 	mod = audioreach_parse_common_tokens(apm, cont, &tplg_w->priv, w);
-	if (IS_ERR(mod))
-		return PTR_ERR(mod);
+	if (IS_ERR_OR_NULL(mod))
+		return mod ? PTR_ERR(mod) : -ENODEV;
 
 	dobj = &w->dobj;
 	dobj->private = mod;


