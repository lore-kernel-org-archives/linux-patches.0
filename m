Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B678F20F88
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:08:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34463C433C8;
	Fri, 21 Jul 2023 19:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966504;
	bh=0hphxRKA0bVY0j62tPdwg7MJY7Evx7AvAMEiZd2eCd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=moknSJBlq95RQo2RwDugOWoX3XTgXVI44ncO0c6wfCROHAT3uz+eeQgOrMgJVOoO/
	 jCgWHkF1sxVjpIBYuMzUeJZh8hBvnF83+mwHUtgS67HzDYENj3IRPyW9tDlj1dOwpv
	 x1RC5NrYxuxU6JcqdajodqQNxMSacE1zT49LB3jU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 367/532] btrfs: reinsert BGs failed to reclaim
Date: Fri, 21 Jul 2023 18:04:31 +0200
Message-ID: <20230721160634.381658747@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Naohiro Aota <naota@elisp.net>

commit 7e27180994383b7c741ad87749db01e4989a02ba upstream.

The reclaim process can temporarily fail. For example, if the space is
getting tight, it fails to make the block group read-only. If there are no
further writes on that block group, the block group will never get back to
the reclaim list, and the BG never gets reclaimed. In a certain workload,
we can leave many such block groups never reclaimed.

So, let's get it back to the list and give it a chance to be reclaimed.

Fixes: 18bb8bbf13c1 ("btrfs: zoned: automatically reclaim zones")
CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1580,6 +1580,8 @@ void btrfs_reclaim_bgs_work(struct work_
 		}
 
 next:
+		if (ret)
+			btrfs_mark_bg_to_reclaim(bg);
 		btrfs_put_block_group(bg);
 
 		mutex_unlock(&fs_info->reclaim_bgs_lock);


