Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EFB145B29;
	Tue, 23 Apr 2024 21:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908562; cv=none; b=KUVtCJ3xlYW2HuT/8yIfSgyGj5hLUPaMSYGykk/Txch9gb7TyFiRINhPxuzEs1z03Q2BVyFDoN8en/2ngMu2GVytJ/evPU505ITJQijsHK5Ugt/MRLqVgqC/XNhuv8MuHoZZInUz7NeN/5ZnRKU2+TaaNWRg3qc3TVUBTbk635s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908562; c=relaxed/simple;
	bh=Q5lDrRA/9J/3UFt/A/8bVPOExtmLnKI5xy/nRNsEcPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqFgpcPTmilpdt+BOMnNvlJNr50XuSBI6i0TOpqBjgqyFVMtLDYLZmmZN+sQHwGGllSLpzG/2gQ3yv1byfWoSywl3fxadTlUnRWQe+l2VFDu6fylP+ti54TdlcglsdK972P7Dme8eA1oqZ/MKgp5GIhjwT5BknJJ6q5BY2OJ7R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z9f42+SL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z9f42+SL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50996C32781;
	Tue, 23 Apr 2024 21:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908562;
	bh=Q5lDrRA/9J/3UFt/A/8bVPOExtmLnKI5xy/nRNsEcPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z9f42+SLPq50panAZLYJYBQ3GSKBLPpCoIjfK4HscvvLu6kY6Pr4wj43NLxjMRA9l
	 JT15d3DvNKRSiIRAxKPlDADykIBAgZDaLQ82uTwiSK/sUvOVjSaaIAeviB0k0mtVkg
	 lxa64VzQep8/gdVoiy1wvH3mV6+5xe3qEUOH2/QY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/158] smb: client: remove extra @chan_count check in __cifs_put_smb_ses()
Date: Tue, 23 Apr 2024 14:37:18 -0700
Message-ID: <20240423213855.742187126@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit c37ed2d7d09869f30d291b9c6cba56ea4f0b0417 ]

If @ses->chan_count <= 1, then for-loop body will not be executed so
no need to check it twice.

Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 24a9799aa8ef ("smb: client: fix UAF in smb2_reconnect_server()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 97776dd12b6b8..556f3c31aedc7 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2015,9 +2015,10 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 
 void __cifs_put_smb_ses(struct cifs_ses *ses)
 {
-	unsigned int rc, xid;
-	unsigned int chan_count;
 	struct TCP_Server_Info *server = ses->server;
+	unsigned int xid;
+	size_t i;
+	int rc;
 
 	spin_lock(&ses->ses_lock);
 	if (ses->ses_status == SES_EXITING) {
@@ -2063,20 +2064,14 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
 	list_del_init(&ses->smb_ses_list);
 	spin_unlock(&cifs_tcp_ses_lock);
 
-	chan_count = ses->chan_count;
-
 	/* close any extra channels */
-	if (chan_count > 1) {
-		int i;
-
-		for (i = 1; i < chan_count; i++) {
-			if (ses->chans[i].iface) {
-				kref_put(&ses->chans[i].iface->refcount, release_iface);
-				ses->chans[i].iface = NULL;
-			}
-			cifs_put_tcp_session(ses->chans[i].server, 0);
-			ses->chans[i].server = NULL;
+	for (i = 1; i < ses->chan_count; i++) {
+		if (ses->chans[i].iface) {
+			kref_put(&ses->chans[i].iface->refcount, release_iface);
+			ses->chans[i].iface = NULL;
 		}
+		cifs_put_tcp_session(ses->chans[i].server, 0);
+		ses->chans[i].server = NULL;
 	}
 
 	/* we now account for primary channel in iface->refcount */
-- 
2.43.0



