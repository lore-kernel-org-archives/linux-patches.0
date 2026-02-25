Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7DF21D596;
	Wed, 25 Feb 2026 01:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982965; cv=none; b=J9/xBtUNq3bKGEUpdueoQqFYnzZpi1hGeeyYi5OKdbKGnTeD6c9CJj6b0yQoFSQeEb8RdHGmrNYPv429Ax3CkwjJ7yb2vY6cojm3CxvVLsCniUlcyc/4vBsK0I05dKZQ4qjFQhtumSk4ZwV7k4uB98bhCwMw5APNruhJrIcmMbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982965; c=relaxed/simple;
	bh=WSbXUZv4n0WU+5slDiR1aps6G8S47g2J6DJMj/reuNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3LgwlPWmdhbVyZPIPK05jhX1w4TCWK0PF4IpBiFChD4JTyGjx27h4vo5GkP6rjdFNvw9qB0hYSy91IXyYUVTHghUSb1FGfBNEwyh5iJ0F4c/CnstvvISxNUtZggDDhT8+B6C3JdvteaOWnCJvte1UinYxxrzYCkeRl6Rd8tNf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RU6gdTWy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RU6gdTWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3FAC116D0;
	Wed, 25 Feb 2026 01:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982965;
	bh=WSbXUZv4n0WU+5slDiR1aps6G8S47g2J6DJMj/reuNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RU6gdTWyGtUzOO/J/uuirAiY9ky+5vhvMgHxFYG0wOAO14gsVH1MmUAaYXLVT83wS
	 7RFhSMvAdsyw/jnPGqmEBa3tFyZRgMNBYTIaFN4gc2dCtte6RO3h6f7DRiQyqrXlyR
	 KJM3dn8H4PzjhcZayacVZ0q39YkI5DfxXwbeAhaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 141/781] soc: qcom: smem: handle ENOMEM error during probe
Date: Tue, 24 Feb 2026 17:14:10 -0800
Message-ID: <20260225012403.126598835@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index c18a0c946f762..d5c94b47f431f 100644
--- a/drivers/soc/qcom/smem.c
+++ b/drivers/soc/qcom/smem.c
@@ -1219,7 +1219,9 @@ static int qcom_smem_probe(struct platform_device *pdev)
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



