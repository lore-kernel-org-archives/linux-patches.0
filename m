Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585717;
	b=asSlN9T5iER0cUC8OKcJmNjqy1ACCE/bCplFEp4WhpiKtbmsDx57wAJVa4uHjVPRU2vn
	 V1rgucXBaNKucVB27T/OUguDP4F3WJmAMNj4EnmyHfhIWMoM7lWDy58dE/pZSne22nlcy
	 zCSWAwZaVa+6Hdz2ZCyVmNZ4ulcGke28kcxYuGjRN0v3ZtIbvJ8KXeD49t1l+/joPqw4A
	 5e+pRu01Jf0m/jZ8zx+aDn/tNdZOdYDFAVu3u0jmg54NfJ8qRdcnPcSH5vVe2nCnJ6ECs
	 Qxki+Rtk3rIjawaeA8bv9d7FzUsKPnzYcbojqlhD+mqCrXS+LWUNxpJBshyac/IOrEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585717;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qRwDXT2PdwAWJnlPoEq+eNI9w1H1NYswe/LdNZwBdwg=;
	b=Hn9yLDrHinv0qV1JqyBELTeuPhqiJFghXvSBE5GnLzxk+PaZC5/YmGwlu5j1L4+DnbDR
	 vxekX/Q/Sejnis1kpaBzxMB5oI9LcKv+ORJpOCplDkcXhUHmrRmTcZWQMErDQBT6YHLF2
	 VIX28mJJT39ONm1iY4lUwEB2g+W8xpmL5Ds90xWLhHG3PxQhNt1d8uyCPlu6OWThDkJX0
	 kreaB1+HN3kyJwOTXyeLuDo7bEFdV6bRsZ9Xk7QrGiq5bOLe5vjCkNnvhVtg/fTTRvWGg
	 0PJnoZWyS+nxef90VTUizY8Uq1B/Y0eae4FAO+zsPAoZTlihUEmds2MM7C/LA1LXUGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hQHfUzvm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B377060A5BCE;
	Fri, 13 Nov 2026 16:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hQHfUzvm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E311F000C4;
	Fri, 13 Nov 2026 16:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585717;
	bh=qRwDXT2PdwAWJnlPoEq+eNI9w1H1NYswe/LdNZwBdwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hQHfUzvmuCQClstCbPn4utIuBZkZ6uBrc23trYYEZkKicp16ycUIaUlHaInSPUX4W
	 0MXs5M/v3PtCkdYGyQnBRgEBbNO4xALOOekQiqAiRPhg+/E/z2W9xT3/rv1pAI2DjJ
	 pBo7NHU+hQYXorzyxpAYzOrd0wwrAalcKjx5omEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 319/507] mm/madvise: fix data loss from MADV_FREE on a KSM page
Date: Fri, 13 Nov 2026 10:50:23 -0500
Message-ID: <20261113153806.221686602@linuxfoundation.org>
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

[ Upstream commit 22d043c1da48d6c7274f9dd900714b6d58b7b9c6 ]

MADV_FREE can clear the dirty flag of a singly mapped KSM folio. The
folio remains in the stable tree and can gain new mappings without being
dirtied again. Once marked lazyfree, reclaim can discard data that those
mappings still need.

KSM always marks a folio dirty when converting it to a KSM folio in
try_to_merge_one_page(). Marking a folio lazyfree clears PG_swapbacked
but leaves PG_dirty unchanged. Preserving PG_dirty makes reclaim restore
PG_swapbacked instead of discarding the folio. This also protects folios
that were already lazyfree when KSM converted them.

Skip KSM folios before clearing their dirty flag, checking under the
folio lock to serialize with KSM conversion.

Fixes: 854e9ed09ded ("mm: support madvise(MADV_FREE)")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Xu Xin <xu.xin@linux.dev>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-34-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/madvise.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index 54d8397059ba6..222c10eb61eb4 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -755,6 +755,15 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 		if (folio_test_swapcache(folio) || folio_test_dirty(folio)) {
 			if (!folio_trylock(folio))
 				continue;
+			/*
+			 * KSM folios can gain new mappings at any time, so we must
+			 * not clear their dirty flag.
+			 */
+			if (folio_test_ksm(folio)) {
+				folio_unlock(folio);
+				continue;
+			}
+
 			/*
 			 * If we have a large folio at this point, we know it is
 			 * fully mapped so if its mapcount is the same as its
-- 
2.53.0



