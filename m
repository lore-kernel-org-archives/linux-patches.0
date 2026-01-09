Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0812032AAB5;
	Fri,  9 Jan 2026 12:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961469; cv=none; b=ARq+x1P4TNvBDvPyjZwWrgbn7vt27do8ZgBdeT+vvxpAvkk55WZfoIiM3eQAXtoe6xHCMpjDA8Vt0BQlqgwv4V6ftOR2QgU+ie+sm1avmtjKerx94ME3TwVdkN7RSqIoSY01JYb1bLIysA7zDA2N/5/S6MDcJOwe5AxiEk2pO2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961469; c=relaxed/simple;
	bh=TOHvDTH/YlgLz2IdVq2d/soJM6ucsydALq26dU7u3xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAhHNA9zdkHZnXFRKgDSoT6mfXQl3mvX8vwMpb2bwdELD998kz9qD75ZMxAn/wdmvTR6BVRVvWXlBCHCnoaQN+3w+BirVV15g8xdSWXXKHqjPY/1FXlcVMjYWdqIawE0NhcTU4ugm3Cd04ZPrO4geeBykmGfX7Z601ti/LYgdDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xdmzXAhQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xdmzXAhQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856B2C4CEF1;
	Fri,  9 Jan 2026 12:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961468;
	bh=TOHvDTH/YlgLz2IdVq2d/soJM6ucsydALq26dU7u3xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xdmzXAhQeN/d+v5TzpnI7enDmVplszKvKbHA/VHyR/hNnWkZ7dNBR5FYI98imWKZ4
	 agPLAfnJ/Pfc26b6wMos3Iw0a3XpEvVtXbuXcbJJmjuKTbUxwQZShZRWrGiyRX0ncX
	 HKzrNtap34vqxspidOpqnkPP6b1R8ppRIGxztQaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiqi Sun <sunyiqixm@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/634] smb: fix invalid username check in smb3_fs_context_parse_param()
Date: Fri,  9 Jan 2026 12:35:03 +0100
Message-ID: <20260109112118.393525489@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yiqi Sun <sunyiqixm@gmail.com>

[ Upstream commit ed6612165b74f09db00ef0abaf9831895ab28b7f ]

Since the maximum return value of strnlen(..., CIFS_MAX_USERNAME_LEN)
is CIFS_MAX_USERNAME_LEN, length check in smb3_fs_context_parse_param()
is always FALSE and invalid.

Fix the comparison in if statement.

Signed-off-by: Yiqi Sun <sunyiqixm@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fs_context.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index e6d2e4162b081..9000299e98cb4 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1183,7 +1183,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 			break;
 		}
 
-		if (strnlen(param->string, CIFS_MAX_USERNAME_LEN) >
+		if (strnlen(param->string, CIFS_MAX_USERNAME_LEN) ==
 		    CIFS_MAX_USERNAME_LEN) {
 			pr_warn("username too long\n");
 			goto cifs_parse_mount_err;
-- 
2.51.0



