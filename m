Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8409B32C92B;
	Fri, 17 Oct 2025 15:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714656; cv=none; b=By87K/k3SUoTPIvZ5L8Rwx2KSCLfCWarv9gC3DHzdDJIUPFyCdhVQZMiIj0auds56IA2SF3eBirvH1gUgmEi9ac0msNKkFZQRClsEHTbYbnBhGRYb5iXD6FjtrKHcKnufkbOgmuYicH4K6g3IK6ZRxgBUPGdDBN6IIA+kb1c4fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714656; c=relaxed/simple;
	bh=dojiDWfAqV3Plj4bRvrNouSY1+THS4ao7Mk+2VeBASE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPJk/lMF6gHS8ALyYZjbogFRjMtqOsVmum2VLYkuQe0/LW8hlzTJ9mm1WjEu9Cnxs0dnQn0pWPs2SzD7tJxSrbEpAaeXVS2iMIx6fUNUGQhFLgP40xBsKa9wm7S6rp2ISbkFBp/15mBT/nDdQNjBdjlBsCrrQMHY5VHh7isckWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FmNMMpz9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FmNMMpz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A373EC4CEFE;
	Fri, 17 Oct 2025 15:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714655;
	bh=dojiDWfAqV3Plj4bRvrNouSY1+THS4ao7Mk+2VeBASE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FmNMMpz9mIx/lIBpmIuEaibHyhxHvdp/uIMv1ejYMDJaqKUM+Lv+rZNzV+G2SlkAb
	 rkUdYzisz/82MhPJZ2y64MINn63akjE23odHkXlP40iud9Aun4gDsfHvd+uutP4Akt
	 UUjSL9qh84dDf6QNqLkkBjJoPoT25gGuY5AaRrL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.12 221/277] ext4: free orphan info with kvfree
Date: Fri, 17 Oct 2025 16:53:48 +0200
Message-ID: <20251017145155.196951852@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

commit 971843c511c3c2f6eda96c6b03442913bfee6148 upstream.

Orphan info is now getting allocated with kvmalloc_array(). Free it with
kvfree() instead of kfree() to avoid complaints from mm.

Reported-by: Chris Mason <clm@meta.com>
Fixes: 0a6ce20c1564 ("ext4: verify orphan file size is not too big")
Cc: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Message-ID: <20251007134936.7291-2-jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/orphan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -513,7 +513,7 @@ void ext4_release_orphan_info(struct sup
 		return;
 	for (i = 0; i < oi->of_blocks; i++)
 		brelse(oi->of_binfo[i].ob_bh);
-	kfree(oi->of_binfo);
+	kvfree(oi->of_binfo);
 }
 
 static struct ext4_orphan_block_tail *ext4_orphan_block_tail(
@@ -638,7 +638,7 @@ int ext4_init_orphan_info(struct super_b
 out_free:
 	for (i--; i >= 0; i--)
 		brelse(oi->of_binfo[i].ob_bh);
-	kfree(oi->of_binfo);
+	kvfree(oi->of_binfo);
 out_put:
 	iput(inode);
 	return ret;


