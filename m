Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE3D254B1F;
	Thu, 28 May 2026 20:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999949; cv=none; b=kB5trrOZO4uR2EtVxJOw6gWUonci09Cbk4KxGyvizymY4xu/v/FaTjeGPH3/OtTiIT4Twg9E5tD/jIVfYqBzirv/cRyw94zeo4+bwnHGs1jBWpvGe25OzwjX+fXw09w/O6aqrXTggL2uKzU3rrpti+DC+p4LxKROI5pl0g1kzxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999949; c=relaxed/simple;
	bh=qa3tyGT31UgcuszDjWliat8w9rZ4nB0W/yzglsq3buw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ci0QSB6LQWwjuwvY7vSbvZLpKcMbc5KQWBVp0ifJdgL47GKfeuTWIAIeT4gr8ESpL5gecu4k+4S8JVGf8npokFSccxL9gtqCSBkhG+QqHdo1KsNsJPunQt6KPtedkjpSCmzeKm7t1nPCIB4zUEdqd0CNiRzqP+sm+0O9+fVH5NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0oW4WsVK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0oW4WsVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CFF01F000E9;
	Thu, 28 May 2026 20:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999947;
	bh=Y94UQT5006FhmnHXd+eaqhPKdJ0zWVvtdQa2t0Lt2a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0oW4WsVKGKQrvPEMhfv5cnBSu5G1pVFHuOOJPYokPCjiRgA41hwWvBOHPLnE+4lhi
	 cgAIWsmCp5m7dFxTTNBXMjF22cWqrHKgYjev53B37x/Sc8Lr91xkGlL+Az4IYlDZNP
	 T3CZzDSmca8AtgVBwJ+blR2sQ4bx6eE60F4cr3PE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ally Heev <allyheev@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 231/377] powerpc: 82xx: fix uninitialized pointers with free attribute
Date: Thu, 28 May 2026 21:47:49 +0200
Message-ID: <20260528194645.079075696@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Ally Heev <allyheev@gmail.com>

[ Upstream commit acd1e47db03d4b528fd5efb8565dd0de1c79f62a ]

Uninitialized pointers with `__free` attribute can cause undefined
behavior as the memory allocated to the pointer is freed automatically
when the pointer goes out of scope.

powerpc/km82xx doesn't have any bugs related to this as of now, but,
it is better to initialize and assign pointers with `__free` attribute
in one statement to ensure proper scope-based cleanup

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/aPiG_F5EBQUjZqsl@stanley.mountain/
Signed-off-by: Ally Heev <allyheev@gmail.com>
Fixes: 4aa5cc1e0012 ("powerpc-km82xx.c: replace of_node_put() with __free")
Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20251116-aheev-uninitialized-free-attr-km82xx-v2-1-4307e2b5300d@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/82xx/km82xx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/82xx/km82xx.c b/arch/powerpc/platforms/82xx/km82xx.c
index 99f0f0f418767..4ad223525e893 100644
--- a/arch/powerpc/platforms/82xx/km82xx.c
+++ b/arch/powerpc/platforms/82xx/km82xx.c
@@ -27,8 +27,8 @@
 
 static void __init km82xx_pic_init(void)
 {
-	struct device_node *np __free(device_node);
-	np = of_find_compatible_node(NULL, NULL, "fsl,pq2-pic");
+	struct device_node *np __free(device_node) = of_find_compatible_node(NULL,
+		NULL, "fsl,pq2-pic");
 
 	if (!np) {
 		pr_err("PIC init: can not find cpm-pic node\n");
-- 
2.53.0



