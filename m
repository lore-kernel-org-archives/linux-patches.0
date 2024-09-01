Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D152184544;
	Sun,  1 Sep 2024 16:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209108; cv=none; b=n086am+p0NMRO+togNH7panpI62Q76DzqADUUFrSoav/9ZqRvUMnA4uT4OtYS/TjvZVoQZm3+EyMGts8vwpa+1u42EMCvIllirv8fBnJ9r9VuBemrNgIufclCCwCraK55E6w0Eyzcin/FiTioWuPrn/038/eMTS+VQ11tga2FFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209108; c=relaxed/simple;
	bh=pDv6GNgY/pKr50dwUjctJR0rsHAntyH9HTeFbH78ioY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UqXKtSqenBoDTZVyFXORwiSx8w1AoXrHMFrGncGLbhJQDCt5fYRJZXxzsNv+tJh6PQmO/Lsumg1aiWDyxPh86xQiuLW26+JwyNE0p9Wj5lPzd6ETVQZuIGVDAeG5F+ffnjtMzNa2Z8arz5plGb5si2sabUzLBHNbCa03IJpnOqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ItV7Wd9j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ItV7Wd9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46C5C4CEC3;
	Sun,  1 Sep 2024 16:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209108;
	bh=pDv6GNgY/pKr50dwUjctJR0rsHAntyH9HTeFbH78ioY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ItV7Wd9jCKNL/lmpEZNZcbHcI2aiMDkwFYsZveVpjF9UckqoBWYILgcDIy8T+mymk
	 +e4XsipZhrWnWyMoq7v0Ql83Vfmo4r2+eUlUkTckin2tA/nBwbMDeosEJSRIpeomvD
	 U1U3xiwxdug4IEh+Xg++nTUwFFT8VIbyX6qZDxMk=
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
Subject: [PATCH 5.4 125/134] soc: qcom: cmd-db: Map shared memory as WC, not WB
Date: Sun,  1 Sep 2024 18:17:51 +0200
Message-ID: <20240901160814.783551240@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -247,7 +247,7 @@ static int cmd_db_dev_probe(struct platf
 		return -EINVAL;
 	}
 
-	cmd_db_header = memremap(rmem->base, rmem->size, MEMREMAP_WB);
+	cmd_db_header = memremap(rmem->base, rmem->size, MEMREMAP_WC);
 	if (!cmd_db_header) {
 		ret = -ENOMEM;
 		cmd_db_header = NULL;


