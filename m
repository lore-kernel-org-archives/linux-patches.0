Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740DB2B9AD;
	Tue, 14 May 2024 11:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687732; cv=none; b=dodjMJoEQbBUwKCWHuY31ep+bL3g8iS37HxHy75l7B+8s5gHb3/37zr+//cdhL1OMm7y9vB5HbF2xn5+coX+SVknxF4Hh/PryHHBGNn/8cmyxQwlDejVgft91JjGZvITWQROFV/AYexNSo6TSPcf+Y8h2i1d2EBUVyWjzc6AU7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687732; c=relaxed/simple;
	bh=Fv16Ef/7Q56eRUSC1XnUQng9NU500FFNAiCpVZdkhws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Un2TrMkbW+MNt3MBFsggz3RP4XowHLaJWUszHl1DkJoj6ZFTEsdUwr035cW7NN177kTT3Gfg3GKNYcNkWQc+0bl67IRUp4nqtnLzIFg2SZx42s0FClO1pCEe49kjINTI2Ezm7WpfGyVS1GsvPSMbaYCh0OOpExTeWjvXrO1tF2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kzd6axdQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kzd6axdQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7A4C2BD10;
	Tue, 14 May 2024 11:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687732;
	bh=Fv16Ef/7Q56eRUSC1XnUQng9NU500FFNAiCpVZdkhws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kzd6axdQ2XE3GRMUISIuCSmtt6fnBQfJ0XCI+EDxTacOzaRFZ2xL4+vqmIxv5jXNc
	 Vxp7nnmIAZreoF4R9P8/lGAiimpOk92ECyetBLwDb3Sbivp/CIrYGkZ3uTb2heGJgF
	 NWC1BtnuuMF8h/5ebl5vbkLqJU5Pk+DwCFQqXu9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Sindholt <opensource@zhasha.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/168] fs/9p: only translate RWX permissions for plain 9P2000
Date: Tue, 14 May 2024 12:19:44 +0200
Message-ID: <20240514101009.939836207@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joakim Sindholt <opensource@zhasha.com>

[ Upstream commit cd25e15e57e68a6b18dc9323047fe9c68b99290b ]

Garbage in plain 9P2000's perm bits is allowed through, which causes it
to be able to set (among others) the suid bit. This was presumably not
the intent since the unix extended bits are handled explicitly and
conditionally on .u.

Signed-off-by: Joakim Sindholt <opensource@zhasha.com>
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 0d9b7d453a877..75907f77f9e38 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -87,7 +87,7 @@ static int p9mode2perm(struct v9fs_session_info *v9ses,
 	int res;
 	int mode = stat->mode;
 
-	res = mode & S_IALLUGO;
+	res = mode & 0777; /* S_IRWXUGO */
 	if (v9fs_proto_dotu(v9ses)) {
 		if ((mode & P9_DMSETUID) == P9_DMSETUID)
 			res |= S_ISUID;
-- 
2.43.0



