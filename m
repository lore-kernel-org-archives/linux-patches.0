Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9816136607D;
	Thu, 30 Jul 2026 15:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426545; cv=none; b=n9zQItjTpuIiu0QFaT29dKoxLdXuDEbeVhLkMM5lpXWMNw23V5ME3uz4zptNP5k0QaY/dVwwZaFZ//kzRegGXmuRJh+v0qvkrq9hEshIqJro3El4cVsI5/C2DCcLEvTgkIP4B45GhVC4jA+NNqUKRCw3eCYtXlmZTKk8jt9aeC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426545; c=relaxed/simple;
	bh=i3JGyXUR5DX1h7jKbIPC/mbKftJORW7C8gXU6uetG0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZR7g4yXWqOah60MdYHj43VPZpaBROhAeD96Ubm+zhXyBuAVO5oV59earg3yaO6D8cCe9PIMXLvDXv64KE5Swt1FMQPzImvb1F65tkAtHj5V26vcja4P+BIIjnxDSvQYc5ArHHr5D2yVQu0FryVWvkALWAnC/SxXnLsWblKiLys0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lYgDeGjJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYgDeGjJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB1061F000E9;
	Thu, 30 Jul 2026 15:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426544;
	bh=CG+DEPsncPXy2BIJNeEuPgQ/sTIMIJqaGTU6qgoagEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lYgDeGjJ53Pbo7PhGtZSR1xgtQz5rJiXxSSnceD76vFqEMGIYnuBSIo0fJfU9u1cR
	 CvV6fSk30cim9cAe2PkZrWz2+NLS/krrlG7GUeWCMYnsvD308wgWWx0besKtQYbWi0
	 YkxOPar+KIOtDWfBUhMyPY72OHPMs8m3f29YQxJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	LocalHost <localhost.detect@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 456/602] ksmbd: validate ACE size against SID sub-authorities
Date: Thu, 30 Jul 2026 16:14:08 +0200
Message-ID: <20260730141445.540804373@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 5152c6d49e3fd4e9f2e857c57527aead752f1f87 upstream.

set_ntacl_dacl() validates sid.num_subauth before copying an ACE, but
does not verify that the declared ACE size contains all sub-authorities
described by that field. An undersized ACE can therefore be copied
and later make the POSIX ACL deduplication walk inspect data beyond
the copied ACE boundary.

The existing initial bound check is also too small. It only ensures
that the ACE size field is accessible before set_ntacl_dacl() reads
sid.num_subauth farther into the input buffer.

Require enough input for the fixed SID header before accessing
num_subauth, reject ACEs smaller than that header, and skip ACEs
whose declared size cannot contain the complete SID. This makes the
validation consistent with the other ACE walk paths.

Reported-by: LocalHost <localhost.detect@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index b0677e095c3292..d3d0a22620f96d 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -743,15 +743,22 @@ static void set_ntacl_dacl(struct mnt_idmap *idmap,
 		for (i = 0; i < nt_num_aces; i++) {
 			unsigned short nt_ace_size;
 
-			if (offsetof(struct smb_ace, access_req) > aces_size)
+			if (aces_size < offsetof(struct smb_ace, sid) +
+					CIFS_SID_BASE_SIZE)
 				break;
 
 			nt_ace_size = le16_to_cpu(ntace->size);
-			if (nt_ace_size > aces_size)
+			if (nt_ace_size > aces_size ||
+			    nt_ace_size < offsetof(struct smb_ace, sid) +
+					  CIFS_SID_BASE_SIZE)
 				break;
 
 			if (ntace->sid.num_subauth == 0 ||
-			    ntace->sid.num_subauth > SID_MAX_SUB_AUTHORITIES)
+			    ntace->sid.num_subauth > SID_MAX_SUB_AUTHORITIES ||
+			    nt_ace_size < offsetof(struct smb_ace, sid) +
+					  CIFS_SID_BASE_SIZE +
+					  sizeof(__le32) *
+					  ntace->sid.num_subauth)
 				goto next_ace;
 
 			memcpy((char *)pndace + size, ntace, nt_ace_size);
-- 
2.53.0



