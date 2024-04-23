Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC70143895;
	Tue, 23 Apr 2024 21:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908777; cv=none; b=mTRztNbDZzUnbdAlTCbhv1pyONQXCTIXIr294GiNpb8MPvdukvCkZPjX2dZT2Saq9PO0umV4l79xE12Ptt+hsRq3fuz3pEe6sEt2LB5P8HpcF6GLT5Y8yvlR6Dyc4JZLiMMr9gGCYVY3OD4nS13Tlyz5xEZFY/eYKo8GohEQqOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908777; c=relaxed/simple;
	bh=ulxGtpUX587knkUlNBV0aCgo3xPpBmxAilS/NSdNsnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVxFF3Hc0e7Cc1cf88iIWFHK5kCkKOK0I100T4rSKt+rChPBdsghabMFH1is0azo3Xal5YmqG7xjnCOP1pXD+sd9WG2rud6gjFZonC2W3NDS+qlbXbNR8LoRgXtjCYHdyc5EPwudHUBoUfXT+tEUVNYABNxIlGpcupQLPtKE/hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MNBW1pe3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MNBW1pe3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C22C32781;
	Tue, 23 Apr 2024 21:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908777;
	bh=ulxGtpUX587knkUlNBV0aCgo3xPpBmxAilS/NSdNsnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MNBW1pe3RR/MFlj6A4ZDtaTcAbKVVWrDQyNaxvWmrkPgecQ/Wt7flHYi/QFaKyB+T
	 5JjiRSKgJg46reKtK9RHX6zhZGJ6mkbVE9v3bYSf+4g1/0XD+GL6T7HQCzE3h8UjYu
	 oJ1LFdPh1BeFsoVwrngxo2PJH+p5oJYVrk6sXbVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Christopher Adduono <jc@adduono.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 03/71] ksmbd: do not set SMB2_GLOBAL_CAP_ENCRYPTION for SMB 3.1.1
Date: Tue, 23 Apr 2024 14:39:16 -0700
Message-ID: <20240423213844.242602828@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 5ed11af19e56f0434ce0959376d136005745a936 ]

SMB2_GLOBAL_CAP_ENCRYPTION flag should be used only for 3.0 and
3.0.2 dialects. This flags set cause compatibility problems with
other SMB clients.

Reported-by: James Christopher Adduono <jc@adduono.com>
Tested-by: James Christopher Adduono <jc@adduono.com>
Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2ops.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ksmbd/smb2ops.c b/fs/ksmbd/smb2ops.c
index c69943d96565a..d0db9f32c423d 100644
--- a/fs/ksmbd/smb2ops.c
+++ b/fs/ksmbd/smb2ops.c
@@ -229,6 +229,11 @@ void init_smb3_0_server(struct ksmbd_conn *conn)
 	    conn->cli_cap & SMB2_GLOBAL_CAP_ENCRYPTION)
 		conn->vals->capabilities |= SMB2_GLOBAL_CAP_ENCRYPTION;
 
+	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION ||
+	    (!(server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION_OFF) &&
+	     conn->cli_cap & SMB2_GLOBAL_CAP_ENCRYPTION))
+		conn->vals->capabilities |= SMB2_GLOBAL_CAP_ENCRYPTION;
+
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL)
 		conn->vals->capabilities |= SMB2_GLOBAL_CAP_MULTI_CHANNEL;
 }
@@ -276,11 +281,6 @@ int init_smb3_11_server(struct ksmbd_conn *conn)
 		conn->vals->capabilities |= SMB2_GLOBAL_CAP_LEASING |
 			SMB2_GLOBAL_CAP_DIRECTORY_LEASING;
 
-	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION ||
-	    (!(server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION_OFF) &&
-	     conn->cli_cap & SMB2_GLOBAL_CAP_ENCRYPTION))
-		conn->vals->capabilities |= SMB2_GLOBAL_CAP_ENCRYPTION;
-
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL)
 		conn->vals->capabilities |= SMB2_GLOBAL_CAP_MULTI_CHANNEL;
 
-- 
2.43.0



