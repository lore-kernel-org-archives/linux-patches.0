Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A163E264FB2;
	Thu, 17 Apr 2025 18:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914928; cv=none; b=t5F+mnFTS4WZicsh3ItOtRVC9aGCnAWCzNnZfSPRdFu1gtJKxKfSAN9gNg7+QZIB/JW81WHXEh+cjem9lHGJSXwX9KtfkNgLq3Ivmc1HXqWRBGhwi7u1407Wo3uo44wRwsm3X5mNXTvJFzDNbD1eE96vq0xis0FdnF3l5qDBQUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914928; c=relaxed/simple;
	bh=0ERnUUZ6ylkGsWIn8VxpB92BYvSq2GottDZ33+uDjf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kY3X6Xy2o3BIRL2eD+SLifhYzhGfK0aGcbCqd0m3dVueNPmIQkdPcHwb8bLUqDz6HpFtxJepcUGkqICfxuV2wntYBewDeTM/5MrvtFYNJTDphEE69kqG31c+olpXUfqX0IhsLFRRTCR+nIr+ao4uswq9oMFM/Iav+V1BSGbj2Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oSVU2VuG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oSVU2VuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACAA5C4CEE4;
	Thu, 17 Apr 2025 18:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914928;
	bh=0ERnUUZ6ylkGsWIn8VxpB92BYvSq2GottDZ33+uDjf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oSVU2VuGqAdgnBdInghIwc7Xu/+fWaQPD2/yMK7kNYtmjuQBHjxBym7bslWNNe3ax
	 MfpfHl9SAw9Gk6uCuNwi1aU01Nm23U4eS1zuNLXaXhhs6mXIJI+yuEVMUuzsiNRv2P
	 XmSholpBVGtu4IvUFPd2LPubmNHirJj+fOqL8Nzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.13 346/414] clk: qcom: gdsc: Release pm subdomains in reverse add order
Date: Thu, 17 Apr 2025 19:51:44 +0200
Message-ID: <20250417175125.343254256@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit 0e6dfde439df0bb977cddd3cf7fff150a084a9bf upstream.

gdsc_unregister() should release subdomains in the reverse order to the
order in which those subdomains were added.

I've made this patch a standalone patch because it facilitates a subsequent
fix to stable.

Fixes: 1b771839de05 ("clk: qcom: gdsc: enable optional power domain support")
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20250117-b4-linux-next-24-11-18-clock-multiple-power-domains-v10-1-13f2bb656dad@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gdsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -571,7 +571,7 @@ void gdsc_unregister(struct gdsc_desc *d
 	size_t num = desc->num;
 
 	/* Remove subdomains */
-	for (i = 0; i < num; i++) {
+	for (i = num - 1; i >= 0; i--) {
 		if (!scs[i])
 			continue;
 		if (scs[i]->parent)


