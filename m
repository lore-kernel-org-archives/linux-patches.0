Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63EF2EA46B;
	Fri, 21 Nov 2025 13:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732129; cv=none; b=SN5nLsvgKNyMfKmGGm9DkwWcGc4deq8ILW6nLAPwM6nRVconLzRaZhEOYapM2yI6wGbZhsdgKg9SNvNxHZiJoNxWO6OwRRX/M4UuD68n+jKNaHGynClUyK0kzgKNNXKiZX6IZAeah829iqEDRS1dyMPTfBDW8ttCMXzxThL6ct8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732129; c=relaxed/simple;
	bh=u0sBk5vEzWiNa4ByL+XYtvKlcQ/Q2H1sibiFOxKFhQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRFczdO30360L0GYefuon51ZKsNcT2LG/zNZKM1m2lDnOv/BbWHG0eiEjOxFOLSzpKVA6LobrtzWoNPaidzAYX4lYh5VXvYWWsA5n1RhK5F2UHhRP7hra91em7YFZ5jc662x95naSfDnyTDEM+2Mwzx50DP/gCyK89oCJoVR08Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gwXMpCBl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gwXMpCBl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680B7C4CEF1;
	Fri, 21 Nov 2025 13:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732128;
	bh=u0sBk5vEzWiNa4ByL+XYtvKlcQ/Q2H1sibiFOxKFhQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gwXMpCBl5gCPkRg6pAVI6bTZyZylbmhwRHKf7SWRr9mHQLdxiQy9lsO8YkbnZyXNk
	 J9YTnywzrLyMbbx65hBczHz62z8fwa9M8CwfoJrQXQrhCfoU+nQRbQ6+3LUhakTj8s
	 aMTrlXsEfUafHFHTLxyfM9m65Q4x7BwKgQYHiYY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 014/529] ASoC: qdsp6: q6asm: do not sleep while atomic
Date: Fri, 21 Nov 2025 14:05:13 +0100
Message-ID: <20251121130231.510092114@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


