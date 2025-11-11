Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123B81FDA92;
	Tue, 11 Nov 2025 00:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822115; cv=none; b=VNlAiUnmIkdtWKIYvibf6QQS0zFXrVLJNwLWsGKpOKN8u0N8CroXNmjd/QRVNo9mmBUsc8pPsC1nZ6/wpp+CgfYM1MuGslCIy9n8zxruYkfn8IzykFdiz4iwdzabZWIJzEXrGtsHJpyegYTP77kN5Vj6Y8p17qYpQXKOdz3TQ7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822115; c=relaxed/simple;
	bh=uLbz8MFkpf/MrPbDjoDqTAeJIqCR5uau1vtC8lCiHVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWpqhRTGka9nYgYhNs7XJZWEW3RFBvPmFQ/6GGRZ6lPjGA9kWlpOs3PDYn0gAXW+51inHzOZMa16Y2RrraXTDcoYTqfbvOEsC/RkcGzhYQ1FqdbZShZlIGaOUgyZFml/p4bFV/gbGplX+eoZaJn1Pe0EY5BITQsB2f1+eHjIDYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+MEssMO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+MEssMO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D72EC113D0;
	Tue, 11 Nov 2025 00:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822114;
	bh=uLbz8MFkpf/MrPbDjoDqTAeJIqCR5uau1vtC8lCiHVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z+MEssMOx/+B2e8VyQZgEMojRl98k7NpgKKarPgJ23RJX9Mb86pXP3KD/bSogGCkn
	 iRx8YiMO4h6bT9KWIg4koqGMbhN9UCz6qxohJ8uXxakhnQqSjBhXO4gQHPp/O1pByB
	 wEQwKVrOodd8wp81qNa7Bt9rJBZd1awOuta20vdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.17 022/849] ASoC: qdsp6: q6asm: do not sleep while atomic
Date: Tue, 11 Nov 2025 09:33:12 +0900
Message-ID: <20251111004536.989896715@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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
@@ -377,9 +377,9 @@ static void q6asm_audio_client_free_buf(
 
 	spin_lock_irqsave(&ac->lock, flags);
 	port->num_periods = 0;
+	spin_unlock_irqrestore(&ac->lock, flags);
 	kfree(port->buf);
 	port->buf = NULL;
-	spin_unlock_irqrestore(&ac->lock, flags);
 }
 
 /**


