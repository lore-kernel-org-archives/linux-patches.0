Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D2D1C3BEB;
	Tue, 11 Mar 2025 15:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706325; cv=none; b=K51K2t0hGM/KACqYnvHZUiIqearQeKzRqCicl9RRprV41JUeN0EZrNwInd2Nmd43pRyrS9ii7/SeoFY6mJUq0tA3C9/wcuz7ltd7B36XsMfTBxlLGMLRZ/+eFGaizcCyPZ4FCnnIXDS0PJFMtvzgyfxLhT1Q8KdAcvyLuXMDS58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706325; c=relaxed/simple;
	bh=GlRJOXq5q4NTN47hvR3Kedvtfux+aQW7NwfC/EdYBe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mzMS4ydKVRD1f0JanBqLJgX3/Vc5AYCPxw92Unpn3aIaoHyIjWPTpLGRNZ4Ka2/LuLQWueXQdM3nvFyhBvDO0PJbbRh8Tj5sHJROEHNPnL9T1YjRWfqil4fjKepLi7h48tscsIP+8yjXRNV8LzIh7MMJIXCAwN6uxTKLE0zmVxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u6i3g4QH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u6i3g4QH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E1A8C4CEE9;
	Tue, 11 Mar 2025 15:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706324;
	bh=GlRJOXq5q4NTN47hvR3Kedvtfux+aQW7NwfC/EdYBe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u6i3g4QHMopUzAw8ZPJXtRCOZ/TN4KsAIo8nBaS1AiMS2l3Yn5/R0K5qg8y0yj9qk
	 7zSNCKuVsJwLhion3BZjGLPfnRAXOZayP0xR77tRmp5tZOzY1ABUWnAe8nXFvT5XM6
	 FQ3fc2C2FueNrYnnstP6kZ20iUK+CqTFeI58mF0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/462] afs: Fix directory format encoding struct
Date: Tue, 11 Mar 2025 15:54:28 +0100
Message-ID: <20250311145758.447557149@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 07a10767853adcbdbf436dc91393b729b52c4e81 ]

The AFS directory format structure, union afs_xdr_dir_block::meta, has too
many alloc counter slots declared and so pushes the hash table along and
over the data.  This doesn't cause a problem at the moment because I'm
currently ignoring the hash table and only using the correct number of
alloc_ctrs in the code anyway.  In future, however, I should start using
the hash table to try and speed up afs_lookup().

Fix this by using the correct constant to declare the counter array.

Fixes: 4ea219a839bf ("afs: Split the directory content defs into a header")
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/20241216204124.3752367-14-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/xdr_fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/afs/xdr_fs.h b/fs/afs/xdr_fs.h
index 94f1f398eefad..cccc8e74f49b0 100644
--- a/fs/afs/xdr_fs.h
+++ b/fs/afs/xdr_fs.h
@@ -82,7 +82,7 @@ union afs_xdr_dir_block {
 
 	struct {
 		struct afs_xdr_dir_hdr	hdr;
-		u8			alloc_ctrs[AFS_DIR_MAX_BLOCKS];
+		u8			alloc_ctrs[AFS_DIR_BLOCKS_WITH_CTR];
 		__be16			hashtable[AFS_DIR_HASHTBL_SIZE];
 	} meta;
 
-- 
2.39.5



