Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B672F260C;
	Thu, 28 May 2026 20:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998644; cv=none; b=rpypB70AeucxW7xzlEnzAE/0J5pPHmiXx2dSTkKazKes4gC1ZPGa6LjcFS0uE/sqAag9zU3UTnNGjOr274qd2lmFRnUL+XsAOpg3U3k9hNvwkp2DahPV2C7lvAXnQHzGBxbqhH5Hogrwbh6OOyvErluhJWQghmJTy0jf1Rh9XcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998644; c=relaxed/simple;
	bh=MWNI4FFWIKP9T+VVMv19L5Iol7BS/5I75NsXTd5P7aA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FAUpekX8Ujy/X5D2vSpWoJUfxjwaNzR69dRop+DaAH+QAVP+O1qtsFvsgS0ii17jtC1RHsYK2atF6XoyEXxcc7TK3geg0Ps0IUN9IBFN895Bb0BC3lwyPJUQCMuiXErZ/LfqDlmQm9JjZoEMKOHUAQKVdziG812H5TGMs7uForQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WaI2CmKA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WaI2CmKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814D41F000E9;
	Thu, 28 May 2026 20:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998643;
	bh=1F1fKUPI7uWaVxzM7ujjsR6X7Jm1lDd+/0V/DZEDYU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WaI2CmKAqkTzFpNPta0A4g4u8C2YFMgRDVAof/c09+ah+PV2jjEHEiRrH108Vb5Wf
	 +ypaTjrArm3f4fAnmRxQU+xgsCXhXpeXGav4TPypSce2zi1KI3OsacCNCxteS0UbLu
	 Y2rW/NBG4I1m/VhQH4x+IA/tOvWImXyQO0ooPSvI=
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
Subject: [PATCH 7.0 247/461] powerpc: 82xx: fix uninitialized pointers with free attribute
Date: Thu, 28 May 2026 21:46:16 +0200
Message-ID: <20260528194654.298114860@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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



