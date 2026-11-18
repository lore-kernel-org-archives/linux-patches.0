Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048927;
	b=oJEqqP7aHjwdEc0WGzA6JMdg8k+jQ+KVUVTwSCf1SmVAl7dZy26giR3VM9dzzxH1Li5p
	 Q0GeagccHE7ej+A0/Edmws26aidQXP0nayma0SzjmNKQnRPn9QbbwT7hRXqY0G/TaqNVL
	 M+90urs67ZZ4PIFjaPlGQYU5xLkRZxahLzkVH4JkfghJRBkL9ALOv1U9PSDRd7Y2JSf4T
	 X/g91hpKaCLMUqnlurls/SOcm8jlh/EW/XsNLIf2jfBvDP5Tba6G0N3+4wb7Hf3cDFGEB
	 iz9JAVq8TXGRbSPaE0QtZs2sIBDtYvsiqWhTiePCiXJAGSfeNxXUfW8sMN2HBJomLBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048927;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4dXpIwRR+HcEcGHE+k6uhv5c0u+bz9nLg4hwQANXlu4=;
	b=Ia3rMAhqqrfpWhOYdHAoyE/+SOzHcwvUVT87UTfs7N5EzToy7oaQ8N4OQ2e6aCoa9WZI
	 RmYj90tN7uyjx89Gy3TxR9oKs5qhoae+C4tJgj4++pbVDGjFDQyFt62WdwW9Y6kaaNF+G
	 670HzfUSTsgQ1+Xz6TnxE340GJw2M3AhgS9JEyQHAR9FPqntAoiV0nhON7T0R/VBC+mRX
	 8sGTiyyDc7/ipzJJ0RlQgbV8vvcUlBep/5j+PRHdn8MtQ7NFDg1vTGKV8HhVOYrAU7UTr
	 vkcvr/un2exUNcNp16jeud0J3R0L98kyZNVPRzBZn6qXqJ0N9SWS/NXGVYX30xPTLHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iU4WcEPm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92463606A337;
	Thu, 19 Nov 2026 00:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iU4WcEPm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4F31F000C4;
	Thu, 19 Nov 2026 00:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048927;
	bh=4dXpIwRR+HcEcGHE+k6uhv5c0u+bz9nLg4hwQANXlu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iU4WcEPmzOg+UDdcxI3KCb0mzAjfz3/c3S6fOEQlAZ290URajdoSLl6v6ZxsNPzEk
	 thfIDp/MYQqEi2CUmuutWH9j2aZoYXaEPMeu6Tujxg1md8yB2oDlLhVRIjsSNBj+Nc
	 YrkcfXfPLX0LeHx23lRYtR/ruyhtIPKhTADEeYgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2162/2857] ARM: vexpress: fix device_node refcount leak in vexpress_smp_dt_prepare_cpus()
Date: Wed, 18 Nov 2026 15:53:16 +0100
Message-ID: <20261118150319.243766309@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



