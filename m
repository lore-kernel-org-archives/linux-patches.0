Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD9E1D0438;
	Wed,  2 Oct 2024 13:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877271; cv=none; b=YP3k7z6ug9V87vNvxXG2142z1tXBHA2z94Oq17g2rfHy1Q3kj2MxH+DnfktN7oRaG9FxSOVtRztbrwjvAtAih49wOLDrR8eKXXWoOZ/kVjts4K+ItYQFcbfKpGcz/KxN7WKtTdGmLu81Qog/1UtTmZ+cmEcEIPBIdjcCfbFiWCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877271; c=relaxed/simple;
	bh=vnrV2xqSLbp0WS0vp6t813dUThk50vwcn7D5N8X3Sdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ts+Fs/fnLrGQ0YMgrQ8vEZc6M7OOiJvLKKwN2p9Y07qeqdeTqhXyrkPozKodHguslTziMjpAxiRA/IWsePgpYMQCVElEZyWeTBruIllUB5/FxV85BjA64J4GxPrZPOC69s/AuM1SE6dPChkYIjikjwhsKHQqPiqj+5G0Lp+Q88M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lX3DO6j8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lX3DO6j8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3EECC4CEFE;
	Wed,  2 Oct 2024 13:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877271;
	bh=vnrV2xqSLbp0WS0vp6t813dUThk50vwcn7D5N8X3Sdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lX3DO6j8mLd4MfDBi+bgJmAfpeShLxohGqe0ppqG6LLoUE+HOFkh2yVpZ8CjVdqiI
	 IPWty8yCgy5dw5+pv5CpVbaeB+L5Nti/NRb7QIiDMPwZVmnNLATT4IP5QpdUKtUqyH
	 67irsdoXgeSBuqZ2de5zejJUliYsgDdvKjIJsXlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Zhang Rui <rui.zhang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 026/634] powercap: intel_rapl: Fix off by one in get_rpi()
Date: Wed,  2 Oct 2024 14:52:06 +0200
Message-ID: <20241002125812.128871436@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8e7f4c0473ab9..9bf9ed9a6a54f 100644
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



