Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4C11A4F12;
	Mon, 23 Jun 2025 22:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716267; cv=none; b=LwkhTQaJdlhiwxa2+lhFPI5RUup5nW4HB6ygRl8lePyjzUHRoqGwfiCJYMMTASnK/q8oSje0O1c7fZhkxmHGKjD7TD2cs7IVkuEFnyh3V/VlXy1nivsMUu0iS7t5eviCMbO+k+RiTfQtFjA0QbxAQ6xYQutN1RK4h9WOCIeEogo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716267; c=relaxed/simple;
	bh=TQJV651lQzDCbKp3rjSkr46WDy8MfXZa5B5ev2YvSNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qOfsInNcEAdx6gviYF7fKfb0XkuzdPMlLzyopb1swVct8MZDFu9aZK9odMRIJ6MoKcoUQJABo8fYzaVobX7NsBZtJg0f2Cy3FRGK5OZCBqPND1uAXo1IRSW2+vET75d8YBNRnK3F0lfjer6J7W28B3Qu2cZQIzIkKnw1J/t07Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ohXs+Sg6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ohXs+Sg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139A5C4CEEA;
	Mon, 23 Jun 2025 22:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716267;
	bh=TQJV651lQzDCbKp3rjSkr46WDy8MfXZa5B5ev2YvSNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ohXs+Sg607nFkJ7IB7447EMXYgMh0krBP8K9/jCjB1tMAs8R6k2RuT4mT913hAij5
	 RI1o6lIhrv38nHkIY3Ege0LhAYnXm4ftdiBLvWscilAyl7K1zoJDOgU2979yYnhh+v
	 rme6rDH+C4s2ckrIh0nDISoE5L/3LcqF+c5CW5Mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Alexander Aring <aahringo@redhat.com>
Subject: [PATCH 6.1 291/508] gfs2: move msleep to sleepable context
Date: Mon, 23 Jun 2025 15:05:36 +0200
Message-ID: <20250623130652.437730295@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -950,14 +950,15 @@ locks_done:
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
 


