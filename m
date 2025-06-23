Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6C0221545;
	Mon, 23 Jun 2025 21:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713712; cv=none; b=RgDTQcF3a51bUzL1Kph+aGfImgw7gZ1ju+p3cioVXDL4j+JPHDrGUZfvNzUS6QcSM+2O+uby0/P8y7wQFlNFSsBaYyjKNfgmIeBsQLPjr81qZCy3WtPZ+Dih/iyygmeTNmcyb5H/ELSgEK6Wy07FefJua8eH0QDfPWALbIi1f5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713712; c=relaxed/simple;
	bh=UTE1fsEyvl8FrrXuu8Jk/rt50MZ16wbz5jmeoi48g7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nB/53iH0Sd2NDQWfrP5Wt6rAC0giK70Gf/Qj/pO2pOEhelnt3xgUMiTRs+8vTaVacxyDKFRXNAJzEDxgHzZm/1hbPT7jyp3XbwsHhpNxu5N4+KUga4y7jyVs9Y4yihrfvBQ34j/nSj5g+8ecBCAkVuz3AZRsUztZm23s87hjJEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YQrbYrAM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YQrbYrAM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A755EC4CEEA;
	Mon, 23 Jun 2025 21:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713712;
	bh=UTE1fsEyvl8FrrXuu8Jk/rt50MZ16wbz5jmeoi48g7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQrbYrAMx+m6kLsZ80DCvYeivDuuFSCuE0CBdAV9CKHdiC5bHVUz+7J+AXWU1vR65
	 Z9H0tk3DHkwfiLTMc4d4PzgFzphj1yIBKb9f72tl/YtpksSzeTVQvC9ndq/Qh4zVou
	 +y3Sw0fRxuHH3AFeIsorVt36AUP2Y6GnuRAPOnF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Alexander Aring <aahringo@redhat.com>
Subject: [PATCH 5.10 161/355] gfs2: move msleep to sleepable context
Date: Mon, 23 Jun 2025 15:06:02 +0200
Message-ID: <20250623130631.541795103@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -939,14 +939,15 @@ locks_done:
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
 


