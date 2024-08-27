Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB201C86F6;
	Tue, 27 Aug 2024 15:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772762; cv=none; b=EjTaal4Op8kQZ8aIoH4weLJ1gXyeMzPGRVRs+eFHwgjKzBtAd4sEqza0PK+TdFLbPOPjlFX6qZ3KSPoSlOgeUL7rmtCataUpXWHhaEswQ1V1gNm2GphlrzX9DtTCc9cB4DXEDGxsvif/JoQVZMLAMrzQNA0deTwPLfpl+8CcabU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772762; c=relaxed/simple;
	bh=C53s0O+ioDjha0W1uWL5M8FWaJQDlPidmVrgAr2wEhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYbmCHNsD9K3LTVwvudPc0XCWtY3JeYe93MB7twG25T2QRDjZGHyNXCcZpQOK46ybp0Lh5MX5z1N4q+/qeUYYMwMTskph5ZknagfOxRQKs/vHj+5lwEU85UzTmhNtSbm01TUWSqpx0KH9wPmUyjFHRwE9NXyCubP+HvEVu22TD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XKL4uoKv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XKL4uoKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F48C61041;
	Tue, 27 Aug 2024 15:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772761;
	bh=C53s0O+ioDjha0W1uWL5M8FWaJQDlPidmVrgAr2wEhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XKL4uoKvjeZyqjqK/110g3fj50bCkRwR3T8KdjOvecTw0GPNNLE7FK0fhGMweZlV1
	 tUDpy8dRDbNbYYe0K4jL4etBcMGfFtk4GyHwBhk2ahgW8MUzi+5T1d5LzORGUB6gTF
	 ukfTJvz1JL//ZXG8FegWGNlSmQ7aTF6DlnMbD/hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 6.1 312/321] gfs2: Fix another freeze/thaw hang
Date: Tue, 27 Aug 2024 16:40:20 +0200
Message-ID: <20240827143850.133658375@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 52954b750958dcab9e44935f0c32643279091c85 upstream.

On a thawed filesystem, the freeze glock is held in shared mode.  In
order to initiate a cluster-wide freeze, the node initiating the freeze
drops the freeze glock and grabs it in exclusive mode.  The other nodes
recognize this as contention on the freeze glock; function
freeze_go_callback is invoked.  This indicates to them that they must
freeze the filesystem locally, drop the freeze glock, and then
re-acquire it in shared mode before being able to unfreeze the
filesystem locally.

While a node is trying to re-acquire the freeze glock in shared mode,
additional contention can occur.  In that case, the node must behave in
the same way as above.

Unfortunately, freeze_go_callback() contains a check that causes it to
bail out when the freeze glock isn't held in shared mode.  Fix that to
allow the glock to be unlocked or held in shared mode.

In addition, update a reference to trylock_super() which has been
renamed to super_trylock_shared() in the meantime.

Fixes: b77b4a4815a9 ("gfs2: Rework freeze / thaw logic")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/glops.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -566,15 +566,16 @@ static void freeze_go_callback(struct gf
 	struct super_block *sb = sdp->sd_vfs;
 
 	if (!remote ||
-	    gl->gl_state != LM_ST_SHARED ||
+	    (gl->gl_state != LM_ST_SHARED &&
+	     gl->gl_state != LM_ST_UNLOCKED) ||
 	    gl->gl_demote_state != LM_ST_UNLOCKED)
 		return;
 
 	/*
 	 * Try to get an active super block reference to prevent racing with
-	 * unmount (see trylock_super()).  But note that unmount isn't the only
-	 * place where a write lock on s_umount is taken, and we can fail here
-	 * because of things like remount as well.
+	 * unmount (see super_trylock_shared()).  But note that unmount isn't
+	 * the only place where a write lock on s_umount is taken, and we can
+	 * fail here because of things like remount as well.
 	 */
 	if (down_read_trylock(&sb->s_umount)) {
 		atomic_inc(&sb->s_active);


