Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5159F446AC;
	Mon,  1 Apr 2024 16:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987643; cv=none; b=scJwe3ocxv4zufNYmecTBlMJulhkZEQc4CbMwkHZ+1+8DA+2+O0484H9eAKnwoxTpvjtQ8nUXQFggqqvSKX/bxcexva9vyPxNsM9aaQWaauer1PDdO8MQtv9NeCqoOtRzcMDQ8M3+m14mJoIb32J6kCLmop24pBKPjzt9sD8134=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987643; c=relaxed/simple;
	bh=U9Vum0xksbSlshPAywr7+ZymbU3g0g2Y/vw4s2m+8mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dzyc5RXKW6RRB5wuqhKYMiGXG5rU+vsKXpi7ytQU6Fgbz/DfQvc3Ul5N3is/KkHCvwp2JO2ROmGPtm/JRTzl2VdUxPQqY8GIzIRsPSCRXsasc7vNMdsuNlx4XNjyMOvUKfxeJQ6ncbdvb/Favn8v85BGNfBoOskQwf9ujWsLDJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0kPejNH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0kPejNH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846AAC433C7;
	Mon,  1 Apr 2024 16:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987643;
	bh=U9Vum0xksbSlshPAywr7+ZymbU3g0g2Y/vw4s2m+8mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0kPejNH4LBbvZDH6lukcaL1PWB3xtL30vOyPzBn1tiCUiNY2G3igrnO2cLWkkHytd
	 BHlyMEPoW7spz7Ld2yoTKLp7NUO9Bt0ByYyC2gkko5TtnxZD5gxNim2o5dYVgsOHH3
	 XAk4pC405b8bIpt7c5/YuX7idMQbXdR6X+YeC5B4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Anand Jain <anand.jain@oracle.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 348/399] btrfs: fix extent map leak in unexpected scenario at unpin_extent_cache()
Date: Mon,  1 Apr 2024 17:45:14 +0200
Message-ID: <20240401152559.563360203@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 8a565ec04d6c43f330e7401e5af3458431b29bc6 ]

At unpin_extent_cache() if we happen to find an extent map with an
unexpected start offset, we jump to the 'out' label and never release the
reference we added to the extent map through the call to
lookup_extent_mapping(), therefore resulting in a leak. So fix this by
moving the free_extent_map() under the 'out' label.

Fixes: c03c89f821e5 ("btrfs: handle errors returned from unpin_extent_cache()")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_map.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index c02039db5d247..76378382dd8c4 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -342,9 +342,9 @@ int unpin_extent_cache(struct btrfs_inode *inode, u64 start, u64 len, u64 gen)
 		em->mod_len = em->len;
 	}
 
-	free_extent_map(em);
 out:
 	write_unlock(&tree->lock);
+	free_extent_map(em);
 	return ret;
 
 }
-- 
2.43.0



