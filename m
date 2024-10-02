Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FFA1D015C;
	Wed,  2 Oct 2024 13:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877074; cv=none; b=WMSky9IALPwmFOKt347WchT1JLOb00Rv+3fWfLGjZNfVugvN+SdKg1pDdMTnGwOsHgzlbgwOPbtSNSh87t0QB09lICqRZLAIfOMcOV9Vp/mgXUHxmvHs0KkXYQOfNO+/RIfIpej2vj6mD4DukBrFf3hn+c57nMk9ykwSDjKTH24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877074; c=relaxed/simple;
	bh=qmBhEDTn5rCs4ld8A1p7cu48ZjFU7iXEJvd4EULYfgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z5ye+HCIw6t4gYwONnbExIvxGYMROUlRe51IR0fjDmKEWmrS+km6IfXs0qfEFrKEDsPP2TjNXI2mHSun6irdKE1NQJuTZhltyQOveaTLAzKpxIM7opzd2Nwy/sS+ukuCoXFNtWDFjFURvwnmDgdCNT8v6gYnTkJcSEmeDv/xqmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1fYdOqab; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1fYdOqab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EF8C4CEC2;
	Wed,  2 Oct 2024 13:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877074;
	bh=qmBhEDTn5rCs4ld8A1p7cu48ZjFU7iXEJvd4EULYfgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1fYdOqabD2GmULCZXYu5KscHpvSnhohHSEe8vpjahQ5szPQA80IPOTt1/zpfqCJ58
	 7o7HVeG3xzo7xS9RRF1wuUTLFMZpBX2pgiLm9KgcROoC9akDq+Z5/Dn+9RZAn32/7L
	 9d3RbPiztd0zREwZWhZd4mkryxfEY7aec7C7VdP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Luca Stefani <luca.stefani.ge1@gmail.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.11 628/695] btrfs: always update fstrim_range on failure in FITRIM ioctl
Date: Wed,  2 Oct 2024 15:00:26 +0200
Message-ID: <20241002125847.583153183@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Stefani <luca.stefani.ge1@gmail.com>

commit 3368597206dc3c6c3c2247ee146beada14c67380 upstream.

Even in case of failure we could've discarded some data and userspace
should be made aware of it, so copy fstrim_range to userspace
regardless.

Also make sure to update the trimmed bytes amount even if
btrfs_trim_free_extents fails.

CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Luca Stefani <luca.stefani.ge1@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent-tree.c |    4 ++--
 fs/btrfs/ioctl.c       |    4 +---
 2 files changed, 3 insertions(+), 5 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6551,13 +6551,13 @@ int btrfs_trim_fs(struct btrfs_fs_info *
 			continue;
 
 		ret = btrfs_trim_free_extents(device, &group_trimmed);
+
+		trimmed += group_trimmed;
 		if (ret) {
 			dev_failed++;
 			dev_ret = ret;
 			break;
 		}
-
-		trimmed += group_trimmed;
 	}
 	mutex_unlock(&fs_devices->device_list_mutex);
 
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -543,13 +543,11 @@ static noinline int btrfs_ioctl_fitrim(s
 
 	range.minlen = max(range.minlen, minlen);
 	ret = btrfs_trim_fs(fs_info, &range);
-	if (ret < 0)
-		return ret;
 
 	if (copy_to_user(arg, &range, sizeof(range)))
 		return -EFAULT;
 
-	return 0;
+	return ret;
 }
 
 int __pure btrfs_is_empty_uuid(const u8 *uuid)


