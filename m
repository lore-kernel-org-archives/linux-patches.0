Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A030C8825
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:00:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19FE8C4339E;
	Fri, 10 Mar 2023 15:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460443;
	bh=arE9gBVWHkVoQ0QTDqXZwU3x+HNbrjUB+oshiRy3by0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WyRKwDgU0SbPV5Hr9uoJgDoqXg7zACBATbm0bmx0DX9JIU51i7j6MvJDrPQjy/CZP
	 15KiK0lZyMVzHZF7mx+cnDezL03hBGWwXEB3JNw9x6RrBScYh9zKoixikfi0/mGcuR
	 x/IjKP61Sh64Obkmted/8LRZy28qXDvO/mhal/OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Volker Lendecke <vl@samba.org>,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.10 336/529] cifs: Fix uninitialized memory read in smb3_qfs_tcon()
Date: Fri, 10 Mar 2023 14:37:59 +0100
Message-Id: <20230310133820.580161339@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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
@@ -859,12 +859,13 @@ smb3_qfs_tcon(const unsigned int xid, st
 	bool no_cached_open = tcon->nohandlecache;
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
 
 	if (no_cached_open) {
 		rc = SMB2_open(xid, &oparms, &srch_path, &oplock, NULL, NULL,


