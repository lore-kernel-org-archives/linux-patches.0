Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F8F218AAB;
	Mon, 18 Aug 2025 13:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522700; cv=none; b=E1z5sQ0Dug1J5lpz6ismAP3KaDOu2MJWOI3yEP8agpmutVGHKf0SAoXaSWHbhsvJ8mVmhva0l4n4LGnGr5XiqLPhDA2plGjXl5xSZXXc60rXLX/iDa5Aly0mRCH2S6u2JoegL6IgiyGcnVtvw7KQTykVIIpnP3g0Lg1Kg+dEBUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522700; c=relaxed/simple;
	bh=a9CewsEJsTmIjGDvKxwGy5tCBaAaYEAH6PsA7RG6RwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ks2ftC1aSQHrwmT81eEWWh06omNd+p3cV645sjyqI7peLrfyoJwxOanFyPgv1wcpqtel/v0k0N8Y9nC0IbVRXhmzKWqDyiFxXC7BsIIx/zy275r6CZTvtMIbcnchgHLi3OjmxBrHUyFEHBBHTNyinGlPzK7UZlDMppqT98WVKpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j5Vw+T74; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j5Vw+T74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60136C4CEEB;
	Mon, 18 Aug 2025 13:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522696;
	bh=a9CewsEJsTmIjGDvKxwGy5tCBaAaYEAH6PsA7RG6RwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j5Vw+T74DuVvj48ASu41JvCHnS3sTqHcEI++hbXgqs0r0k9V0aRFxbqU2CY/vFvga
	 CD3zUMzHfYhejIAewI9fPxT5s6lOx+RCAed3uok21ZrXevWv48DZZnRdIJlt9+Bj6V
	 tLSJ9cbvllIwVgc3VpLr7QekAEdoPIdeysTF+EsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 392/444] btrfs: abort transaction during log replay if walk_log_tree() failed
Date: Mon, 18 Aug 2025 14:46:58 +0200
Message-ID: <20250818124503.612866041@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 2a5898c4aac67494c2f0f7fe38373c95c371c930 upstream.

If we failed walking a log tree during replay, we have a missing
transaction abort to prevent committing a transaction where we didn't
fully replay all the changes from a log tree and therefore can leave the
respective subvolume tree in some inconsistent state. So add the missing
transaction abort.

CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -7295,11 +7295,14 @@ again:
 
 		wc.replay_dest->log_root = log;
 		ret = btrfs_record_root_in_trans(trans, wc.replay_dest);
-		if (ret)
+		if (ret) {
 			/* The loop needs to continue due to the root refs */
 			btrfs_abort_transaction(trans, ret);
-		else
+		} else {
 			ret = walk_log_tree(trans, log, &wc);
+			if (ret)
+				btrfs_abort_transaction(trans, ret);
+		}
 
 		if (!ret && wc.stage == LOG_WALK_REPLAY_ALL) {
 			ret = fixup_inode_link_counts(trans, wc.replay_dest,


