Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591194;
	b=HCDgnwR2F8zEdnA+ziMZqD8mlS/mc0y+BJF+gtKLpeROKZ+d3Aqw9dku02IJmYw93ZLK
	 Wgr2y0E0PrwkjnC/+x9HF0XA60CZgD8dBTmT4IcBm/de2i2pg4xu4KRDwq6NVCCWa7OBr
	 Ifa2cP9H4J/JbTE/8nWilMlQ9Emngx9c9g01/Sth5XMIVtk1KqhhsV+6AtGSIIMlC026o
	 +1D6Uawjh6oMOVX6xM99743eSsV/EXgx4XMZOVa+kck/0EdrAV/Bx6OzWBZMKpfWWrCBn
	 gzYDwWIeEpVZqPEBm7wBodieIZ3VPSyq6NbeB2RgN55SS7gdZmFe1SFa/KgyxDwL88A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591194;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PGTzIpTFJezj1l8W8MRGXqjeFCFLle3HhV8G9oSlXxk=;
	b=fJlALTMuH5ql0eUHPBxx8ZkEeeEB0UG6uT23tgCj2MbKBfgpwh4fjwlkSwI9lVxwQ5Q7
	 4Q79HHY5/GqR6rdbyW0DcuAdb9kfcey+gD7989U+v2U9xI4LoIZpcVytP8dkO6oe+TU61
	 ICX79Dwb+SlD5QZFdTeONoVNvF+uhol2cr3/UlkGg8CqZDAHsvjgqFZqFbhS4cvNk+Xj0
	 HUUC+Aer2W2ndvCl1Uxui1CGZUD7GclEGGlqPIe/7j0dG2tvp0b+IF6nXBpywXPJC364r
	 w0GBshkmsp2yO2j62zNEpXWElzzOFbk139/8YZKl6rGBkEEJnrK3wyrcrKYHH8Mt1CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z6AqAgNa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123586075840;
	Fri, 13 Nov 2026 17:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z6AqAgNa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B790E1F000C9;
	Fri, 13 Nov 2026 17:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591193;
	bh=PGTzIpTFJezj1l8W8MRGXqjeFCFLle3HhV8G9oSlXxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z6AqAgNaeTB8z0w5UDKu4Z5pCAvrZNP2esIXX8jtIqYmgOwDgtmFs67wCO9v4eNSf
	 4Kb2Qf39LK5bW3FF/gwxsX6gvX/k29fQLc/S2Hgo3qfEVA8kj3z6FguWPaDB1CRtzw
	 K0kDfPWfHHplCYMQ9ZmVhiaEkfpf8QLF7IBC2CkA=
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
Subject: [PATCH 6.12 329/670] mm/madvise: fix data loss from MADV_FREE on a KSM page
Date: Fri, 13 Nov 2026 10:48:13 -0500
Message-ID: <20261113153823.027142555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index ea966d402f073..6ce97106d6d44 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -752,6 +752,15 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
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



