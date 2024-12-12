Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25663215762;
	Thu, 12 Dec 2024 17:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024172; cv=none; b=nJJ7l0q+TjaAYQtK450GN/TyJtRz723W6xqiPMhFMNJvZNFq6ssG1BUAmCFql8nZPBfjClyH9Y86iaNTGJZ6KE67PN7B4SAAJ2qOfA7HswUWHrVmYtTrqwg4bhwN0AH2oTQ1fzikv34K9Dx3AMLwWkROjHtGTiJa7P5fIKCehrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024172; c=relaxed/simple;
	bh=H1g5H4lbPzjxEuacGveUs/DoHEZTehPOBRIZinFSwHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkTHhDtzsxOJ9doQAaT8KYKNa05MJtHn5/u3guXVlF6oEBHOCbyIUWSdFW2/Ja5e1eWoZlOO1z+WCAZBRtSWYUJwHn7IskdN4qsKZVsNKIZXW4W/kMVvDP7GrMBy3DyGC3MpanCXSu7TbUUYjrAPOf7A+1xZzmuyjFTDLaq0AlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bteCfoel; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bteCfoel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7CB1C4CED0;
	Thu, 12 Dec 2024 17:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024172;
	bh=H1g5H4lbPzjxEuacGveUs/DoHEZTehPOBRIZinFSwHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bteCfoelR26+inK0+VIZwcamCWd6XDPh71tX41SdFS80LU9tIPYWKqxw0pM1VVI3E
	 FpH4wkfdVcY9Yh23zlhq9im8Lr0CNkZcsYEp+iueaalRs/0U/KdlSZHS+kA6DHBy+l
	 Pt9krmFyPyK7T/7FVoZwK3vf25CK38JiQpWQz0DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 209/459] rpmsg: glink: use only lower 16-bits of param2 for CMD_OPEN name length
Date: Thu, 12 Dec 2024 15:59:07 +0100
Message-ID: <20241212144301.825765375@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit 06c59d97f63c1b8af521fa5aef8a716fb988b285 ]

The name len field of the CMD_OPEN packet is only 16-bits and the upper
16-bits of "param2" are a different "prio" field, which can be nonzero in
certain situations, and CMD_OPEN packets can be unexpectedly dropped
because of this.

Fix this by masking out the upper 16 bits of param2.

Fixes: b4f8e52b89f6 ("rpmsg: Introduce Qualcomm RPM glink driver")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241007235935.6216-1-jonathan@marek.ca
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/qcom_glink_native.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/rpmsg/qcom_glink_native.c b/drivers/rpmsg/qcom_glink_native.c
index 831a5d1cd4806..82670cb063f5a 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1045,7 +1045,8 @@ static irqreturn_t qcom_glink_native_intr(int irq, void *data)
 			qcom_glink_rx_advance(glink, ALIGN(sizeof(msg), 8));
 			break;
 		case GLINK_CMD_OPEN:
-			ret = qcom_glink_rx_defer(glink, param2);
+			/* upper 16 bits of param2 are the "prio" field */
+			ret = qcom_glink_rx_defer(glink, param2 & 0xffff);
 			break;
 		case GLINK_CMD_TX_DATA:
 		case GLINK_CMD_TX_DATA_CONT:
-- 
2.43.0



