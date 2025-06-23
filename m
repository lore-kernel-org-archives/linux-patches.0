Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343072F24;
	Mon, 23 Jun 2025 13:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685557; cv=none; b=O7EKZ/7pWqQRxYSpIKzI5VS5VVj2eoIaos0S/+gu7x8Q4SBwPHNibXRWZ+XewVoFHfG43XFn3ZnqGrkL0XxBOOGENi+dyczc/CGA6UIquSTV/ipaLMknnvvIYuFOhbEihx5rmDJFO4JSOq8UR78OOv2DU8ss2owy7xwwBqtZx1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685557; c=relaxed/simple;
	bh=rY1e9aHxi4i2UofoAmVIrVI2hUP/ep+6hAcXjhxwVxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cW4bY0nE93R59ACNZ5OOKxaCi+4UHIehEWkiUtuwc6PP6u98mD0Pg6zFWk2CotmvrQ472CCwP/1OU6NuqqUgyygXu7F/yV0EBT0JaKzfj6/YD6faFSY3YihUwCS5yP/kLXki+E3E8fYCDbxs37zFa2j3Lmoz+atXYBVHFTlGoh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZEHds/+G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZEHds/+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEEAC4CEEA;
	Mon, 23 Jun 2025 13:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685557;
	bh=rY1e9aHxi4i2UofoAmVIrVI2hUP/ep+6hAcXjhxwVxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZEHds/+GAZ0ZmjqNf72R4Wzd4IknqJVqTnDj/gEAkSmdHN1dMSJuDL8vLhdWWOECr
	 ITAJd8AmCfIr6RuRYHaHeYWSPFzhbal3+OsxmC0tdwA9tPaPIq1+BmmpYzQwfoG9mR
	 ShfJAYJs+T+DhuOdNEUhhFjLQkwk05nDp0F3CD7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Alexander Aring <aahringo@redhat.com>
Subject: [PATCH 5.4 103/222] gfs2: move msleep to sleepable context
Date: Mon, 23 Jun 2025 15:07:18 +0200
Message-ID: <20250623130615.212582811@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -905,14 +905,15 @@ locks_done:
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
 


