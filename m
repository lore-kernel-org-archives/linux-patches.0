Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041255;
	b=eCz2nKIMBb+DUMM8KDERYIhjfMKRqN6b1IudNoQz2t3dLPjEeeD++NCCdguGVcbXu+U9
	 AX9xtb5ufDQqjfASFPknrk/0ON+uBf5x3N/4h5C0ywyL4XDPmAexYQz7SLit8hALkrLzL
	 An3aE3vXI6xT4VXOs/cg3HJ0Y6+VNogcmhCL4GGbXMaadR5S1goJ8h6Ls1MxVO6xpStHI
	 alVlO50pQ3W61lZor5b0qE5n+akdErspNNC8GAFLS3U1bfH8Pvx+SeGgmYHjGyDkUFGL4
	 v6jsBs1QZmcv9/PTe1IoNl9pMdoe/uXz+euolo1i5aNHcmzEekga1zfLIrF5/VTlcKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3joX8OUha7FGr5VIwqMmBgz6/I5zeYwxbphiHd66OK0=;
	b=usMQubQFI9maMMtbw7w1WNjj0Ottub6kA7f60AKONpD4T8XkUylkLR0oan6YrqVx9iO6
	 cffvT8CkIcG2L+0RJVBSPUepPokowjzmNBNO2iVTAplRpQQ71YDOEZ4lYyDrKUxVZyNuE
	 isHBj5E6xvWI/MB8XJrDUKtfdqpQ++wn7Lg/KqvTQgVC9LL41kf9BqhQvb4O4n57CPLPU
	 gMkyxZFs5OOyTv5LUIl+mHjf+eKUamrOY9Ezh9QMIoZENM+ROn4bsr1T+lslLEG74vDn9
	 xM+A//iMbMahFk5ktaX9hVX98TxMyh+AVuTV181bWJw3OG06ahHGv6+f1MSCvu2r7VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V6m99fEq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2DE606A31C;
	Wed, 18 Nov 2026 22:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V6m99fEq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409FB1F000C5;
	Wed, 18 Nov 2026 22:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041255;
	bh=3joX8OUha7FGr5VIwqMmBgz6/I5zeYwxbphiHd66OK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V6m99fEqpiCJKsQ61jtxrAofi39emj9J9X9PubjtyYAJIrBFx2xEZQi0CjSO00FqU
	 eF1JJMVZGwnKmsExeHLalur0421lfdXKrT5QabiaUfnobNiNaxopYIy45Y6UwwfZxO
	 gGAiL7j58y+spEBI9/LC5PggFieGbif2nIjEOjE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2747/3318] btrfs: fix off by one super block end offset calculation when writing super blocks
Date: Wed, 18 Nov 2026 15:56:09 +0100
Message-ID: <20261118150443.179026494@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 7884a8f3279c28ff990e2eacd5c2479bb1c930d0 ]

We are skipping the write of a super block mirror if its end offset
matches exactly the device's end offset. This happens because we are using
a greater than or equals comparison instead of just a greater than
comparison.

Fixes: 935e5cc935bc ("Btrfs: fix wrong disk size when writing super blocks")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 20253e3e5f820..201ef6dcb82a2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3784,8 +3784,7 @@ static int write_dev_supers(struct btrfs_device *device,
 			errors++;
 			continue;
 		}
-		if (bytenr + BTRFS_SUPER_INFO_SIZE >=
-		    device->commit_total_bytes)
+		if (bytenr + BTRFS_SUPER_INFO_SIZE > device->commit_total_bytes)
 			break;
 
 		btrfs_set_super_bytenr(sb, bytenr_orig);
@@ -3871,8 +3870,7 @@ static int wait_dev_supers(struct btrfs_device *device, int max_mirrors)
 				primary_failed = true;
 			continue;
 		}
-		if (bytenr + BTRFS_SUPER_INFO_SIZE >=
-		    device->commit_total_bytes)
+		if (bytenr + BTRFS_SUPER_INFO_SIZE > device->commit_total_bytes)
 			break;
 
 		page = find_get_page(device->bdev->bd_inode->i_mapping,
-- 
2.53.0



