Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024991;
	b=5CozE6ER0RWmbEIM9tjBQCQRiAt4qu9XNFc9zEQyiONpDswRrjQVlbasaYBtBki64SKP
	 MeVl4ij8gBjTjKx/RR1yvc7y0r+bXRvPbtgSESdcnm3Yo3+DMrxdCYsUvRXL/XBpBUiqO
	 x7XRC5Ub507QMeVGLGLoJDUYJTc52+hSFj9B0IIHzfhptk85F+dopKhp6v72m8Gc51Chj
	 ulruwe/YBvUEqUDrcQyzmH2zvgYZreX2002c8rERp20L21UN+NyAkjEcqGzLJrFJhOTco
	 DDIzCvOpr9aPC1Wc9dvVbdayYE4oawVMi9QCnubmnGrtGyUpseRuveIHxQJGaqMfdMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024991;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MGzKMbOH5BhSVtn8FIqdV6N6hPkcL8jm1aKw0jZpdxg=;
	b=qVncWdrLDvJFpr5T9+d85nVpyptG3iTlhK8rBQOQXyQLnmSO3V2F8kDqEO7Ts/aMeIEy
	 8TGrF2dLHLsMO0FczMLDfST80Xdyd2LOJEK0Sl9zQTTvHu/HYC1tO1XJYiAbUi4FucfnX
	 WmS05LT5K6uhMjDpKlgFFky/1geA1otT/vZXXhshs5Mk0CSC6xuh7JzQ5bI7DKx7AOXqw
	 oKLdohaDcVn5ktacp1aI/VCIPIInW/Ce1q6Je5lTBDDpiTA26AY6nUJiB3gKBYdexMz+i
	 HaBakctG2xCqtIVi2qX3X+UkLVkztqHXPrstcaiydGGZc3Gu3XwqbuZ786ldL14d2mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="VIz//JrY";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266A3606A31C;
	Wed, 18 Nov 2026 18:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VIz//JrY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F811F000C4;
	Wed, 18 Nov 2026 18:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024991;
	bh=MGzKMbOH5BhSVtn8FIqdV6N6hPkcL8jm1aKw0jZpdxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VIz//JrYgdJ/2PK9aISvbX+stIW4QBRp1G0i9QJBsXdpQLxiAvr8l/RTW82jvgiUi
	 O3oPW8JMtxd6q+Z2VZZxA4/v57IQ2j8H8bblxEDpVko7xpP39vGuJseRAYPzO8P6el
	 FGxpZKiAKUR3SnyhmqrNccqEAtPkjr/tvZstJiUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0922/2151] ARM: vexpress: fix device_node refcount leak in vexpress_flags_set()
Date: Wed, 18 Nov 2026 15:44:17 +0100
Message-ID: <20261118150156.049454031@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/mach-versatile/v2m.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-versatile/v2m.c b/arch/arm/mach-versatile/v2m.c
index 79afdf2a90b6f..c86b38386cf7c 100644
--- a/arch/arm/mach-versatile/v2m.c
+++ b/arch/arm/mach-versatile/v2m.c
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



