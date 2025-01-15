Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5951E98E4;
	Wed, 15 Jan 2025 10:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938205; cv=none; b=fArR9lyp3uvGEET6NpLZqxTMuqQ0Z4WywUCHqSF0nWTwA3Xqzq/gRWqTmcPIkeEMtAA35fvMM2lZ++4T4+Gc8yObRE7b16Ir2zWLqnv+KNiqIWnn6LnP8yjpUxOvPhGG5iIdvwWk9F5U5Eb3Uow93GCAvooLXOrq1SQ3XnXzrQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938205; c=relaxed/simple;
	bh=jUkFeOvezK/IHEeoa8JofPyVT/WiwwhoYqjQjaHdYN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IkajAIUPYuyppND+J3VdSfajKXwXItu6Hw3PZaF+0IHCzAwJ7JvjbK01DzpcoP0Waj8/uOfZkdBzyEOM2Oyslppb3ZfcRlyOlUtmk/A9FblUSzD1xOqZEN5Ey/v+maVodKovHU9VIsGVMcxWy3m7db/h8BcsHuULPsdTY5F2FPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j4hFJcAG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j4hFJcAG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA9BC4CEE2;
	Wed, 15 Jan 2025 10:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938205;
	bh=jUkFeOvezK/IHEeoa8JofPyVT/WiwwhoYqjQjaHdYN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j4hFJcAG/lc+/c8mGcoNhGyjrQEPig19fGpj+VAhad7csA7xrTAGv+tdzyhZNLNYF
	 TP/41ujH+bNJFVenEU1WXKA40zvMU/B9mQ6MwTDkbf6kDoyhE9flOMFC3VQXpKb8dO
	 nyCIuIBIAn647jqfdbRIwHOah8hmcdOBBHThbElc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meetakshi Setiya <msetiya@microsoft.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 114/189] smb: client: sync the root session and superblock context passwords before automounting
Date: Wed, 15 Jan 2025 11:36:50 +0100
Message-ID: <20250115103611.012847740@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meetakshi Setiya <msetiya@microsoft.com>

commit 20b1aa912316ffb7fbb5f407f17c330f2a22ddff upstream.

In some cases, when password2 becomes the working password, the
client swaps the two password fields in the root session struct, but
not in the smb3_fs_context struct in cifs_sb. DFS automounts inherit
fs context from their parent mounts. Therefore, they might end up
getting the passwords in the stale order.
The automount should succeed, because the mount function will end up
retrying with the actual password anyway. But to reduce these
unnecessary session setup retries for automounts, we can sync the
parent context's passwords with the root session's passwords before
duplicating it to the child's fs context.

Cc: stable@vger.kernel.org
Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/namespace.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/fs/smb/client/namespace.c
+++ b/fs/smb/client/namespace.c
@@ -196,11 +196,28 @@ static struct vfsmount *cifs_do_automoun
 	struct smb3_fs_context tmp;
 	char *full_path;
 	struct vfsmount *mnt;
+	struct cifs_sb_info *mntpt_sb;
+	struct cifs_ses *ses;
 
 	if (IS_ROOT(mntpt))
 		return ERR_PTR(-ESTALE);
 
-	cur_ctx = CIFS_SB(mntpt->d_sb)->ctx;
+	mntpt_sb = CIFS_SB(mntpt->d_sb);
+	ses = cifs_sb_master_tcon(mntpt_sb)->ses;
+	cur_ctx = mntpt_sb->ctx;
+
+	/*
+	 * At this point, the root session should be in the mntpt sb. We should
+	 * bring the sb context passwords in sync with the root session's
+	 * passwords. This would help prevent unnecessary retries and password
+	 * swaps for automounts.
+	 */
+	mutex_lock(&ses->session_mutex);
+	rc = smb3_sync_session_ctx_passwords(mntpt_sb, ses);
+	mutex_unlock(&ses->session_mutex);
+
+	if (rc)
+		return ERR_PTR(rc);
 
 	fc = fs_context_for_submount(path->mnt->mnt_sb->s_type, mntpt);
 	if (IS_ERR(fc))


