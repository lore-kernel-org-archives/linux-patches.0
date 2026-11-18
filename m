Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061193;
	b=Xj3d9lCR/56qoNG5HCe0q7Xqp+fS53TzEtGoN6QrxX81Wf3gT7guF2nF0cXW1GeYC4wb
	 g4iaIiiAapI91krxV4J+Bvqxxh2CY+RlYMjEVpE5umfkdzPFiZsnDk16+k8nf/g3RdzkU
	 Qm0Prz1S8D6XU99xWv42THVdksZWvzgHXLc8FRO4IhZk2QfuzgrBJrgNWU3rKMPU/OfKF
	 wRA/7VVZuJbCtw5dUptcO3QV5qstRWNEWS9y1596XGNqEDhn2BjMHToJiucdl95hGRNow
	 mBPuowng2EMVL2QUIkDeRTQa7AUHuuDvmbPpe9XY/+K+FEDXeUMOlHDTXeMOXmX7ftw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061193;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HFbBzuWEDfqPxIYYXWnLkwrHk+3mrYPYlRKFVR240CA=;
	b=zlyEmL+TCGlxcroq7pD6rsq6xRLlwN7ZjmAUjh/EusoAQuEmJ8CSSwt9iQDuDuo2x58E
	 qNuvSCxPNRtaOLISzsnRi//Js1c61d0ECHruzoc2aU7YVuo5x5H5kDwT1T930JXzS06OC
	 DBueKKaam4aPcbbGSCIbevDQLfkRoEuyl2T80QMQenj08eFi7BnQG9Hfy6WAZHJkxMHX+
	 Ny/ReNaXefwHg8RIQnHHVWWpX9p7rCPsudbLq4/i57RfUAxlTM3HU4xxCHXLShwKMx2yo
	 oLukXyyXhn4C12uVCm/vd+tkxD22ojyqhLlbugfKl/jPU1veiITW69slm3/2OZCs1BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rG8ZFxsR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18393606A320;
	Thu, 19 Nov 2026 04:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rG8ZFxsR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6C81F000C4;
	Thu, 19 Nov 2026 04:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061193;
	bh=HFbBzuWEDfqPxIYYXWnLkwrHk+3mrYPYlRKFVR240CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rG8ZFxsR9q5LwHd66uqxWuUTHPy+cTyrCw5KroKxmZCIIbM5ruDuC0I7DUfA5GGKk
	 3O7NgJ/FmWnnpovUawPHaOW9zz1KpNTrRIBo0TVGgEvM/T/I+mN6s9oeuDS+W4tvv2
	 dQVvv/JY3O5ohTsPnhlpYM97hM2ADe5W5perAUkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1424/1848] ARM: vexpress: fix device_node refcount leak in vexpress_flags_set()
Date: Wed, 18 Nov 2026 15:57:42 +0100
Message-ID: <20261118150019.155525575@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weigang He <geoffreyhe2@gmail.com>

[ Upstream commit 62b9ae8ae4a7f0b93efa1efa230782b37057b1e7 ]

vexpress_flags_set() obtains a reference to the "arm,vexpress-sysreg"
device node via of_find_compatible_node() and passes it to of_iomap(),
but never calls of_node_put() on it. of_iomap() only reads the node's
reg property to create the mapping and does not take ownership, so the
node reference is leaked. The function runs from the __init SMP prepare
path and caches the mapping in a static, so this is a one-shot leak of a
single refcount during boot, with no functional impact.

The lookup was added to drivers/mfd/vexpress-sysreg.c by the commit
below and later moved here by commit 9b06fc39084e ("ARM: vexpress: Move
vexpress_flags_set() into arch code").

Annotate node with the __free(device_node) cleanup attribute so the
reference is released when it goes out of scope.

Found by static analysis tool CodeQL.

Fixes: 974cc7b93441 ("mfd: vexpress: Define the device as MFD cells")
Assisted-by: LLM codeql
Signed-off-by: Weigang He <geoffreyhe2@gmail.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260925173252.933705-2-geoffreyhe2@gmail.com
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-vexpress/v2m.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
index ffe7c7a85ae9a..bd179c8c3db63 100644
--- a/arch/arm/mach-vexpress/v2m.c
+++ b/arch/arm/mach-vexpress/v2m.c
@@ -13,8 +13,8 @@ void vexpress_flags_set(u32 data)
 	static void __iomem *base;
 
 	if (!base) {
-		struct device_node *node = of_find_compatible_node(NULL, NULL,
-				"arm,vexpress-sysreg");
+		struct device_node *node __free(device_node) =
+			of_find_compatible_node(NULL, NULL, "arm,vexpress-sysreg");
 
 		base = of_iomap(node, 0);
 	}
-- 
2.53.0



