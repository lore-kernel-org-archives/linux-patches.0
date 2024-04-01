Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E0A481D1;
	Mon,  1 Apr 2024 16:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988140; cv=none; b=kbEu3IvN1MOPxkQm4pX6kT0aKXD/HPa+KKgwRaYVhd/ojHFM8GVnezu8n8hIYVphjcMxKtksSaJXreGZ+4c/Ob2kSpvZyXb0pHle6/9gqMdzaWeY4kTmAo950ZH2Lwv5wYtXCR13Motqcr73wOQede72pSUSRPyD3tRvPVYegzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988140; c=relaxed/simple;
	bh=WS0K1ceUNeej5O1O6cV4yeTOiP9iRoQhd49Ezvi7DAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqe8KP+9gp+sBH1DncwPZxBXArMIAF4wMQcjFok4pCX0bIuz/2XpKPCW1B36jo4BgNDaczFhvxNNKADj90VhNC265+Y1npOJLquN9xR5ju7rRko04QBlKMh4nn3v6k+aKQZ3RUUYgIHme6UJsb8lan7dwgPep6Q8emH45VhL6DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qDwCTqtU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qDwCTqtU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43935C433C7;
	Mon,  1 Apr 2024 16:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988138;
	bh=WS0K1ceUNeej5O1O6cV4yeTOiP9iRoQhd49Ezvi7DAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qDwCTqtU7fg1RwCd9Itor8/M2Pe++Y5oDV+F0KZowB+Sriu54VFR8A1QunXLXmuu0
	 PVKe8KFAmbnxbb+t0p1mFwcmDcitiVlG6rn2//tKeEVq+NAKSMV1/OCIPzMKiAI8T+
	 GUnVBeA9z7bJSplMjfCZHyHH3f127q0h91jiw6v8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Lyakas <alex.lyakas@zadara.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 095/432] btrfs: fix off-by-one chunk length calculation at contains_pending_extent()
Date: Mon,  1 Apr 2024 17:41:22 +0200
Message-ID: <20240401152555.957538593@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit ae6bd7f9b46a29af52ebfac25d395757e2031d0d ]

At contains_pending_extent() the value of the end offset of a chunk we
found in the device's allocation state io tree is inclusive, so when
we calculate the length we pass to the in_range() macro, we must sum
1 to the expression "physical_end - physical_offset".

In practice the wrong calculation should be harmless as chunks sizes
are never 1 byte and we should never have 1 byte ranges of unallocated
space. Nevertheless fix the wrong calculation.

Reported-by: Alex Lyakas <alex.lyakas@zadara.com>
Link: https://lore.kernel.org/linux-btrfs/CAOcd+r30e-f4R-5x-S7sV22RJPe7+pgwherA6xqN2_qe7o4XTg@mail.gmail.com/
Fixes: 1c11b63eff2a ("btrfs: replace pending/pinned chunks lists with io tree")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f627674b37db5..b7a75bd11632a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1392,7 +1392,7 @@ static bool contains_pending_extent(struct btrfs_device *device, u64 *start,
 
 		if (in_range(physical_start, *start, len) ||
 		    in_range(*start, physical_start,
-			     physical_end - physical_start)) {
+			     physical_end + 1 - physical_start)) {
 			*start = physical_end + 1;
 			return true;
 		}
-- 
2.43.0



