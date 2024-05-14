Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F016C2374E;
	Tue, 14 May 2024 11:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687343; cv=none; b=AlU93baWaJJgaHALPyYzFy+8Qo1S5jyBahMpiPGzLhHEsscH7LswOiopJkpFzoZf2wiTnyBfVpeHYl/2rBSZx+YIE3IHczdAdHBiztCtMEPQw5GQPnDzc50eYX4WUblPoQiOP8d5K1NSZkGwjtYXeDKHfS3QluiW55f6zww2oqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687343; c=relaxed/simple;
	bh=jw6OyIoyRCEfcv6qQPbf4bUmPBHdWdCs8QPtsUIQ/ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1qGslZIzIeuQRXwtH4TCzs8z+giiy/DdkvW3QVj3poU06rnNZtG8l+Nl5Xa9Bn14tDKeECsZWFhgzC8+JUdufbgHMG+LI9h3G5/jSdldpzFxBONfPHkbnjbFSlvGWv0pVq1DqRDZktrCkeIfAuHOph6RX9nYTJNOvPdjNKH7zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Py+8Okty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Py+8Okty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADBFC32782;
	Tue, 14 May 2024 11:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687342;
	bh=jw6OyIoyRCEfcv6qQPbf4bUmPBHdWdCs8QPtsUIQ/ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Py+8OktyFE7JkDBOaz8idqQoRcXXkdHT2BQIS4UU4KF9P/J4/Bk74x5qBJ+7l/DEP
	 RifcYAzhm8f3NmUh220UOwYnEdSezCEiT5oXFBtYSGwaon2RjiPbTPBSh3d/CjV/Cl
	 UpZmqrjB1FCipUJpxpIC6s4xrkNkxIAepOKHZxqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Sindholt <opensource@zhasha.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/111] fs/9p: only translate RWX permissions for plain 9P2000
Date: Tue, 14 May 2024 12:20:02 +0200
Message-ID: <20240514100959.567758093@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0791480bf922b..88ca5015f987e 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -86,7 +86,7 @@ static int p9mode2perm(struct v9fs_session_info *v9ses,
 	int res;
 	int mode = stat->mode;
 
-	res = mode & S_IALLUGO;
+	res = mode & 0777; /* S_IRWXUGO */
 	if (v9fs_proto_dotu(v9ses)) {
 		if ((mode & P9_DMSETUID) == P9_DMSETUID)
 			res |= S_ISUID;
-- 
2.43.0



