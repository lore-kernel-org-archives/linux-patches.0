Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026216;
	b=pr+OzKz7kZ4D6rLorHwN5E02zlWa9Y67TTtzSQ1vVAdB+nGD9ndjTB+pG0EfmnO5cUfh
	 sl3FUuyJdnaLaLBLUlVpFieP3jd8aRejzUHTfv4skkevn9V/o3BANpMHfYwAal7Fq1ZTv
	 6VRcNAALdAwTY5+2DPWHWFIXyYuUNdv92oTSTvzd7ugmeSQb+VfuCezW0arIOyfHCgEbX
	 ibKBgCNqdqQWxXb07iAvnBWG7yZIzdeiJv6RbYa6dRMn0H3DQkS8sxf4ArzrL3f7M+lHY
	 0m7SNJfP3Afdotr3w4CMhIf+7jUFdu5xUJlZ4A5jSJhte7ov6n5lbxEwwrnsPXHE6rQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JUkiQDLd73kbvB8vFYHwZbsohhYyn58nFlM0lBLMgjA=;
	b=ZPr1PsyqXKILPvtZwe8gPZ40iDRzEfV8+sDXOzjODjVNKUznSHiAnM8bOas4YnviTSB0
	 12OlGkI99td9j0V7nRdpOLshDiB1qXdfyMVgA1HLyQWFO6+FDQrsKYOUJsSrkvf1H/XEo
	 CWUJ8gO91aFsFID24OOTljH8J7rShwb85LELNqOxOmO5tXWwUDPDOJO+Woo7coP8kqk6a
	 OYEUhnHJiRICIBeKCFXB2Gpi7vU4jVsgTUy38t6ySjL+4L/nTZ2Z2sIMPs+4xfZtGqj9a
	 ZvC/RmCgupeG4MGEPbZZwgB1NsNvEwvfqnomQ8m5w6JvzMkwgLfXEqYryeOgbV/RDaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w8abWD5U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13890606A320;
	Wed, 18 Nov 2026 18:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w8abWD5U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A92A1F000C4;
	Wed, 18 Nov 2026 18:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026215;
	bh=JUkiQDLd73kbvB8vFYHwZbsohhYyn58nFlM0lBLMgjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w8abWD5UPI7xQEzXwQ6SE+3XoDw/sn2cgVviSYaa37mSMJuQe2J0akstZjUnqZua5
	 vfG9yUujVsHGiMIDXtp/MUAHPjTkKIFlKpGw9pMJ8BhW0jpGXcutlIivHNzINr0H5R
	 q9NWz+57ICgzGIIaO0O+7MkeM+oUKGiZe4HBUcNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1356/2151] btrfs: fix off by one super block end offset calculation when writing super blocks
Date: Wed, 18 Nov 2026 15:51:31 +0100
Message-ID: <20261118150211.426252165@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 2af30d1009783..08680c2511e3a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3824,8 +3824,7 @@ static int write_dev_supers(struct btrfs_device *device,
 			atomic_inc(&device->sb_write_errors);
 			continue;
 		}
-		if (bytenr + BTRFS_SUPER_INFO_SIZE >=
-		    device->commit_total_bytes)
+		if (bytenr + BTRFS_SUPER_INFO_SIZE > device->commit_total_bytes)
 			break;
 
 		btrfs_set_super_bytenr(sb, bytenr_orig);
@@ -3907,8 +3906,7 @@ static int wait_dev_supers(struct btrfs_device *device, int max_mirrors)
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



