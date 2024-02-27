Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1A31420A0;
	Tue, 27 Feb 2024 14:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043279; cv=none; b=E13iCkHkPPJhavR/Okm1iGi8c62mQOXNwJB74VDethfLBl+Uw3zzIdIgcQ+pKpgmj/LYCyGi88dfHB0zH5+8V1GbYItZoS2BPvuts/qt4y+5s78fqr+YX3HmIaZ3MsGfN0GqjFcHgQftwVQr/mvWAwLShNBeqtutY7JbGFlAd5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043279; c=relaxed/simple;
	bh=FTr/OG61YcowNoGAneRMJtAMsjaByvhjpNtp3eg9cKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acE+1aNL/mLVxOJvrzf5Lr9xxiptTVZsU60EFIHnmfnlkHGSMgI7odOQ09bkvQ3cDJWLrQz6JS0TYE98PSohfWQb9Nw4dKwlHTfzvvrDDShupC+SU3vVo60oRDvcAvG1o4FSSaWXlA6rarUhTpJ9qUnMsT/hydPjPbDY5ysrw6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XN6L7sl7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XN6L7sl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEAEFC433F1;
	Tue, 27 Feb 2024 14:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043279;
	bh=FTr/OG61YcowNoGAneRMJtAMsjaByvhjpNtp3eg9cKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XN6L7sl72GOSYeT9wLmnq72KxobgDwpvIP3zq0yazAiZHkkj7obt9TvCJnRvHGKpX
	 rKz4qTZMaUhKx2iizqQ7TRT64VsicJ6tmulDRbPgcGrxo1Yu494VX0p/ZdDT8oLmqD
	 AyeTQks3zjuXrj7pVYJArdQdEyEw9d9ifRX9BLI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/195] smb: client: increase number of PDUs allowed in a compound request
Date: Tue, 27 Feb 2024 14:25:12 +0100
Message-ID: <20240227131612.191891925@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 11d4d1dba3315f73d2d1d386f5bf4811a8241d45 ]

With the introduction of SMB2_OP_QUERY_WSL_EA, the client may now send
5 commands in a single compound request in order to query xattrs from
potential WSL reparse points, which should be fine as we currently
allow up to 5 PDUs in a single compound request.  However, if
encryption is enabled (e.g. 'seal' mount option) or enforced by the
server, current MAX_COMPOUND(5) won't be enough as we require an extra
PDU for the transform header.

Fix this by increasing MAX_COMPOUND to 7 and, while we're at it, add
an WARN_ON_ONCE() and return -EIO instead of -ENOMEM in case we
attempt to send a compound request that couldn't include the extra
transform header.

Signed-off-by: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h  | 2 +-
 fs/smb/client/transport.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 7f1aea4c11b9c..58bb54994e22a 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -86,7 +86,7 @@
 #define SMB_INTERFACE_POLL_INTERVAL	600
 
 /* maximum number of PDUs in one compound */
-#define MAX_COMPOUND 5
+#define MAX_COMPOUND 7
 
 /*
  * Default number of credits to keep available for SMB3.
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 97bf46de8e429..df44acaec9ae9 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -456,8 +456,8 @@ smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	if (!(flags & CIFS_TRANSFORM_REQ))
 		return __smb_send_rqst(server, num_rqst, rqst);
 
-	if (num_rqst > MAX_COMPOUND - 1)
-		return -ENOMEM;
+	if (WARN_ON_ONCE(num_rqst > MAX_COMPOUND - 1))
+		return -EIO;
 
 	if (!server->ops->init_transform_rq) {
 		cifs_server_dbg(VFS, "Encryption requested but transform callback is missing\n");
-- 
2.43.0



