Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF2A157041;
	Mon, 29 Jan 2024 17:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548078; cv=none; b=NPGOD2H8Hzfixtv0tOOjlwAhelVhNcaRVZUHEY8GO80bd2jG8yig8N4CUuD2+8n7Xy/vodoZfu3x0PEkf2UhKde6jIowejs8GkVDuEDTlhjEHMEzjId86BI7sPfKGVatMfIxztqlDoAINUgQ+WoIl0pv7A2DU5aup8PE3bSOb9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548078; c=relaxed/simple;
	bh=rZjPEjW+/lCAkGZI2J7jBjFCuoR5KZRUNMLCUPlqz+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbpVUs4MqH4V2GRzAY6yTktTTGHocEoECiNOBMuP+sPe1U96vWNp3CJdPMMF8VD2XE8Nd47CttcWbT0VEg2hWeOLEMa454kgF23kMqVqoAbwchhlE7ZX8pZlD99pY8cN9gPlPKZeTvKkWYT/N0Yy+Yi/ZCUyxOT9Xtcb0t+V600=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVcHDBal; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVcHDBal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96121C433F1;
	Mon, 29 Jan 2024 17:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548077;
	bh=rZjPEjW+/lCAkGZI2J7jBjFCuoR5KZRUNMLCUPlqz+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVcHDBalK+FgQpO4NnJ4VQV2P9hzVI46ZGCw0JOKd1a/EmNf9eD6rKW5x7Aory1s3
	 6e7hwbdoabE6zYWar1lZxAdJwwxN+libH4eseRVcoMHFODEY2NBKwRgxKUbpSgyteE
	 g89i3+CSruaeBF4gfRaSinnROPrAK/mYvPjC+tgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 062/346] smb: client: fix parsing of SMB3.1.1 POSIX create context
Date: Mon, 29 Jan 2024 09:01:33 -0800
Message-ID: <20240129170018.220112153@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 76025cc2285d9ede3d717fe4305d66f8be2d9346 ]

The data offset for the SMB3.1.1 POSIX create context will always be
8-byte aligned so having the check 'noff + nlen >= doff' in
smb2_parse_contexts() is wrong as it will lead to -EINVAL because noff
+ nlen == doff.

Fix the sanity check to correctly handle aligned create context data.

Fixes: af1689a9b770 ("smb: client: fix potential OOBs in smb2_parse_contexts()")
Signed-off-by: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 4f971c1061f0..12e41fcd0b46 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2279,7 +2279,7 @@ int smb2_parse_contexts(struct TCP_Server_Info *server,
 
 		noff = le16_to_cpu(cc->NameOffset);
 		nlen = le16_to_cpu(cc->NameLength);
-		if (noff + nlen >= doff)
+		if (noff + nlen > doff)
 			return -EINVAL;
 
 		name = (char *)cc + noff;
-- 
2.43.0



