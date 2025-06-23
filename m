Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DB6238C19;
	Mon, 23 Jun 2025 13:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685731; cv=none; b=WkJS0pb+ZvdxWOBz7ME8h7+SsQ+nqQbIp4RdpkD+3u5PiYkXa4dJPj73NNfqnJt80YHUMm7yrDY/rXZCcyrpGk3HY+7HYoi2RXA9RWgHKZRNFd4q0pnsEEHBXteUTJVRNb2WF9pLzZlyp2OScGpA+EOKaS8jEn9fNaonfTTJJAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685731; c=relaxed/simple;
	bh=DNExwQD1UFb40vufDKMr7KvfXSo9GHlXFppAOCbuaU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xgv+FEx8TDE/uZsJ42Q46zE3PJ9xiKYr/QjVHEYbk1b1e/cQRmueWL6jCtw7bNNoiW4mpqIpgvswswaWUbmtYnJjXz5FKhqVUKx4R+F9HMJKUncC4V/tpy7IYJqsYGsOOggwTSmGIBSF5d5nygRRy7q/lNX8BWVY3sl7FKWvwjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nmy038qp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nmy038qp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4E6C4CEEA;
	Mon, 23 Jun 2025 13:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685731;
	bh=DNExwQD1UFb40vufDKMr7KvfXSo9GHlXFppAOCbuaU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nmy038qp8rx/OXlel0GjCJWHVIg+mPKLjyiTPJPvURCu5vkk1JRvljxet+aHTcAi8
	 z4R8XhtmIf21V4shC4tPiEV/u5IXaqpBns0PJt7t8Ix4H1FhHtj6rCdYkjfR9+IkRY
	 mD0q5Bm4ANu8FvAs2CnGyCWXH42Hx+m43xM3E9QA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Alexander Aring <aahringo@redhat.com>
Subject: [PATCH 6.6 003/290] gfs2: move msleep to sleepable context
Date: Mon, 23 Jun 2025 15:04:24 +0200
Message-ID: <20250623130627.034981863@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -959,14 +959,15 @@ locks_done:
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
 


