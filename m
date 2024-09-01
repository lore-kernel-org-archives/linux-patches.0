Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433E12A1B8;
	Sun,  1 Sep 2024 16:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209777; cv=none; b=n+DeKqTAipw569/DzCAYZN+Q+yaj19MAgThkrg2KJn34oU3Y8OokZUU9w9c29pb8UBS6e/MqNZEfZth1WSBO4IuXf6wARbh9bIXv7fCsePZiw5oknnZbCPjbCiV/QYncWGB2xFptRQ2Bc7MpU5Zg5jNpT6cemYwZUCtvsqnpK60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209777; c=relaxed/simple;
	bh=zkQwyQ+Pjs5ej5dnZuEeJqXsNfDmVUUQos1ZOTIphu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wf7g5CofR0RWQEZOgDhydhOlYK9PNBQ9MTGTYNBD9+ANXzN+9NqV6JhP7Zm668WAFroTZFZsEKa4fhToDudWuMghdNIcJ3kVesCnVXd0WeZI2CVb5YVc91hy8YyQJURec+J6XMTDFJXfg5MHgdeo7tNls3tf67iSJNICfwgcA9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ArTTthiI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ArTTthiI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F49EC4CEC3;
	Sun,  1 Sep 2024 16:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209776;
	bh=zkQwyQ+Pjs5ej5dnZuEeJqXsNfDmVUUQos1ZOTIphu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ArTTthiI4+udEZv8aX85qSe+/qLFDcHOcR83D5tdwDX55O3XZ7ku/COSenn7Q1zm2
	 K9hllDAxnKFvpIR8WA1AIYgCKv+jRxFKoPhyHJt/Nm823ElNjVUtbEom1bx3yeBjhn
	 7Bdm9fZKnUmRSVlej0M/kZA2/DFaIIiAaP8pEt+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Volodymyr Babchuk <volodymyr_babchuk@epam.com>,
	Maulik Shah <quic_mkshah@quicinc.com>,
	Pavankumar Kondeti <quic_pkondeti@quicinc.com>,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Nikita Travkin <nikita@trvn.ru>
Subject: [PATCH 5.10 142/151] soc: qcom: cmd-db: Map shared memory as WC, not WB
Date: Sun,  1 Sep 2024 18:18:22 +0200
Message-ID: <20240901160819.450918646@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

From: Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>

commit f9bb896eab221618927ae6a2f1d566567999839d upstream.

Linux does not write into cmd-db region. This region of memory is write
protected by XPU. XPU may sometime falsely detect clean cache eviction
as "write" into the write protected region leading to secure interrupt
which causes an endless loop somewhere in Trust Zone.

The only reason it is working right now is because Qualcomm Hypervisor
maps the same region as Non-Cacheable memory in Stage 2 translation
tables. The issue manifests if we want to use another hypervisor (like
Xen or KVM), which does not know anything about those specific mappings.

Changing the mapping of cmd-db memory from MEMREMAP_WB to MEMREMAP_WT/WC
removes dependency on correct mappings in Stage 2 tables. This patch
fixes the issue by updating the mapping to MEMREMAP_WC.

I tested this on SA8155P with Xen.

Fixes: 312416d9171a ("drivers: qcom: add command DB driver")
Cc: stable@vger.kernel.org # 5.4+
Signed-off-by: Volodymyr Babchuk <volodymyr_babchuk@epam.com>
Tested-by: Nikita Travkin <nikita@trvn.ru> # sc7180 WoA in EL2
Signed-off-by: Maulik Shah <quic_mkshah@quicinc.com>
Tested-by: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Reviewed-by: Caleb Connolly <caleb.connolly@linaro.org>
Link: https://lore.kernel.org/r/20240718-cmd_db_uncached-v2-1-f6cf53164c90@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/cmd-db.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/soc/qcom/cmd-db.c
+++ b/drivers/soc/qcom/cmd-db.c
@@ -319,7 +319,7 @@ static int cmd_db_dev_probe(struct platf
 		return -EINVAL;
 	}
 
-	cmd_db_header = memremap(rmem->base, rmem->size, MEMREMAP_WB);
+	cmd_db_header = memremap(rmem->base, rmem->size, MEMREMAP_WC);
 	if (!cmd_db_header) {
 		ret = -ENOMEM;
 		cmd_db_header = NULL;


