Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01DA2E7BBE;
	Thu,  3 Jul 2025 14:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554615; cv=none; b=naH9itjvF1hhAMpMHBYDYiHh5es8QL9ig6Gnmai1ra7Xb7Ma665vvApctpv7jhNzlK/DU+gVCmFWNwa0pX62cqfpI+YQ+4xZBPOPboxj8cWrlsMUrVGMIQXa6v1XCFoTZKZP0XTa7MpbgUXBVSjBUSONkKISFOMOPvY0ck0Pp70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554615; c=relaxed/simple;
	bh=Myujslm9L9bSst3NgGxdXugp0laRfkXW5g0C9h5NGFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMVw7ZfGC+t96xlx53SENYG3YoxUDT3nGnLwVYcCvVC8+VFJj1s1rny5yJMmzHB6QsI9yWo9tThQQpo7DMt93rH2aDjQ0nZfjGBZU4RmUOXJR9PuXp3N6z/9Vz46CnJ4QhpwVODuPi341DCA5Vvx49HRoymoDtSKWEsXLuYXgGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ltWCutN3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ltWCutN3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8BACC4CEE3;
	Thu,  3 Jul 2025 14:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554615;
	bh=Myujslm9L9bSst3NgGxdXugp0laRfkXW5g0C9h5NGFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ltWCutN3j9tBT9r69u6zqgk9G6fn7fpcy94VRhVF1hBkhw0vGNy837FZ79f07m70p
	 LvEIMOBtHsCTwa5CsAvOFrh+Jx+PWwna6EroWqOjOJZASj0zrEzgUKyiK/lVmGeUMG
	 ieM5Q3R0tVvB3w6Q8U69a/bANIj862N7NaTsl88Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Young <hanyang.tony@bytedance.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 004/263] NFSv4: Always set NLINK even if the server doesnt support it
Date: Thu,  3 Jul 2025 16:38:44 +0200
Message-ID: <20250703144004.463980903@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Han Young <hanyang.tony@bytedance.com>

[ Upstream commit 3a3065352f73381d3a1aa0ccab44aec3a5a9b365 ]

fattr4_numlinks is a recommended attribute, so the client should emulate
it even if the server doesn't support it. In decode_attr_nlink function
in nfs4xdr.c, nlink is initialized to 1. However, this default value
isn't set to the inode due to the check in nfs_fhget.

So if the server doesn't support numlinks, inode's nlink will be zero,
the mount will fail with error "Stale file handle". Set the nlink to 1
if the server doesn't support it.

Signed-off-by: Han Young <hanyang.tony@bytedance.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 119e447758b99..4695292378bbe 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -557,6 +557,8 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr)
 			set_nlink(inode, fattr->nlink);
 		else if (fattr_supported & NFS_ATTR_FATTR_NLINK)
 			nfs_set_cache_invalid(inode, NFS_INO_INVALID_NLINK);
+		else
+			set_nlink(inode, 1);
 		if (fattr->valid & NFS_ATTR_FATTR_OWNER)
 			inode->i_uid = fattr->uid;
 		else if (fattr_supported & NFS_ATTR_FATTR_OWNER)
-- 
2.39.5



