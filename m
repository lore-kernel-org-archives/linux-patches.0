Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590260;
	b=QCTTp/lp/ByczFuYVBSYHhuRohawy2I1nCt8+eStYbJD+CPPHseL2V2YiSLOFbUYBgza
	 s3TmIbFLIO5T/WVl46r0gkN2DFGxxgsk4C+1tsu3AZWuwpGQPyqK5Ov8mkXMP+YLM9OTL
	 J8uJsdMv1bx9NP1iFJPJ+HftCsAp/q9ULSgVHX9y4yctZChinUj4DfAwi0ZiLA1LyO49m
	 S/JJlaiFjNa7WtrMSQZIhelwZe8q0cvxta4cJO5i6rbSYgd9x9lzl35S5qQ0+fF1JVONy
	 xb/5uPKOXVqEaLcQPcufoPt2AU+K8PSyV4ocf4bmebU9+ZAz8HS2o/ZFMLKNwwmSn6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590260;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Av9nxfPh4CGVTv2R2a1ookLoVDhwdGLaAD5makudT84=;
	b=x4ARd/1k1bfjmN8Pjwas+Y0YWNBhSCWxznP6R7BeYClBpGoA6b6Mwv7FAZd+bgbsMx4c
	 eLLnHEmth/5rPyLq3mDZXsber3LeXxd8SyL6uVyadjTMtz3QuGaADkTutL1UWvJsCOUj5
	 m+fPJKt3wmWIMay8FU/oTdy30aX5/jLnBsiW4Brk+N6w0c36YcMComjn1mePWevQn5YgD
	 Ty7D1Hl7tC3Hu1C+yiO4lw63Vs5iHCICH194qFlzoX0ogImnBomMgnCooLLLMgUDnZVyR
	 pnjDbHqwZnVpqtPXw4SN4gP0uZNBS8zO7SVAG1doypaHOuYQzuG2EHTq//LFMusHPvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xAM6HTxP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAED60A3818;
	Fri, 13 Nov 2026 17:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xAM6HTxP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFFC1F000C4;
	Fri, 13 Nov 2026 17:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590260;
	bh=Av9nxfPh4CGVTv2R2a1ookLoVDhwdGLaAD5makudT84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xAM6HTxPPcGfZt4LAUxciAFCLkw/Ea7q+0pk8ZtVaYqf6Vv4ayxL5YSO3vLv0gyNR
	 rFsUyLsq9VMM/PFgoraGYDlnOZZfs/10Bw4u7E4d6t1CA+rds5I3CMrmKJE9TkMUxP
	 MS1eCHCWR8NIxXpXpsw/El5GJf+FLx9usV++Pkwc=
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
Subject: [PATCH 6.18 254/686] mm/shmem: fix truncate loop after boundary swapin failure
Date: Fri, 13 Nov 2026 10:46:27 -0500
Message-ID: <20261113153829.644185472@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index 4c5e07c8f3173..169ba30664782 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1197,14 +1197,16 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
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



