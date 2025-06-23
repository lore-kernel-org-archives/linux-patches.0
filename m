Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB61D24EA85;
	Mon, 23 Jun 2025 13:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684289; cv=none; b=X+Xpyz7nFyuvq8smLrpSnTZR50wq97YyOIt4K2SfXH/UEfltreF2wpK7kH4gno0kF5seSZLemM9QQnzmsWAeoLxsTfabxSL5nwghbzPUpjSXgRIERHz17UHUMlCB3Ijm/lekcpNE/P++6YQg0ozwM97wq9kNtOR2+d7n5N6qjSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684289; c=relaxed/simple;
	bh=LI5dq8veMhtKHaAl4w9eTzv+uWiO2Ds3/PWNV6XP6AY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ooIgyFLdFBc+ivDNvLaryjK9xa8wpTUJ0ncFN5WQ0FD5yNllxdvGFr+sMcWeR4rWRPoQkxPtdoVlLY9OPN4+s5upZfXaZ4ZRaQsxoPam6HrJHZpzFE2MmuL0qp9HJ9AgwyAkZ5fkharJSJyK5by2Wn1oOa6Y+3Xh6+BBFsHZNNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1fPIETS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1fPIETS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A2DC4CEEA;
	Mon, 23 Jun 2025 13:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684289;
	bh=LI5dq8veMhtKHaAl4w9eTzv+uWiO2Ds3/PWNV6XP6AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1fPIETSLHLWJxbRJJiUVkzCNwwYfk9w2HG+K2Q+cOLWJB4rr3hX2bZciVVWEJ1fr
	 6RBLdBkvUgBQUkde0p4pkMmb52MCPYmD03xW1vw9z1MfGzPLFnHabzndmp6Czx6/f2
	 XH59DYyNRe0UJBLbps/ylFAEu15PRDFFlGpVWHwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Alexander Aring <aahringo@redhat.com>
Subject: [PATCH 6.15 004/592] gfs2: move msleep to sleepable context
Date: Mon, 23 Jun 2025 14:59:22 +0200
Message-ID: <20250623130700.324300470@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Alexander Aring <aahringo@redhat.com>

commit ac5ee087d31ed93b6e45d2968a66828c6f621d8c upstream.

This patch moves the msleep_interruptible() out of the non-sleepable
context by moving the ls->ls_recover_spin spinlock around so
msleep_interruptible() will be called in a sleepable context.

Cc: stable@vger.kernel.org
Fixes: 4a7727725dc7 ("GFS2: Fix recovery issues for spectators")
Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/lock_dlm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -996,14 +996,15 @@ locks_done:
 		if (sdp->sd_args.ar_spectator) {
 			fs_info(sdp, "Recovery is required. Waiting for a "
 				"non-spectator to mount.\n");
+			spin_unlock(&ls->ls_recover_spin);
 			msleep_interruptible(1000);
 		} else {
 			fs_info(sdp, "control_mount wait1 block %u start %u "
 				"mount %u lvb %u flags %lx\n", block_gen,
 				start_gen, mount_gen, lvb_gen,
 				ls->ls_recover_flags);
+			spin_unlock(&ls->ls_recover_spin);
 		}
-		spin_unlock(&ls->ls_recover_spin);
 		goto restart;
 	}
 


