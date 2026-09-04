Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CED3ECBDA;
	Fri,  4 Sep 2026 06:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501722; cv=none; b=Wz+gjLROXxxDj3yxuk+5HNBelf8nRu5f4xY/0KCDC5otv/wwZN4C8HqyWFDxsY4lSYI5nKB4GwwGwPtRBWMcH74GjiNA1blNBIQqfTsUjbRNOHgDT6/8GsO8PM4bCdQCu3yh2e/Ndjed/Nb+NufL/mkNpRywVlwgA2Fu+crE0Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501722; c=relaxed/simple;
	bh=lCIgV+3FCSShCbLLYEIGqbluufFsYUje5WpUyd4jpL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qS9/cYTvh11N5qI79dwVLHAqOHczsitUVGky5MYkbyi3vFKeCgxKjUqarpYuqJhQGzhE+BURMk+1RO7RiUkTHdOCMu6fzQCvN/FZdpxtVsWMDIKrq7knqTgoDxPO9SMMvI5gfoU4d6A7NvT0+gwy8C3hEAowTN2bNRPiwT896yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTGnJH4E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTGnJH4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377F51F00A3D;
	Fri,  4 Sep 2026 06:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501720;
	bh=Gtj+fNj4ExPkk9wLaiAwK/1lp8fnuVNUljma7wKq7E0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QTGnJH4EZ72qJQ6+4+hE2PWYhias6aQnJugtdVaWpJR3U3FE5nXf0YezpG53ekjR9
	 WrCskwjuxtV8aa8t1SS1CyzwC8GE8B19PuJD8CodewbBMGNmi3ZGPHrB0/kOe+EGP8
	 xppoQqR3BuEczcZxl6npWxziOBPjoAv7YbvnWOrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 509/552] dm-pcache: bound the persisted tail-position offset
Date: Fri,  4 Sep 2026 07:01:06 +0200
Message-ID: <20260904045802.180928733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

commit d1898576090a10d2ac2715218a652e78fb65a6b0 upstream.

cache_pos_decode() takes the persisted key_tail and dirty_tail seg_off from
the cache device and addresses within the segment with it. A seg_off at or
past the segment data_size, controllable by whoever supplies the device
(CAP_SYS_ADMIN), reads past the segment data.

Reject a decoded seg_off that is not below the segment data_size.

Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-pcache/cache.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/md/dm-pcache/cache.c
+++ b/drivers/md/dm-pcache/cache.c
@@ -119,6 +119,10 @@ int cache_pos_decode(struct pcache_cache
 		return -EIO;
 
 	pos->cache_seg = &cache->segments[latest.cache_seg_id];
+
+	if (latest.seg_off >= pos->cache_seg->segment.data_size)
+		return -EIO;
+
 	pos->seg_off = latest.seg_off;
 	*seq = latest.header.seq;
 	*index = (latest_addr - pos_onmedia);


