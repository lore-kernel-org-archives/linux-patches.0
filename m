Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A693115AAA8;
	Mon, 29 Jan 2024 17:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548160; cv=none; b=syktQkajsDULBivRd6Y82PiEx6rw9Z2KBTVjQo0PnuCGwWELoGjHsgi2kQ9OwSMzxE+5EBRo30vSzKmiy+eKAuvE20nbZVbWaXEhc7udPn4OBBdv7XK21kGDzTewNcXcuyeb8qXAjULdDaHqvhZAS1TOX7MKq0Gx/LNmxWaQPYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548160; c=relaxed/simple;
	bh=AyK80NAhJZ1ONJaH8PiWbiwEiD1uGo8+wYHJJUNh4fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gth7ne5tNH7eStt9zjg/rSJjr2Fd3RGP2/Qz30HCwp6eEC3J5CXSg+uBWpN63J0U5oaJzq1SXVh1h2ovhH7U/6ir0yfPuXMVVvBLhkC/QA113bbgNFu5kPsiIFeogcQ5AsvBhvLTxg6PPyfMvPD+4PI6v8X9Cm8k/+FHcJIuOug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mt7cIZea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mt7cIZea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7D5C433C7;
	Mon, 29 Jan 2024 17:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548160;
	bh=AyK80NAhJZ1ONJaH8PiWbiwEiD1uGo8+wYHJJUNh4fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mt7cIZeahBVpatjqQ0rPKKMfC39VmgfALYdXPAHq+ANSv394ua3/SVU3R/zVHRwIl
	 3Xd6e/ITCa7gEJLKkvZjjWnFBC8Ghkd1oXhhENTZVRK2+QjpeTSidpA7sBshRKnvwc
	 yiqAceQQcWg5O2njzAMpNht+jD7S7S5Actr+nPIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 175/346] afs: Use op->nr_iterations=-1 to indicate to begin fileserver iteration
Date: Mon, 29 Jan 2024 09:03:26 -0800
Message-ID: <20240129170021.544860751@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 075171fd22be33acf4ab354814bfa6de1c3412ce ]

Set op->nr_iterations to -1 to indicate that we need to begin fileserver
iteration rather than setting error to SHRT_MAX.  This makes it easier to
eliminate the address cursor.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Stable-dep-of: 17ba6f0bd14f ("afs: Fix error handling with lookup via FS.InlineBulkStatus")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/fs_operation.c |  2 +-
 fs/afs/internal.h     |  2 +-
 fs/afs/rotate.c       | 11 ++++++-----
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/afs/fs_operation.c b/fs/afs/fs_operation.c
index 7a3803ce3a22..3e31fae9a149 100644
--- a/fs/afs/fs_operation.c
+++ b/fs/afs/fs_operation.c
@@ -41,7 +41,7 @@ struct afs_operation *afs_alloc_operation(struct key *key, struct afs_volume *vo
 	op->cb_v_break	= volume->cb_v_break;
 	op->debug_id	= atomic_inc_return(&afs_operation_debug_counter);
 	op->error	= -EDESTADDRREQ;
-	op->ac.error	= SHRT_MAX;
+	op->nr_iterations = -1;
 
 	_leave(" = [op=%08x]", op->debug_id);
 	return op;
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index ec08b4a7e499..88381935bd66 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -859,7 +859,7 @@ struct afs_operation {
 	struct afs_call		*call;
 	unsigned long		untried;	/* Bitmask of untried servers */
 	short			index;		/* Current server */
-	unsigned short		nr_iterations;	/* Number of server iterations */
+	short			nr_iterations;	/* Number of server iterations */
 
 	unsigned int		flags;
 #define AFS_OPERATION_STOP		0x0001	/* Set to cease iteration */
diff --git a/fs/afs/rotate.c b/fs/afs/rotate.c
index a108cd55bb4e..4084e023ff43 100644
--- a/fs/afs/rotate.c
+++ b/fs/afs/rotate.c
@@ -116,7 +116,10 @@ bool afs_select_fileserver(struct afs_operation *op)
 	unsigned int rtt;
 	int error = op->ac.error, i;
 
-	_enter("%lx[%d],%lx[%d],%d,%d",
+	op->nr_iterations++;
+
+	_enter("OP=%x+%x,%llx,%lx[%d],%lx[%d],%d,%d",
+	       op->debug_id, op->nr_iterations, op->volume->vid,
 	       op->untried, op->index,
 	       op->ac.tried, op->ac.index,
 	       error, op->ac.abort_code);
@@ -126,13 +129,11 @@ bool afs_select_fileserver(struct afs_operation *op)
 		return false;
 	}
 
-	op->nr_iterations++;
+	if (op->nr_iterations == 0)
+		goto start;
 
 	/* Evaluate the result of the previous operation, if there was one. */
 	switch (error) {
-	case SHRT_MAX:
-		goto start;
-
 	case 0:
 	default:
 		/* Success or local failure.  Stop. */
-- 
2.43.0



