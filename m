Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98ED21F890C;
	Tue, 17 Dec 2024 17:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455813; cv=none; b=FJOEd+qswzXieiAhWRlz2yxvyaz+1SPMoyJuWj6ASvgsygvflT3Xd2pRkcX6+qYk1wvi3K6+799BPck85Q/NSaPMah5JzLcBf20RrBsaYWzueNJct3Xe43RwTQ6shXB38xmhwhZc40v6pfnccvXm8g7GTISxVmfvBwsy7IrIWCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455813; c=relaxed/simple;
	bh=Ujutyt4jXWS1U4KPWtN2WnXZM/yKtZE1P6S8drtl4tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CH7vjwsaanFjia96i+6fUx6VMiNdKh5bGLXNOzfSo/4ObQmgl/QwRxSMLf6SXE0II8ZLOQE4QA2Oi2J6y44AK5ZHu32bemncQj3k9Wwp6pdZCsuyKDFOji5pMMBTMY9qHQ1BxidtXTQ+cwb9HuW0RJHzD4Y5hcEE+s8NfEFFcmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dBFVpdR6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBFVpdR6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203D1C4CED3;
	Tue, 17 Dec 2024 17:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455813;
	bh=Ujutyt4jXWS1U4KPWtN2WnXZM/yKtZE1P6S8drtl4tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBFVpdR6WGk664Ll1UdHbMMgBQiZAfp6uNCP/PPhi++Kp/syuV/1eVnCiGJxtyEAo
	 TVQsfH90pDntrVQ4hxIrNG+pAVe75JsaqFlJUwyfUx4f1kMs93vDhErfGK+YiSLMus
	 C4a81wB5HZfT6T6ZX6KGk8KHGQ+06VsBalxV+48o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 41/76] ptp: kvm: x86: Return EOPNOTSUPP instead of ENODEV from kvm_arch_ptp_init()
Date: Tue, 17 Dec 2024 18:07:21 +0100
Message-ID: <20241217170527.972429938@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



