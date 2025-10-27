Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8522D5C95;
	Mon, 27 Oct 2025 19:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593120; cv=none; b=NU9xX95zEinmTHxMcgEE0OX1NiRHjk7HnvthGPi/u7G1TRpWGAUARF/t/XawVCQoX3LkbCHc1FtPeFyJF9X9MXTEftMtemEDF3tWG/vBFZNAOZkaDCUD6BiUhIEuzqs0vhcnIwOh3mcOp1bxFXEbTcXeEmZcC/LpZImAw3GARw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593120; c=relaxed/simple;
	bh=uai9y0/UafDd0qqlpuzuB/8+1RmPAjnmyfldUMf2LU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2iw0zPJsmrEEQBRG0H1S2oHXp4U5yve+QKM8BcBWhCJiM3rok4qGWqZklUEClHjRglrVngE8pb+WhIBjMIVMOD2Karnsyw3EnIxubWdGdvyete0Tobdk2ZLUS97MAgFbirmzczxiIHCkMp+R9uOL5oLPbAgpQqi04W+r/9EDBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p5y3PlKe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p5y3PlKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F36C4CEF1;
	Mon, 27 Oct 2025 19:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593120;
	bh=uai9y0/UafDd0qqlpuzuB/8+1RmPAjnmyfldUMf2LU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p5y3PlKezV0BV0jaU2943PY9U2inlAQat6Hi8QbWqeLUOSLolMQFWd8Vw6QcFrM4Y
	 OD540IXFdxyJxAIwj/KaimPTXkO98EsV8YAZ+AmFu5Ad/QWt2Fi9dpRp5V/tZg5r+n
	 34rHaFx7Am2B866VSjNDg1/DZZGRetkQ/VqAQ4Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Andrew Price <anprice@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 020/184] gfs2: Fix unlikely race in gdlm_put_lock
Date: Mon, 27 Oct 2025 19:35:02 +0100
Message-ID: <20251027183515.477580758@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 28c4d9bc0708956c1a736a9e49fee71b65deee81 ]

In gdlm_put_lock(), there is a small window of time in which the
DFL_UNMOUNT flag has been set but the lockspace hasn't been released,
yet.  In that window, dlm may still call gdlm_ast() and gdlm_bast().
To prevent it from dereferencing freed glock objects, only free the
glock if the lockspace has actually been released.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Andrew Price <anprice@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/lock_dlm.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index 6db37c20587d1..570e5ae6b73df 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -361,12 +361,6 @@ static void gdlm_put_lock(struct gfs2_glock *gl)
 	gfs2_sbstats_inc(gl, GFS2_LKS_DCOUNT);
 	gfs2_update_request_times(gl);
 
-	/* don't want to call dlm if we've unmounted the lock protocol */
-	if (test_bit(DFL_UNMOUNT, &ls->ls_recover_flags)) {
-		gfs2_glock_free(gl);
-		return;
-	}
-
 	/*
 	 * When the lockspace is released, all remaining glocks will be
 	 * unlocked automatically.  This is more efficient than unlocking them
@@ -396,6 +390,11 @@ static void gdlm_put_lock(struct gfs2_glock *gl)
 		goto again;
 	}
 
+	if (error == -ENODEV) {
+		gfs2_glock_free(gl);
+		return;
+	}
+
 	if (error) {
 		fs_err(sdp, "gdlm_unlock %x,%llx err=%d\n",
 		       gl->gl_name.ln_type,
-- 
2.51.0



