Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF8B1D0416;
	Wed,  2 Oct 2024 13:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875229; cv=none; b=Ob2DfsYqDyJ9lAUGcIiNxf3pQAEisRCTjmbrk7UQ9xvfTwfs13zP+LW3/7dBXA+Sluq4GKNd04EhboSiKiz+pZoPJqM0z+OfSth5mYKUdCDJSJNC7meOpUJ6EYzjNT4HQHIwhWrooDH1Jl9tktPpEKa2db25P4Mg/0D4vc/i5pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875229; c=relaxed/simple;
	bh=KWeNqRXNCoeB3QpaB4LS/uCBHJUU7SKivjKlyB4L6uU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JlnDkzhYg+pO25RPj1kl2ztqPnJs6B8W0UQVbkbuZvLucn/0QOcjYJK5qFmet22VrGYcPw+pNs0iU4a000UEkfOzkJnrrLy0aU7l47kCNO9Pl3wVzwwWdOLRuUYaVMb6tusnQgvyQw7UzbkllirUzD5v4UkFbY5CoHUlmBoo80s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOfSTOlV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOfSTOlV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74BEC4CEC5;
	Wed,  2 Oct 2024 13:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875229;
	bh=KWeNqRXNCoeB3QpaB4LS/uCBHJUU7SKivjKlyB4L6uU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOfSTOlVPaXyjGyLX/wVUsB8oCoxtXeV2Pia6jdRSJqcPtgVRQR9tonC9/rGx1jd/
	 3AsqnftIC2vCYPSTqah/pKdWjxdEQ+e42TCwQBd18K1rlDl2PlfjpiROmPp9JwGPa1
	 rVF0xRVnNXoM4nlGSVSR84oWS/M61Ed2fxK8khB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Zhang Rui <rui.zhang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 034/695] powercap: intel_rapl: Fix off by one in get_rpi()
Date: Wed,  2 Oct 2024 14:50:32 +0200
Message-ID: <20241002125823.853221040@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 95f6580352a7225e619551febb83595bcb77ab17 ]

The rp->priv->rpi array is either rpi_msr or rpi_tpmi which have
NR_RAPL_PRIMITIVES number of elements.  Thus the > needs to be >=
to prevent an off by one access.

Fixes: 98ff639a7289 ("powercap: intel_rapl: Support per Interface primitive information")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Zhang Rui <rui.zhang@intel.com>
Link: https://patch.msgid.link/86e3a059-504d-4795-a5ea-4a653f3b41f8@stanley.mountain
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/intel_rapl_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/powercap/intel_rapl_common.c b/drivers/powercap/intel_rapl_common.c
index 7c0cea2c828d9..b6f682dac42e7 100644
--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -740,7 +740,7 @@ static struct rapl_primitive_info *get_rpi(struct rapl_package *rp, int prim)
 {
 	struct rapl_primitive_info *rpi = rp->priv->rpi;
 
-	if (prim < 0 || prim > NR_RAPL_PRIMITIVES || !rpi)
+	if (prim < 0 || prim >= NR_RAPL_PRIMITIVES || !rpi)
 		return NULL;
 
 	return &rpi[prim];
-- 
2.43.0



