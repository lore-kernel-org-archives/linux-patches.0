Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C951A00CE;
	Tue, 21 Oct 2025 20:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077196; cv=none; b=KvogruUcQLt5QZ2M1rpl4HLjVUjeG3cn/Eeo73qGmvMFvS4Yf1d2LnRLvIW7c56ARI/e87psJW4rE93xVQPLE060EylBSO8YynGwZJ2VAslBqdXR6J/aH5dK55R/SmTe4TvVASYuTAUOO6JDnQLM7DZfqYM1wuURsvozaVXPoZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077196; c=relaxed/simple;
	bh=ptkcywSZQMJ1TCZnwRj0wHBREUlozryG8euG0zRf9k8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KW/eM0qDvqljg1Y9/nMwhVL15fHeqCNQxJFVjfYKUuVk4wCtFTF6aT8jjiYJu6vPHjOpBCGOc1xbR7yMgfgR1EyU0EfNho6gSzizz684V5BobQQxQf1pHN/QqA1XFw073pHZAsZrvtcTkN3d2VJY10k9Vt72cXqQa5oDwqUQr/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xLR/8KEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLR/8KEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFB5C4CEF1;
	Tue, 21 Oct 2025 20:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077196;
	bh=ptkcywSZQMJ1TCZnwRj0wHBREUlozryG8euG0zRf9k8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xLR/8KEzP2RIPUVaGU/A+i0G78Lub17hkkSIAn+9ESRScBYftuXPx8REbSvG9NetQ
	 KII9qjEDks7niOYDVHvsl/6dAlMFHIdr+shcxK/j4rEq4FUZCiTyHEFNsO/JOKkdK+
	 FK3wd2ajwP+psqc4SfmQw0mRaMm6c95TKMckBRY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	=?UTF-8?q?Miquel=20Sabat=C3=A9=20Sol=C3=A0?= <mssola@mssola.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.17 029/159] btrfs: fix memory leaks when rejecting a non SINGLE data profile without an RST
Date: Tue, 21 Oct 2025 21:50:06 +0200
Message-ID: <20251021195043.896109637@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Sabaté Solà <mssola@mssola.com>

commit fec9b9d3ced39f16be8d7afdf81f4dd2653da319 upstream.

At the end of btrfs_load_block_group_zone_info() the first thing we do
is to ensure that if the mapping type is not a SINGLE one and there is
no RAID stripe tree, then we return early with an error.

Doing that, though, prevents the code from running the last calls from
this function which are about freeing memory allocated during its
run. Hence, in this case, instead of returning early, we set the ret
value and fall through the rest of the cleanup code.

Fixes: 5906333cc4af ("btrfs: zoned: don't skip block group profile checks on conventional zones")
CC: stable@vger.kernel.org # 6.8+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Miquel Sabaté Solà <mssola@mssola.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1753,7 +1753,7 @@ out:
 	    !fs_info->stripe_root) {
 		btrfs_err(fs_info, "zoned: data %s needs raid-stripe-tree",
 			  btrfs_bg_type_to_raid_name(map->type));
-		return -EINVAL;
+		ret = -EINVAL;
 	}
 
 	if (cache->alloc_offset > cache->zone_capacity) {


