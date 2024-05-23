Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08C61D545;
	Thu, 23 May 2024 13:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470723; cv=none; b=eSaPuAgBr1UsLc7dzHq2HzRpBRGqNzRDc6oiOJqWCT66kYyrtrQsy82J9za+abSoIboBa2LXMKEPPxSyaNiqDvXWOktR0xehL1/k6ArbULWvtIpq20ziMXHCE4ysbe/Q06qKgUKcO+AT+E8KUR7pz9nf9nVJnfQ7Q9vdiKpNmoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470723; c=relaxed/simple;
	bh=DRikswJ3sA97cw+wRq6VN66As5jmq6V6NJcAMWjaqls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/KKvBFzHGAVIT4aqBRe34a1FFRoZknkamqwkPCRTvXhmQ/7/j6o9pilZc/dw9SXS4V76V+O2z+nCpdGXnKNvsxUo5p4hBuKpJvh9NOIKAxn/p4grNGrErVio5okXM3aXNUpPPX6KhQo3CnoBQa8lNgNQJwUH4mijUweIZZC/GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SEReMkdp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SEReMkdp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07BC6C2BD10;
	Thu, 23 May 2024 13:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470723;
	bh=DRikswJ3sA97cw+wRq6VN66As5jmq6V6NJcAMWjaqls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SEReMkdptFp7erGqM2Qvb0AlKFvmatDJwsOGOEsXCiFr82GcSJG6SM+fI6aWivyQa
	 vDcTJ+VvI9Ev9tRJLq8nZZ0tv7/pTQLW8KDbYYZwXeaXtkjvtERz0iIEGfr73HEE+n
	 /t14r/TGyQXegMk9mHRlo8pIXxrjZGRylByJNJtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Chaoming <lometsj@live.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/102] ksmbd: fix slab-out-of-bounds in smb_strndup_from_utf16()
Date: Thu, 23 May 2024 15:13:31 +0200
Message-ID: <20240523130344.959847315@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit d10c77873ba1e9e6b91905018e29e196fd5f863d ]

If ->NameOffset/Length is bigger than ->CreateContextsOffset/Length,
ksmbd_check_message doesn't validate request buffer it correctly.
So slab-out-of-bounds warning from calling smb_strndup_from_utf16()
in smb2_open() could happen. If ->NameLength is non-zero, Set the larger
of the two sums (Name and CreateContext size) as the offset and length of
the data area.

Reported-by: Yang Chaoming <lometsj@live.com>
Cc: stable@vger.kernel.org
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



