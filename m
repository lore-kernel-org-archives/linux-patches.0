Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF530401A18;
	Tue, 21 Jul 2026 17:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654640; cv=none; b=V4YoG98j58PgrOFZ4sOHu+ideRcP/Ukrjv9cEP0HXL5WxuvoMU5FslmDLfIeKJdv9yE104+wRO5WvHYQ14vKqQLHIh4HMwCVNbcoEJAd41q2UNS89AwXtRdkDK3TNA+QGUgYlcymV1EL3yomfINBSQ/4GC/IAbdmZ8nwmSsxR3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654640; c=relaxed/simple;
	bh=lxTGACXFeDodRftt1zA1fYsUIbiY6jxwAQqEg3ziKWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7u7pHD7v3ePyw3lw4ZoKoKhbzgDERqC7qfeVI+kXbhejmT4/qfLYusQO9edHjaXaYCQZ5bk0aAfvZNqimYxczd8f3EVDypMMWAz4KGlMgD+HaQATcjZATcV1jmf4ZaK4Jd4BorZe9DNsrGlkeotoQvMtVRmTRnfyCRlva9C/Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hUpVeRMD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUpVeRMD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240C91F000E9;
	Tue, 21 Jul 2026 17:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654638;
	bh=0gBWMd+wkTA2wv5zMCGPYEITItSnstlGad8MGu7F7zU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hUpVeRMDmwA1KlR7XyQIXcjzvRlCKTP864VgYTPZlRKYglsM9bdpnW5BSuzg9gBoK
	 vrGucjPMQ5FDiZNmo28vROtvKZkmuaOyKr7OgvBKzkCOSuUBsSr9onHKrXM2a0Mdhu
	 msdRFr1i1b2/HFh3yxS55mDiG8NCj6PY6u2IUi9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Changwei Ge <gechangwei@live.cn>,
	Heming Zhao <heming.zhao@suse.com>,
	Joel Becker <jlbec@evilplan.org>,
	Jun Piao <piaojun@huawei.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Mark Fasheh <mark@fasheh.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 1754/2077] ocfs2: reject dinodes whose i_rdev disagrees with the file type
Date: Tue, 21 Jul 2026 17:23:47 +0200
Message-ID: <20260721152634.114903343@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 51407c2d249987a466416890a5c931a2354a46aa upstream.

id1.dev1.i_rdev is the device-number arm of the ocfs2_dinode id1 union.
It is only meaningful for character and block device inodes.  For any
other user-visible file type the on-disk value must be zero.

ocfs2_populate_inode() currently copies id1.dev1.i_rdev into inode->i_rdev
before the S_IFMT switch decides whether the inode is a special file.  A
non-device inode with a non-zero i_rdev can therefore publish stale or
attacker-controlled device state into the in-core inode.

System inodes legitimately use other arms of the same union, so keep the
cross-check restricted to non-system inodes.  Factor that predicate into a
helper and use it in both the normal validator and online filecheck path;
filecheck reports the malformed dinode through
OCFS2_FILECHECK_ERR_INVALIDINO instead of ocfs2_error().

Link: https://lore.kernel.org/20260519110404.1803902-3-michael.bommarito@gmail.com
Fixes: b657c95c1108 ("ocfs2: Wrap inode block reads in a dedicated function.")
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-7
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/inode.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -72,6 +72,16 @@ static bool ocfs2_valid_inode_mode(umode
 	return fs_umode_to_ftype(mode) != FT_UNKNOWN;
 }
 
+static bool ocfs2_dinode_has_unexpected_rdev(struct ocfs2_dinode *di)
+{
+	umode_t mode = le16_to_cpu(di->i_mode);
+
+	if (le32_to_cpu(di->i_flags) & OCFS2_SYSTEM_FL)
+		return false;
+
+	return !S_ISCHR(mode) && !S_ISBLK(mode) && di->id1.dev1.i_rdev != 0;
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1518,6 +1528,41 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
+	/*
+	 * id1.dev1.i_rdev is the device-number arm of the id1 union and
+	 * is only meaningful for character and block device inodes.  For
+	 * any other regular user-visible file type the on-disk value
+	 * must be zero.  ocfs2_populate_inode() currently runs
+	 *
+	 *     inode->i_rdev = huge_decode_dev(le64_to_cpu(fe->id1.dev1.i_rdev));
+	 *
+	 * unconditionally, before the S_IFMT switch decides whether the
+	 * inode is a special file.  As a result, an i_rdev value present
+	 * on a non-device inode is silently published into the in-core
+	 * inode; a subsequent forced re-read or in-core mode mutation
+	 * (cluster peer with raw write access to the shared LUN,
+	 * on-disk corruption, or a separately forged dinode) can then
+	 * expose the attacker-controlled device number to
+	 * init_special_inode() without ever showing an unusual i_mode
+	 * at validation time.
+	 *
+	 * System inodes (OCFS2_SYSTEM_FL) legitimately use the bitmap1
+	 * and journal1 arms of the same union (allocator i_used /
+	 * i_total counters and the journal ij_flags /
+	 * ij_recovery_generation pair); those bytes are not an i_rdev
+	 * and must not be checked here.  Restrict the cross-check to
+	 * non-system inodes, which is the full attacker-controllable
+	 * surface.
+	 */
+	if (ocfs2_dinode_has_unexpected_rdev(di)) {
+		rc = ocfs2_error(sb,
+				 "Invalid dinode #%llu: non-device mode 0%o with i_rdev %llu\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(di->i_mode),
+				 (unsigned long long)le64_to_cpu(di->id1.dev1.i_rdev));
+		goto bail;
+	}
+
 	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
 		struct ocfs2_inline_data *data = &di->id2.i_data;
 
@@ -1712,6 +1757,16 @@ static int ocfs2_filecheck_validate_inod
 		     (unsigned long long)bh->b_blocknr,
 		     le16_to_cpu(di->i_mode));
 		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
+	if (ocfs2_dinode_has_unexpected_rdev(di)) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: non-device mode 0%o with i_rdev %llu\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->i_mode),
+		     (unsigned long long)le64_to_cpu(di->id1.dev1.i_rdev));
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
 	}
 
 bail:


