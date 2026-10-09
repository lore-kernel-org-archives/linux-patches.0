Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98ECBBA45;
	Fri,  9 Oct 2026 14:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556286; cv=none; b=Ikp/JljtOjeVV4p3UtyY5/NtfYXfDnS3pjHuyxXKchYgrnOAfqBH0f8spOwW7H1/jIA5P97UJoqOA/QMn4Dy08COcvBcHluR4kmme0QY5PoJ25z49cw9ObrAcS5IeF/n+5iFP+eKltsjRJISm1kJFCBHYTFFNsir1f5vJ4hXjLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556286; c=relaxed/simple;
	bh=RtHakaLqkxT1edratJ2Tc+6KLgrlGkWKcJ/5+LSSIEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rf1+6bVZmcj5PyT/8k4wVCLdrQ9Yl2etcW5NNSgWpJHJUewBDjLp9PWwQdyCpXYLcho4WOG84hT2Kj6/q0Uh1e8CFWsSUi4VUcWPJIhhfpbVmGHPI8uQmkoHyeXSonbSoAUKqwJBTfmax2STIIH4IqW0BjYrlEqAZbPK/kVMSDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sfoK55ux; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sfoK55ux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D3F1F000FF;
	Fri,  9 Oct 2026 14:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556285;
	bh=4zEzWDN0Q9uk1UEL4cPzGPWBK/gPczmVz3s+KRRFDVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sfoK55uxGCyHQRsm+3ojyj85srM/o5/v87V2CJ3T6pbgbPm7cdeIaL8wiQdV5/+zT
	 65OH5OgoSr8U6VTjjQ16IAdaunwHpBdAZcxuQnvS7tF+B1S7c0APUyh9kDjbhm/bc8
	 3S4dc9+g0zY3OA2HDdiQ8pm8j2DVT2bJhgq5akaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 152/428] of: Put coreboot node after compatibility check
Date: Fri,  9 Oct 2026 16:08:09 +0200
Message-ID: <20261009140949.507405974@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <oss.patchbox@gmail.com>

[ Upstream commit 77f21a59e8cf7efcc1c4b3e9176e8b99993a7ae4 ]

of_find_compatible_node() returns a referenced device node, but
EXCLUDED_DEFAULT_CELLS_PLATFORMS used the result only as a boolean and
discarded the reference. This leaked a reference each time the
address-cells or size-cells warning condition was evaluated on a
coreboot system.

Use a helper that checks for the coreboot node with a scoped reference,
so the reference is dropped once the check is done.

Fixes: 8600058ba28a7 ("of: Add coreboot firmware to excluded default cells list")
Signed-off-by: Yuho Choi <oss.patchbox@gmail.com>
Link: https://patch.msgid.link/20260924011358.734722-1-oss.patchbox@gmail.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/base.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 477017ed6f49b..f4673bfe38100 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -95,9 +95,17 @@ static bool __of_node_is_type(const struct device_node *np, const char *type)
 	return !strcmp(match, type);
 }
 
+static bool of_coreboot_present(void)
+{
+	struct device_node *np __free(device_node) =
+		of_find_compatible_node(NULL, NULL, "coreboot");
+
+	return np;
+}
+
 #define EXCLUDED_DEFAULT_CELLS_PLATFORMS ( \
 	IS_ENABLED(CONFIG_SPARC) || \
-	of_find_compatible_node(NULL, NULL, "coreboot") \
+	of_coreboot_present() \
 )
 
 int of_bus_n_addr_cells(struct device_node *np)
-- 
2.53.0



