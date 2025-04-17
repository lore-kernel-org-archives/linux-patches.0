Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405CF2571B2;
	Thu, 17 Apr 2025 18:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916132; cv=none; b=EMHIL8ZHxjzjUBY/HY0zUhdRfkhQa8k5mnmzKAmX54cVUI9PZ3P0SbRtQG+W+u9gUnfDBxOLPmW8yuwn13zGUzdw4zUN+mGB5MfxvPDkDGPi2GcGJrpSaEbBCZRxkn9H6Fzx0sfn3hHK2/X4RO3rK8PkX8SO4Du2yMiCJOcTavQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916132; c=relaxed/simple;
	bh=TDIEv7pdn63SjsK42/nBLOrLRVB/3cL0L+79mOMJD8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOlLAo+teMz23qAiylA0LJQmZVmpic4vFIGQQPuTc/AU9cJtq/O+Mmz+k3pTfjPHE5DH67D1b87OHTYi4ZjV+43zDGoYQNgPv7RPiADe4WWZRZhVb+LFNGur+LvEvQmThlD/diDe24X3VYrXElQr4fx5f8TArtR+rrwrQkzbVlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fFX/iP5M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fFX/iP5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B56C4CEE4;
	Thu, 17 Apr 2025 18:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916132;
	bh=TDIEv7pdn63SjsK42/nBLOrLRVB/3cL0L+79mOMJD8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fFX/iP5M2/p1xn4d4fgkqStX18RB8zlJ8cQFX+Y231Wg30a4zzCc1NnGUXJ6kvber
	 uXoio8Xine9aukG2LkGool6sBucRAao4OsEFGjvRjK7n+kMNXYz/LoB8C8/iuiY/eg
	 mRKdEjw/fhlDdhC8zJRkRzc2RTNSs9hfLi0zwybk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 324/393] clk: qcom: gdsc: Release pm subdomains in reverse add order
Date: Thu, 17 Apr 2025 19:52:13 +0200
Message-ID: <20250417175120.647449803@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


