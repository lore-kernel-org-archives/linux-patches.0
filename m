Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B76432E94;
	Thu, 30 Jul 2026 14:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423431; cv=none; b=JRWuOfU83uUTu5yD+8y0X+raVqa9WEWhgWq59KHrXQXhefYIuHVNvxEEGZs1aoaDHlEUZutk+t/EpdtObX9Unkh/F3QwdfHE2TREab/R6UaGecniWiCGeFAqu51jzroGrg+BvjZUxplr8nBi0BEWYYatYSVulB24iL76P1bBcBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423431; c=relaxed/simple;
	bh=cLVGnWfkEm23HaiLBGIBkdC0OxGqyUmUN4xSA/W5958=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uP11aSvMY2qwbWVXjdYfwP0gz9u/w1k845o5R5R1tFBuMmfdKuTlO8CuDDKbA3HvcegqY28kVHjoIay7JHYKFgPWlvUk3PjiTf/K7c8q6xaGReByerC8aNwWmiJKnItn6IB7seoMqjYIJUFl94e0vqnuzY8651lPSOQMv1DuJ/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1q9qQQfj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1q9qQQfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497731F000E9;
	Thu, 30 Jul 2026 14:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423429;
	bh=MToGKQT+dWrZN5qAQGMHoIG/RXAvbgGM07QetdNk51E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1q9qQQfjvC+o75l4SZdy//XiINcNeDfqoBKzwVY0yEPnM+uzEvs7tHI/1/+h/5NET
	 056aYD5wMinkMsNTUVQF0/JnDNzVxhEFJ5vP0lmr0zteVVjdxlY/8699U870ISX8rf
	 +GYMZuIFzlW8BwJC2GMCKBetH+ExH7Pvvg+G0hkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 042/675] btrfs: fix root leak if its reloc root is unexpected in merge_reloc_roots()
Date: Thu, 30 Jul 2026 16:06:12 +0200
Message-ID: <20260730141446.015340605@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index fc76013b1a3e01..ea68328d289cba 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1857,6 +1857,7 @@ void merge_reloc_roots(struct reloc_control *rc)
 				 * corruption, e.g. bad reloc tree key offset.
 				 */
 				ret = -EINVAL;
+				btrfs_put_root(root);
 				goto out;
 			}
 			ret = merge_reloc_root(rc, root);
-- 
2.53.0



