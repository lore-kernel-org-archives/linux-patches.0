Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557BD152787;
	Tue, 17 Dec 2024 17:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456070; cv=none; b=Hk+F+OmMsmzjy3afaOMnuZW9SProGgPys6aaVv9uof3Owq+Tlm6LdkqUArWSmI7QKWvaBN8PP89NAlCBMeWFDJZtP2vIR2d0fTTrwnRv3AqlPg64s16QLV8XBJrAHKQVJbjXtEPHiCEgKQNsc2z2F16KylTMlGCsfleE+FR8sT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456070; c=relaxed/simple;
	bh=2S6O3pKeA9hbgMv4wMUT1krsvZPpCteljtzb1lnYhJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hedo2Ht2hhCeYFCqSlmQCvHyRldRUX6KESxYyIr+gJu4aS0TQZ6aZrt5IFDlPmVz4J+A8aqH7Me+5ZC/1cdx9gSV28nLeLauLqwxZdsWtNDCX8V5avk0qISLbP5fNp3+Jlfb2SUr3xQwrOYtaPtCTsUQeuomjN2DaHAA7ur9oE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=laRfPVRC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="laRfPVRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D521CC4CED3;
	Tue, 17 Dec 2024 17:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456070;
	bh=2S6O3pKeA9hbgMv4wMUT1krsvZPpCteljtzb1lnYhJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=laRfPVRC9QslPTOAXc65O06tMsfLAMTnFuZBMzW+ZUQwu7nDxxd8VlWmN6QHR3RQc
	 c6yApzQxmbpbrGLMrDxL0tkmjks+EcNn6KPuqm0qxtlHCkZHMouxG9B82Ja1RluF1t
	 QURjUEP9A6vB+J2PfUYE2SXEWmIT88EocbyAkTnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/109] ptp: kvm: x86: Return EOPNOTSUPP instead of ENODEV from kvm_arch_ptp_init()
Date: Tue, 17 Dec 2024 18:07:34 +0100
Message-ID: <20241217170535.463375298@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 5e7aa97c7acf171275ac02a8bb018c31b8918d13 ]

The caller, ptp_kvm_init(), emits a warning if kvm_arch_ptp_init() exits
with any error which is not EOPNOTSUPP:

	"fail to initialize ptp_kvm"

Replace ENODEV with EOPNOTSUPP to avoid this spurious warning,
aligning with the ARM implementation.

Fixes: a86ed2cfa13c ("ptp: Don't print an error if ptp_kvm is not supported")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://patch.msgid.link/20241203-kvm_ptp-eopnotsuppp-v2-1-d1d060f27aa6@weissschuh.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_kvm_x86.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ptp/ptp_kvm_x86.c b/drivers/ptp/ptp_kvm_x86.c
index 902844cc1a17..5e5b2ef78547 100644
--- a/drivers/ptp/ptp_kvm_x86.c
+++ b/drivers/ptp/ptp_kvm_x86.c
@@ -26,7 +26,7 @@ int kvm_arch_ptp_init(void)
 	long ret;
 
 	if (!kvm_para_available())
-		return -ENODEV;
+		return -EOPNOTSUPP;
 
 	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
 		p = alloc_page(GFP_KERNEL | __GFP_ZERO);
@@ -46,14 +46,14 @@ int kvm_arch_ptp_init(void)
 
 	clock_pair_gpa = slow_virt_to_phys(clock_pair);
 	if (!pvclock_get_pvti_cpu0_va()) {
-		ret = -ENODEV;
+		ret = -EOPNOTSUPP;
 		goto err;
 	}
 
 	ret = kvm_hypercall2(KVM_HC_CLOCK_PAIRING, clock_pair_gpa,
 			     KVM_CLOCK_PAIRING_WALLCLOCK);
 	if (ret == -KVM_ENOSYS) {
-		ret = -ENODEV;
+		ret = -EOPNOTSUPP;
 		goto err;
 	}
 
-- 
2.39.5



