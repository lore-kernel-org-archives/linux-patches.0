Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6271039B48E;
	Thu, 15 Jan 2026 17:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497676; cv=none; b=uIsqEVDe9dfnNEd3Fp6VyOYxvohmK7z4Lti4GKrezY5t5aFje6p3hpWWY1vq6Z4DS3mjIcmLOlLmBQjurErtimKTO0GDVdwURSbanaRTGQ/00609cb2qY5vIme1x8adFxZjlxOjM0jfhyWc7JSHCN38vHD1V8/7RMvk8TB3fM+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497676; c=relaxed/simple;
	bh=3JK/igJJkk9zatdIw0kLohzosTwuPJLD9fG+nAkCQP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHyTYiO+R/g2RDkALIJADZxUXQ6WOq9d0U/cBntLCGvP0dhAKclPatVfjavg94KCfdBflE+iDXnPMb31poFeMR0rPdOo8gvS11sq60Avp+XkuJQiDGcb41pyW1a6LqbrHnAmtsd8/kGiyyyGsaT/uSy/XAM+LPtOi5Sb7VKnQkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rNxeWbOV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rNxeWbOV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F5CC116D0;
	Thu, 15 Jan 2026 17:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497676;
	bh=3JK/igJJkk9zatdIw0kLohzosTwuPJLD9fG+nAkCQP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rNxeWbOVhrkUkfuoNqsijk+uHzH0vA+boMVW0BCYTOUn0X7vRa8eHWU3OShqs3mBY
	 iFmWYPGta6UBxYnWXQaVRGXkIqzxSG1olqsguqKbTDGQS1cJh2DRfDMdvkmY4Ssqma
	 UzYPPbITeCsBf+zJtDx/x4IMoaM65RIWUSYftr6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandru Gagniuc <mr.nuke.me@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 163/554] remoteproc: qcom_q6v5_wcss: fix parsing of qcom,halt-regs
Date: Thu, 15 Jan 2026 17:43:49 +0100
Message-ID: <20260115164252.168415477@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandru Gagniuc <mr.nuke.me@gmail.com>

[ Upstream commit 7e81fa8d809ed1e67ae9ecd52d20a20c2c65d877 ]

The "qcom,halt-regs" consists of a phandle reference followed by the
three offsets within syscon for halt registers. Thus, we need to
request 4 integers from of_property_read_variable_u32_array(), with
the halt_reg ofsets at indexes 1, 2, and 3. Offset 0 is the phandle.

With MAX_HALT_REG at 3, of_property_read_variable_u32_array() returns
-EOVERFLOW, causing .probe() to fail.

Increase MAX_HALT_REG to 4, and update the indexes accordingly.

Fixes: 0af65b9b915e ("remoteproc: qcom: wcss: Add non pas wcss Q6 support for QCS404")
Signed-off-by: Alexandru Gagniuc <mr.nuke.me@gmail.com>
Link: https://lore.kernel.org/r/20251129013207.3981517-1-mr.nuke.me@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_wcss.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/remoteproc/qcom_q6v5_wcss.c b/drivers/remoteproc/qcom_q6v5_wcss.c
index cfd34ffcbb121..d900ef12ada43 100644
--- a/drivers/remoteproc/qcom_q6v5_wcss.c
+++ b/drivers/remoteproc/qcom_q6v5_wcss.c
@@ -85,7 +85,7 @@
 #define TCSR_WCSS_CLK_MASK	0x1F
 #define TCSR_WCSS_CLK_ENABLE	0x14
 
-#define MAX_HALT_REG		3
+#define MAX_HALT_REG		4
 enum {
 	WCSS_IPQ8074,
 	WCSS_QCS404,
@@ -864,9 +864,9 @@ static int q6v5_wcss_init_mmio(struct q6v5_wcss *wcss,
 		return -EINVAL;
 	}
 
-	wcss->halt_q6 = halt_reg[0];
-	wcss->halt_wcss = halt_reg[1];
-	wcss->halt_nc = halt_reg[2];
+	wcss->halt_q6 = halt_reg[1];
+	wcss->halt_wcss = halt_reg[2];
+	wcss->halt_nc = halt_reg[3];
 
 	return 0;
 }
-- 
2.51.0



