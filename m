Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27BDB1B2194;
	Wed, 19 Mar 2025 14:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394903; cv=none; b=h/f15z8ken8ICdPTnArqJ9uUt/4hW3PFQnjUpcb9xCUIUsvJXxic1ftC4Eb5kct32OvobwdYJaAkCkUY+X9PE0iLFVLFz9GxTm996IFrRd/2LMvlAgoo0MCHrxGUhcwZsPxVUIDbUJvFIjdqHZXyf0dnP6njJoDU1xrT6rQtFRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394903; c=relaxed/simple;
	bh=VGOcnHjBwn98nXzkEryS1CZ+d7gsOt8Np6ePlEZ4H3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YheNdaSFFBFqIEyVJhGxcnqFh6eNlnTcS7J2Fb/a2ylqQIT5SseQpt7HC4SeJgvyD1dsrfuBpfpVN91/HZgDdAliOQDVUluhnwQFcBcqI2lo3xJiBPoMRXZuKrkTZsWcd37i3Z+b0yGVCLWdK+jUQoQNx6eYYG8kROAa0MiFe3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WNB73G/d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WNB73G/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16C4C4CEE4;
	Wed, 19 Mar 2025 14:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394903;
	bh=VGOcnHjBwn98nXzkEryS1CZ+d7gsOt8Np6ePlEZ4H3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WNB73G/d9nJ28rRc1L+5fn2De+HvoSoJ0hwexBKOrkct85on1MXEnWhRVr0rDbz4Y
	 U2yDdUJE5mkeubFngYZnP1qC106lg+qXvnBv6dsJgcGuAWn0HBhUkdr+CqcbNPcPIb
	 ELwC9X6RcCqB77saxKkcxN4rJDmGBXRuoHH5SS/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 072/241] smb: client: fix noisy when tree connecting to DFS interlink targets
Date: Wed, 19 Mar 2025 07:29:02 -0700
Message-ID: <20250319143029.506382400@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 773dc23ff81838b6f74d7fabba5a441cc6a93982 ]

When the client attempts to tree connect to a domain-based DFS
namespace from a DFS interlink target, the server will return
STATUS_BAD_NETWORK_NAME and the following will appear on dmesg:

	CIFS: VFS:  BAD_NETWORK_NAME: \\dom\dfs

Since a DFS share might contain several DFS interlinks and they expire
after 10 minutes, the above message might end up being flooded on
dmesg when mounting or accessing them.

Print this only once per share.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 10eca164c8386..f1f55fbd0eeab 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2169,7 +2169,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 
 tcon_error_exit:
 	if (rsp && rsp->hdr.Status == STATUS_BAD_NETWORK_NAME)
-		cifs_tcon_dbg(VFS, "BAD_NETWORK_NAME: %s\n", tree);
+		cifs_dbg(VFS | ONCE, "BAD_NETWORK_NAME: %s\n", tree);
 	goto tcon_exit;
 }
 
-- 
2.39.5



