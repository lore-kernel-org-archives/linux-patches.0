Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705295;
	b=T5NNcMKFbU314sZGf7K6OqH9jNyFojqrAMQpZQHaZcwsalcOk0e8qt7I0UsENJeb0CVi
	 jigfpWtE7JkCNzUOHZEwHSZv07TlUXd8MSohbJfOyQJaEE/Jzax0Q5Eo9EBZNsQCMU5V/
	 Gr2LrtH4ul+4UHxSuyzCqRI7CQXGBv26DTucnUVcjNMHSFEgVGlJDsW2cihvhoiyeCwtg
	 kiNxjOlwNQ+YEw3hVVBzknznm7VpP2I6Q6GYnt3vFqKR7PxIFo/lsFzwsQOPG4tubzjIx
	 ymzH0aBH0nnqgiRoVTMqKUDhijLZzOYv3QX4cs0EWOvJ46gHRG8j/UigTCovzseV0KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RVzymO4YW9snVzP4wQory4uVQBhe5qvWrv5hlj/LVu0=;
	b=kiDyvavD0k+fkWSn0WL1pZR1LdvMqcOP1XmQ88LbidDvVrFeboyxB/VCLnCX22uChIyk
	 PNHP3Yx5Oh3SXsdE8x70vRwwwGDCKr3VE0P84WWrQr1RatTc8XXu2W1BTFeQHY4SLcQ19
	 PGp2Oblows1xT21kxe+Q9LTfZCmgdPDCQ+rVz2Me2B72wJW1i0TYUgZrdv7qKXAEzlhMo
	 WXBqooi67XtTivOqoRHU7u/v+xFjflqvUKVFPOddX34l4RIqRGyWzZXl+Rv0K/WVHAkLJ
	 4Cxv6r99y3zDyQtGNHKfVk3blEWH1QZz1RDfgFktigjNgSo1I3QXdJTjJxnZQ+FsD+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="hiN/GyS1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C8B606A31C;
	Thu, 26 Nov 2026 15:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hiN/GyS1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B141F000C4;
	Thu, 26 Nov 2026 15:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705295;
	bh=RVzymO4YW9snVzP4wQory4uVQBhe5qvWrv5hlj/LVu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hiN/GyS14PszXskyjM2l8BfY0bknHDiOfLkzuzIG02DxxCTds7JKQWXMtVkk/pzTn
	 hAA//ODLfhbsbhKYvpn6iHSFIfla3/QURnoI7msowGNQE5g/wMXnZehQyfVaVFOmFk
	 m8d8NfbXRXZCCMi1OSSk+9ihmzfa03D3fJFPcH8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 150/319] ptp: kvm: x86: Leak clock_pair page if changing its encryption fails
Date: Thu, 26 Nov 2026 15:38:38 +0100
Message-ID: <20261126144010.131155965@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
index 5e5b2ef785474..ab35b20dfb7df 100644
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



