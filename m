Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021D13E95A9;
	Tue, 31 Mar 2026 16:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974688; cv=none; b=astvUzT+CJaPXsDxfECVWM21+7Y0bJ7Bi2Z7vxGY9d67rw5PCk5cIhGWGovf3xIDMQWIeFXRrb3OIj1eNlpbnG63mqzpFuHlfQe+YafYJRVVSMQHVmhWoTl90hp9rVqyS7iED1PpVzV5JmUdC7t4BhVZhPgop7l3Jl8Nl7stPTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974688; c=relaxed/simple;
	bh=cQLTzSu9nGejXDCZerhDhZjd5Nn4knyXDeZFbImQTk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgqvKNmH1DtyVcg0yX6hoBQ6TZl2lsdB151cPO0rnni2WoqmqJgDbCH9Z3k9Sf8bR1l1pPsBfN3TGElWwnZdf93z2v3tZYT1nPRGL7oq+xxhKb26pf2guOtQ+soy/hTW9aYPJmxuUM3OQvredwXV9Jhh+7Hi6D+mtmlpIBTfr5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mBRm/XAy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mBRm/XAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1CEC19423;
	Tue, 31 Mar 2026 16:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974687;
	bh=cQLTzSu9nGejXDCZerhDhZjd5Nn4knyXDeZFbImQTk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mBRm/XAyY0CQQ/KZ+CB/PEf8gNsHBgEAWEK7OYxqLpNI0VzY4wB5DHEOV3QhePeyY
	 4nndRc6KmIYpU4Eb9hdHPSVZDMtLdJ8ogjEcF6bW0oe2FrAUTD2u1aOzBA2Gwc2vD0
	 5PTNRDJdWWoHyIgy1zHiAQPxIAMkHbG9Upo784M4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	"stable@vger.kernel.org, Andreas Gruenbacher" <agruenba@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Price <anprice@redhat.com>,
	Robert Garcia <rob_garcia@163.com>
Subject: [PATCH 6.6 152/175] gfs2: Fix unlikely race in gdlm_put_lock
Date: Tue, 31 Mar 2026 18:22:16 +0200
Message-ID: <20260331161735.376057205@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ Minor context change fixed. ]
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/lock_dlm.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -311,11 +311,6 @@ static void gdlm_put_lock(struct gfs2_gl
 	gfs2_sbstats_inc(gl, GFS2_LKS_DCOUNT);
 	gfs2_update_request_times(gl);
 
-	/* don't want to call dlm if we've unmounted the lock protocol */
-	if (test_bit(DFL_UNMOUNT, &ls->ls_recover_flags)) {
-		gfs2_glock_free(gl);
-		return;
-	}
 	/* don't want to skip dlm_unlock writing the lvb when lock has one */
 
 	if (test_bit(SDF_SKIP_DLM_UNLOCK, &sdp->sd_flags) &&
@@ -332,6 +327,11 @@ again:
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


