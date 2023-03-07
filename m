Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335DABA34
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:31:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE1BC433A7;
	Tue,  7 Mar 2023 17:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210267;
	bh=PDIVsOlCwFT1k3N3H3OIoDZhGVUi9IHilVno7x2T4ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=knmbKfDSY9sPkaSSbWiuG2tXdqTYLKFaH1aS6lj1wCckuwZw+zfj0wf9h6u5SHvbg
	 Z3qxBkWCl6S03abnOkcMpIoBnb5O0629Nm75TIEIDMaR4OyfL/4X7pZZVwnmSV/3zz
	 3rzK4YwGzG3vsHAzdwKXN7VD7u0DxM7GZekx05j0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0459/1001] cifs: use tcon allocation functions even for dummy tcon
Date: Tue,  7 Mar 2023 17:53:51 +0100
Message-Id: <20230307170041.302683781@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit df57109bd50b9ed6911f3c2aa914189fe4c1fe2c ]

In smb2_reconnect_server, we allocate a dummy tcon for
calling reconnect for just the session. This should be
allocated using tconInfoAlloc, and not kmalloc.

Fixes: 3663c9045f51 ("cifs: check reconnects for channels of active tcons too")
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 2c9ffa921e6f6..3b93680a319e4 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3898,7 +3898,7 @@ void smb2_reconnect_server(struct work_struct *work)
 		goto done;
 
 	/* allocate a dummy tcon struct used for reconnect */
-	tcon = kzalloc(sizeof(struct cifs_tcon), GFP_KERNEL);
+	tcon = tconInfoAlloc();
 	if (!tcon) {
 		resched = true;
 		list_for_each_entry_safe(ses, ses2, &tmp_ses_list, rlist) {
@@ -3921,7 +3921,7 @@ void smb2_reconnect_server(struct work_struct *work)
 		list_del_init(&ses->rlist);
 		cifs_put_smb_ses(ses);
 	}
-	kfree(tcon);
+	tconInfoFree(tcon);
 
 done:
 	cifs_dbg(FYI, "Reconnecting tcons and channels finished\n");
-- 
2.39.2



