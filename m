Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040555;
	b=QKALFnOelqt/fOPrsPk94JtrggSCc26RbnkRr7WuifwUDLkDuthlfipy5NoNOj7eEGvx
	 ykgTn3CJpr5f2Nh+AU8+fqhw3RZOWY235VuEE/Go86TU040XBoI43M2WbWb0LLQwSNjM9
	 rRITUK6OZBms/YrYPQP7NcAVXCWLQNSnXsr1KyfC2l15gwFrTLUQwJ4vF8Uel1p6/R4v7
	 SRr30nt/eBtzCBXo+AhCFWOk4ha6Qr68OgvRtYDyaf3vCClQX29qYqG+xsTnf5ckUnaJk
	 fBS/N5ABsBf/qr7nYmv+9A9w19sZaV+CXbrykallvuP5o6ll/hNIkZIAJ7CNmck7h/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040555;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AuTvwHREXW/K2oBLC/AUIN2QQzX87KjJYHj3TNGzhEg=;
	b=h3ljBiZf9KtYSMOvGIf8C6L9t/RFpyoqnLHuArHWKPpTA81qHOBZMvpX3qEpPJ3FAJAX
	 iFzafNt77FyWiP6OOU2FxTCcNqrm54vcmZd9/oOOGPaWjyUi2WdgvgsoHdikIbLzzL7px
	 OfczaX7K+/eiIJCxdrDs0fLXNRX5msPI++PJrhf47dU2xOdyfQUSS08JGpVeDRdZAMxlu
	 v9dtzhNQMXInB5i/S6JWZUwiNe0vwLAlnIcV9EY+RRobRjA0u82kvzEihPY3C8xXlP6js
	 P845ye8fJb3DWjRCNH0t4keaZ/gzn5rIN5FyV77psMPrqvw+Rnlk3llGY7Rajow79Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S2KtmcGh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D33606A320;
	Wed, 18 Nov 2026 22:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S2KtmcGh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9701F000C4;
	Wed, 18 Nov 2026 22:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040555;
	bh=AuTvwHREXW/K2oBLC/AUIN2QQzX87KjJYHj3TNGzhEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S2KtmcGh1P1h7IwdsVBX2PEbdoiAaapj4Y+NIbjBrCjRNh2I83/6TmedgO+qLLUcB
	 LSxGS9MiVi5HMY+BVRUfZjXIq6stzYoATh9hisvNVO8P44mECQVStSez7mQNR+Qyr4
	 v7L4v9cw9+LLocmibr7hgk1h1SwJ/z3kUhMhVwY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2492/3318] ARM: vexpress: fix device_node refcount leak in vexpress_smp_dt_prepare_cpus()
Date: Wed, 18 Nov 2026 15:51:54 +0100
Message-ID: <20261118150436.147512771@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



