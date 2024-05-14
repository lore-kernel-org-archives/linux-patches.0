Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3874D12EBCE;
	Tue, 14 May 2024 11:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685753; cv=none; b=PQg9cmdzL36yDYTQTOzDhGcw0zyiFj6x/fiPnTBIuf5EfWKXMef7lNttwr2m9FrqB+A3qrmR24DNXQSD0+5/fD4U79hrpzHnEyM9fm7tda4wybqqVHRr8dfUcZl05cV7MRc6rT8JTMdJmxcrVrJaBw68MxwNQCsff2RnSXIcgDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685753; c=relaxed/simple;
	bh=//pL/qtSaBcF9ay4inLVPdHImr1LKb/bwCdRLqOZwQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ruvpSLiCh8sZ+s+8u39rRUaeL1a9gPLB9QY5fpLTv12hgR4uJxTbM/5TF4uUnQu5b/rulURNadvmDP3W1TRAf+KhtEgY+kbLXa6SYaDkfyO9/DxufewjkeqzLyQAe0aT1csD2mEz0yun10S9ZvyPjrxa3QIY2tji6c2NVs0jznE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gLrntfLc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gLrntfLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C61C2BD10;
	Tue, 14 May 2024 11:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685752;
	bh=//pL/qtSaBcF9ay4inLVPdHImr1LKb/bwCdRLqOZwQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gLrntfLc/6IYWZNgm9gN5sYmXh4zumX2wc83ldeKUSQNEVfBMMtaLdimVLY+8J7is
	 cU95IeyOl/YSQIzXlvYrYb/K8RixXNCXyZJBa4KNosCoyAhoAf6P110kjnAUqjRSvA
	 JoL1mKV75sqqDhr/CgS6j7UO3oav9T+pv9pqld6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Machek <pavel@denx.de>,
	Dominique Martinet <dominique.martinet@atmark-techno.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 241/301] btrfs: add missing mutex_unlock in btrfs_relocate_sys_chunks()
Date: Tue, 14 May 2024 12:18:32 +0200
Message-ID: <20240514101041.353893163@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominique Martinet <dominique.martinet@atmark-techno.com>

commit 9af503d91298c3f2945e73703f0e00995be08c30 upstream.

The previous patch that replaced BUG_ON by error handling forgot to
unlock the mutex in the error path.

Link: https://lore.kernel.org/all/Zh%2fHpAGFqa7YAFuM@duo.ucw.cz
Reported-by: Pavel Machek <pavel@denx.de>
Fixes: 7411055db5ce ("btrfs: handle chunk tree lookup error in btrfs_relocate_sys_chunks()")
CC: stable@vger.kernel.org
Reviewed-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3368,6 +3368,7 @@ again:
 			 * alignment and size).
 			 */
 			ret = -EUCLEAN;
+			mutex_unlock(&fs_info->reclaim_bgs_lock);
 			goto error;
 		}
 


