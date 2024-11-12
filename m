Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5121213EE5;
	Tue, 12 Nov 2024 10:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408176; cv=none; b=aXiZskCVsDmJc+SVtNs34OMCMUKdCm5/YDkumGHYbxvBZdQXuRHnZRx+SPBvPfpBuEp7FynNaSVz6MlOnG38bcinFY5qaVF73x9L3LoG/nNUFT/sy3BWBGQfu66LLZ++Dw4wIHsqvm+zvHLjJvh2RWDq/bNiAwNyzO5bGg77lf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408176; c=relaxed/simple;
	bh=74fiWBkEqX8twxGcdq9X/k9jLlxZHXLgsR+U2KAvUsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hoa593j9jW74PO8uFlC1P5xnc+AoZEDKKvDQwGwrH8wFjV2KcFsAiBuiy/zdaaWYpGGKojYCirgV9GhCpCu2KwDpLnQ+xcv20uplPJci5nds/0d6YC0GHsQPEr2+gh7fAL21kI5MDq0RZzk+hmL11HWCnqphKrBW/IbvhGHqtZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZdamLtB9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZdamLtB9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3C6C4CED4;
	Tue, 12 Nov 2024 10:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408176;
	bh=74fiWBkEqX8twxGcdq9X/k9jLlxZHXLgsR+U2KAvUsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZdamLtB9iouqJwyPRZXuCHvdekrYUa4T9cgKVy2bcAES0SkMODmJ0W+c9faEtb1Wp
	 L3VsRiPLvJJkAujjjR96iq9kWTO1Vo2hVpmdT2eDvewTcXf6fb4pf5VEcVy9u4Htxs
	 dmI0+518ngxlniAp4sbc4ldOt/P/OefAOP2xIOsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.11 083/184] media: v4l2-tpg: prevent the risk of a division by zero
Date: Tue, 12 Nov 2024 11:20:41 +0100
Message-ID: <20241112101904.044493059@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

commit e6a3ea83fbe15d4818d01804e904cbb0e64e543b upstream.

As reported by Coverity, the logic at tpg_precalculate_line()
blindly rescales the buffer even when scaled_witdh is equal to
zero. If this ever happens, this will cause a division by zero.

Instead, add a WARN_ON_ONCE() to trigger such cases and return
without doing any precalculation.

Fixes: 63881df94d3e ("[media] vivid: add the Test Pattern Generator")
Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -1795,6 +1795,9 @@ static void tpg_precalculate_line(struct
 	unsigned p;
 	unsigned x;
 
+	if (WARN_ON_ONCE(!tpg->src_width || !tpg->scaled_width))
+		return;
+
 	switch (tpg->pattern) {
 	case TPG_PAT_GREEN:
 		contrast = TPG_COLOR_100_RED;


