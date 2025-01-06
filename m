Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20C6146D6B;
	Mon,  6 Jan 2025 15:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176975; cv=none; b=XhA+j/gL3cmO5VAbwHwVWv8ZS/TGHm61VKysNux9tU8teQrNtfnQlLCFxYOA9htJ8nlimxk48U6sUBdNZXJowPBrzEPB8fGwAvW1ykGKFyKjcJAnCPeKOfW4GruYAhNIMiIl8vkcocJcugWsYzCqtjhlV0XWG7wwfBvYhR8n56o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176975; c=relaxed/simple;
	bh=QNqC+HTgejrIlanHjsIJCrz6PMCI06PJxlAu1x2AsBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPT1uJOdSmNxIEe+TMWLNlHrABSKsJHwYTVy/yW3lfiRl2gZt3l0mkOykI8zIk7UWBIXQAmPM63Ac1Dt/ShfzmmdFiz8CryF8iu4oXsrH3GfAAev3ZXFI3vKsTC875jMBx9o3QUCQyaf37lKxMQvHkKmMF2OB8tR2cn60+8tPdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKByf+E4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKByf+E4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6C9C4CED2;
	Mon,  6 Jan 2025 15:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176974;
	bh=QNqC+HTgejrIlanHjsIJCrz6PMCI06PJxlAu1x2AsBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OKByf+E4bqSWbUZYFOG/fRJfVayjfOP4iopEC+dn88Cc2wEoqt9vJTFGTt5YMT6M4
	 FdAaD9h1usVhB8qNjfIOdlj2LSLZ9+cm8iLQPdQVsFRT9sh0SgZ1Dn2Zqak93AxHyP
	 MmtBzxlS+SGeYto5jX84kyLyKE2fhX32QjVci95k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/222] smb: client: stop flooding dmesg in smb2_calc_signature()
Date: Mon,  6 Jan 2025 16:13:34 +0100
Message-ID: <20250106151150.987811136@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit a13ca780afab350f37f8be9eda2bf79d1aed9bdd ]

When having several mounts that share same credential and the client
couldn't re-establish an SMB session due to an expired kerberos ticket
or rotated password, smb2_calc_signature() will end up flooding dmesg
when not finding SMB sessions to calculate signatures.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 343d7fe6df9e ("smb: client: fix use-after-free of signing key")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 4ca04e62a993..73eae1b16034 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -242,7 +242,7 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 
 	ses = smb2_find_smb_ses(server, le64_to_cpu(shdr->SessionId));
 	if (unlikely(!ses)) {
-		cifs_server_dbg(VFS, "%s: Could not find session\n", __func__);
+		cifs_server_dbg(FYI, "%s: Could not find session\n", __func__);
 		return -ENOENT;
 	}
 
-- 
2.39.5



