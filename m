Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18541F759C;
	Tue,  3 Dec 2024 15:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239215; cv=none; b=uCBfZDe/rZoHIIz7eGYb2ap/lcYXcfqvwg1K8aB1t0tJubt6Gwtg+ZsHEWeyV+tdjy9KCqwAtwws7CIT5NrwnftyC5727YDUwGsxmIfpXig+c8SkqICKl3UuOU5WyRR9/fetMgeSscFLaPRwRRYw30yPKSugRpkbL42ZaSMTwro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239215; c=relaxed/simple;
	bh=xH7IvMOzHJWSvSIZuShZieSrvJQEvza0anuamhC8dZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2G5p4tgfn2Nz2UP7ks8FhV3zJQotOvelY1V6QuKrIWOhss6uhrRlIoMHHsP74jFZ49WA34JnbDc7lxekLAPpzG4iCXWShuR6orskewk+I8XZyqdJCbFaKtPSUeHxFoT5XMBpmH1JX4ZxhLyGMTpFAcrAeFUQlH/M/ArhimAA4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8/RNEVy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8/RNEVy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A97C4CECF;
	Tue,  3 Dec 2024 15:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239214;
	bh=xH7IvMOzHJWSvSIZuShZieSrvJQEvza0anuamhC8dZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z8/RNEVy65bRv1VVbSCQPhyjbZAJ3DSt6HxPF193vHiS11SAdI691kNPSSFfmctWY
	 avmbrsosXYjNcS2AuS6pF5Ulo3RHtq7MeHmIp6eJfG0w8GkkGasWSls4R6VzqUMp9H
	 BJPebpihEgXw92ZJHTHTw/hoaVFW44mM409TipvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 537/817] rpmsg: glink: use only lower 16-bits of param2 for CMD_OPEN name length
Date: Tue,  3 Dec 2024 15:41:49 +0100
Message-ID: <20241203144016.862432492@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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
index d877a1a1aeb4b..c7f91a82e634f 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1117,7 +1117,8 @@ void qcom_glink_native_rx(struct qcom_glink *glink)
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



