Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA323081AD;
	Mon,  1 Dec 2025 11:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588349; cv=none; b=faeNI7i8IFHu2X9bbPDm77yNaRp+TfbAS4Og3wRpkUjq3j6mTBt/desaINpxOGWZH5Rk80Ue70E0udTwYHpq4IitkFKXEVbVQ6Lao3plTHVJwd6HS42s8WyTfEeUJxsDLmdRDVSJwW8VWRUuOz+QBj0s9ihqM+UYZJ7Wp61lW+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588349; c=relaxed/simple;
	bh=t40FUZZwQkGh5+UrTRTSxUXHMLadFGV0ikpdKA4jqGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NWBRucmVOyN+s4JzFLfFpH+dyIpi06WFHpW4ZKIRnX6FTf17Z4Qv+uwO217h/mCFzAEFOB52KvuGCH1RkOdBLMRO9AxWc7RktzhjEEk3MsNNFz5zTmVAaQZuiYBa64dm9TnPMyU9lMXsLhO8jNTiRZf7oo8Vj0xnjVoEr9pYV6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y27uV857; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y27uV857"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3ECC116D0;
	Mon,  1 Dec 2025 11:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588349;
	bh=t40FUZZwQkGh5+UrTRTSxUXHMLadFGV0ikpdKA4jqGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y27uV857H5eQfSPmzOAvf3FvWbqDK9qTi+ycc0JWSbT0ZM0mTV0YksGQTqQWvCCje
	 Thlyx3giTqzNUr8P4DBA1LCeqjMHkL37WScR6WAixFgXI31VARX66YbkAA0TgJXKS8
	 lcWnMTx3tFPClIotObxVUn5V9TbE9l24mEAe/N0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 010/187] ASoC: qdsp6: q6asm: do not sleep while atomic
Date: Mon,  1 Dec 2025 12:21:58 +0100
Message-ID: <20251201112241.622197927@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -299,9 +299,9 @@ static void q6asm_audio_client_free_buf(
 
 	spin_lock_irqsave(&ac->lock, flags);
 	port->num_periods = 0;
+	spin_unlock_irqrestore(&ac->lock, flags);
 	kfree(port->buf);
 	port->buf = NULL;
-	spin_unlock_irqrestore(&ac->lock, flags);
 }
 
 /**


