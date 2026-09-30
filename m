Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0148309EF2;
	Wed, 30 Sep 2026 18:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794584; cv=none; b=ZmFq8bdV6E1WawyFepV5MGpeODL1k9d0tKCCGv583fpXBg6OiqOAjcLPsvGavbNg0wB7qsxcoIhSBY3VIwM7l4CgwKlv9qWsPo8TjoNsJ6fffh+xcuEEu+QQZzsqt/AnTHz1TkMSyBN4+hPho6xZgqHVCNSP9p9BNn6ggZHQmJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794584; c=relaxed/simple;
	bh=+WoftDQYOWkJ+vvK2enIlYdBuHv1tOYVLhGC8NL1u3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDYIaT5AZFiFbbmKbbPxNIwjHkzXrjX4pziBzJapSBQNrS5UJbVUNkyzUmhJILEEQIg9oN+H25GtWFZ4FJFvcGhb04PL2hgWDbbCSoSG/XSnb5FyD64jV7ijmVt3aHy7hhJTf3nGDc91RHa8zt5WLKhIdUIr2QuOsjk+LM+0LIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/XuvTni; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/XuvTni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64D71F000FF;
	Wed, 30 Sep 2026 18:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794583;
	bh=CqYrOhIAWCwHqXj0kZcOTktx9Ne7Cm4ULx4XAYcrils=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t/XuvTnibb8iqjsdDOi3G1m8O9/VJg9y41DU0/hV1WK5I/g0l1NQ3ioJw2bKBBD70
	 Oe3I0uPA/qs4QA9bKRInhi1umMkMRgU2OC7JAfnk0oZlYx6jYwgl6w/iO7T/m27Ig/
	 vpz9ezp1S0UV/Uf4GfYMRAPyTvqnW/P61A4NFq1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0261/1193] ksmbd: treat read-control opens as stat opens only for leases
Date: Wed, 30 Sep 2026 17:15:45 +0200
Message-ID: <20260930152439.968869516@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit be939e11c4724d1de3650e8bafd4c3583d9684b2 ]

A second open that requests only metadata-level access must not break
the existing caching state. ksmbd already skips the break for such opens
via fp->attrib_only (FILE_READ_ATTRIBUTES,
FILE_WRITE_ATTRIBUTES and FILE_SYNCHRONIZE).

An open requesting only READ_CONTROL (reading the security descriptor)
must be treated differently depending on the existing caching state.
smbtorture smb2.lease.statopen4 expects a read-control open NOT to break
a caching lease, while smb2.oplock.statopen1 expects the same open to
break a batch oplock. So READ_CONTROL is a stat open for leases but not
for oplocks.

Extend the stat-open break-skip in smb_grant_oplock() to also cover a
read-control-only open, but only when the existing holder is a lease.
The global fp->attrib_only flag (used for share-mode, rename and truncate
decisions) is left unchanged so oplock behaviour is preserved.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/oplock.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index e1e3832190c74..dc2ca423a1bf8 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -208,6 +208,18 @@ void opinfo_put(struct oplock_info *opinfo)
 	free_opinfo(opinfo);
 }
 
+static bool ksmbd_inode_has_lease(struct ksmbd_inode *ci)
+{
+	struct oplock_info *opinfo = opinfo_get_list(ci);
+	bool is_lease;
+
+	if (!opinfo)
+		return false;
+	is_lease = opinfo->is_lease;
+	opinfo_put(opinfo);
+	return is_lease;
+}
+
 static void opinfo_add(struct oplock_info *opinfo, struct ksmbd_file *fp)
 {
 	struct ksmbd_inode *ci = fp->f_ci;
@@ -1331,10 +1343,22 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 	if (!opinfo_count(fp))
 		goto set_lev;
 
-	/* grant none-oplock if second open is trunc */
-	if (fp->attrib_only && fp->cdoption != FILE_OVERWRITE_IF_LE &&
+	/*
+	 * A stat open that only requests metadata access must not break the
+	 * existing caching state. READ_CONTROL (reading the security
+	 * descriptor) does not conflict with a lease, but it does conflict
+	 * with an oplock, so only treat a read-control-only open as a stat
+	 * open when the existing holder is a lease.
+	 */
+	if (fp->cdoption != FILE_OVERWRITE_IF_LE &&
 	    fp->cdoption != FILE_OVERWRITE_LE &&
-	    fp->cdoption != FILE_SUPERSEDE_LE) {
+	    fp->cdoption != FILE_SUPERSEDE_LE &&
+	    (fp->attrib_only ||
+	     (!(fp->daccess & ~(FILE_READ_ATTRIBUTES_LE |
+				FILE_WRITE_ATTRIBUTES_LE |
+				FILE_SYNCHRONIZE_LE |
+				FILE_READ_CONTROL_LE)) &&
+	      ksmbd_inode_has_lease(ci)))) {
 		req_op_level = SMB2_OPLOCK_LEVEL_NONE;
 		goto set_lev;
 	}
-- 
2.53.0



