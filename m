Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE45B248BA6;
	Wed, 15 Jan 2025 10:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938059; cv=none; b=s2C7b59TLlMYC6cT1PRT9SdXg9pa9ECVsbzW2lsEkcsjt7IQsbI+E26Lbv9hC9zHIBy+/azHR5TagbHOVFGYd0/OzW1VRQgCHPhKih8ddEDrtZ0EJJmaBTmpRvTdYMsQ3tvv/pao0exVwxdy3bE3GM9Ce1YnKJwU7fWLmZyLq88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938059; c=relaxed/simple;
	bh=hLIOLEoZYwOt6VcQ2MTct0eKChOWXYh/HIkIF9uh/Cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8ggkBCnH+REHv/Me7bBzE0kOC/9a9JpIjF+U7HmSMgz3dgEF/ve26NGCHdG6IVXgpY2NV4+Kh1ZtL4lAnD0Uy0karW6FGLcxYPRD710ZNEM+QupTSN+hi33iC8SkNpQ45nBXKULC4h4k3hQN0Op3y8RtOPzA3j6GEAJCDsjF6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7E7TD3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7E7TD3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD86C4CEDF;
	Wed, 15 Jan 2025 10:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938058;
	bh=hLIOLEoZYwOt6VcQ2MTct0eKChOWXYh/HIkIF9uh/Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p7E7TD3RRNaHR89sDmHiMnhnY6pZNI9gBgIFi7thuEvTjkxzO6RpXArfld399KwKq
	 so9RpRdQ1cVLQid4xEbCF4c77zyT+iCVLPMOmb0MPpurfLl4/Pc0oGBapQzGE7mre+
	 MPWk5F2AjRgI8u2F/EYcHMeCyUwXX1aC5KNLvswg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7848fee1f1e5c53f912b@syzkaller.appspotmail.com,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 071/189] afs: Fix the maximum cell name length
Date: Wed, 15 Jan 2025 11:36:07 +0100
Message-ID: <20250115103609.194166682@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit 8fd56ad6e7c90ac2bddb0741c6b248c8c5d56ac8 ]

The kafs filesystem limits the maximum length of a cell to 256 bytes, but a
problem occurs if someone actually does that: kafs tries to create a
directory under /proc/net/afs/ with the name of the cell, but that fails
with a warning:

        WARNING: CPU: 0 PID: 9 at fs/proc/generic.c:405

because procfs limits the maximum filename length to 255.

However, the DNS limits the maximum lookup length and, by extension, the
maximum cell name, to 255 less two (length count and trailing NUL).

Fix this by limiting the maximum acceptable cellname length to 253.  This
also allows us to be sure we can create the "/afs/.<cell>/" mountpoint too.

Further, split the YFS VL record cell name maximum to be the 256 allowed by
the protocol and ignore the record retrieved by YFSVL.GetCellName if it
exceeds 253.

Fixes: c3e9f888263b ("afs: Implement client support for the YFSVL.GetCellName RPC op")
Reported-by: syzbot+7848fee1f1e5c53f912b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/6776d25d.050a0220.3a8527.0048.GAE@google.com/
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/376236.1736180460@warthog.procyon.org.uk
Tested-by: syzbot+7848fee1f1e5c53f912b@syzkaller.appspotmail.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/afs.h      | 2 +-
 fs/afs/afs_vl.h   | 1 +
 fs/afs/vl_alias.c | 8 ++++++--
 fs/afs/vlclient.c | 2 +-
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/afs/afs.h b/fs/afs/afs.h
index b488072aee87..ec3db00bd081 100644
--- a/fs/afs/afs.h
+++ b/fs/afs/afs.h
@@ -10,7 +10,7 @@
 
 #include <linux/in.h>
 
-#define AFS_MAXCELLNAME		256  	/* Maximum length of a cell name */
+#define AFS_MAXCELLNAME		253  	/* Maximum length of a cell name (DNS limited) */
 #define AFS_MAXVOLNAME		64  	/* Maximum length of a volume name */
 #define AFS_MAXNSERVERS		8   	/* Maximum servers in a basic volume record */
 #define AFS_NMAXNSERVERS	13  	/* Maximum servers in a N/U-class volume record */
diff --git a/fs/afs/afs_vl.h b/fs/afs/afs_vl.h
index a06296c8827d..b835e25a2c02 100644
--- a/fs/afs/afs_vl.h
+++ b/fs/afs/afs_vl.h
@@ -13,6 +13,7 @@
 #define AFS_VL_PORT		7003	/* volume location service port */
 #define VL_SERVICE		52	/* RxRPC service ID for the Volume Location service */
 #define YFS_VL_SERVICE		2503	/* Service ID for AuriStor upgraded VL service */
+#define YFS_VL_MAXCELLNAME	256  	/* Maximum length of a cell name in YFS protocol */
 
 enum AFSVL_Operations {
 	VLGETENTRYBYID		= 503,	/* AFS Get VLDB entry by ID */
diff --git a/fs/afs/vl_alias.c b/fs/afs/vl_alias.c
index 9f36e14f1c2d..f9e76b604f31 100644
--- a/fs/afs/vl_alias.c
+++ b/fs/afs/vl_alias.c
@@ -253,6 +253,7 @@ static char *afs_vl_get_cell_name(struct afs_cell *cell, struct key *key)
 static int yfs_check_canonical_cell_name(struct afs_cell *cell, struct key *key)
 {
 	struct afs_cell *master;
+	size_t name_len;
 	char *cell_name;
 
 	cell_name = afs_vl_get_cell_name(cell, key);
@@ -264,8 +265,11 @@ static int yfs_check_canonical_cell_name(struct afs_cell *cell, struct key *key)
 		return 0;
 	}
 
-	master = afs_lookup_cell(cell->net, cell_name, strlen(cell_name),
-				 NULL, false);
+	name_len = strlen(cell_name);
+	if (!name_len || name_len > AFS_MAXCELLNAME)
+		master = ERR_PTR(-EOPNOTSUPP);
+	else
+		master = afs_lookup_cell(cell->net, cell_name, name_len, NULL, false);
 	kfree(cell_name);
 	if (IS_ERR(master))
 		return PTR_ERR(master);
diff --git a/fs/afs/vlclient.c b/fs/afs/vlclient.c
index cac75f89b64a..55dd0fc5aad7 100644
--- a/fs/afs/vlclient.c
+++ b/fs/afs/vlclient.c
@@ -697,7 +697,7 @@ static int afs_deliver_yfsvl_get_cell_name(struct afs_call *call)
 			return ret;
 
 		namesz = ntohl(call->tmp);
-		if (namesz > AFS_MAXCELLNAME)
+		if (namesz > YFS_VL_MAXCELLNAME)
 			return afs_protocol_error(call, afs_eproto_cellname_len);
 		paddedsz = (namesz + 3) & ~3;
 		call->count = namesz;
-- 
2.39.5



