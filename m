Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953D21C296;
	Wed,  3 Jan 2024 17:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V4JY+0pw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E13C433C7;
	Wed,  3 Jan 2024 17:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301267;
	bh=76kPto4apcf6hlcilp4n9G5f13jkFje8uYa+VPya6cU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V4JY+0pwXGisHLShyO0XXFmQ8TMO7X9rA0KvWXJF2zQV5+SfZKqmUZTR3cVYs2vPY
	 /ht0GKQ89vdENFwu5cqxfhLBbRzIuW8MQD0kCT2qap+BFjruJT4gnlzRNOTo7zhvIQ
	 L1i1vrf/Z4uEAwxI1TQ6YgYXHui3PfbG5pTMD51E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Chaoming <lometsj@live.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 085/100] ksmbd: fix slab-out-of-bounds in smb_strndup_from_utf16()
Date: Wed,  3 Jan 2024 17:55:14 +0100
Message-ID: <20240103164908.856549185@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit d10c77873ba1e9e6b91905018e29e196fd5f863d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2misc.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/fs/smb/server/smb2misc.c
+++ b/fs/smb/server/smb2misc.c
@@ -106,16 +106,25 @@ static int smb2_get_data_area_len(unsign
 		break;
 	case SMB2_CREATE:
 	{
+		unsigned short int name_off =
+			le16_to_cpu(((struct smb2_create_req *)hdr)->NameOffset);
+		unsigned short int name_len =
+			le16_to_cpu(((struct smb2_create_req *)hdr)->NameLength);
+
 		if (((struct smb2_create_req *)hdr)->CreateContextsLength) {
 			*off = le32_to_cpu(((struct smb2_create_req *)
 				hdr)->CreateContextsOffset);
 			*len = le32_to_cpu(((struct smb2_create_req *)
 				hdr)->CreateContextsLength);
-			break;
+			if (!name_len)
+				break;
+
+			if (name_off + name_len < (u64)*off + *len)
+				break;
 		}
 
-		*off = le16_to_cpu(((struct smb2_create_req *)hdr)->NameOffset);
-		*len = le16_to_cpu(((struct smb2_create_req *)hdr)->NameLength);
+		*off = name_off;
+		*len = name_len;
 		break;
 	}
 	case SMB2_QUERY_INFO:


