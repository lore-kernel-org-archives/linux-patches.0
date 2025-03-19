Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885352144DB;
	Wed, 19 Mar 2025 14:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395045; cv=none; b=seAXpQUHy0Nr1nko9KC08dblEX8z67tnAScQUcaF+tZryArYuR4E3QL1DUzRzrCQolGG0CWBsEqEoS7HI2MJe9IN2ROFQzb+iyZC3ekofEGIKpNSBGFaIg/OOrzUjB0K6dchCxuXQJ7N+wnOPYKTK/vQeDjdkPFLmj27apRXlFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395045; c=relaxed/simple;
	bh=vuB+aUBCvaiDwhN7BFzwedMFXtaRu169DCb/9NYThjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyNjVncWS+7YB4++q5LV1lArcCoiUG3W8gjU6T3RVit1ALloOm0HbVaWVwhEjdUQpDQyr/J1N81JNEsn6khBLUG9kFOszdtcwaqyn1foPoTBJEoGQWc+wpTIX4BM8/8YiwLd9Fom7R2vb79POfCjIpXA1B0K9eI+gqQDadYBs4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kiuE86X3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kiuE86X3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB14C4CEE4;
	Wed, 19 Mar 2025 14:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395045;
	bh=vuB+aUBCvaiDwhN7BFzwedMFXtaRu169DCb/9NYThjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kiuE86X3wDrpIHlJpl/zQyKv7uCtPjYajq3O2FdlVcDCjLDMzM1cF5ACc+1MoYp/b
	 FQYLj5s4m40mRN8l/te/dbuSWQeFGLZjOUiidOcir3GRGWwROmIw1wQ2X42e05zHuN
	 YvXZafqo1BJNh8ZiHhl6OUkWv3KXaMkjdQeYSPU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/231] smb: client: fix noisy when tree connecting to DFS interlink targets
Date: Wed, 19 Mar 2025 07:29:23 -0700
Message-ID: <20250319143028.562861916@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2e3f78fe9210f..89a9b8ffe9d92 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2175,7 +2175,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 
 tcon_error_exit:
 	if (rsp && rsp->hdr.Status == STATUS_BAD_NETWORK_NAME)
-		cifs_tcon_dbg(VFS, "BAD_NETWORK_NAME: %s\n", tree);
+		cifs_dbg(VFS | ONCE, "BAD_NETWORK_NAME: %s\n", tree);
 	goto tcon_exit;
 }
 
-- 
2.39.5



