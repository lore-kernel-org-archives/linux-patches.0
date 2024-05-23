Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECB814AD36;
	Thu, 23 May 2024 13:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470645; cv=none; b=F48mIKxlOhJAiXKPeZr0u19ljZpV88+GnfZaXwMWQP++kBHQ+zSZ7lYrEt2uUAge7IjhQt5kzEOTXPZaB1QyM44OFIljWv+r9XSDJOYPAhJgM3EpQJ0Z/Eg9cm9lj787onbWQ6dR2+Z2820X0KvdMxspncbLnwHm9V26YVAV8I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470645; c=relaxed/simple;
	bh=dvddSzMPNP+7LD38niesJ14ww41MOC8RTMEoDV2wvdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blgfnolYJoN3pONghVaCBW6v/+3VhG15v/6XMFwpRFTMpfHmZ/KY8hFgox4Uae0ippsYQNs6qbUJw0MeViAfZ1zhMcC4kJ3yB2WQcrNvD94Pw5dS/QU3+tjUVuvI5UBhyKn5BxM9n9p/mmSopZT8jKuE12e1ibSbbiTAr+GmeXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kVEp0OfO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kVEp0OfO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B93C4AF0A;
	Thu, 23 May 2024 13:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470645;
	bh=dvddSzMPNP+7LD38niesJ14ww41MOC8RTMEoDV2wvdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kVEp0OfOq9EHRKhYclsTMKK4era0NvjhZ8XcjXzFxaG7+YT06Irt6N8Url7Pa3KeH
	 AYc8+fA3LzboIKzzoiSYbNKRVCs92ka4Q9OWVXgwHH/xAf8pDog0DdAiwEs4NvE0v0
	 PiskvfPwV7n8gF0EVBCrA/BJA8twwtt9cZ7/Wd8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/102] smb: client: handle path separator of created SMB symlinks
Date: Thu, 23 May 2024 15:13:03 +0200
Message-ID: <20240523130343.901249804@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

[ Upstream commit 8bde59b20de06339d598e8b05e5195f7c631c38b ]

Convert path separator to CIFS_DIR_SEP(cifs_sb) from symlink target
before sending it over the wire otherwise the created SMB symlink may
become innaccesible from server side.

Fixes: 514d793e27a3 ("smb: client: allow creating symlinks via reparse points")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 23cf6e92fd54c..9ade347978709 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5212,7 +5212,7 @@ static int smb2_create_reparse_symlink(const unsigned int xid,
 	struct inode *new;
 	struct kvec iov;
 	__le16 *path;
-	char *sym;
+	char *sym, sep = CIFS_DIR_SEP(cifs_sb);
 	u16 len, plen;
 	int rc = 0;
 
@@ -5226,7 +5226,8 @@ static int smb2_create_reparse_symlink(const unsigned int xid,
 		.symlink_target = sym,
 	};
 
-	path = cifs_convert_path_to_utf16(symname, cifs_sb);
+	convert_delimiter(sym, sep);
+	path = cifs_convert_path_to_utf16(sym, cifs_sb);
 	if (!path) {
 		rc = -ENOMEM;
 		goto out;
@@ -5249,7 +5250,10 @@ static int smb2_create_reparse_symlink(const unsigned int xid,
 	buf->PrintNameLength = cpu_to_le16(plen);
 	memcpy(buf->PathBuffer, path, plen);
 	buf->Flags = cpu_to_le32(*symname != '/' ? SYMLINK_FLAG_RELATIVE : 0);
+	if (*sym != sep)
+		buf->Flags = cpu_to_le32(SYMLINK_FLAG_RELATIVE);
 
+	convert_delimiter(sym, '/');
 	iov.iov_base = buf;
 	iov.iov_len = len;
 	new = smb2_get_reparse_inode(&data, inode->i_sb, xid,
-- 
2.43.0



