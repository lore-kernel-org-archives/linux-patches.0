Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B881F396582;
	Thu, 12 Mar 2026 20:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346408; cv=none; b=Y5fbF1ooVVZwzvS6kJcAo8QqpoE5SxV9g0AuafUF66CAJbzlWvpgb+lc2/ZlVCmX6IQe4Pd0VkRxKlXma9x9v5utVrNREc708Z6GMkUcId28YAeoycwMYVtDu2XKYSDxWDsnb5HclkR8Qfen9IB/x+cvMrM2+ek6W7DDjZr54vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346408; c=relaxed/simple;
	bh=xqapVojFydFXQsPQLdXDh3Rk+EDXGhD1XwIjjDGr1W4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JWGX42ODIQfEH6pC0+AlcFZh+ajotN6zM9Zju1HzwAjNhPJKS9IdQB4yHIXschTsa0w05ujsoCCfJV3+n7I918ch3soBqK9Cc+9BlgzLONrqSvkzOC7Im0K1mmDdgBb65eQojlHRf6jZI3/YLdHsSXuMoXWlseKOACY2ZpEQWVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nhaBXzQA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nhaBXzQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B00C4CEF7;
	Thu, 12 Mar 2026 20:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346408;
	bh=xqapVojFydFXQsPQLdXDh3Rk+EDXGhD1XwIjjDGr1W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nhaBXzQA3HgJ7YjEcxNGpLlA1wKgYhKNs1gpFRjsiFIYGnRZtJsmGmeyICXh23XPR
	 epmRNf3ic/OPpg0wj0ztP4vCRvkn6tM+epW8cxkxWLl6k2bJZeR9V63Zx9FQBHrwIO
	 cFwSvanS8axNVrZSpTO0oZg70JYXneMG5apFPoRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Mark Harmstone <mark@harmstone.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/265] btrfs: fix warning in scrub_verify_one_metadata()
Date: Thu, 12 Mar 2026 21:07:02 +0100
Message-ID: <20260312201019.458492197@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Mark Harmstone <mark@harmstone.com>

[ Upstream commit 44e2fda66427a0442d8d2c0e6443256fb458ab6b ]

Commit b471965fdb2d ("btrfs: fix replace/scrub failure with
metadata_uuid") fixed the comparison in scrub_verify_one_metadata() to
use metadata_uuid rather than fsid, but left the warning as it was. Fix
it so it matches what we're doing.

Fixes: b471965fdb2d ("btrfs: fix replace/scrub failure with metadata_uuid")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Mark Harmstone <mark@harmstone.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 3cbb9f22d3944..513c2bfa8d628 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -634,7 +634,7 @@ static void scrub_verify_one_metadata(struct scrub_stripe *stripe, int sector_nr
 		btrfs_warn_rl(fs_info,
 		"tree block %llu mirror %u has bad fsid, has %pU want %pU",
 			      logical, stripe->mirror_num,
-			      header->fsid, fs_info->fs_devices->fsid);
+			      header->fsid, fs_info->fs_devices->metadata_uuid);
 		return;
 	}
 	if (memcmp(header->chunk_tree_uuid, fs_info->chunk_tree_uuid,
-- 
2.51.0



