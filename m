Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1962701B6;
	Wed, 25 Feb 2026 01:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983851; cv=none; b=LeHhq4wnoxBk92NJEpQyJCbqQyq0OScGuU6o2XHNokB6GZhiTMxkaD/V5dyNvvJ8NEN+UWxtHkMEGlvPg7l3UUr67bT7oBFkHWuHhHOsPEEBipI2YqtdWCOKwQXVWK5rSoaw4AkOkLCGnp0GXnkzDsuh4uO/DXYpFZKdx28n4LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983851; c=relaxed/simple;
	bh=qHJqVhky52t+XM7TLBIJu3m2/kyzjRaYwysg0ZMkvms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jg4mUV5zlAIRKyU3DphYQvSueP/7fHPHkn0xiJzNNHZlX6z3yyStD3Wmn+fmjo7ADUKXxUOqf8uNWvp7B4ZL1s5+zccXRkXQf9HcCoeFfDsQY049+ZAUZoL/Kp98WF/XUlXG3Cmjr0q1YQqVqp78g3u2OrhnRfDmWmydtXTGQe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=feAPsL3t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="feAPsL3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BB8C116D0;
	Wed, 25 Feb 2026 01:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983851;
	bh=qHJqVhky52t+XM7TLBIJu3m2/kyzjRaYwysg0ZMkvms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=feAPsL3tpvBK2435E/gvaquCbUHEEebKeviC2OOxmTTryqPqGdS/nKc4kVrAbMQ4q
	 OsbsZ6isKPwLNOXIAcy3ikM2JOiiRP6RnzptDea8u5+rZxAXI47PtQnD2sCjE9VIPP
	 JXz7klP1iDUox09LHYduE4U0Mnwey8gePK3HqDwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 127/641] soc: qcom: smem: handle ENOMEM error during probe
Date: Tue, 24 Feb 2026 17:17:33 -0800
Message-ID: <20260225012352.227977643@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>

[ Upstream commit 0fe01a7955f4fef97e7cc6d14bfc5931c660402b ]

Fail the driver probe if the region can't be mapped

Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
Fixes: 20bb6c9de1b7 ("soc: qcom: smem: map only partitions used by local HOST")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251209074610.3751781-1-jorge.ramirez@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/smem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/smem.c b/drivers/soc/qcom/smem.c
index f1d1b5aa5e4db..39177aa5793ad 100644
--- a/drivers/soc/qcom/smem.c
+++ b/drivers/soc/qcom/smem.c
@@ -1215,7 +1215,9 @@ static int qcom_smem_probe(struct platform_device *pdev)
 		smem->item_count = qcom_smem_get_item_count(smem);
 		break;
 	case SMEM_GLOBAL_HEAP_VERSION:
-		qcom_smem_map_global(smem, size);
+		ret = qcom_smem_map_global(smem, size);
+		if (ret < 0)
+			return ret;
 		smem->item_count = SMEM_ITEM_COUNT;
 		break;
 	default:
-- 
2.51.0



