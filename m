Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DAA3D961;
	Mon,  1 Apr 2024 16:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988458; cv=none; b=UJ2GUWqrfXD1qIjMFHYvZgowbI1AcNLYJxe60W5H2pOTZgeLVwi/XDbXDdof7dlHVTQShKNc7ZYPuXxUGglzjH2l0USLdnopZLCv32QNU5buyoet6zfwaUoVGR80WpfzBS8Vl6FINLUlKH9gy+C6QmscVe2R+ZPe+6HON1KtwoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988458; c=relaxed/simple;
	bh=Ta3BCZSupIVWYMUSAgNRMZAAtJ4EF2nuDMxT7XUDYME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xkq+sQyi9/VvHUL9Tzs5on/DGEzcG6WURFUmo1BCCXpF43tlP+y53ZPcwwO8ncZiPYUTn25FphHaxxnttXYfukBTVe38l8Pa2unc0IWdxK4TWJlqTY3T32mu9XYEeoc9tvvn6xu9jelz6QoL4QkQG5I+XJvCvRB7EX0RkuttKJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sPJOTc2Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sPJOTc2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D21C433C7;
	Mon,  1 Apr 2024 16:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988458;
	bh=Ta3BCZSupIVWYMUSAgNRMZAAtJ4EF2nuDMxT7XUDYME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sPJOTc2QPSZmmCix1z5WE1HWy4EgBXl+h+eqlMWucq+EESWoTVvW4CvIKjVXvNmqk
	 Lvn1cSQ60XtmzX34cWG4FWGS40HXfEAW+UUmvm3H2Q4CEcB1luchlKHfFUvJ2cD32h
	 vUXtUz9KSO4MK6iWmsZvyU5MvfJLBvg6yYkjPQpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanzhe Yu <yuxuanzhe@outlook.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 190/432] ksmbd: fix slab-out-of-bounds in smb_strndup_from_utf16()
Date: Mon,  1 Apr 2024 17:42:57 +0200
Message-ID: <20240401152558.806942211@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit a80a486d72e20bd12c335bcd38b6e6f19356b0aa ]

If ->NameOffset of smb2_create_req is smaller than Buffer offset of
smb2_create_req, slab-out-of-bounds read can happen from smb2_open.
This patch set the minimum value of the name offset to the buffer offset
to validate name length of smb2_create_req().

Cc: stable@vger.kernel.org
Reported-by: Xuanzhe Yu <yuxuanzhe@outlook.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2misc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2misc.c b/fs/smb/server/smb2misc.c
index 03dded29a9804..7c872ffb4b0a9 100644
--- a/fs/smb/server/smb2misc.c
+++ b/fs/smb/server/smb2misc.c
@@ -107,7 +107,10 @@ static int smb2_get_data_area_len(unsigned int *off, unsigned int *len,
 	case SMB2_CREATE:
 	{
 		unsigned short int name_off =
-			le16_to_cpu(((struct smb2_create_req *)hdr)->NameOffset);
+			max_t(unsigned short int,
+			      le16_to_cpu(((struct smb2_create_req *)hdr)->NameOffset),
+			      offsetof(struct smb2_create_req, Buffer));
+
 		unsigned short int name_len =
 			le16_to_cpu(((struct smb2_create_req *)hdr)->NameLength);
 
-- 
2.43.0



