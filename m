Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB983AC0EB;
	Mon, 23 Mar 2026 14:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277455; cv=none; b=tC9uXzIYcnIfDrNSOQlIjJPXMdNrT7cZrA/Ik2Ve2g+DreJqLlxMbgsWLrFUeXFKk+sHgrd/BViL9cIJe2y/jRitBUxzqgy8QV1VUU67gu5nedxM1wnC90MWmL4z55Gs8sZwDBMnO8Kj7G2SSnbSxdFwdw3HIxhc8Gpbi0lXxJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277455; c=relaxed/simple;
	bh=V+JNWGNPwL2CETUlI41xQqxjExtGPAFCidUVBfJI0yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0aEKahj63y9PrrbLQowIsVp7/5uc23MnLpWdnV1fiBNVG5kM2S1ZdlEzrF5swSjBmxZZtatkQArtzAjsLLSWTOGm0eJmbVp6N+tEQ0Gc5k0lH/IzWlaN/cwi5umIz7/mJ9LdquZ/xpqEOwYDTIeAh9aUrl8J1QOJBEgH401oYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0w1T9FC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0w1T9FC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28025C4CEF7;
	Mon, 23 Mar 2026 14:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277455;
	bh=V+JNWGNPwL2CETUlI41xQqxjExtGPAFCidUVBfJI0yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0w1T9FCzKnAmf0KqOaP0tgbf91S5EMDWuq4Xy6XKgBCkQpFo5zhGmtlrLvHo7qwJ
	 zQBBUH2Tf3/rSjewx+cG8CLa/bV881LvLGatCnAi4DeLMrPKIMfkcfsMO859gvs+sJ
	 9isbs6CQwePqjTediloBqcPcqWRZ58vQRXBV4g3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Kairui Song <kasong@tencent.com>,
	Hugh Dickins <hughd@google.com>,
	kernel test robot <oliver.sang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 446/460] mm: shmem: avoid unpaired folio_unlock() in shmem_swapin_folio()
Date: Mon, 23 Mar 2026 14:47:22 +0100
Message-ID: <20260323134537.542976066@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

commit e08d5f515613a9860bfee7312461a19f422adb5e upstream.

If we get a folio from swap_cache_get_folio() successfully but encounter a
failure before the folio is locked, we will unlock the folio which was not
previously locked.

Put the folio and set it to NULL when a failure occurs before the folio is
locked to fix the issue.

Link: https://lkml.kernel.org/r/20250516170939.965736-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20250516170939.965736-2-shikemeng@huaweicloud.com
Fixes: 058313515d5a ("mm: shmem: fix potential data corruption during shmem swapin")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

[ hughd: removed series cover letter comments ]
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shmem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2198,6 +2198,8 @@ static int shmem_swapin_folio(struct ino
 		 */
 		split_order = shmem_split_large_entry(inode, index, swap, gfp);
 		if (split_order < 0) {
+			folio_put(folio);
+			folio = NULL;
 			error = split_order;
 			goto failed;
 		}


