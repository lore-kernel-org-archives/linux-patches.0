Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F9825A2C9;
	Tue, 25 Mar 2025 12:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905628; cv=none; b=YMQ0Jc+d7QgfZaBrj+jAYNenlfgM6qK7/qRYpKa5OYYpnU5LWBrX3QmQfbYnUgouiwfrAHXOje38cC/+rnyHlVPJjTAB6jkdWH+u0iw6UggP8puHkfhEHOkcBdeS1wxy3ipLXEs4IApu6Qg8b9VP+cOskIKXTWU/qhfvKsjmpQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905628; c=relaxed/simple;
	bh=0J+ZBnPnn48UAu2ldr8osnLetLr85UCG0n37PbOkFyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uc5NJpvEJpqUVX22zHfilt+faI5zki+s4yS9fv8XRZI+R5SnC36sZ9Yix9vln3vA+djGp1Nimpy4JWjz5n3DaesgJwx1T7f9BWA4DQVyfLOxKl/O1bXivSfVSn8VNKMKeZ4SC++pAzZ8+VO91HqPhiX5K9jdjvsx2Pk1Q/ET5B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gdfxjnP/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gdfxjnP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77244C4CEE9;
	Tue, 25 Mar 2025 12:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905628;
	bh=0J+ZBnPnn48UAu2ldr8osnLetLr85UCG0n37PbOkFyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gdfxjnP/nX1bhonomY9kSZClIYCVbBUTcQzF0FRezaAVUM7w1Sk9ISVeo2brWqDNC
	 2i5qNonYwhPkJ5/vzWUfc3UgJzMxysitvjpxrDB6Mqi+lN0jupeVGmx9GrRv5TE7Rv
	 cWm4YKw/n8oEomPy5qj2emHrYfd2P+eBwZLFX+/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/198] smb: client: fix noisy when tree connecting to DFS interlink targets
Date: Tue, 25 Mar 2025 08:20:00 -0400
Message-ID: <20250325122157.640890675@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 217d381eb9fea..0ae931e023cee 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1999,7 +1999,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 
 tcon_error_exit:
 	if (rsp && rsp->hdr.Status == STATUS_BAD_NETWORK_NAME)
-		cifs_tcon_dbg(VFS, "BAD_NETWORK_NAME: %s\n", tree);
+		cifs_dbg(VFS | ONCE, "BAD_NETWORK_NAME: %s\n", tree);
 	goto tcon_exit;
 }
 
-- 
2.39.5



