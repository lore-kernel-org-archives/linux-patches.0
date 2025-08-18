Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD78C335BB3;
	Mon, 18 Aug 2025 13:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524455; cv=none; b=JPVnpUZSRV/jBxiFxWZQpaF8nWLTldFLUgR/uzQBhxh0buKuAzgmg9SaW55iDpf4Hquji4FB2w+zjzggDI/6mPJAO/xqSvMm/KY2MIcOFnbOVGjiS5zY2BKTK4o1QI6UhJndMzVjNjkV/b2Woh+urKdwUu8Hoqp4u7CgtOFKLXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524455; c=relaxed/simple;
	bh=YyD4TPkFo0frsr4b4tcIa7OcBv/eLCCOV6172wUpCFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHE2szlKLFE2OupZXz6AIXoEw3vpG0MIsk4MV1A9Oa9oCfRwE/v7BjtBU4kqJZ05yCT6AKh3R/l37UuTKPel41J6GS0APyqJZxJzCAr9C2fRy0d58aQtQvefixYuY9SGF25O5JKoP+JG8NR+bfW8CYeAJezhxcrbjbUJLuV/K2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J5mmWocu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J5mmWocu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CE4C4CEF1;
	Mon, 18 Aug 2025 13:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524455;
	bh=YyD4TPkFo0frsr4b4tcIa7OcBv/eLCCOV6172wUpCFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J5mmWocucHKKHCRvls33gPuQvFpXH+jA+b3eo0Rq2L0qnddnTbZjSTbaSlFEnYWtw
	 ++gUOLm5FvUjubUn9gySYd8E25q/GJmaaCQVN4rAt0DIUrtG6ROu+FtHLrxxyFmTtJ
	 lCyA3A/o225x9dgzej6cYY9Y1rPsaAjpOaRdKCLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.15 478/515] btrfs: zoned: do not select metadata BG as finish target
Date: Mon, 18 Aug 2025 14:47:44 +0200
Message-ID: <20250818124516.823151882@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 3a931e9b39c7ff8066657042f5f00d3b7e6ad315 upstream.

We call btrfs_zone_finish_one_bg() to zone finish one block group and make
room to activate another block group. Currently, we can choose a metadata
block group as a target. But, as we reserve an active metadata block group,
we no longer want to select a metadata block group. So, skip it in the
loop.

CC: stable@vger.kernel.org # 6.6+
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2544,7 +2544,7 @@ int btrfs_zone_finish_one_bg(struct btrf
 
 		spin_lock(&block_group->lock);
 		if (block_group->reserved || block_group->alloc_offset == 0 ||
-		    (block_group->flags & BTRFS_BLOCK_GROUP_SYSTEM) ||
+		    !(block_group->flags & BTRFS_BLOCK_GROUP_DATA) ||
 		    test_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &block_group->runtime_flags)) {
 			spin_unlock(&block_group->lock);
 			continue;


