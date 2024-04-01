Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D3517552;
	Mon,  1 Apr 2024 15:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987123; cv=none; b=u9tfB0G0w4MNVmPqsU6wA/TFEB9XyfKNNHRW6BovsnyXJOkmXHDn6eyKEYRitGMz/6OrG4I9A2KQBsCCh4t791KoW9hvjRY0lCXVKdjkdU8ZRVBmfcKj55RLLoELn5AU56OaoduwUyqbwIIIX19RuB7Y7e8WjHYFIIKxi2GUvmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987123; c=relaxed/simple;
	bh=wTUh0Sx4lUW+SwXkQnTDMGXsVK/wQiio3H3g6cyOyB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCsfSjRDJDKZpeE9xPHUdeda+n+LOnK7F/YTb9LYCq4HdN9gLtbmuqa7Xd2SVqySugwmOiiKiGO6EvS/mzvcUZWZ3mBIlG+B5q+1czZjfM/YiyvQ7WKQT8lPECI7OyAbNnNAoCby9Yrq7r5Ha2tMicfqok9dlXlZ8guxCZ/2yMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hBj4Zkr3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hBj4Zkr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D105EC433F1;
	Mon,  1 Apr 2024 15:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987123;
	bh=wTUh0Sx4lUW+SwXkQnTDMGXsVK/wQiio3H3g6cyOyB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hBj4Zkr3++rw7hRlDIU9F6UpN9qHv9/M2MUmownvo/qJi/rslUHbK1rQptO97jZON
	 9nXIwLc4L+lZbp9GiOv5V2Sig0P+M4PcItQLs4tkhAClhAClQkU8xB3Cp8VM6WFsEn
	 nvvv5cMsAfKPU+1VFjdFPSa8BBRkqSxpTjaRhniw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanzhe Yu <yuxuanzhe@outlook.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 190/399] ksmbd: fix slab-out-of-bounds in smb_strndup_from_utf16()
Date: Mon,  1 Apr 2024 17:42:36 +0200
Message-ID: <20240401152554.845459393@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



