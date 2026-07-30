Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DF644C51A;
	Thu, 30 Jul 2026 15:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425385; cv=none; b=WOUZQ0+8xmdKHP3GErzxTWZ5DXD8Y1+VBdcsCG3gDSipHOQN2qlvA7v+UPauG0J5b6UsfJsm1oHt+ohKunexIcXKoXHsWNCCxGU3RXycetYNEhsodN1f4dVcwBq67XCBwOpEVUC0OAcItYMzYKsq43HGfdgStpoeZayMruA+faQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425385; c=relaxed/simple;
	bh=knlPJ/+S+i+YpLc0caaRd8VPh0E6ule5bCMTGxFED04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LyKRAY4NoPxp9YfECxVIK2MCVlkALpkAaQSAAF92B6I2amNmkO+hN+9KloKhA2Tm7SZPtakMfNB7oYeQpgvqEu56PRJ4sGagfagpP1e5TN6TJZ3JTgriNJn9xVEuNoDNDxEAvUijahUibDm6GDpIPd/BUi5E41IBeGX0A8OwGtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e5ZNXCl3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e5ZNXCl3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DBFE1F00A3A;
	Thu, 30 Jul 2026 15:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425381;
	bh=rI9Vzt6zEO/SEUQ/9Vqku4pXfF8aa0DTx6aWk7jmmzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e5ZNXCl3La9Oksdx9lS/du/dajco/RXR7YYlCrI9zhhv6P8P7DKOb+IJ61yT5Bc4h
	 mauOxi8nJAKdY1YFjR6+zXwwoGdsnIPIJQ5BQscbOtsu9+INEuHy0nrYSu6Adc6s92
	 fMTz0OxQUkpdc0WcN8yTrWco8I47hGvhQG4WJBM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/602] btrfs: fix root leak if its reloc root is unexpected in merge_reloc_roots()
Date: Thu, 30 Jul 2026 16:07:14 +0200
Message-ID: <20260730141436.890911554@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
index 43e8c331168e94..d2a1323e8b1034 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1956,6 +1956,7 @@ void merge_reloc_roots(struct reloc_control *rc)
 				 * corruption, e.g. bad reloc tree key offset.
 				 */
 				ret = -EINVAL;
+				btrfs_put_root(root);
 				goto out;
 			}
 			ret = merge_reloc_root(rc, root);
-- 
2.53.0



