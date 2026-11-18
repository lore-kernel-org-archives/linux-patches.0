Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055617;
	b=FpTPBE3LopXKhASOdys5Nk/a0lfYDY1vCYdl+m3rkMsBj2KkbQF5ka4a3TszqaAn9e44
	 DVPh8peD1u4Xvkkbe+OBSuvfEuhjBSgrvy5hcdwUBgCOYOgtBISpN3eF0savy1u3xHUaX
	 ThsbUtKv5Ob602UM0A7znbAio8ux1dpH/dfbczSZXMM3PYmnRkixMDKv0q24yUdd9t+jQ
	 wnemZKf+cUmMVdapaisV+5zfjrQpcHCZCutx5wZAeGffNeAGBTCZnidezI43Ik3c0i2ET
	 gHxtcQqDBkRF69kKtT2uufKWzSS+NpnhRI/smUtFxSkbV0S2W15skoubYAh4Q94/UGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055617;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E0D1aeKa831Di7Beyz20CxSfVjAFABeFqi3v5EqjCCQ=;
	b=czYsu1MZetNfvmWZST14hhRKky9rh6SCWMZoNgitWO/BuvIhyeNi/6P57UEE7XDQAVIX
	 3eEufkALFHhc3MlX4VcTDywTnBf46jrOKeAB6E32LCKyeOp5HizlajyT3jtZHdjjyHkfS
	 hhXq27vnt0QW0FjyDVD+r3cvNHVQRnuTNZxwkH2+9NZ86gem5ZINBCf9AauJhMkUmO0kv
	 6Cq3Db73mi/xHZkjA30crJfyhSaroNtdEZbDFEQFLe24BCbLzkjNrUa3JxDsoLjdgSYZm
	 dGzppHuMVS7iCqX5wQ/1qOaJSaTvp1T2Lo6w53hQ1QGHMG5HZO8Nb5C483uKet6J4Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dYGzcdDE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEED606A331;
	Thu, 19 Nov 2026 02:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dYGzcdDE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497A61F000C4;
	Thu, 19 Nov 2026 02:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055616;
	bh=E0D1aeKa831Di7Beyz20CxSfVjAFABeFqi3v5EqjCCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dYGzcdDEta/Rl068W+pj4JbpfZSxrjx/e2ugc147h0GQunJi/2rmj7FMysz7O75RW
	 jdvlkQXBFJBJznC3/ndzKhBW6+HGLD0lBx4WzE1qW11NowoTsLcyRl6tMzSDsyzBwU
	 WCtsUWYFz0zxKtjHBM6XFlC5PUINDG3l/DoNQYqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1696/2214] ARM: vexpress: fix device_node refcount leak in vexpress_smp_dt_prepare_cpus()
Date: Wed, 18 Nov 2026 15:56:12 +0100
Message-ID: <20261118150119.654967053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/mach-vexpress/platsmp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-vexpress/platsmp.c b/arch/arm/mach-vexpress/platsmp.c
index 99c93124aa68d..acc7473515e39 100644
--- a/arch/arm/mach-vexpress/platsmp.c
+++ b/arch/arm/mach-vexpress/platsmp.c
@@ -64,8 +64,8 @@ static const struct of_device_id vexpress_smp_dt_scu_match[] __initconst = {
 
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



