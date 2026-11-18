Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017391;
	b=wmOIBEx4kOnmtAF51VU8yNZLPnX8b0kD6tuKwWvJ058lJ9OwqNvRk0M+wyVer4MOS3Pa
	 34btNHbiMfsy530cs4Ok0Oy43cwgeTeeL/EAhvN3SVsZrfEXDzz6/DTlkSknm9kWEf95i
	 YoRGgMyVC3bCTRaY53tQi7Fqggbml0OsIsDctW1oF3hON4dwKL3kBDpN8XJpjwi3IlIvu
	 XLpmkePpiwWYzEc0pGRq4bdOvCtYnirOew/VbvX2+9FbpJksO4qSTsQdnP+HP3Oxgf42V
	 adD7TZXkFQal1J3cvcu/h8STf5aaYzCbAemPV002mzZ0nANszvgHjocluKwD6MLOQjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017391;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=95ukgwSKSFNfl4XPCXaCtzYSHu0Wtx8V684YhvoG56s=;
	b=ICtcYI0Cyb+CwD9Ic5J6OwqTGrKZKsmUHRPLqB/bYpo063KG0PWEkks3SL6b8mD6P9pi
	 ediYzG2X+vttVHWMRC7xKrMn/VFi7Dykl0op2/0OLIpdTXv2orre/YP7bzJV8nTfeK1+7
	 8+1/NOzw6Ze3kUf/kJRpYtAn+L4Ogz4VX8yGM9Xu1KaKLgGTaDkQ/5rY5ktGXbwTwBwHn
	 5jyyxlJrcRaquoEZhq4PQvlwXU6vcYAennk88/3oaSqGI0cibk+iqqpWribpOegu1dq9J
	 3jY+Av4yqJEDq9lgIV0DJrq55lCC6069yYhlJkhNMOUWlDAfr+eQ5cCdZM15mWav8vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="fsl/cDiG";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5BD606A31C;
	Wed, 18 Nov 2026 15:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fsl/cDiG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1534D1F000C5;
	Wed, 18 Nov 2026 15:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017391;
	bh=95ukgwSKSFNfl4XPCXaCtzYSHu0Wtx8V684YhvoG56s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fsl/cDiGkkZ7NZKPR15KbtU/H13d0/3uAk/VyJsmeQw9k9BWWPnO8/bxiv58HainV
	 Ls7EWoyE/EzVN3jv9yT6eIgPQMYo42WgmDfSWWsThGx0hWWRt42JCO90RQoE4k2AeA
	 O3kubR5xWQ7UjD0cMrYEqKeC7q20W3TJPSaSrX/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Joel Granados <joel.granados@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0828/2651] sysctl: unregister tables before freeing bitmap
Date: Wed, 18 Nov 2026 15:34:28 +0100
Message-ID: <20261118150317.696306048@linuxfoundation.org>
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

From: Yibo Tan <lhfff@tju.edu.cn>

[ Upstream commit 238dfe02fb0a9f72d7fd275d74ce80f13923ef31 ]

The table registered for bitmap_0001 retains a pointer to
test_data.bitmap_0001. unregister_sysctl_table() prevents new handlers
from starting and waits for active handlers to finish.

test_sysctl_exit() currently frees the bitmap before unregistering the
table. A concurrent read during module removal can therefore enter
proc_do_large_bitmap() while the bitmap is freed. KASAN reports a
slab-use-after-free in _find_next_bit().

Unregister all tables before freeing the bitmap so the unregister rundown
provides the required lifetime boundary.

The unmodified module reproduced the use-after-free in three KASAN runs.
With this change, three runs each completed 100 load, read and unload race
rounds without a kernel diagnostic.

Fixes: 2ea622b887e7 ("tools/testing/selftests/sysctl/sysctl.sh: add proc_do_large_bitmap() test case")
Assisted-by: LLM
Signed-off-by: Yibo Tan <lhfff@tju.edu.cn>
Signed-off-by: Joel Granados <joel.granados@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_sysctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/test_sysctl.c b/lib/test_sysctl.c
index 909cfcf76dbfc..dd795979558a2 100644
--- a/lib/test_sysctl.c
+++ b/lib/test_sysctl.c
@@ -321,11 +321,11 @@ module_init(test_sysctl_init);
 
 static void __exit test_sysctl_exit(void)
 {
-	kfree(test_data.bitmap_0001);
 	for (int i = 0; i < TEST_H_SIZE; i++) {
 		if (ctl_headers[i])
 			unregister_sysctl_table(ctl_headers[i]);
 	}
+	kfree(test_data.bitmap_0001);
 }
 
 module_exit(test_sysctl_exit);
-- 
2.53.0



