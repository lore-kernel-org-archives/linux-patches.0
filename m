Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591071;
	b=ik4JcknsnjF3CBp8FfanIxM9PVsG65XQdScZkaI3NinBB1Bc9lxBg3GSWCKFFmfW0gLx
	 IxYjf4RWb5Z+6j0S+lDzVc4HT6yFgNigoPB69eoVssjLc3xGJxOj5TB+qsLy90wG2GfRx
	 fH1bYijCx+UZsxHRMH9Nkdmg4NjSNi9nE7U0Eh6NPFeQn3OEAkUK6w00u08X6xR1eJvps
	 XM6+aDdWq4qC+mzKsEqmJkeN/GSvRsnOGFBL2uV9tkQMsn0waFwg8t8Hwfp9znSGs2mTU
	 /DSM61ztuqgTUNzF4RCGVA0xrDZfxdfud5dXKiu4Pb+0PH2oPhh420ne5SrVEPrw7sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591071;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2tXtRw20/OLyG0JBIfHEP/F0/ELQ+WBz4IcPPWijPS8=;
	b=qxgIjiOmYUwY8smCmON01XXQ7jFeGr34VRE5sPNFtjR852SPCBK5x855iJslVOlen93h
	 WfU9OMOkcyVaSgSGK98Av6EsfyeOvW5VUpQTPh6mi+8OAuaVUYTVxV+fscjliQztDMvd+
	 pWxRxaNwIdJE7xnluyeC2MB+wMJI/zI6B5BNQsm92/3qDAzQIMvDnYBga1x5+6yJQYF+s
	 9YZD+XTv28oZDvdJGj9BfHb61Gpi3b8OJtI54GdGTVd10x1wsYxC7g7uAdTGV7k0yK90V
	 Q2/xOq33DleRhBLnbFfdrmpiL11gerIwNG/wgp66K16KjpNE9p27nMAr2Ioa+97kB9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mFvde7kT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5B7606B35A;
	Fri, 13 Nov 2026 17:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mFvde7kT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6EF1F000C4;
	Fri, 13 Nov 2026 17:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591071;
	bh=2tXtRw20/OLyG0JBIfHEP/F0/ELQ+WBz4IcPPWijPS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mFvde7kTqRT/OdEwXgbbWUDEwwVYumP6Tw8iToeq5iCX3fzFmmByJpF5PGTKgSzQD
	 s53JuAIhks0tR2JuLzR3ASiOiBQtKWNAB4ceTiHe7yvx5qWgIfO8DtX5O+Y1LSd0hF
	 wWteS4pX+ZykVxKe5cZrb4kgDgQyVKSyD7wAXaZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nhat Pham <nphamcs@gmail.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 229/670] mm/shmem: fix truncate loop after boundary swapin failure
Date: Fri, 13 Nov 2026 10:46:33 -0500
Message-ID: <20261113153819.621253816@linuxfoundation.org>
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

[ Upstream commit 5f1ec2cf92a7d655a8eb39711987822f9b1f9d67 ]

If swapping in a large entry at the new EOF fails, shmem_undo_range()
leaves the entry in place. Its final scan skips the entry, then restarts
from the same start index and finds it again. Truncation can loop forever
while holding i_rwsem.

Advance start past the skipped entry so that a restarted scan can finish,
as we already do for folios that cannot be split.

Note that this does not fix the missing zeroing when boundary swapin fails,
it merely prevents the endless loop.

Fixes: 8a1968bd997f ("mm/shmem, swap: fix race of truncate and swap entry split")
Cc: stable@vger.kernel.org
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Link: https://patch.msgid.link/20261029-fixes_shmem-v4-13-392fc715d8f6@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b89ff0879f891..28157cb2e4cec 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1125,14 +1125,16 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 					order = shmem_confirm_swap(mapping, indices[i],
 								   radix_to_swp_entry(folio));
 					/*
-					 * If found a large swap entry cross the end or start
-					 * border, skip it as the truncate_inode_partial_folio
-					 * above should have at least zerod its content once.
+					 * Skip boundary entries when restarting
+					 * the scan to avoid endless loops after
+					 * swapin failure.
 					 */
 					if (order > 0) {
 						base = round_down(base, 1 << order);
-						if (base < start || base + (1 << order) > end)
+						if (base < start || base + (1 << order) > end) {
+							start = max(start, base + (1 << order));
 							continue;
+						}
 					}
 					/* Swap was replaced by page or extended, retry */
 					index = base;
-- 
2.53.0



