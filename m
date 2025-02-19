Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550191DE4D7;
	Wed, 19 Feb 2025 09:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955940; cv=none; b=bRx577Vak/nHoCfQBHwNtx0+JR3GhQt51a8oc+0d3HRgH+UkEgSVoRDeGwWMwxCttfDNCZHuTJJ12x657cwF0qCgNHeNxAP8nQeDN1F8xPVoBdcdMIHQ09uX0HHS0vPWR6T1cw8wkDt1bqBEpx/In9g8JUwr5sqWA4uThPXtXvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955940; c=relaxed/simple;
	bh=9L342Qb+uvHcH1BA4MmaKo5qKnuzv2aP+J1HWpC8n8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGDckEb7heymXMtabZv2awfgeKVWzFC2mlsiaVX58YNOJsRRBNwu6nAmxDCMWXxZ2wpae8w6gDzENDtWYjjhdmOz9KxmYkRUjvGLZsiXekk4nLXEBodKgbYITeCRkcwr6KwS0MKtzD8nocZUBPpWnFVvR5iOi8GoHCSlEpBmP28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sS6J86Ob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sS6J86Ob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1346C4CED1;
	Wed, 19 Feb 2025 09:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955940;
	bh=9L342Qb+uvHcH1BA4MmaKo5qKnuzv2aP+J1HWpC8n8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sS6J86Obnzpn55p/KrG/louInURTju06rK9s1JYN3oPUyYMJNywnXlCXgp7d7k3Ei
	 E8Sbv8+pBj3rW+rH9bZwFZDOnr6soHoLCOQeLbbqj9ZfbZf0TOoWTwg/V/uewk7NvQ
	 qGHqGjlPxLQ+o4EgVJhDV7rpOpqjAcf3BALbOStQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/578] afs: Fix directory format encoding struct
Date: Wed, 19 Feb 2025 09:20:07 +0100
Message-ID: <20250219082653.033773097@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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
index 8ca8681645077..cc5f143d21a34 100644
--- a/fs/afs/xdr_fs.h
+++ b/fs/afs/xdr_fs.h
@@ -88,7 +88,7 @@ union afs_xdr_dir_block {
 
 	struct {
 		struct afs_xdr_dir_hdr	hdr;
-		u8			alloc_ctrs[AFS_DIR_MAX_BLOCKS];
+		u8			alloc_ctrs[AFS_DIR_BLOCKS_WITH_CTR];
 		__be16			hashtable[AFS_DIR_HASHTBL_SIZE];
 	} meta;
 
-- 
2.39.5



