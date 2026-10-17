Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83581F16B;
	Sat, 17 Oct 2026 17:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257768; cv=none; b=Ih1F5W7d57XWSbbbcoL0YmGllujp+dlhDSjwqt1oDNw/DWP8b/Zct5x8TAOdw68gAbqWlDFFywEybv/2o7FmSDav+RhvPszlg3FC1iFoSPaZrQk6S0MXBo48i8pqkW6XuukUxRiJ38qy43Ptg59LKAyk7CLYl/HPnAQUiHwvnAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257768; c=relaxed/simple;
	bh=ya9ZeKoCxayHEqRK0BZHpjNa8BNkxKBJtmX/FVVN7Rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0HG7AZgwqpi3LwH8sjkGi7b2SQJwVW1WZ7VvSm5fb9df4UlOAVruABjeAe8aNLPqxKwyYpZlg4c4eInBLPF7/htbO7gvZyuyVnBrIdiKiLhEjOGapdbGncY7/ag1SEfWjfTxeXs8Wvh7G0i0JrvqIuQS+iJKZkUto0tI63cFRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zhBldvgz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zhBldvgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40E91F000C4;
	Sat, 17 Oct 2026 17:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257767;
	bh=Zady7TZUn5PqnnfxVdP8w5Fgia6S4w0M6ckH9sUql+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zhBldvgzzyQQLCozxR6u+ML7ocwsd9LZVvuoayRMykWXWeKOJ50kFkL+gYmaA8s6k
	 OtlX217UK+hEtusrUln/+AZImMDWIqrjfYGrJ0xSEgiFNBI+uBUSNXogCq+jL6znlu
	 2+iyzN1cejZAawQUAtaQOYOE9tsXaYutdX0gwB0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0612/1674] fcntl: refuse F_SET_RW_HINT on an immutable inode
Date: Sat, 17 Oct 2026 17:48:04 +0200
Message-ID: <20261017160446.792141270@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit b0d1022b9bdb1e98aa7fb3244fdd50a58c61766c ]

An immutable inode is never written to so write hints are pointless.
Refuse the hint on an immutable inode the way setattr(), fallocate() and
etxattr() refuse their changes.

Fixes: c75b1d9421f8 ("fs: add fcntl() interface for setting/getting write life time hints")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261002-work-mount-fixes-4-v1-3-dd44b89d44ce@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: Moved the check from fcntl_set_rw_hint() to the F_SET_RW_HINT case in the combined fcntl_rw_hint() helper. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fcntl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index ee4699bcfc4d3..89f327e51f14c 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -291,6 +291,9 @@ static long fcntl_rw_hint(struct file *file, unsigned int cmd,
 			return -EFAULT;
 		return 0;
 	case F_SET_RW_HINT:
+		/* nothing is ever written to it */
+		if (IS_IMMUTABLE(inode))
+			return -EPERM;
 		if (copy_from_user(&hint, argp, sizeof(hint)))
 			return -EFAULT;
 		if (!rw_hint_valid(hint))
-- 
2.53.0



