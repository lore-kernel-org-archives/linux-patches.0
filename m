Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BFF13790B;
	Mon, 17 Aug 2026 14:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976555; cv=none; b=BaxBthGAaScq2wXFBPGjGUPXtuiZ+axbujjar3IP565gRE432ztLG7CdO+/6zPqI1XDc/rWBDmsu7MajjGMVZ+zJ61saWZS/ReCualZzNUqvQWLN6tBgYHbz9EEtQuxjpslOtZY2uLlUycLGomdPi9lQWdPwGicbtvkBMfEovL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976555; c=relaxed/simple;
	bh=03knbUVrpfV8MiFMd8ct0cRxvejasDikTOl0ebDQhSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQwqsr57oILVV1mXZHhZIHonIVG1SKoZR8rHcP3xMktagCWIsuliLo+KBiff5EZjBxCi0gQ3M1Y10aOpGobX2xfQY1ChbkRJWpnBliHUTPdXK0dkU11op4mKRl0qhYhBPtTOt+C4lVPYr8xrgG1MNoprYrrQQ+60ZFVieOLtAmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u50uCuWq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u50uCuWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBA61F00A3D;
	Mon, 17 Aug 2026 14:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976554;
	bh=ShI+b1NRuMKAqe8HKeCzTWz3e5wYP1Ux8NeUbtdkTwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u50uCuWqRxwqgnCgTsZJDO56/1V0K8yoftGEddV/zV7TCEjrQD0TkUXwne+roXG8x
	 RGUyMbXqGV9STdWIMiVOlPGZOnrXKsF+FpgeL0qJSWLIJnp4iM6vq/QmQj/9Z23RJn
	 9r7m2Z/z8XFhakh9GHivZd442DqxLOUqGo6gNns0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/456] btrfs: fix root leak if its reloc root is unexpected in merge_reloc_roots()
Date: Mon, 17 Aug 2026 15:26:46 +0200
Message-ID: <20260817132540.540560083@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e66ec0c23153ea..2c4130c3120175 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2047,6 +2047,7 @@ void merge_reloc_roots(struct reloc_control *rc)
 				 * corruption, e.g. bad reloc tree key offset.
 				 */
 				ret = -EINVAL;
+				btrfs_put_root(root);
 				goto out;
 			}
 			ret = merge_reloc_root(rc, root);
-- 
2.53.0



