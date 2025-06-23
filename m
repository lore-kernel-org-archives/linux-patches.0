Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B1544C77;
	Mon, 23 Jun 2025 21:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714208; cv=none; b=pN/Y7bAAKI0lDPPCLa08kVrurTBgYMaBVUUA7116jNt//RrDJVelWKUMPR9PrNhMBtS6759aUtY6PSGSu8atq0A2inxoRY1iVgt4bFQZmoLLpEa4ucnH1L1EgZTSWk5O11xiKxJOtRSGd9H0twr7f3buWviYrHPz58BZeNsSdQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714208; c=relaxed/simple;
	bh=c9DJiNpzdc4bkPEdmk93HJZmKUdJ1aiCGEvEDn9JWwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jkDTxxEugYXQkzBmlX1pGs8CG4RfZ45K26g3jkotC1xn6bL3xlBFluTQxIVW7fiO1kqVAVWZkNNi5WBWxF8A3wkuAUKWAfF24oS9uczXljr7dJvCxvU2x+/T6wJt4cmSN3sASe3KnuHxUbliNKTuDNzxiqcdqDnGuNMMAVb18XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r2gLvZGf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r2gLvZGf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665A9C4CEEA;
	Mon, 23 Jun 2025 21:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714208;
	bh=c9DJiNpzdc4bkPEdmk93HJZmKUdJ1aiCGEvEDn9JWwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r2gLvZGfsmxlGIoMr1l1BKX8Fed/aMS3dabotSnh1AB2srWjQmM4KEBmGZCxKMfu+
	 edjYbBOKK6jn/UObJMXze4sg3xkY7gX0Jgn7/xVOrzJMVsyfy67RU2mRXq8SpnBxw8
	 6E8iCUjdYALQ+soZ2zxsi5SH0tK2Al9d0sTzX2hM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Alexander Aring <aahringo@redhat.com>
Subject: [PATCH 5.15 194/411] gfs2: move msleep to sleepable context
Date: Mon, 23 Jun 2025 15:05:38 +0200
Message-ID: <20250623130638.561837264@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -942,14 +942,15 @@ locks_done:
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
 


