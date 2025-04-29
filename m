Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE0B2472AC;
	Tue, 29 Apr 2025 16:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945690; cv=none; b=E+V8/uISWWgNDEWm9Q6I6QfOvtBma6xY/339d+aNDMtEE/q++QN1SLSBIIR9R1FfcFt5z2qJtTBuGstw9UJbze6nsJNxTlPnOF0OxdgDKC7TG0O91oTDdSbU6tGpx0tyVD518p+Ro7TIIecDIpXnQOYh0eGy8mpnPC8yN2aMEJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945690; c=relaxed/simple;
	bh=2dMC1oq8OHd5/G++PPu/j6RyX8WaaC4myU2tqPEn5BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2HsbjXOLyMeivIksYFsMVulGGu/J58qk69B67JtLIneSWtaovHBAu7iI0QLjhOcattsaMivtmSyBc1jlZPhwdWlBw2yi+rZo+jCCLW4qAuRXH3bc2/g1vFGyrpnGBKGKJYhT3aqfMMifLG5a6d9jAg9hQTDNe0kXtDMcoYAL/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2VvD6PE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2VvD6PE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62CCAC4CEE3;
	Tue, 29 Apr 2025 16:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945689;
	bh=2dMC1oq8OHd5/G++PPu/j6RyX8WaaC4myU2tqPEn5BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2VvD6PESy4eEzVEGPBEN+9wdFH93p2f8oCDwmja799a//iv7iJm1pJjbYeUcFvAb
	 Q/D09v1EYqo7IRvW3tAaBf9IPfb06jRg1UPI3TOY47u/vVZhPNnqYkRhJPK1epa/3P
	 yfJ+244HAnG80HA5vQyZbCJUPt24I9Ik2IaRf/ME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 017/311] of: resolver: Fix device node refcount leakage in of_resolve_phandles()
Date: Tue, 29 Apr 2025 18:37:34 +0200
Message-ID: <20250429161121.740425461@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit a46a0805635d07de50c2ac71588345323c13b2f9 ]

In of_resolve_phandles(), refcount of device node @local_fixups will be
increased if the for_each_child_of_node() exits early, but nowhere to
decrease the refcount, so cause refcount leakage for the node.

Fix by using __free() on @local_fixups.

Fixes: da56d04c806a ("of/resolver: Switch to new local fixups format.")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250209-of_irq_fix-v2-9-93e3a2659aa7@quicinc.com
[robh: Use __free() instead]
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/resolver.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/of/resolver.c b/drivers/of/resolver.c
index c871e35d49217..2caad365a665c 100644
--- a/drivers/of/resolver.c
+++ b/drivers/of/resolver.c
@@ -249,8 +249,9 @@ static int adjust_local_phandle_references(const struct device_node *local_fixup
  */
 int of_resolve_phandles(struct device_node *overlay)
 {
-	struct device_node *child, *local_fixups, *refnode;
+	struct device_node *child, *refnode;
 	struct device_node *overlay_fixups;
+	struct device_node __free(device_node) *local_fixups = NULL;
 	struct property *prop;
 	const char *refpath;
 	phandle phandle, phandle_delta;
-- 
2.39.5



