Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06FE322533;
	Thu, 16 Jul 2026 13:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209540; cv=none; b=SUhLfW5qcKJAmZ4v9eCPOV5ZMXc3oxYSg0+eamOdGG6gV7Y4/S2CG590wOC+103ABvpoU2tdshl1l1IjqWg3zookc9IW8LjOSUVD5brKO+BJuDPaICquX7qgGIxl0R6FEDHu4zJklx+BUJlg5o4GMVuoQWXGDjHI5nfyWFKpbJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209540; c=relaxed/simple;
	bh=3snduxKTUeoOa7n6EZsc2H+bpZ+LXtK8DMYSODCjNPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQklgBy5JvcqqGr7bYy+mbvw7D387cdmxz9a5bZvXfmaFZnyjKqma7j8wOfHUMlKdoqGCDkmXO4JD9rgWYBh7n7iQJ9skBKTR1KaEbmF2NECg7N//0FS7h5nwIILYRshVxA7y1hUCQdYkSwtmymQOzFtTEcOcnov0VM2O2D5biY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HGIft5OG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HGIft5OG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E94B1F000E9;
	Thu, 16 Jul 2026 13:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209539;
	bh=fE8mU2Z3dLTgKOPu5nm6MNktGXLskFZFrxXGVCbv9Co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HGIft5OG3BEsoR9nKMZCCBH3Z/+kMgqkL8GR5OGc2ipFKaP57CIBX6zHHT46qFpUB
	 7DI6LKLLO9Tw3HPRapl8GAE4Bn3vqWmiTz6irc85jCt4Ng/OFknmYnHdnIEVy92KAv
	 H07QSP0BIFAWVPnVkd8NchobwU8a48pzmjxKVS0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.1 225/518] ksmbd: add per-handle permission check to FILE_LINK_INFORMATION
Date: Thu, 16 Jul 2026 15:28:13 +0200
Message-ID: <20260716133052.743481252@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gil Portnoy <dddhkts1@gmail.com>

commit 13f3942f2bf45856bb751faed2f0c4618f41ca20 upstream.

The FILE_LINK_INFORMATION arm of smb2_set_info_file() calls
smb2_create_link() with no per-handle fp->daccess check. On the
ReplaceIfExists path smb2_create_link() unlinks an existing file at the
target name (ksmbd_vfs_remove_file) and creates a hardlink
(ksmbd_vfs_link); neither helper checks daccess. A handle opened with
FILE_READ_DATA only (no FILE_DELETE, no FILE_WRITE_DATA) can therefore
delete an arbitrary file in the share and plant a hardlink over its name.

The sibling delete/move arms in the same switch already gate:
FILE_RENAME_INFORMATION and FILE_DISPOSITION_INFORMATION both require
FILE_DELETE_LE; FILE_FULL_EA_INFORMATION requires FILE_WRITE_EA_LE. Gate
the link arm the same way as its closest analogue (rename), since it
mutates the namespace and, on replace, deletes an existing entry.

This is a sibling of commit cc57232cae23 ("ksmbd: fix FSCTL permission
bypass by adding a permission check for FSCTL_SET_SPARSE").

Cc: stable@vger.kernel.org
Signed-off-by: Gil Portnoy <dddhkts1@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6564,6 +6564,11 @@ static int smb2_set_info_file(struct ksm
 	}
 	case FILE_LINK_INFORMATION:
 	{
+		if (!(fp->daccess & FILE_DELETE_LE)) {
+			pr_err("no right to delete : 0x%x\n", fp->daccess);
+			return -EACCES;
+		}
+
 		if (buf_len < sizeof(struct smb2_file_link_info))
 			return -EMSGSIZE;
 


