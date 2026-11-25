Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622135;
	b=aQD0gnaOgq0rfXWm95F94dbfrcVtjWSVSrLkOVBpIQI+XKsQ6QsAP6drRUWOu3kbhtTi
	 mp4gvsPvHdDgDlmrgAnCXk3rYsP1pMddml68c+6/T5DyHbluAGH/LSMvqzxyOI9hE1JMy
	 M9jxx4bgJHNYCKmng9YcyE9FxBRlWdhuYvb2eo77G2hEKhh/3TBNPabxqphTzm0CgR3GF
	 BSVvsp+lQ4kdrb1OO2LDwGlruC7ISAWYNHeXkjhumIV5ZEMX41Mi9WYtQKhEDnMf/gDEs
	 w/oqtE7EhCwWWcRbohvcKE+5YDU6EOunmTNwDv0CtAuC68ZP2Q9vaWfOaBLeJHWYedQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7aTQeAwVga2loo08PTjdd0Xybi/rwcAl3IacopusRNY=;
	b=mow4EqXLqacjiVySOKmHhCWughl7lSrcbzwUbA+sNEhsdTv3N8L7pbhIaa3MD9z5EsIG
	 biR2CRyBJFm/yWhj1iMIyq0A346Fc4fIJDQ62bUrcU0X1Vqh+0aJfkUi9IxI1jbPovmQN
	 iRR7rNd+oH97PJ6Dd0uFNimCMLGrgevRS6EVu/anP9CFfjUS32UywwoPN+RDfDNJ/TVK7
	 eSXbHmDeP2XaZ83XQUIvGB3VKUlqE6Lc+77B2DL+fmnfEc6o5KemPK3i37jJABt11hvKP
	 mMEN2tz7mAfcQhCG1oq0DXluexSmGADqh1cifPFvi9vfU5pt7lNApORs1P+cMR167Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bRiEFY51;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5383606A326;
	Wed, 25 Nov 2026 15:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bRiEFY51
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64A51F000C6;
	Wed, 25 Nov 2026 15:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622134;
	bh=7aTQeAwVga2loo08PTjdd0Xybi/rwcAl3IacopusRNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bRiEFY51tlHfgZrPnInJjvmTyGR91SU0EtFBtvxYcDyT0Y8TiNmZ0cdRkQZzCQ6wt
	 LFsYp7HGjGD57qiFdvPq3LXYh9BTc9doEfUaTXFP3yGF1a9Lc/GOrQDF6IpgVUhP2/
	 YLpQ1uLeCK6uekbtwlMO0oCjSI2Wy29sGyRkxQjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 433/990] ptp: kvm: x86: Leak clock_pair page if changing its encryption fails
Date: Wed, 25 Nov 2026 15:30:00 +0100
Message-ID: <20261125143832.238445707@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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



