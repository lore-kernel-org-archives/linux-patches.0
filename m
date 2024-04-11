Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE4C140E3D;
	Thu, 11 Apr 2024 10:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831114; cv=none; b=JWYM/qbfD5cEQL7mgZDb0i/L7Re3/2AnJLhuD422ciFHPEuYNsLEjbLOgbfJFfqwq0MOQUXadKtle5po20NFu/m7AkorOIaTMQ03IL73+KE/FtF2w4fUMNGox/lrwVm/06tgPJxV8Xyjntzh2Rvniwx06a9v9NE2f+s4lGYfem0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831114; c=relaxed/simple;
	bh=6Sci30jRnojMuyc9cbU3YYEq6qCsP7xfCrUVSZeG9sY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9HPik5mow6vFfLKxZ9XOTmtCoioxGHZAsXKvYOI/hXGuIvHRErqjJS1crPgK/3xFom26xwqmmY6QFETiCSVTXi4JVHUGCUourOzoWkwa2fpTBEiX1k43/5oXiqrXm1mH37b4Unsv0NfJSueiSsxbNA/3t9pqz2Hq8fEsmTDRFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FKPaJYdq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FKPaJYdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8A6C433F1;
	Thu, 11 Apr 2024 10:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831114;
	bh=6Sci30jRnojMuyc9cbU3YYEq6qCsP7xfCrUVSZeG9sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FKPaJYdqjuUX5+CAnOFT7+tdIBI33gD9vdBL0HiAa8YFfxJj3Zv8YiIyVqtRAO5+h
	 MTOxbSo3EYyiOfKEEjzXw5Bulh+k/hoGOlW9INXrPPw3F/JBRB7AIc8oTOhC/wTg0x
	 JvSwt5dPzuZlwhfod7FYw2fQJSPluXEIT/7IXarY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	C Cheng <C.Cheng@mediatek.com>,
	Bo Ye <bo.ye@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/114] cpuidle: Avoid potential overflow in integer multiplication
Date: Thu, 11 Apr 2024 11:55:40 +0200
Message-ID: <20240411095417.267851129@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: C Cheng <C.Cheng@mediatek.com>

[ Upstream commit 88390dd788db485912ee7f9a8d3d56fc5265d52f ]

In detail:

In C language, when you perform a multiplication operation, if
both operands are of int type, the multiplication operation is
performed on the int type, and then the result is converted to
the target type. This means that if the product of int type
multiplication exceeds the range that int type can represent,
an overflow will occur even if you store the result in a
variable of int64_t type.

For a multiplication of two int values, it is better to use
mul_u32_u32() rather than s->exit_latency_ns = s->exit_latency *
NSEC_PER_USEC to avoid potential overflow happenning.

Signed-off-by: C Cheng <C.Cheng@mediatek.com>
Signed-off-by: Bo Ye <bo.ye@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
[ rjw: New subject ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/driver.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index d9cda7f6ccb98..cf5873cc45dc8 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -16,6 +16,7 @@
 #include <linux/cpumask.h>
 #include <linux/tick.h>
 #include <linux/cpu.h>
+#include <linux/math64.h>
 
 #include "cpuidle.h"
 
@@ -187,7 +188,7 @@ static void __cpuidle_driver_init(struct cpuidle_driver *drv)
 			s->target_residency = div_u64(s->target_residency_ns, NSEC_PER_USEC);
 
 		if (s->exit_latency > 0)
-			s->exit_latency_ns = s->exit_latency * NSEC_PER_USEC;
+			s->exit_latency_ns = mul_u32_u32(s->exit_latency, NSEC_PER_USEC);
 		else if (s->exit_latency_ns < 0)
 			s->exit_latency_ns =  0;
 		else
-- 
2.43.0



