Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A7C383983;
	Thu, 30 Jul 2026 15:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426940; cv=none; b=VLkFnj4fe3TKF28VJB0ay0e2xYu4W7kt47ijkPpKqXS8rBD8C2Exr/jpXlFCTCtf0AmerJsfGyzhmF4eNPZtS/lWQ60YBrKX8t15na9fs4JM8D1EWVbeJWfdyT0ylq2yYzmz4OQ8WGKXn8G7csawT9evOBQlBq/nQV6Xua4XgRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426940; c=relaxed/simple;
	bh=A7L+33T4ILGoQifpqSUgmk4P3TaFNk86/DigRj3FV/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WbvDM73sUCEqogqpf6bZprKdtUPuqWds0LGfzmVQXUNO3LRj6eNWa9uXGIMfv+XCY6VCq29ebLp66EEL0WoBpA0c00ynk+4DrKizbTa7kWVzZfIrk4a3LMNJ1tSyIY5fmxyPXGyxlux0/tViNms31tnS9voGYNAQmPAzO/ISe3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+VAm80R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+VAm80R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A984D1F000E9;
	Thu, 30 Jul 2026 15:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426939;
	bh=DvT+W9BIj8z+5cPUTOtw2r+2R4579AJMvkMqb67CLxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t+VAm80RvY8Poh4hXi2NLVs7ZWldjoFqeInO28i13hrRF7JTgEpd+LIRtvJZ/EBDi
	 Unj7vTRVNaI0d6b/AyVrPRF22+K4lpYOOXPhJ1fJpJsePvkAIN29r8DESoiYB6k5TB
	 cMxZaSWjs5oaSieGX3VlPxCTODM/x4NT7Ok1zZ1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 594/602] dpll: fix clock quality level reporting
Date: Thu, 30 Jul 2026 16:16:26 +0200
Message-ID: <20260730141448.535875473@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

commit 70d99623d5c11e1a9bcc564b8fbad6fa916913d8 upstream.

The DPLL_CLOCK_QUALITY_LEVEL_ITU_OPT1_EPRC is not reported via netlink
due to bug in dpll_msg_add_clock_quality_level(). The usage of
DPLL_CLOCK_QUALITY_LEVEL_MAX for both DECLARE_BITMAP() and
for_each_set_bit() is not correct because these macros requires bitmap
size and not the highest valid bit in the bitmap.

Use correct bitmap size to fix this issue.

Fixes: a1afb959add1 ("dpll: add clock quality level attribute and op")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Link: https://patch.msgid.link/20250912093331.862333-1-ivecera@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dpll/dpll_netlink.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/dpll/dpll_netlink.c
+++ b/drivers/dpll/dpll_netlink.c
@@ -191,8 +191,8 @@ static int
 dpll_msg_add_clock_quality_level(struct sk_buff *msg, struct dpll_device *dpll,
 				 struct netlink_ext_ack *extack)
 {
+	DECLARE_BITMAP(qls, DPLL_CLOCK_QUALITY_LEVEL_MAX + 1) = { 0 };
 	const struct dpll_device_ops *ops = dpll_device_ops(dpll);
-	DECLARE_BITMAP(qls, DPLL_CLOCK_QUALITY_LEVEL_MAX) = { 0 };
 	enum dpll_clock_quality_level ql;
 	int ret;
 
@@ -201,7 +201,7 @@ dpll_msg_add_clock_quality_level(struct
 	ret = ops->clock_quality_level_get(dpll, dpll_priv(dpll), qls, extack);
 	if (ret)
 		return ret;
-	for_each_set_bit(ql, qls, DPLL_CLOCK_QUALITY_LEVEL_MAX)
+	for_each_set_bit(ql, qls, DPLL_CLOCK_QUALITY_LEVEL_MAX + 1)
 		if (nla_put_u32(msg, DPLL_A_CLOCK_QUALITY_LEVEL, ql))
 			return -EMSGSIZE;
 


