Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5628F1DFE10;
	Wed,  6 Nov 2024 13:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899047; cv=none; b=XSKSWOmwNEo/YIxHoNL/S2T9Nlyo+vSTujazBLNSfZGOGvxIPQzahMTGWtjoHPI8kcRgGxDdI4kw+MSGnzlpoZmKIXFkQd24++6CEFEgXceQ6w7CLJC3wBwMZsKA/ttuKGtN9ibk02sB7Grh/2x0jmH+dFPMsHKG+WxExZxgK1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899047; c=relaxed/simple;
	bh=AHyamoGx3f8ih55HiyiAYD+ENVevOpxYD4bO5JnP01k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AuLf56nhYfDhtmTaXtdg7cbOjJP8c0Tbrram6zJiEDDsX7HwI7WjsepFS3zvFm5dzRyeW3aFwo/uxM9eZlRyayaIzGzTvMLcJEHQ4H0PPfao5WNcswoGvbawGHYfO8KtQb60avuMLLmoBr51r1a9DwUbEZ0nNiidUlv5rpmCDpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2d+VFiA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2d+VFiA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4145C4CED3;
	Wed,  6 Nov 2024 13:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899047;
	bh=AHyamoGx3f8ih55HiyiAYD+ENVevOpxYD4bO5JnP01k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W2d+VFiANMW6W9p5GsMw/VvaZ2h3B9otmXK0dVttEdF/EfZ4NP5aCQoXofO9kGDLD
	 LaNt36YXH6SZd+OwhMvM8qzMC6E4rVbyQ0SQ4aLOKylYFZ04YA1fG7q3FGWgoypkGR
	 NJqTy3PDvD/NKx71PXbMAxTB0myzLzvNIhNlu+1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 443/462] firmware: arm_sdei: Fix the input parameter of cpuhp_remove_state()
Date: Wed,  6 Nov 2024 13:05:36 +0100
Message-ID: <20241106120342.444855923@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit c83212d79be2c9886d3e6039759ecd388fd5fed1 ]

In sdei_device_freeze(), the input parameter of cpuhp_remove_state() is
passed as 'sdei_entry_point' by mistake. Change it to 'sdei_hp_state'.

Fixes: d2c48b2387eb ("firmware: arm_sdei: Fix sleep from invalid context BUG")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Reviewed-by: James Morse <james.morse@arm.com>
Link: https://lore.kernel.org/r/20241016084740.183353-1-wangxiongfeng2@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_sdei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
index b0e8752174c6f..f6627ccbc2d81 100644
--- a/drivers/firmware/arm_sdei.c
+++ b/drivers/firmware/arm_sdei.c
@@ -802,7 +802,7 @@ static int sdei_device_freeze(struct device *dev)
 	int err;
 
 	/* unregister private events */
-	cpuhp_remove_state(sdei_entry_point);
+	cpuhp_remove_state(sdei_hp_state);
 
 	err = sdei_unregister_shared();
 	if (err)
-- 
2.43.0



