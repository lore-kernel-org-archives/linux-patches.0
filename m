Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470343B14AF;
	Sat, 17 Oct 2026 16:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255279; cv=none; b=FLGUKJlv+a8GilsoZuuQiI5q44pEYuuAxelPfk2vi5rrEhsM//rNBvFPTIf6tbGTvFzUhINXsps5o6Rq68CSLbUVbnNaw374gkkLE0nVUzHcwa6hvjm/+e9Va8ymK6JtkReFKB00d1sjT32wd9tmElmNMgHtpCKCrKfO0BIUVuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255279; c=relaxed/simple;
	bh=/H02BfaufSSk5dbSRK8HYi1uaYF0enLT8CXLt4UwV/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9ldKx7d4BGjZ7XVeJ7CjtQiNbJL27MMpUMR6jT75ocSotosPpXs0Md+9aXhw4UFD6cTy2kbO2QhYYarLqkitTcGItk8bK3dSj90b1cDYSzyeKGygl3KzWldQcN+UWOOJM1IRI7DTTXTCebphhLEv13bzhWj3ouWGWZUItuVm78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pw5Td54o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pw5Td54o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DAD71F000C4;
	Sat, 17 Oct 2026 16:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255278;
	bh=f6kS+rsv54adkxyPEI0vlG7ySSlsVSgG6w1P8/v9VNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pw5Td54oF9698ohii3TYACNUCVo5PxhqYrHN8ZnPiQMmUmKt7UEtlMmgJtXaqrgQc
	 K0dD6TLulbridX2VBE6XFtbmlxP/A7n9XOWHlXh9MV+qZmcTvO/26m/JbiE3M1Q72H
	 EeMYo6DcDeonuq3MfN7VDM9yHh2Sn55raII9QINo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Velichayshiy <a.velichayshiy@ispras.ru>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 723/869] ksmbd: remove redundant DACL check in smb_check_perm_dacl
Date: Sat, 17 Oct 2026 17:59:24 +0200
Message-ID: <20261017160055.493085977@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Alexey Velichayshiy <a.velichayshiy@ispras.ru>

[ Upstream commit 8dd2e58b62731a96e276ee0545fb910ffb2057d9 ]

A zero value of pdacl->num_aces is already handled at the start of
smb_check_perm_dacl() so the second check is useless.

Drop the unreachable code block, no functional impact intended.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Alexey Velichayshiy <a.velichayshiy@ispras.ru>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: cc2f133e80eb ("ksmbd: fix maximum allowed access checks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 2a46646b3a0e4..114fd2e67725d 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1511,9 +1511,6 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			granted |= le32_to_cpu(ace->access_req);
 			ace = (struct smb_ace *)((char *)ace + le16_to_cpu(ace->size));
 		}
-
-		if (!pdacl->num_aces)
-			granted = GENERIC_ALL_FLAGS;
 	}
 
 	if (!uid)
-- 
2.53.0



