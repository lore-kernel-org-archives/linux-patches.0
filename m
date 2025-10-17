Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28B3336EED;
	Fri, 17 Oct 2025 15:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715504; cv=none; b=AsNRzI00foCu9uLlxUFA6XJzu/JA6Oa4qedSS7mg7Y+8MCQmaWy+LdQPcPspvC7BLNy+DlfvAtNr7Wlm0BRazg6+M2Qn4pD+W8yjpDqXtGIdVsJisjNqWO+q8wW7Opzd+QsyGpsPw6GELF/cPyOa9KtI8hjdgHDJXfZLvbJyGoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715504; c=relaxed/simple;
	bh=ViqXjPRBc03EfVrFjbGqM6kXnwHnzOw0eLmYwq2eWoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8JC6eTFJhlutuONqPe2EUrCzqgxcEgQTHUw/VSLxjNBj7EHSNdsqv5wu4Dol9or4unN8Q7olbxVeJhJxEJ2nXsinEDQGxLvsr9I5+aHxOwZV1rs9RHHZKtlRDug84FVlbnp+x84r/rwevlXQSTnIq7StpFCXEmjAKFh32grk6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X21ES++V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X21ES++V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343D5C4CEE7;
	Fri, 17 Oct 2025 15:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715504;
	bh=ViqXjPRBc03EfVrFjbGqM6kXnwHnzOw0eLmYwq2eWoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X21ES++V3W5FPgmN3kyqMrWLH3/DzOHJAg/zuvsDB2UuHz3JOT39M0TErkCzn5ABP
	 3x6+DVbSA9Mu4njrpN9k0TFlrCvPIoRCsylaOctl+dOcMLixH8Hsxf9EHboZOYaUYB
	 KI8v+X0kPc9HJcL7ylzsXvDzitPC3bhqQU9s6q5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anderson Nascimento <anderson@allelesecurity.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.17 196/371] btrfs: avoid potential out-of-bounds in btrfs_encode_fh()
Date: Fri, 17 Oct 2025 16:52:51 +0200
Message-ID: <20251017145209.018024140@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anderson Nascimento <anderson@allelesecurity.com>

commit dff4f9ff5d7f289e4545cc936362e01ed3252742 upstream.

The function btrfs_encode_fh() does not properly account for the three
cases it handles.

Before writing to the file handle (fh), the function only returns to the
user BTRFS_FID_SIZE_NON_CONNECTABLE (5 dwords, 20 bytes) or
BTRFS_FID_SIZE_CONNECTABLE (8 dwords, 32 bytes).

However, when a parent exists and the root ID of the parent and the
inode are different, the function writes BTRFS_FID_SIZE_CONNECTABLE_ROOT
(10 dwords, 40 bytes).

If *max_len is not large enough, this write goes out of bounds because
BTRFS_FID_SIZE_CONNECTABLE_ROOT is greater than
BTRFS_FID_SIZE_CONNECTABLE originally returned.

This results in an 8-byte out-of-bounds write at
fid->parent_root_objectid = parent_root_id.

A previous attempt to fix this issue was made but was lost.

https://lore.kernel.org/all/4CADAEEC020000780001B32C@vpn.id2.novell.com/

Although this issue does not seem to be easily triggerable, it is a
potential memory corruption bug that should be fixed. This patch
resolves the issue by ensuring the function returns the appropriate size
for all three cases and validates that *max_len is large enough before
writing any data.

Fixes: be6e8dc0ba84 ("NFS support for btrfs - v3")
CC: stable@vger.kernel.org # 3.0+
Signed-off-by: Anderson Nascimento <anderson@allelesecurity.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/export.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -23,7 +23,11 @@ static int btrfs_encode_fh(struct inode
 	int type;
 
 	if (parent && (len < BTRFS_FID_SIZE_CONNECTABLE)) {
-		*max_len = BTRFS_FID_SIZE_CONNECTABLE;
+		if (btrfs_root_id(BTRFS_I(inode)->root) !=
+		    btrfs_root_id(BTRFS_I(parent)->root))
+			*max_len = BTRFS_FID_SIZE_CONNECTABLE_ROOT;
+		else
+			*max_len = BTRFS_FID_SIZE_CONNECTABLE;
 		return FILEID_INVALID;
 	} else if (len < BTRFS_FID_SIZE_NON_CONNECTABLE) {
 		*max_len = BTRFS_FID_SIZE_NON_CONNECTABLE;
@@ -45,6 +49,8 @@ static int btrfs_encode_fh(struct inode
 		parent_root_id = btrfs_root_id(BTRFS_I(parent)->root);
 
 		if (parent_root_id != fid->root_objectid) {
+			if (*max_len < BTRFS_FID_SIZE_CONNECTABLE_ROOT)
+				return FILEID_INVALID;
 			fid->parent_root_objectid = parent_root_id;
 			len = BTRFS_FID_SIZE_CONNECTABLE_ROOT;
 			type = FILEID_BTRFS_WITH_PARENT_ROOT;


