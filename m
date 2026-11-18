Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046813;
	b=e3NbME0gF9Cm1tqhW0mUzusJPJV1RsOyeleskazQA53FItrAQ+FcOSqtpI17ftqWeZZl
	 MC56XTnUB4BWpXy3yXSbkqyPhQjusiRpTqOuNCBeejtipEHMK/5qKZ48Czni6edk7sfin
	 9MM8S/a4ZzFhPsBNrO66RjU3cnvGfvnrcbUYPhLSyEumz+u6JHVEfFwsMVpjWNuhBABzw
	 GR4VamW/RxI2N/y5gPadimpIkclEJGZOxllqqtsg1X0vUSxoui8V66GyhkSN3vrTbFA2H
	 eEPHYuptF7r4vazazcZxY65GyjHpAUs4lSEsu93Jkl2hs0cZ5atHP7c1zuRx1PSRaJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046813;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=COaMEWQ77HTJs5CAkgqomGHjB+RBQjzUPcO+dLlPXY0=;
	b=If5bVoCasnWEsTBqcfRAeCo9sN+p9QK2omXFhhhzC7eOUHV+s68wn4NkePMYoAy6o/lO
	 2KjAvSabtWQoKuaTwMEccKejsLXHiB8+aOdsF7DTGtdoKatmp86dQB+Vz6LrFCFCNWKj2
	 eWTXc/Jx17VNAfHMY8xqKbRrDATlS2EvGLnqVJr+e+56raROxFbz+miNLuxOBPgFdysMV
	 2CllkbZENCEvukuQs9s0xux/6DODJQfcOU2+AvQSgYDIt6/rhCXImpKeMXiwU/dONWxIz
	 MSBGdR8CCAbGdYKI+tyd6g6n0zKIyDj6jBeYP2Ump2csskYbKRI8Tkf01ccdD2JA7vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jg2NQRci;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6962606A32F;
	Thu, 19 Nov 2026 00:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jg2NQRci
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D60E1F000C4;
	Thu, 19 Nov 2026 00:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046813;
	bh=COaMEWQ77HTJs5CAkgqomGHjB+RBQjzUPcO+dLlPXY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jg2NQRciZ4IYxb1MV/Jr82uOcRTmD4shY5WbQzdQElMYK7588fHKtKm51uRJOMqvO
	 4zVX3ubS5N1zCn37Dn7djkppx3lb7olmrkck9aGUs9KVfGxPx6w4HcsbOvGjV62GnW
	 8EVPDGAtuNbpgQByrML1/W4FL93A9qX7U7Wd9JAk=
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
Subject: [PATCH 6.1 1414/2857] mm/madvise: fix data loss from MADV_FREE on a KSM page
Date: Wed, 18 Nov 2026 15:40:48 +0100
Message-ID: <20261118150252.245459036@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context to match the existing shared-folio dirty-flag comment ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/madvise.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index 5640bacba5384..40e23e42d62b5 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -675,6 +675,15 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
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
 			 * If folio is shared with others, we mustn't clear
 			 * the folio's dirty flag.
-- 
2.53.0



