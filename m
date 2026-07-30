Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0169843CEC4;
	Thu, 30 Jul 2026 15:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427054; cv=none; b=i/9shJ+MMMhQnNjW/QIcHlHdk7TqVpOboII8vVup5hinGDCYd/CwSnH3EzqSvgP4VHnD2BugZw0x/K6pwpnpooleVK30dZ5ZjxB5k7NQeUJoZbzhVxvznGn7Aj89FKVRrps373zmKd5ojxau52h7jZlVJnZJvxF59hERPePSJWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427054; c=relaxed/simple;
	bh=EdnkOhjMDlKqbwT55CaRK9WzQwcYcwcDfmLA/nkq80s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMulr6EnVNwPKX9LlpZUlxwHOJcbjWwe0qxNlS52LksdzUga3BJZCaNfnLPF+DWVfnANs1Qmcuw8/5B04N0CQIggzYCdosQsPSYrWgMgPVZ4XbQxwtY9W7SvYRMFXlpge4LbdYqRDkqfo/THGsJ0pf/RKTr+M5vjKVccGdCt/Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0/JNr7B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0/JNr7B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A23F1F000E9;
	Thu, 30 Jul 2026 15:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427052;
	bh=/xmqe841zrs67adk2TiPRHs2NWmoJl0vJNg/E6PaD74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F0/JNr7BtkjDqesSETWBhcLWfDb/D8B2fy1j910NLOQF1vpo9wqu6xzvSM2d/GJHt
	 wFAd4yRUg+mGiNMRbWuVssc81e6sBDy/2VpvQi9+WkN/UaxQ9hk5dl5T+k1dSk3j06
	 YGle2y3lyB1UbN/LCsFHzmc3QoGorq4zev94d9cM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/484] btrfs: fix root leak if its reloc root is unexpected in merge_reloc_roots()
Date: Thu, 30 Jul 2026 16:08:51 +0200
Message-ID: <20260730141424.166517248@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit ce6050bafb4e33377dc17fcc357736bfc351180c ]

If we have an unexpected reloc_root for our root, we jump to the out label
but never drop the reference we obtained for root, resulting in a leak.
Add a missing btrfs_put_root() call.

Fixes: 24213fa46c70 ("btrfs: do proper error handling in merge_reloc_roots")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/relocation.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 0f05eb97925fdd..90aacda2523eb5 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1991,6 +1991,7 @@ void merge_reloc_roots(struct reloc_control *rc)
 				 * corruption, e.g. bad reloc tree key offset.
 				 */
 				ret = -EINVAL;
+				btrfs_put_root(root);
 				goto out;
 			}
 			ret = merge_reloc_root(rc, root);
-- 
2.53.0



