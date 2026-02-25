Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C393F242D9B;
	Wed, 25 Feb 2026 01:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982866; cv=none; b=gATV7LpW6/xUgZItIRsTtK4+ZEWCtUCb+o3xfb+mTGrnCyEkuzV1mv9J13FY0ybsRr5WmzTlYnI9bHDdnu9jJLdNwWJ4vQ7UWgvEPWVG4+U7yIT6UHiQjV+8egENNJ+pGarR1RS19TcJ33xhEaal/NKg7G3RW4I+9C2LSHynK30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982866; c=relaxed/simple;
	bh=PMZpEvpGQPnoQS1s7bygA8pM3MCtDH46qTEU6ftI0os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+NwjScRhMwCGcKZzPHzNNuTUikNed8jjBS6Hz3Cg+ZW4+DxGDgRkfi8bdDQ3j5gEPgtMnQFbbY/lA4JoCjLMVZY9h9yYAVvNjalnjxNAcWM56QHRTBb0AaAcmkUkMw9vmenXE2RkDlCqWgEQwudxqrMz4x/1wMwWt9XbbFZrlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KglFHibG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KglFHibG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87292C116D0;
	Wed, 25 Feb 2026 01:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982866;
	bh=PMZpEvpGQPnoQS1s7bygA8pM3MCtDH46qTEU6ftI0os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KglFHibGPZSy/4Qa6WBNtZErQ9S44jDy7WK3oi13o9uTnTDeoQowHJT2KJw19KK73
	 U1JHS0sa8D2twcsW0MkyGw8uDxIfi/K0htdNNLAP1nfSpudQMSqnGCEqDSRq6e2J2A
	 F9qNNci9Q8Yk1gX/Y+/Za+hkqOWIQM58hcVUg2Jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 053/781] thermal/of: Fix reference leak in thermal_of_cm_lookup()
Date: Tue, 24 Feb 2026 17:12:42 -0800
Message-ID: <20260225012401.003377616@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit a1fe789a96fe47733c133134fd264cb7ca832395 ]

In thermal_of_cm_lookup(), tr_np is obtained via of_parse_phandle(), but
never released.

Use the __free(device_node) cleanup attribute to automatically release
the node and fix the leak.

Fixes: 423de5b5bc5b ("thermal/of: Fix cdev lookup in thermal_of_should_bind()")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
[ rjw: Changelog edits ]
Link: https://patch.msgid.link/20260124-thermal_of-v1-1-54d3416948cf@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_of.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
index 1a51a4d240ff6..b6d0c92f5522b 100644
--- a/drivers/thermal/thermal_of.c
+++ b/drivers/thermal/thermal_of.c
@@ -280,10 +280,10 @@ static bool thermal_of_cm_lookup(struct device_node *cm_np,
 				 struct cooling_spec *c)
 {
 	for_each_child_of_node_scoped(cm_np, child) {
-		struct device_node *tr_np;
 		int count, i;
 
-		tr_np = of_parse_phandle(child, "trip", 0);
+		struct device_node *tr_np __free(device_node) =
+			of_parse_phandle(child, "trip", 0);
 		if (tr_np != trip->priv)
 			continue;
 
-- 
2.51.0



