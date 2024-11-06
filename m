Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC3E1F5853;
	Wed,  6 Nov 2024 13:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898588; cv=none; b=IzcsokIg8dR8+ywc9ZZ1916glM2M+t+FX6tblJiPVr1blv4Oy8NefvzDzf5h3IBA5Xz9ROdjfd02O/DZJz7+o/M+CKKPGfO+S0z7dzNh0lkRYkOk5nzv0h30wjoDIhU8aLGRwrftfy8/ngzs5oI+uLCAREYZ9wnVlgRjzbIvgBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898588; c=relaxed/simple;
	bh=3YhbVMq73/OIbG2Ekibf9etB6qtv++8MF7IIeYhO40U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXPdMNUQPlB/I9lfWYnOLXA+nowbNGrdpDGsgBUuGy/FBPh1OIW43r2Pn1GieHrBd9/SuSJwES+mX/KGezDZlSKGaM5KGjQ5bIzL7sqE2fOrsGJqcWIFygh2TvgdbuQQiLq3hS/zmOoC5zg/zODFdW6uOls20oy26hD1pdmP8pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CNi0nVRB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CNi0nVRB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC27C4CECD;
	Wed,  6 Nov 2024 13:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898588;
	bh=3YhbVMq73/OIbG2Ekibf9etB6qtv++8MF7IIeYhO40U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNi0nVRBN4wTollt+cR3STNJRJPvnPxOB6uZtCFlIvKMMpazY7xWK995jkt2wc+2B
	 95T7958sLJSTcB81OOQ+tcAgNVwEnHz8xqXanTD6CtwwhK3jVhHoUJ5J6cJrX1fCXr
	 at230x+SaGGFn/Z+jGS6jz3yIOQvGniZExoe5xl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	NeilBrown <neilb@suse.de>,
	Benjamin Coddington <bcodding@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 288/462] nfsd: fix delegation_blocked() to block correctly for at least 30 seconds
Date: Wed,  6 Nov 2024 13:03:01 +0100
Message-ID: <20241106120338.637782018@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 45bb63ed20e02ae146336412889fe5450316a84f ]

The pair of bloom filtered used by delegation_blocked() was intended to
block delegations on given filehandles for between 30 and 60 seconds.  A
new filehandle would be recorded in the "new" bit set.  That would then
be switch to the "old" bit set between 0 and 30 seconds later, and it
would remain as the "old" bit set for 30 seconds.

Unfortunately the code intended to clear the old bit set once it reached
30 seconds old, preparing it to be the next new bit set, instead cleared
the *new* bit set before switching it to be the old bit set.  This means
that the "old" bit set is always empty and delegations are blocked
between 0 and 30 seconds.

This patch updates bd->new before clearing the set with that index,
instead of afterwards.

Reported-by: Olga Kornievskaia <okorniev@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 6282cd565553 ("NFSD: Don't hand out delegations for 30 seconds after recalling them.")
Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 336342b414627..89927d9b07673 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -820,7 +820,8 @@ static void nfs4_free_deleg(struct nfs4_stid *stid)
  * When a delegation is recalled, the filehandle is stored in the "new"
  * filter.
  * Every 30 seconds we swap the filters and clear the "new" one,
- * unless both are empty of course.
+ * unless both are empty of course.  This results in delegations for a
+ * given filehandle being blocked for between 30 and 60 seconds.
  *
  * Each filter is 256 bits.  We hash the filehandle to 32bit and use the
  * low 3 bytes as hash-table indices.
@@ -849,9 +850,9 @@ static int delegation_blocked(struct knfsd_fh *fh)
 		if (ktime_get_seconds() - bd->swap_time > 30) {
 			bd->entries -= bd->old_entries;
 			bd->old_entries = bd->entries;
+			bd->new = 1-bd->new;
 			memset(bd->set[bd->new], 0,
 			       sizeof(bd->set[0]));
-			bd->new = 1-bd->new;
 			bd->swap_time = ktime_get_seconds();
 		}
 		spin_unlock(&blocked_delegations_lock);
-- 
2.43.0



