Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1C830C358;
	Wed,  3 Dec 2025 16:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778814; cv=none; b=b84Rl3xr7bkrDqVda2HIvs+EFd7NMB7ChEL8DGlWzGgilMadpdM8jkJ4W0zNo9GrG9ajoInTSU7Qt6V9dFBQtyWkuHrnCUswMFp2aN+IZFhi35hzHojy5pw9V1JiF2PbrkWoN1FymZHC9bAQO+F9/HZQDQpcFnIOaDOYKotmHpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778814; c=relaxed/simple;
	bh=2FRZ6DAHfKje0gkw7zJHsetveROE/V5QCgcBvn+OSAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f29dduii5bCOjEklOjFClSswvvOGRaXkSmbTZ5kyEyrO3eE2pbVtWrsEE2LzOnER8myJEbowMNHXPPc1zB9YUFIyI3LRff98Z9UTJIoMdcwH0nfW08Brnm0sr0xl+QlBP4uf+iWgn+mXXgr9I9FVP6oHnEj9RMA5JrA8IyDxYt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1njWiQcp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1njWiQcp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39534C4CEF5;
	Wed,  3 Dec 2025 16:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778813;
	bh=2FRZ6DAHfKje0gkw7zJHsetveROE/V5QCgcBvn+OSAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1njWiQcpj/07IyTrb/YB/L7581rn6vrPrpAUW65qbp4zEgruSVArS0dbO7Z9ur1Oz
	 pUIL+n9aIhdM2TMDGvtJbsesJ2N2sstMOT8poWeuyCbW1uDKFtwiQGTsYIXt9Mv/W9
	 C/aMZxfvq9vC/rhm4zecqTPPGwuBuXDmabw1MdYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 034/568] ASoC: qdsp6: q6asm: do not sleep while atomic
Date: Wed,  3 Dec 2025 16:20:36 +0100
Message-ID: <20251203152441.922033281@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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


