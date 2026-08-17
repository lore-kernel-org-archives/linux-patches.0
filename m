Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3CB2773EC;
	Mon, 17 Aug 2026 15:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978988; cv=none; b=Xr18EdAgp++Txr103VTPeUum5v/It3I6QlwxyuK6+Mr2IAsojKQiMyUvC4lfQoNN5Byoh7jbUsG0f8h9urnJKoy2futbgA6uQmZ7kOJHdYzbE+vKBwO/X1EPwF+PP3A5V792XmSOmR5a+bwtshi9aOhaJPFph2Xi2aoiIGt+jt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978988; c=relaxed/simple;
	bh=iBzl+dEAbgrMJYl27k4LqRuAA/wziQCiWqjuVMUkDe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvT0yRXFSAItRAVU/SP1ddODFJ1rrpfBPBuSZP3cSxB3gXzG8+R8jelu5LxZRZTVTN4FNRCChaCvUbs/GsQLmS0Ob1YRZosUB3kSGVfYrP1EMc1P0uN50aqRoSK+aT0Q+fcMqOJdlUnjDEE4FFyqOZCRKFJINlu0XJYhYM8Q5r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dKeCKwUH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dKeCKwUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306671F000E9;
	Mon, 17 Aug 2026 15:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978986;
	bh=XVpU+wdw8pw4GLq4wf5GDJ++PN8wp85MFiznXJNT5hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dKeCKwUHFeIU0q3ioA770KlmZgWMplJpHmvFKSLjp9AvvGKC2Emyz1lZY83FJE4MT
	 8vk0K7sf4aVX+dhQ4TNoz+4pFRzPFFlS/1z8R7AtHuOaugbKuMXLgVueFYwizoglet
	 WzajI6BbDJh4z5D7wGQmx6F9zPvodr/5dgcLxdF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/609] btrfs: fix root leak if its reloc root is unexpected in merge_reloc_roots()
Date: Mon, 17 Aug 2026 15:25:25 +0200
Message-ID: <20260817132544.219578202@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 93916c52b50e94..2e66a0672ba7fa 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2045,6 +2045,7 @@ void merge_reloc_roots(struct reloc_control *rc)
 				 * corruption, e.g. bad reloc tree key offset.
 				 */
 				ret = -EINVAL;
+				btrfs_put_root(root);
 				goto out;
 			}
 			ret = merge_reloc_root(rc, root);
-- 
2.53.0



