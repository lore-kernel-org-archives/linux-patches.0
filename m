Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C51433EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:56:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D76C433F2;
	Mon, 16 Jan 2023 15:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884597;
	bh=UOYZVzsz4sHHWxo/TzPiAXAEMO3oShLbeC5mYHnj0XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J0TkM+96I9gtlsMZphaSD29tGIZvlDJKRruqnElpH6Fxo5FT5BXc39HLZWZluONJn
	 m0g7NatW7Nceq7kY55A7bGSfcVsc1vr93X2Cccno1QVvCwinOi36wSt76ORvGsLGMu
	 lH1ZrbdAx2Qd+MM4g7HEdf270TPKS3CZP+fhX4RM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 039/183] cifs: fix file info setting in cifs_query_path_info()
Date: Mon, 16 Jan 2023 16:49:22 +0100
Message-Id: <20230116154805.027598454@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@cjr.nz>

commit 29cf28235e3e57e0af01ae29db57a75f87a2ada8 upstream.

We missed to set file info when CIFSSMBQPathInfo() returned 0, thus
leaving cifs_open_info_data::fi unset.

Fix this by setting cifs_open_info_data::fi when either
CIFSSMBQPathInfo() or SMBQueryInformation() succeed.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216881
Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb1ops.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 50480751e521..5fe2c2f8ef41 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -562,17 +562,20 @@ static int cifs_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 	if ((rc == -EOPNOTSUPP) || (rc == -EINVAL)) {
 		rc = SMBQueryInformation(xid, tcon, full_path, &fi, cifs_sb->local_nls,
 					 cifs_remap(cifs_sb));
-		if (!rc)
-			move_cifs_info_to_smb2(&data->fi, &fi);
 		*adjustTZ = true;
 	}
 
-	if (!rc && (le32_to_cpu(fi.Attributes) & ATTR_REPARSE)) {
+	if (!rc) {
 		int tmprc;
 		int oplock = 0;
 		struct cifs_fid fid;
 		struct cifs_open_parms oparms;
 
+		move_cifs_info_to_smb2(&data->fi, &fi);
+
+		if (!(le32_to_cpu(fi.Attributes) & ATTR_REPARSE))
+			return 0;
+
 		oparms.tcon = tcon;
 		oparms.cifs_sb = cifs_sb;
 		oparms.desired_access = FILE_READ_ATTRIBUTES;
-- 
2.39.0



