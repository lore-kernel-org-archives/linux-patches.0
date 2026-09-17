Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DFA54705A;
	Thu, 17 Sep 2026 18:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668242; cv=none; b=Jh9SEqTFoSfGWSDQj8g+atScMAqpkIqkB2ieCB+GKk3vw6/kjlvhwAIPsJFz4v3SrAKcc0B1RYwiNFEXHABu1oxan3RYVM7NNAPscsMHRbUVy8Yr1PCjARB2DJ3M+mM6ipC7TiPugRpiF7DTbg9lPSwwEVrGV1hJYYbItcYOeMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668242; c=relaxed/simple;
	bh=glHA/snsfntS8g3gsm6oYFcAzI/TO3df2VG+ZdwpfxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CE0yvzYGjK68a67GSqhgkcHsfTKLJCh6DxaLOlS4YUjHklwA2Do+IVsbK+Nfme22iQZ0uc+gHJbzw1d5NxwKxFroZ/87SYARspHySdAnDuOvJQ03F45lW7fRFzkigv9Id1qITKrN4rc2BI5a6/nzS6GVwUh8WB7ts4veGMUclCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KGI1Ktxm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KGI1Ktxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A621F000FF;
	Thu, 17 Sep 2026 18:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668240;
	bh=qz8UQPeA3SOsQYaFWKz/sxrkz0m90loFKwmdQdtom2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KGI1Ktxm7A5AMJZBNOW0y8NSGfQSNygYszrnCd88GVs1UjXG/L+lw5LMvS/IaLXfh
	 1BKJz1nRom78nOnq8bZA2/g5AwuNGk7rjYaexY7LCqfS1FtQEz/mbMMMdN+gkncza2
	 IDNPKoWGj5fEU7oLbe2F9EpVUbNOkPxOQszjy+9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0359/1102] ksmbd: treat read-control opens as stat opens only for leases
Date: Thu, 17 Sep 2026 16:05:02 +0100
Message-ID: <20260917151548.659872599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a413d81db11b9..6183bd52ca9d1 100644
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



