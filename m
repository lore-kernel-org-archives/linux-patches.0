Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B864116B3AE;
	Tue, 18 Jun 2024 12:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715301; cv=none; b=mJAdZvj+UNlGZmAbU6D34d08PKkZoxmKyuusja7tRTGaMm4l/+v1YYfzRqrQKVA91q8znri5qHT3IpW3ne0qoTO+KnPYCBZv7tuU95kMJ3Akd9UwDHgoyX4htxeQCamI9UqUl1JLR+IRWa5QShN7LxZZmUtYQaKbK7bLVavgOE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715301; c=relaxed/simple;
	bh=9oxyokKiEgiJ2AU5X2wfhccOkpvOoKtp/Pq0eudubdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ggRifZcl5VIhiclS9yggD+uT5El93XY0fmayWq79tb8UXXEagPQhvsHq8FtjpdPupWcL9eh9sr9Gwys54rCD4+SZkpbz9BtrjEjO7YPHLWA3jUcphxmPqvbzzPcRsTRbhHArPfXpcMl5Rt/0FkV2loz8bbTLW1Bfgm+9BcbrkgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YEdWmpP+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YEdWmpP+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C3EC3277B;
	Tue, 18 Jun 2024 12:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715301;
	bh=9oxyokKiEgiJ2AU5X2wfhccOkpvOoKtp/Pq0eudubdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YEdWmpP+30rLJWq4Y1laiIOjGW4Klud+5umfm7gqHkXi3k8/3wJPjXywd3+tfP9ms
	 0/+Zm+PjPpgQD0rsjuKXeormyILQCp45zB7lH6Z5mhoBLSlNxz5voIV0QKmK/gWVu3
	 UonEH9U00XFBB5s7//xoNjnW1WU3ocVjf3T4SmjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 262/770] nfsd: reshuffle some code
Date: Tue, 18 Jun 2024 14:31:55 +0200
Message-ID: <20240618123417.386922420@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit ebd9d2c2f5a7ebaaed2d7bb4dee148755f46033d ]

No change in behavior, I'm just moving some code around to avoid forward
references in a following patch.

(To do someday: figure out how to split up nfs4state.c.  It's big and
disorganized.)

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 235 ++++++++++++++++++++++----------------------
 1 file changed, 118 insertions(+), 117 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 89d5669ce1463..9c8dacf0f2b86 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -354,6 +354,124 @@ static const struct nfsd4_callback_ops nfsd4_cb_notify_lock_ops = {
 	.release	= nfsd4_cb_notify_lock_release,
 };
 
+/*
+ * We store the NONE, READ, WRITE, and BOTH bits separately in the
+ * st_{access,deny}_bmap field of the stateid, in order to track not
+ * only what share bits are currently in force, but also what
+ * combinations of share bits previous opens have used.  This allows us
+ * to enforce the recommendation of rfc 3530 14.2.19 that the server
+ * return an error if the client attempt to downgrade to a combination
+ * of share bits not explicable by closing some of its previous opens.
+ *
+ * XXX: This enforcement is actually incomplete, since we don't keep
+ * track of access/deny bit combinations; so, e.g., we allow:
+ *
+ *	OPEN allow read, deny write
+ *	OPEN allow both, deny none
+ *	DOWNGRADE allow read, deny none
+ *
+ * which we should reject.
+ */
+static unsigned int
+bmap_to_share_mode(unsigned long bmap)
+{
+	int i;
+	unsigned int access = 0;
+
+	for (i = 1; i < 4; i++) {
+		if (test_bit(i, &bmap))
+			access |= i;
+	}
+	return access;
+}
+
+/* set share access for a given stateid */
+static inline void
+set_access(u32 access, struct nfs4_ol_stateid *stp)
+{
+	unsigned char mask = 1 << access;
+
+	WARN_ON_ONCE(access > NFS4_SHARE_ACCESS_BOTH);
+	stp->st_access_bmap |= mask;
+}
+
+/* clear share access for a given stateid */
+static inline void
+clear_access(u32 access, struct nfs4_ol_stateid *stp)
+{
+	unsigned char mask = 1 << access;
+
+	WARN_ON_ONCE(access > NFS4_SHARE_ACCESS_BOTH);
+	stp->st_access_bmap &= ~mask;
+}
+
+/* test whether a given stateid has access */
+static inline bool
+test_access(u32 access, struct nfs4_ol_stateid *stp)
+{
+	unsigned char mask = 1 << access;
+
+	return (bool)(stp->st_access_bmap & mask);
+}
+
+/* set share deny for a given stateid */
+static inline void
+set_deny(u32 deny, struct nfs4_ol_stateid *stp)
+{
+	unsigned char mask = 1 << deny;
+
+	WARN_ON_ONCE(deny > NFS4_SHARE_DENY_BOTH);
+	stp->st_deny_bmap |= mask;
+}
+
+/* clear share deny for a given stateid */
+static inline void
+clear_deny(u32 deny, struct nfs4_ol_stateid *stp)
+{
+	unsigned char mask = 1 << deny;
+
+	WARN_ON_ONCE(deny > NFS4_SHARE_DENY_BOTH);
+	stp->st_deny_bmap &= ~mask;
+}
+
+/* test whether a given stateid is denying specific access */
+static inline bool
+test_deny(u32 deny, struct nfs4_ol_stateid *stp)
+{
+	unsigned char mask = 1 << deny;
+
+	return (bool)(stp->st_deny_bmap & mask);
+}
+
+static int nfs4_access_to_omode(u32 access)
+{
+	switch (access & NFS4_SHARE_ACCESS_BOTH) {
+	case NFS4_SHARE_ACCESS_READ:
+		return O_RDONLY;
+	case NFS4_SHARE_ACCESS_WRITE:
+		return O_WRONLY;
+	case NFS4_SHARE_ACCESS_BOTH:
+		return O_RDWR;
+	}
+	WARN_ON_ONCE(1);
+	return O_RDONLY;
+}
+
+static inline int
+access_permit_read(struct nfs4_ol_stateid *stp)
+{
+	return test_access(NFS4_SHARE_ACCESS_READ, stp) ||
+		test_access(NFS4_SHARE_ACCESS_BOTH, stp) ||
+		test_access(NFS4_SHARE_ACCESS_WRITE, stp);
+}
+
+static inline int
+access_permit_write(struct nfs4_ol_stateid *stp)
+{
+	return test_access(NFS4_SHARE_ACCESS_WRITE, stp) ||
+		test_access(NFS4_SHARE_ACCESS_BOTH, stp);
+}
+
 static inline struct nfs4_stateowner *
 nfs4_get_stateowner(struct nfs4_stateowner *sop)
 {
@@ -1167,108 +1285,6 @@ static unsigned int clientstr_hashval(struct xdr_netobj name)
 	return opaque_hashval(name.data, 8) & CLIENT_HASH_MASK;
 }
 
-/*
- * We store the NONE, READ, WRITE, and BOTH bits separately in the
- * st_{access,deny}_bmap field of the stateid, in order to track not
- * only what share bits are currently in force, but also what
- * combinations of share bits previous opens have used.  This allows us
- * to enforce the recommendation of rfc 3530 14.2.19 that the server
- * return an error if the client attempt to downgrade to a combination
- * of share bits not explicable by closing some of its previous opens.
- *
- * XXX: This enforcement is actually incomplete, since we don't keep
- * track of access/deny bit combinations; so, e.g., we allow:
- *
- *	OPEN allow read, deny write
- *	OPEN allow both, deny none
- *	DOWNGRADE allow read, deny none
- *
- * which we should reject.
- */
-static unsigned int
-bmap_to_share_mode(unsigned long bmap) {
-	int i;
-	unsigned int access = 0;
-
-	for (i = 1; i < 4; i++) {
-		if (test_bit(i, &bmap))
-			access |= i;
-	}
-	return access;
-}
-
-/* set share access for a given stateid */
-static inline void
-set_access(u32 access, struct nfs4_ol_stateid *stp)
-{
-	unsigned char mask = 1 << access;
-
-	WARN_ON_ONCE(access > NFS4_SHARE_ACCESS_BOTH);
-	stp->st_access_bmap |= mask;
-}
-
-/* clear share access for a given stateid */
-static inline void
-clear_access(u32 access, struct nfs4_ol_stateid *stp)
-{
-	unsigned char mask = 1 << access;
-
-	WARN_ON_ONCE(access > NFS4_SHARE_ACCESS_BOTH);
-	stp->st_access_bmap &= ~mask;
-}
-
-/* test whether a given stateid has access */
-static inline bool
-test_access(u32 access, struct nfs4_ol_stateid *stp)
-{
-	unsigned char mask = 1 << access;
-
-	return (bool)(stp->st_access_bmap & mask);
-}
-
-/* set share deny for a given stateid */
-static inline void
-set_deny(u32 deny, struct nfs4_ol_stateid *stp)
-{
-	unsigned char mask = 1 << deny;
-
-	WARN_ON_ONCE(deny > NFS4_SHARE_DENY_BOTH);
-	stp->st_deny_bmap |= mask;
-}
-
-/* clear share deny for a given stateid */
-static inline void
-clear_deny(u32 deny, struct nfs4_ol_stateid *stp)
-{
-	unsigned char mask = 1 << deny;
-
-	WARN_ON_ONCE(deny > NFS4_SHARE_DENY_BOTH);
-	stp->st_deny_bmap &= ~mask;
-}
-
-/* test whether a given stateid is denying specific access */
-static inline bool
-test_deny(u32 deny, struct nfs4_ol_stateid *stp)
-{
-	unsigned char mask = 1 << deny;
-
-	return (bool)(stp->st_deny_bmap & mask);
-}
-
-static int nfs4_access_to_omode(u32 access)
-{
-	switch (access & NFS4_SHARE_ACCESS_BOTH) {
-	case NFS4_SHARE_ACCESS_READ:
-		return O_RDONLY;
-	case NFS4_SHARE_ACCESS_WRITE:
-		return O_WRONLY;
-	case NFS4_SHARE_ACCESS_BOTH:
-		return O_RDWR;
-	}
-	WARN_ON_ONCE(1);
-	return O_RDONLY;
-}
-
 /*
  * A stateid that had a deny mode associated with it is being released
  * or downgraded. Recalculate the deny mode on the file.
@@ -5565,21 +5581,6 @@ static inline __be32 nfs4_check_fh(struct svc_fh *fhp, struct nfs4_stid *stp)
 	return nfs_ok;
 }
 
-static inline int
-access_permit_read(struct nfs4_ol_stateid *stp)
-{
-	return test_access(NFS4_SHARE_ACCESS_READ, stp) ||
-		test_access(NFS4_SHARE_ACCESS_BOTH, stp) ||
-		test_access(NFS4_SHARE_ACCESS_WRITE, stp);
-}
-
-static inline int
-access_permit_write(struct nfs4_ol_stateid *stp)
-{
-	return test_access(NFS4_SHARE_ACCESS_WRITE, stp) ||
-		test_access(NFS4_SHARE_ACCESS_BOTH, stp);
-}
-
 static
 __be32 nfs4_check_openmode(struct nfs4_ol_stateid *stp, int flags)
 {
-- 
2.43.0



