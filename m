Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C10630ACF4;
	Wed,  3 Dec 2025 15:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764775872; cv=none; b=bFJInVRFU9+tZ/00Yb2XKjbefFe/227rz3gc3jQ75o39JDOs7j+jZUzq61bBZjgVF5E5maI/1DPTd7WCQcMD11BaseVqsAfwLOn1+Jn2DWS+FtrIQ99LFHber9U67sxI5WuJI7SOeSu3ZW0Axw0g4BY+8/DEONPWXzkYs/O54CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764775872; c=relaxed/simple;
	bh=nw6FMW4+qZvESZ/pCcNnkqNsfw2SfwDgCIUby3R/IOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=as5nZZQgWYXGI+1K3QQ+o29IzZDa1c7XH4YTn4dlo2Qy/X5sojRpH4Zkm6xOdIxFmsuZR/zBxt1WCU4QiqshpFxoGuAeohridBuWM5A0d3tUyzbck0kcqvmuW9Fewj2CdmoHnoFhRvAQRmeJSOqxHRtI5uv12OnkZdS37wE/N8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GEI4Dud1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GEI4Dud1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C78C4CEF5;
	Wed,  3 Dec 2025 15:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764775872;
	bh=nw6FMW4+qZvESZ/pCcNnkqNsfw2SfwDgCIUby3R/IOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GEI4Dud14Okf6oeVIi9DwyRE/dqQdVu/FJzgMGRaD+GDaaY0B+b/VELmQAWDzKj91
	 XBgzojsLpOM4DpvY9JKNoQKqiMRmb8eEMa0X65JW1HPUxwkvM0n9/7QIW9R3x+lqNw
	 PZ6Fan2MlQK8wRJ5ip7BD7f7+C67G8ieocG1v/88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 013/300] ASoC: qdsp6: q6asm: do not sleep while atomic
Date: Wed,  3 Dec 2025 16:23:37 +0100
Message-ID: <20251203152400.949724126@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

commit fdbb53d318aa94a094434e5f226617f0eb1e8f22 upstream.

For some reason we ended up kfree between spinlock lock and unlock,
which can sleep.

move the kfree out of spinlock section.

Fixes: a2a5d30218fd ("ASoC: qdsp6: q6asm: Add support to memory map and unmap")
Cc: Stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20251017085307.4325-2-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6asm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/qcom/qdsp6/q6asm.c
+++ b/sound/soc/qcom/qdsp6/q6asm.c
@@ -376,9 +376,9 @@ static void q6asm_audio_client_free_buf(
 
 	spin_lock_irqsave(&ac->lock, flags);
 	port->num_periods = 0;
+	spin_unlock_irqrestore(&ac->lock, flags);
 	kfree(port->buf);
 	port->buf = NULL;
-	spin_unlock_irqrestore(&ac->lock, flags);
 }
 
 /**


