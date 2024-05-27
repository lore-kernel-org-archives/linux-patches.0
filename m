Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC126168C4;
	Mon, 27 May 2024 19:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837452; cv=none; b=dA36fFACTftSevSS8Qczjf4N4CZnSffglUTNYlqVgiIA/RazJqcOB3GZcLtCHiJi0Z73qLKiFFNuXWrKn47mX/yF4CTXLCBT4OhcY6l96HrnwfNv8kaDctK1xKiDhYfkFS3xeVsAIMSgc35I81a7GeepSup8lmv7jyRwsYuQO7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837452; c=relaxed/simple;
	bh=ze7QeFIJ8L0syFUsOHDfS6VBkcyRdm1/2Bq3MKpLN+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pOsroXh3DAYGgS6xuN7tJtsKcmq4/C/UCV+594y9o847r2KlOZA57MCb2e8OY2drzxGZrCudQ375tdwurBN3FAp/hJvkSr9Lm0sFI5NPsrwwZ569BBk3LgvU0KInk7Y7Kt81TlY3av8+RKF9MmHNEGzYSWsqXhVuiMtblx6sowc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WqmdmheT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WqmdmheT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4172EC2BBFC;
	Mon, 27 May 2024 19:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837452;
	bh=ze7QeFIJ8L0syFUsOHDfS6VBkcyRdm1/2Bq3MKpLN+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WqmdmheTCibUSYMW2TEBi6mtz+Nane+4t44+deuHxgaNtDITOVNyC6xqX5ASu8N0W
	 kSQaGkEPmsd1/tdwACPgo96nHrOhUFLl7M1jXYsE2PBbBbbO5AMmfwffrrGlliJpEW
	 pBheTYgjw6YHzduk904GPwHNtIbAiPo0/sMC9Tx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Dexuan Cui <decui@microsoft.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.8 019/493] net: mana: Fix the extra HZ in mana_hwc_send_request
Date: Mon, 27 May 2024 20:50:21 +0200
Message-ID: <20240527185628.422170058@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>

commit 9c91c7fadb1771dcc2815c5271d14566366d05c5 upstream.

Commit 62c1bff593b7 added an extra HZ along with msecs_to_jiffies.
This patch fixes that.

Cc: stable@vger.kernel.org
Fixes: 62c1bff593b7 ("net: mana: Configure hwc timeout from hardware")
Signed-off-by: Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Link: https://lore.kernel.org/r/1716185104-31658-1-git-send-email-schakrabarti@linux.microsoft.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microsoft/mana/hw_channel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -848,7 +848,7 @@ int mana_hwc_send_request(struct hw_chan
 	}
 
 	if (!wait_for_completion_timeout(&ctx->comp_event,
-					 (msecs_to_jiffies(hwc->hwc_timeout) * HZ))) {
+					 (msecs_to_jiffies(hwc->hwc_timeout)))) {
 		dev_err(hwc->dev, "HWC: Request timed out!\n");
 		err = -ETIMEDOUT;
 		goto out;


