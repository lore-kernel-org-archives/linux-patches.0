Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E5F36D;
	Wed, 17 Sep 2025 12:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112642; cv=none; b=EApByVtXnqXLbUuZOH8BoYo98ZtrN98zc0d1OHHcK4+2PNnmKL31W06S/7uCEfmP7lErVJB4eSWlTCS6fUlvxwBv6kENkPrUho7TJ650RQtvkix+ndwLrZ1r8rCWFrOgleeEIR8G2pkPSMO543S1wLmWda4u8fJ9oFNHLAjptmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112642; c=relaxed/simple;
	bh=xMaG04WXcY+hO5EgOFclhsQ76K3ItC9tTECZFTe1O24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOC19OQwXg5tOK3vTKLVEMo/Fc7pKXnohgnNLDU4T0OS6L/Xmq3A55tHs/AopNZPMTqIK+U2K+7Pvxy4xuVnRats1E8vi9rxh4CpTqIkHMHP9Iya8Eh+ss6URnZ2hffr48s6YUnuLc1dIhcCCxycCesQKdRCXj0xTHypsQkhS2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iMI4sQ/4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMI4sQ/4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A81C4CEFC;
	Wed, 17 Sep 2025 12:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112641;
	bh=xMaG04WXcY+hO5EgOFclhsQ76K3ItC9tTECZFTe1O24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMI4sQ/4QSWM66dOP+fzxXlBbxxua3/Br0BPP6NOvwqBsXR1VR/WO8cz7Ms1bWlny
	 b3oT0pjvMgGRPCd9EBSG+LggU13Y0ikqaGcEX0QPrN6FwLuiD31W/oryNFf6vVTsy/
	 N1VDI6c3XS4DDRvXO46vMQt1AAmuSbevkFbQnPwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 032/189] NFSv4.2: Serialise O_DIRECT i/o and copy range
Date: Wed, 17 Sep 2025 14:32:22 +0200
Message-ID: <20250917123352.637597018@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit ca247c89900ae90207f4d321e260cd93b7c7d104 ]

Ensure that all O_DIRECT reads and writes complete before copying a file
range, so that the destination is up to date.

Fixes: a5864c999de6 ("NFS: Do not serialise O_DIRECT reads and writes")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42proc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
index 3774d5b64ba0e..48ee3d5d89c4a 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -431,6 +431,7 @@ static ssize_t _nfs42_proc_copy(struct file *src,
 		return status;
 	}
 
+	nfs_file_block_o_direct(NFS_I(dst_inode));
 	status = nfs_sync_inode(dst_inode);
 	if (status)
 		return status;
-- 
2.51.0



