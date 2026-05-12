Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF613955F9;
	Tue, 12 May 2026 17:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608574; cv=none; b=Y1aYzRcKBUCfCkOnavCAH80h3K31cGTbvR6zE+e+ELTP1xOwTCDfeDZVHkJLVbBMJrChZ2TBppBWX09WVuRP9g/1vrlZV3fItbkLohQrsj86qAvOX/NuvKCqf4OcSlt6LQtygz1mHu/32iI4DYrXc3sCCoesewO5CClnm91Fwmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608574; c=relaxed/simple;
	bh=mEsn27ScPzfElfOfbhLpfjx/HdtxgRh3QrmIn1v6BCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTLwFCwv8uioN9CbqZHPDLU+zWjp8Z3Fk+gG+ctkuKwHAfhpPq3j6Z8l3zzyANoPiS/ChJ+4ECPXvwt7GtJ8/qMZBuaauFhnv/F1mLfDviiJYoNKkI79Pbm+wcj5hTCxWPH9whojKu4JdhZztSGIH1f88N/4jR+9ijRYe0f2RQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1BmJqA/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1BmJqA/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD9AC2BCB0;
	Tue, 12 May 2026 17:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608574;
	bh=mEsn27ScPzfElfOfbhLpfjx/HdtxgRh3QrmIn1v6BCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1BmJqA/UruD+1ATOd6e9imT0Tw5u7UGsvwMae3AV/FWYQ0HLjyy6rZWUAo/36NiLd
	 6mj0EZnwqogvZo3QEArm7JjOF+pSV5ZDBTCO9mAU3KBeMzgN3BZJFBg5iATnl+jfq6
	 DRFZEMG4XfgVfYx73hhnvKMLrEcYj473Rbesb9Xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH 6.18 133/270] thermal/drivers/sprd: Fix temperature clamping in sprd_thm_temp_to_rawdata
Date: Tue, 12 May 2026 19:38:54 +0200
Message-ID: <20260512173941.252058070@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 83c0f9a5d679a6f8d84fc49b2f62ea434ccab4b6 upstream.

The temperature was never clamped to SPRD_THM_TEMP_LOW or
SPRD_THM_TEMP_HIGH because the return value of clamp() was not used. Fix
this by assigning the clamped value to 'temp'.

Casting SPRD_THM_TEMP_LOW and SPRD_THM_TEMP_HIGH to int is also
redundant and can be removed.

Fixes: 554fdbaf19b1 ("thermal: sprd: Add Spreadtrum thermal driver support")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260307102422.306055-1-thorsten.blum@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/sprd_thermal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thermal/sprd_thermal.c
+++ b/drivers/thermal/sprd_thermal.c
@@ -192,7 +192,7 @@ static int sprd_thm_temp_to_rawdata(int
 {
 	u32 val;
 
-	clamp(temp, (int)SPRD_THM_TEMP_LOW, (int)SPRD_THM_TEMP_HIGH);
+	temp = clamp(temp, SPRD_THM_TEMP_LOW, SPRD_THM_TEMP_HIGH);
 
 	/*
 	 * According to the thermal datasheet, the formula of converting


