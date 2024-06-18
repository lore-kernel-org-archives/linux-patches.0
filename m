Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A867B1AC220;
	Tue, 18 Jun 2024 13:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716643; cv=none; b=OpQ3OrP32V2uW6hc6A/diRhwINpzUlQVqMKubR8JjTK/wHCpgym4JPg1I7uKLlQ+ES/qIDBkWCzX0noZGezO5fo3BeKSz633x1ZsnP9Wi7merudVAKeaK/wJZuM1pqItPTB+fXJuESq3b6fs1xAhrXPeAiRfeqqYQoajDX1yA6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716643; c=relaxed/simple;
	bh=dR/vXq66ZM+Po3Lkicyg5f3H2ZGgiKQ5bV+m62w6yX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCfgUF71BNmfq6SZjs+0m+cTGYBaf9/pIfkqxkXQrhXu/7lr5AxmEyduFQfyj9vNekgHj9Zj8N9Zrsmb9MU8GR09FRJbkgMRFXFxZkKS0+vSxp1nJWgsrjauVvUUw2dsz7gGBB4pNb1ImE62M+d3Gv2ufMRPgU63IVyzqK4vHc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QqcgmE4Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QqcgmE4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03FD3C3277B;
	Tue, 18 Jun 2024 13:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716643;
	bh=dR/vXq66ZM+Po3Lkicyg5f3H2ZGgiKQ5bV+m62w6yX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QqcgmE4Qky1Vpl6mB1J2wuoCenX96hRRQl51Ff6ZzGd2GIGloclBLbKl35A9sRaE0
	 l6HX7VSjpSzgnT/hffG0DO5/oJqCJ6H+sIR1ya4ldDWezCr4m1aczPPFKTBrZ/18vD
	 ouge3OW/G+oXNc+vTjVbeHeN6dezAe3pKaWfFq5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 713/770] lockd: ensure we use the correct file descriptor when unlocking
Date: Tue, 18 Jun 2024 14:39:26 +0200
Message-ID: <20240618123434.794781463@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 69efce009f7df888e1fede3cb2913690eb829f52 ]

Shared locks are set on O_RDONLY descriptors and exclusive locks are set
on O_WRONLY ones. nlmsvc_unlock however calls vfs_lock_file twice, once
for each descriptor, but it doesn't reset fl_file. Ensure that it does.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svclock.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index 9c1aa75441e1c..9eae99e08e699 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -659,11 +659,13 @@ nlmsvc_unlock(struct net *net, struct nlm_file *file, struct nlm_lock *lock)
 	nlmsvc_cancel_blocked(net, file, lock);
 
 	lock->fl.fl_type = F_UNLCK;
-	if (file->f_file[O_RDONLY])
-		error = vfs_lock_file(file->f_file[O_RDONLY], F_SETLK,
+	lock->fl.fl_file = file->f_file[O_RDONLY];
+	if (lock->fl.fl_file)
+		error = vfs_lock_file(lock->fl.fl_file, F_SETLK,
 					&lock->fl, NULL);
-	if (file->f_file[O_WRONLY])
-		error = vfs_lock_file(file->f_file[O_WRONLY], F_SETLK,
+	lock->fl.fl_file = file->f_file[O_WRONLY];
+	if (lock->fl.fl_file)
+		error |= vfs_lock_file(lock->fl.fl_file, F_SETLK,
 					&lock->fl, NULL);
 
 	return (error < 0)? nlm_lck_denied_nolocks : nlm_granted;
-- 
2.43.0



