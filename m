Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCCB2AF07;
	Mon, 28 Oct 2024 06:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098498; cv=none; b=oOoYezdmPUFy87rwGyT5crEMS/7NwnGYBWZrnJGUi7xIuYr74fvhr4gPQi5lTVs6JGGikmJwTAlMDc22HQClRvl8up6z4CxO4QNOWVrsqw8krWVMprB6cW00Y/TjSe0LxWekPLDK6jEwYporan4GqZdu3lm6I9hdVG9YSE7g94M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098498; c=relaxed/simple;
	bh=Gl/UWyEGULqNxH0REwABOMvAmYKvtDpbpAzXneuQNCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZoDs1dCG8tClkBnjDZxO1Qze2FsEjeVS46Suin0xD2T9ZCj9bnCxhsqD0XC5QYPa4gjs0o49NXjnfxO9dV1z2+DAd0agvRiBtPOLtjafeDXLyqZFTtG0sLE+DQyF4xO5jSRQ0K9DfzUtThp4bOADXM+ReJEx+7Xi1KBpISFKj6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BWPh7m4P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BWPh7m4P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF23AC4CEC3;
	Mon, 28 Oct 2024 06:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098498;
	bh=Gl/UWyEGULqNxH0REwABOMvAmYKvtDpbpAzXneuQNCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BWPh7m4PFmksAWTI4wJV2wmtAiVUORkpuR6GXSjMBLczxWwPZNlanlOgZ5GFoH6vX
	 hsSD8yoOxxxhCnRSERoGaotR7NwMbxSNyOvu0josMPjTtslvydf9qysCB8BrKo52uj
	 T5zS4VWZVFZwf2R0kzsJ6FllRKbiu156Kc704TEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.11 216/261] xfs: dont fail repairs on metadata files with no attr fork
Date: Mon, 28 Oct 2024 07:25:58 +0100
Message-ID: <20241028062317.511289669@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit af8512c5277d17aae09be5305daa9118d2fa8881 upstream.

Fix a minor bug where we fail repairs on metadata files that do not have
attr forks because xrep_metadata_inode_subtype doesn't filter ENOENT.

Cc: stable@vger.kernel.org # v6.8
Fixes: 5a8e07e799721b ("xfs: repair the inode core and forks of a metadata inode")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/repair.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1084,9 +1084,11 @@ xrep_metadata_inode_forks(
 		return error;
 
 	/* Make sure the attr fork looks ok before we delete it. */
-	error = xrep_metadata_inode_subtype(sc, XFS_SCRUB_TYPE_BMBTA);
-	if (error)
-		return error;
+	if (xfs_inode_hasattr(sc->ip)) {
+		error = xrep_metadata_inode_subtype(sc, XFS_SCRUB_TYPE_BMBTA);
+		if (error)
+			return error;
+	}
 
 	/* Clear the reflink flag since metadata never shares. */
 	if (xfs_is_reflink_inode(sc->ip)) {


