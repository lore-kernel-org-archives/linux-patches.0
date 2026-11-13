Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585781;
	b=xcCn3soEijEiKNROg4SRHIX40jeED6FFS5+HFSDb9BwUZScIlQYXS58Mf2Z0V3uJzlwg
	 4ULqOsvIIFisZHhmR/LqVU3KAUfdRpGNdK38gK4N8k1ERU+OYo3GMZ6WlIuYrZc+q6bCP
	 a1UgsZOQTWgDx/xd2TKTaskn8ZGWMX1Uc7VApkgYmlu4sI0cA6MvybbAPy9WG9jp+FO7l
	 xx10/KTzPJGBw6FWh+fXyUAcyS27GEWDJ+uj1jcSxph0f/wzN2EIDEXxA0W0rFWZnyNph
	 EIwvwMK/n7NDHZq0jQ40l6xvr5L64qiYZoW1JJPJOBmlq8o/urMuMUXJbzbUUDZAdGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UfYSV4lPKN9Ge/S0jzYyPARtJtcC521ICvdxLLkgLOc=;
	b=lRMrq9RSTONCiryT0oo+rp5bJ5C5PEArtS5pHPFnErRUGVZ8Ftna/EIYmPCAH/onXJY1
	 gSsEEa46k+MpmY9pWqgxWzkkAoTljtwIn7XxeJfJ69ti3o6tqTQewzRnQbcP8cz/Y+wuo
	 FAqjIRpOqjBE3R1EfhXwA+/2SCiZBirLPagRiUbcn1zWw6yWnHQO6njJeXRn6NF0zTgsG
	 5ARJ123chcQ5XZy95vvLHNYBPJzA6zJHqbE8Bz/MX6ukanXsavqibfu0nAviKC14rMAsW
	 ALtOOVoDaWxuelwaUrWKfxayy/3q7oavZfXHqGF8zBXIqBeZjRNQu8SVlpxDCBXrGSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="U/rWI+1C";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B3A606BA81;
	Fri, 13 Nov 2026 16:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U/rWI+1C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721BD1F000C4;
	Fri, 13 Nov 2026 16:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585781;
	bh=UfYSV4lPKN9Ge/S0jzYyPARtJtcC521ICvdxLLkgLOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U/rWI+1CBvB+53L8fSS43RjM6+lfh/+Q4tcUveZeBFCiOtctvW7FooYzgYTAOJ/d/
	 PtRguqC/M7pC0ExEdr2R5NsMxubYtjX4xmDwD1VW0siEdVU2EfvFPYQJjLwmmttjM9
	 q/QC6nMB41PrCUT2SWGu7AVdKMLCxw55sL96bXwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Harry Yoo (Meta)" <harry@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 329/507] mm/vma: dont leak the charge for stack growth
Date: Fri, 13 Nov 2026 10:50:33 -0500
Message-ID: <20261113153806.564333977@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit b1ee87802111156e27557e82acc31fa7dfc76e2a ]

acct_stack_growth() charges stack expansion even without VM_ACCOUNT.
This can happen for read-only or MAP_NORESERVE mappings created with
MAP_GROWSDOWN. Unmapping these VMAs does not release the charge, leaking
Committed_AS.

Only check and charge growth for VM_ACCOUNT VMAs, matching mremap().
Unaccounted growth skips the overcommit check while remaining subject
to the other stack-growth limits.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-44-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/vma.c b/mm/vma.c
index b257365f6e3c4..e382fd32f0fff 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -3260,7 +3260,8 @@ static int acct_stack_growth(struct vm_area_struct *vma,
 	 * Overcommit..  This must be the final test, as it will
 	 * update security statistics.
 	 */
-	if (security_vm_enough_memory_mm(mm, grow))
+	if (vma_test(vma, VMA_ACCOUNT_BIT) &&
+	    security_vm_enough_memory_mm(mm, grow))
 		return -ENOMEM;
 
 	return 0;
-- 
2.53.0



