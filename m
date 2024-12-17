Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E9A1F893C;
	Tue, 17 Dec 2024 17:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455613; cv=none; b=FsPUNTUXOXWbSkA/on5EkakuuccASpPNbhe/9jVQfQWnhVwTB0dj83b+i/mq/NSL5WC1kEcdkvzk4wZc2Mqgc+kbiwgAmfpAqFEoIB/QvW88ZnYKIztnq1/LuFrlfefft+Ov5XSeTQF7rVVEgKNZ6W18ao62hkoig5ukDm17n5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455613; c=relaxed/simple;
	bh=1ukvaR2B7jyaXrxZDTsZMncDWS0rZXMvYSX2oA7jRtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tR9HtMtfm7ire7PRJ33Ber1gdkddFO40MR0FhKyA3Xa5Q9wT7+KbMZCW5nLZPclC/7rfv447W13ZJOBFkxaX+KueGgHwwobKDz1jJdT/444ft51hpxi94tyNqXDA5C2KjjOVq9omQeaLtBN5KVwXzKRdl27K1NAckG7enNis0YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s180QRSf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s180QRSf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D942C4CED3;
	Tue, 17 Dec 2024 17:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455613;
	bh=1ukvaR2B7jyaXrxZDTsZMncDWS0rZXMvYSX2oA7jRtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s180QRSfld2t2krYWtkGSvz8IPxAs42CmMZEzyiuG2dz7FMe+fK/XDUy01Yb/EgX0
	 uTliqaRkAke3Lf3p0nCAGDAIpsCcYJkxkKFFNEtN0aBRuG+Ynl3iLzx1KovwYYMMeP
	 zmCuVFrc8XmYBiD6BS8eYt8aBDcLm4N44H9LaR1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 26/51] ptp: kvm: x86: Return EOPNOTSUPP instead of ENODEV from kvm_arch_ptp_init()
Date: Tue, 17 Dec 2024 18:07:19 +0100
Message-ID: <20241217170521.365279054@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
References: <20241217170520.301972474@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



