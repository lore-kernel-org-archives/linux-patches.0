Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C31227EBD;
	Tue,  8 Apr 2025 11:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112599; cv=none; b=LVFDF3qE40oT1Zl17RVlqci94gKNbGBDo4tXvKS097sByp1X26sQsG+brnKAJ6DhJIU0v4R72JuFokVuaTROZZFbuKbDndhpbNZIEe8WH3No9QlC3Hr9q1wU4vXJyMbimMar5mxse6hFgzG6IFR0veUdrGQrsS0poSzsQR8Sqe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112599; c=relaxed/simple;
	bh=fV6UWKzzGdoVFCaDMgR58Gu7znpgKAq9YiZrCJik7QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/MjITlkwQRb9gCG6pCK5Se3CTLzPUBVU3cWej3oFTCb12N/nxDsJh0rksUQRwAckgW0uTWrFEgKF4l9CnjLfN6UXl0vIeBowx9YzPcbxEcGAcRcEOtP/v7skQR1dXwoXS3cy3U63W+J69yZ3D7tobf77qldOgMj4BjpldKhP2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aMSPH5pi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMSPH5pi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D12C4CEE5;
	Tue,  8 Apr 2025 11:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112599;
	bh=fV6UWKzzGdoVFCaDMgR58Gu7znpgKAq9YiZrCJik7QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aMSPH5piUnj0QFqaZcxMQxdbFZSESsX7AavYeb4akWgIYKIi4hwmAoQrbTCnfW5Kl
	 v/oqGuyEK+9V6dbBl3GhTJkJnPama2ud2lYW33O/1NTbOkdt9uTOJ95jlMj+lSMTOn
	 17vIBdx1fl91YtpCbMXi+IPoMOP0ifOfthAX0sRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.15 078/279] smb: client: fix potential UAF in cifs_debug_files_proc_show()
Date: Tue,  8 Apr 2025 12:47:41 +0200
Message-ID: <20250408104828.451307532@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

commit ca545b7f0823f19db0f1148d59bc5e1a56634502 upstream.

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ This patch removes lock/unlock operation in routine cifs_ses_exiting()
  for ses_lock is not present in v5.15 and not ported yet. ses->status
  is protected by a global lock, cifs_tcp_ses_lock, in v5.15. ]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifs_debug.c |    2 ++
 fs/cifs/cifsglob.h   |    8 ++++++++
 2 files changed, 10 insertions(+)

--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -183,6 +183,8 @@ static int cifs_debug_files_proc_show(st
 	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
 		list_for_each(tmp, &server->smb_ses_list) {
 			ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
+			if (cifs_ses_exiting(ses))
+				continue;
 			list_for_each(tmp1, &ses->tcon_list) {
 				tcon = list_entry(tmp1, struct cifs_tcon, tcon_list);
 				spin_lock(&tcon->open_file_lock);
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -2041,4 +2041,12 @@ static inline struct scatterlist *cifs_s
 	return sg;
 }
 
+static inline bool cifs_ses_exiting(struct cifs_ses *ses)
+{
+	bool ret;
+
+	ret = ses->status == CifsExiting;
+	return ret;
+}
+
 #endif	/* _CIFS_GLOB_H */


