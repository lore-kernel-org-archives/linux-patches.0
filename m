Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109C5BA4F
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690DBC4339B;
	Tue,  7 Mar 2023 19:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678216082;
	bh=eeCU8/tBzYvap0j+f+/IlSz7p+GVMGU+Mro+AJJHqJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xgflRNKCPUPeq3Ojcp7LylEQUjnyDLARtH9KFPKo6PWNVU42aihoeeN4tori//AqI
	 aha7JmZcM2UHDiNPkWDqaG+Of1V6MPlXZ802VO1cKPAnrLCGZKuBqOkU/BnLRB1AWe
	 zLl5NEzdKE2P1g4Ey7gXo/JImZ2VhpS2CC3c3tc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Volker Lendecke <vl@samba.org>,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 438/567] cifs: Fix uninitialized memory read in smb3_qfs_tcon()
Date: Tue,  7 Mar 2023 18:02:54 +0100
Message-Id: <20230307165924.897343517@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Volker Lendecke <vl@samba.org>

commit d447e794a37288ec7a080aa1b044a8d9deebbab7 upstream.

oparms was not fully initialized

Signed-off-by: Volker Lendecke <vl@samba.org>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2ops.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -966,12 +966,13 @@ smb3_qfs_tcon(const unsigned int xid, st
 	struct cifs_fid fid;
 	struct cached_fid *cfid = NULL;
 
-	oparms.tcon = tcon;
-	oparms.desired_access = FILE_READ_ATTRIBUTES;
-	oparms.disposition = FILE_OPEN;
-	oparms.create_options = cifs_create_options(cifs_sb, 0);
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.desired_access = FILE_READ_ATTRIBUTES,
+		.disposition = FILE_OPEN,
+		.create_options = cifs_create_options(cifs_sb, 0),
+		.fid = &fid,
+	};
 
 	rc = open_cached_dir(xid, tcon, "", cifs_sb, &cfid);
 	if (rc == 0)


