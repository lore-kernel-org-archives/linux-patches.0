Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4D1198A29;
	Thu,  5 Sep 2024 09:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529969; cv=none; b=o+yijGwvYLkwMup+oSEKNSeoRti47Oy2nQMGKzbEJvP2/qL2HBOUjiOPB9ugKTXN4y3MQFsVYI17ErJiHT1ahZkx2hj0bqLbWdL2YtFpiU6MBPxsw4JHNq7UaFfLsQOh/LwuImF/fkFPQgyHOBRyMyaqX8eD7HGsBlNu7BwEXas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529969; c=relaxed/simple;
	bh=iUC1i9eEaNO1GEoDF1qCRfa3niskAXAQnIALxVxUFR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CiLr5KSItAH8t0H850e2Kk2+/ux7dq6F7hcwMQS6uGjWC0W10LxzaGWRqyBm6LrLoHbqpjBzWruxsea3+RiBrx8tbkhZUrxti/XHkeOXL/pZ/F0qX35MT+TKormpuDCRE7V0UfingEtbxVr+mXmIH5eZLlVInlGdvh/yOw7TJgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rXtpci5H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rXtpci5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4492EC4CEC3;
	Thu,  5 Sep 2024 09:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529968;
	bh=iUC1i9eEaNO1GEoDF1qCRfa3niskAXAQnIALxVxUFR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rXtpci5Hq6RsjeIEf/5Z3yhAh8jSe7XNLo+xN97z5qXZmBWynY8s6wTrj2X1QbMcY
	 Mk1I3PhdHdJFiIFvJvqJO3BNsPPHxJKbbJ/7MfxDrQfTjk7vwE0p/nu3FlBZJ0Gprm
	 ADG9sXqv0ulrAYMuuwkFSCzuISsLPVCw2IP0ynfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Steinbeisser <Sebastian.Steinbeisser@lrz.de>,
	Tom Talpey <tom@talpey.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/132] smb: client: fix FSCTL_GET_REPARSE_POINT against NetApp
Date: Thu,  5 Sep 2024 11:40:01 +0200
Message-ID: <20240905093722.792036383@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

[ Upstream commit ddecea00f87f0c46e9c8339a7c89fb2ff891521a ]

NetApp server requires the file to be open with FILE_READ_EA access in
order to support FSCTL_GET_REPARSE_POINT, otherwise it will return
STATUS_INVALID_DEVICE_REQUEST.  It doesn't make any sense because
there's no requirement for FILE_READ_EA bit to be set nor
STATUS_INVALID_DEVICE_REQUEST being used for something other than
"unsupported reparse points" in MS-FSA.

To fix it and improve compatibility, set FILE_READ_EA & SYNCHRONIZE
bits to match what Windows client currently does.

Tested-by: Sebastian Steinbeisser <Sebastian.Steinbeisser@lrz.de>
Acked-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 28031c7ba6b19..15cbfec4c28c7 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -950,7 +950,8 @@ int smb2_query_path_info(const unsigned int xid,
 			cmds[num_cmds++] = SMB2_OP_GET_REPARSE;
 
 		oparms = CIFS_OPARMS(cifs_sb, tcon, full_path,
-				     FILE_READ_ATTRIBUTES | FILE_READ_EA,
+				     FILE_READ_ATTRIBUTES |
+				     FILE_READ_EA | SYNCHRONIZE,
 				     FILE_OPEN, create_options |
 				     OPEN_REPARSE_POINT, ACL_NO_MODE);
 		cifs_get_readable_path(tcon, full_path, &cfile);
@@ -1258,7 +1259,8 @@ int smb2_query_reparse_point(const unsigned int xid,
 	cifs_dbg(FYI, "%s: path: %s\n", __func__, full_path);
 
 	cifs_get_readable_path(tcon, full_path, &cfile);
-	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path, FILE_READ_ATTRIBUTES,
+	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path,
+			     FILE_READ_ATTRIBUTES | FILE_READ_EA | SYNCHRONIZE,
 			     FILE_OPEN, OPEN_REPARSE_POINT, ACL_NO_MODE);
 	rc = smb2_compound_op(xid, tcon, cifs_sb,
 			      full_path, &oparms, &in_iov,
-- 
2.43.0



