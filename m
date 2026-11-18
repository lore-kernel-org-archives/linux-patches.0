Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018050;
	b=hshKiOWMTrz1RvAJjy2GMdN8pqBW+KkF3PTff9DDwfoDKdXDoTDdJ08VwZj7ZumHCGuS
	 ub+Cvghl7n8TqRbhYWhAwqLEm062IyWrvz/x0dBhnEL3wl5Y18e6cHWW5qzpHE8dxqn9C
	 Q1hz+uAaQsaVHfv0D8kGjlkT1vTChH61jGU9dlXElbm7f1OjSqGRA976NHMoxqermMEc/
	 A/2w3b3/WJgYjPWoiL4xDWSNrTK/yqDpGpYvqCoB0i6KYD4Bw6CtDoxnUrgnpVFhMYTd/
	 eGm//4ShCuPNhTq8rtNv/2NHXAC125w4hzsqo1SOImxnfRoXyPEe7sQk3FjeKczAqeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018050;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=basYnSpqoIlFdLHZUzH7yrNyfaOg9i66lU8YWGRfwOE=;
	b=HsLwmErR6UPK2+Xi/hIO8E44od9bzEtbdg+msLAeR6paLb3zHq/ds6oTABq+eif4m1oO
	 osp6qMGGYQz1vfPIb7ln54qF2/JVJpRVa4Hdl0L0zJWwh+rANgGAAb17Sl8K4CamX5QfJ
	 4uSbcpdVxDVQASZ83n4qDYVePFEKkwjCKp5EHJlsTl/cFm8mGfhhX47/WR/4WBz7GwKLl
	 u/e3Hxp6WflKNTJRtPFERaV2PdpXMMY8PnIsylNWTlYRgfLhWjgvPDHkIdlA1+dDEL/UM
	 bVY1HUtZvkq93dz7Tasm1JsLjkX3EUCrPzEDa5QOtfQ/Hk0YJdoD1WC8EiF+nqebiHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C1ZOYPbh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C43606A320;
	Wed, 18 Nov 2026 16:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C1ZOYPbh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F251F000C4;
	Wed, 18 Nov 2026 16:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018050;
	bh=basYnSpqoIlFdLHZUzH7yrNyfaOg9i66lU8YWGRfwOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C1ZOYPbhl0eAh15AkduuiMguqTHjHr1REnizZQdteBcIY1D20eZWKtddNvVjF7/gk
	 QkqoA4OpvmeuiE+b0XY9GN3ilsJNFfvgrYavZB8Lg9SbfoCwpfcvxWx+ZVxi8CqAZG
	 nOfeH2EUZ5ER4gpdPQr7c2qM2FQo0hMb1rnusQQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1103/2651] ARM: vexpress: fix device_node refcount leak in vexpress_smp_dt_prepare_cpus()
Date: Wed, 18 Nov 2026 15:39:03 +0100
Message-ID: <20261118150327.703381560@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weigang He <geoffreyhe2@gmail.com>

[ Upstream commit 27b98d331f1dcebe088ab51a7061a387a7440cb2 ]

vexpress_smp_dt_prepare_cpus() obtains a reference to the SCU device
node via of_find_matching_node() and passes it to of_iomap(), but never
calls of_node_put() on it. of_iomap() does not take ownership of the
node, so the reference is leaked. The function is the .smp_prepare_cpus
hook invoked once from the __init SMP bring-up path, so this is a
one-shot leak of a single refcount during boot, with no functional
impact.

Annotate scu with the __free(device_node) cleanup attribute so the
reference is released when the function returns.

Found while reviewing a CodeQL report for vexpress_flags_set() on the
same SMP bring-up path.

Fixes: d2606f81d563 ("ARM: vexpress: Simplify SMP operations for DT-powered system")
Assisted-by: LLM codeql
Signed-off-by: Weigang He <geoffreyhe2@gmail.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260925173252.933705-3-geoffreyhe2@gmail.com
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-versatile/platsmp-vexpress.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-versatile/platsmp-vexpress.c b/arch/arm/mach-versatile/platsmp-vexpress.c
index 1ee3c45e71c99..b810ad50b98ce 100644
--- a/arch/arm/mach-versatile/platsmp-vexpress.c
+++ b/arch/arm/mach-versatile/platsmp-vexpress.c
@@ -61,8 +61,8 @@ static const struct of_device_id vexpress_smp_dt_scu_match[] __initconst = {
 
 static void __init vexpress_smp_dt_prepare_cpus(unsigned int max_cpus)
 {
-	struct device_node *scu = of_find_matching_node(NULL,
-			vexpress_smp_dt_scu_match);
+	struct device_node *scu __free(device_node) =
+		of_find_matching_node(NULL, vexpress_smp_dt_scu_match);
 
 	if (scu)
 		scu_enable(of_iomap(scu, 0));
-- 
2.53.0



