Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624858;
	b=uFDxnrnHItvLoFNOk/DjxjYmkIiHYTGKKgYXWWF4ILLOBHQAJBkUE+kZvTTfrP13hzu1
	 BGMxNSWDJHy+Qx7E8omq0gQBlJAsCS8DG5SSQrtxVVljqnLuutpva1cZWK0IqS6IjMVqy
	 8p3SWJimgayM/a9Vxb3s6PfT8daQYCDOXEfQWIsIdeXOWNpzAZpB293WNIS/Rjckv7eYN
	 XfBpi5XO/7AY0vEqDcrcfeSLDpINODMnXgfluARLky8gro0ti4aKRLDCYCAFSVDPiYCbC
	 UoB+sEYd+kHz3FqilLShRZysBpqjigt7BwNLjsOG3N7KJc32LrFOpffnKLJ7vn1yV+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624858;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dGYNiKq3kOvNZC+ZpegM8RiZx1hzVD/GpKv/Hj2x4R4=;
	b=OZqOTZnyK9zpEpkRS7+c3lALmxUzsYNlvEPf7quqQbY3WyKhpo+191vyBn6QstaVpuQh
	 Px9n68H4VcE6+L4VbrT1k8OoJ4uKDg9FS1cxfpRK5ofxOoF+5Ew7O832qKyoJ1cXEvYss
	 KF6Mhy/HbygtaU2N2y3MtQQ2jbFz1nHQ+0Ljj9fLa32A0Lsor+WhyKXa62jb3ZAPZNY64
	 QgoDx52iWhxIsBEQub1BjXjToerBLMf8KvRvCxJ893VjEtwWzyRADz+ByWSmj4Zv3tncm
	 nfsq8BT93GCpOAVs41yz8QSUqsaNYaDDh3ow6OrZQXipYOuSsl8Y6SjAv1k5vHHpsDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qxmmo0sE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9939D606A31E;
	Wed, 25 Nov 2026 16:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qxmmo0sE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD951F000EC;
	Wed, 25 Nov 2026 16:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624858;
	bh=dGYNiKq3kOvNZC+ZpegM8RiZx1hzVD/GpKv/Hj2x4R4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qxmmo0sEPYccQQIlUcl//baqO6Svo73BwwhP8iVvjEusk245rlfAgg1AVcDnJ6jkR
	 RUKuVGl8Bprp0ZIxcpSZ3hwhBjs46ETChDMNe3ZImxy9VQwp7mtZAYJqadWA7FDRAB
	 fGTa8nTW7K/G7OUuGqtH+4Yyz1jIUtWQY/MucJ94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 330/816] ptp: kvm: x86: Leak clock_pair page if changing its encryption fails
Date: Wed, 25 Nov 2026 15:31:18 +0100
Message-ID: <20261125143856.837835665@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <oss.patchbox@gmail.com>

[ Upstream commit 6a01fb125ba6474cb97f14b68fe5435d3cdd08e5 ]

In a confidential guest, kvm_arch_ptp_init() shares the clock_pair page
with the host using set_memory_decrypted(), and kvm_arch_ptp_exit()
makes it private again with set_memory_encrypted() before freeing it.

The untrusted host can make either call fail and leave the page shared.
Both paths still free the page: the init error path with __free_page(),
and kvm_arch_ptp_exit() after only a WARN_ON(). The page allocator can
then hand a page the host can still access to an unrelated user.

Leak the page in both cases instead, as was done for the same situation
in commit b9fa16949d18 ("dma-direct: Leak pages on dma_set_decrypted()
failure") and commit 03f5a999adba ("Drivers: hv: vmbus: Leak pages if
set_memory_encrypted() fails").

Fixes: 6365ba64b4dbe ("ptp: kvm: Use decrypted memory in confidential guest on x86")
Signed-off-by: Yuho Choi <oss.patchbox@gmail.com>
Link: https://patch.msgid.link/20261105164324.23501-2-oss.patchbox@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_kvm_x86.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/ptp/ptp_kvm_x86.c b/drivers/ptp/ptp_kvm_x86.c
index 6cea4fe39bcfe..811758bd8b0de 100644
--- a/drivers/ptp/ptp_kvm_x86.c
+++ b/drivers/ptp/ptp_kvm_x86.c
@@ -36,7 +36,7 @@ int kvm_arch_ptp_init(void)
 		clock_pair = page_address(p);
 		ret = set_memory_decrypted((unsigned long)clock_pair, 1);
 		if (ret) {
-			__free_page(p);
+			/* The page may be left shared, so leak it. */
 			clock_pair = NULL;
 			goto nofree;
 		}
@@ -68,8 +68,9 @@ int kvm_arch_ptp_init(void)
 void kvm_arch_ptp_exit(void)
 {
 	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
-		WARN_ON(set_memory_encrypted((unsigned long)clock_pair, 1));
-		free_page((unsigned long)clock_pair);
+		/* Leak the page if it cannot be made private again. */
+		if (!WARN_ON(set_memory_encrypted((unsigned long)clock_pair, 1)))
+			free_page((unsigned long)clock_pair);
 		clock_pair = NULL;
 	}
 }
-- 
2.53.0



