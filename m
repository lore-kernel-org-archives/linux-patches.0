Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019602;
	b=YtjHz4Nl0khBUjdWhRBP982kvApchHWFyPHVbttax4Z5L9ZmBoLIjFbtMr96MMft/6rK
	 aV7J4QcMwzegTr6vSMYE6pJ32uyAChyNNKgY6vTjFGV6dSfj/pAfPXuyeYVxL0qV/uB+H
	 E5vqFVBoEz1UsHnKvu6Q7MKcJbrbEa5yBIghk0Gf6/eewTnPwFm6nWWFcOYyR7gwys15P
	 KjgecY3fDZiuX/HMKWWjF50wdPLL+ZvB5bvYUCvoYktoE9+3B06RUHm1sZKE4zLRCHCJN
	 8OwqwAozY1nxbjeZEIrHcCpkUGmBtueLtKI42W8tG+LRHptz2/F9+9y8GGxhyJiagug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019602;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lODUdFIe74mfd69A11elw3sU896kHEOEoROtr14AFEE=;
	b=0t7Y3smdFNQhXVzuNuWc3+1TGuFFyP8cvd1jO37diZGOkj8vw5xC2D/9FmLSMo1IBtwY
	 ns5YUmPq28chIYz1V59o9nCXQ7vXs9TzkQxZ+XbVQ9/fZ+WBzzwDhMNGqJxdgJIgcAjjF
	 J+UjKVz5tEPWZJ0prKPl/LGJgxQe5dYUq4udVVKvGo8iHc7bhK8lRMl8I5UZnufFAVCde
	 GkxIWRjP/ptGNT8iEt69dihmY0fSfv2q/kfbMOw++aB/w5LHVxO1fuQ7f/W+EiCo6uXvT
	 stlr4Sas4aL/8VrMYlkodRKARsvHMZ9/XKz7foee+kPWf3xrbRphzI7vd4oquTebk4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QWKMdJPc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D321606A7D1;
	Wed, 18 Nov 2026 16:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QWKMdJPc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9461F000C5;
	Wed, 18 Nov 2026 16:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019602;
	bh=lODUdFIe74mfd69A11elw3sU896kHEOEoROtr14AFEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QWKMdJPclaHDTU++2du86G9sgxyN8MESmPr0vRYa85IjOHJEl7NdQqqwRPoaw5Chd
	 qlQ0hieUA9nea7upf0p2B2owlr1c7lJXzATGFJHpL7Nzbhaz8H+IoSA/hCypVIGRhA
	 i4TNfpx72wbY6FKfIimyJqxUQzjfOirW7irWlnQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1653/2651] btrfs: fix off by one super block end offset calculation when writing super blocks
Date: Wed, 18 Nov 2026 15:48:13 +0100
Message-ID: <20261118150347.281561992@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 0f3e8e74b7682..b25028ba74f68 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3909,8 +3909,7 @@ static int write_dev_supers(struct btrfs_device *device,
 			atomic_inc(&device->sb_write_errors);
 			continue;
 		}
-		if (bytenr + BTRFS_SUPER_INFO_SIZE >=
-		    device->commit_total_bytes)
+		if (bytenr + BTRFS_SUPER_INFO_SIZE > device->commit_total_bytes)
 			break;
 
 		btrfs_set_super_bytenr(sb, bytenr_orig);
@@ -3988,8 +3987,7 @@ static int wait_dev_supers(struct btrfs_device *device, int max_mirrors)
 				primary_failed = true;
 			continue;
 		}
-		if (bytenr + BTRFS_SUPER_INFO_SIZE >=
-		    device->commit_total_bytes)
+		if (bytenr + BTRFS_SUPER_INFO_SIZE > device->commit_total_bytes)
 			break;
 
 		folio = filemap_get_folio(device->bdev->bd_mapping,
-- 
2.53.0



