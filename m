Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24822206AA;
	Tue, 29 Apr 2025 17:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947187; cv=none; b=IUVlnJpfjUe5wnd+HnhRHu+gpXBR6N+SLvIWhU+zB0qu1SziZ1JFndMfEPhEy9r1fpjjvqxLRdupfwSIzelvVTrzJo+MUDoN5wWM0LXg49pIhqLT0aggKfyFhnGPrlQu+Z+TGHbwvDTmcIJGbcxuptKmEogk7+oBeBY253GroIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947187; c=relaxed/simple;
	bh=TcG8tgpJ+bi3HZi5NQq0FNSQRcFuOWdfe+dmZSnkGsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TeLalwNE98UyH0hvwFVt+vZGtVA0cruj5cbDEWHn1oRSv4SS8FZIq7SOZE3jaTuMDmrYp9ZJIKSGjCd56MgL0NiLESPUZ2TcdHIDEqznibIP2JEMdI0OnAh3P0VdBRAImGHYn4SEjTqCXqyS/8DLs011ljgTggDhVv8pHT3I7KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7L+2q1q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7L+2q1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43FE9C4CEE3;
	Tue, 29 Apr 2025 17:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947187;
	bh=TcG8tgpJ+bi3HZi5NQq0FNSQRcFuOWdfe+dmZSnkGsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q7L+2q1qHHEwv7xDeSAwmBjTCg8Uk0lQAcC3i3z7VqyKN5hLgfJKlqVbXZmPgJ89K
	 zz06ICKuemzcKc3UHyaHjyAvqPMKHtpyL5Oy6rFj+jm6DCLsec+u5STHDzF2hR47/h
	 z0oLZ21713dH65nAV8HGtZRZ8o9Z3XxhBOUnzLSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.10 161/286] smb: client: fix potential UAF in cifs_debug_files_proc_show()
Date: Tue, 29 Apr 2025 18:41:05 +0200
Message-ID: <20250429161114.508796090@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

commit ca545b7f0823f19db0f1148d59bc5e1a56634502 upstream.

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ This patch removes lock/unlock operation in routine cifs_ses_exiting()
  for ses_lock is not present in v5.10 and not ported yet. ses->status
  is protected by a global lock, cifs_tcp_ses_lock, in v5.10. ]
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
 				    tcp_ses_list);
 		list_for_each(tmp, &server->smb_ses_list) {
 			ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
+			if (cifs_ses_exiting(ses))
+				continue;
 			list_for_each(tmp1, &ses->tcon_list) {
 				tcon = list_entry(tmp1, struct cifs_tcon, tcon_list);
 				spin_lock(&tcon->open_file_lock);
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -2115,4 +2115,12 @@ static inline struct scatterlist *cifs_s
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


