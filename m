Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045907;
	b=D+wFjF6ns4N+/mClfJOH0YVwl2gebApbnPpjKVhXAcoYD9W+/kkunKTot2OpYoxvP1VN
	 N0C6YHMe6g7yuRnU9VB16DL6Sq5Bikk4iYTVxbFrva7UT5hTpuUV7YsIK/N5GXUi/FNRW
	 9Xve4XSE9ec+qz78nHpQObaiNhoz2wP2E6tq3z4vptBk97bzSTGaLoIVIOw1he40hrNSe
	 zDxPQPkjy6ctiOLv420GKrT4xJRfJ5NQXEgyHCJElyzTr3j8YoHiJMdOE319RbkdizNgX
	 oYwyCQcsTHpj07DayuKnf0y7VPUpBvHO2mol8+iXhGLVMxfsD8DOnF23KLb2T8VKb/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045907;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SLGuC3peLJ5yxcDpjebiBB5iB5Qr6nxdfz+6sA6M5AM=;
	b=0+/F+08x7d4YsFW/8Ly8ukc1jSV/bviD8zj9QW1f76cJIMCIhkvdlBr6+2nu3hDZbj3S
	 9uIrvyI7PW2rRZLsA7tqMlAP0/L6RmPnFy8FG01wAmzGX8sI+/QtiKd7FLKukqocESrHY
	 92zbEZHuxYNZ2jnASTCBTP4hNHrR7X1WOYtqnWRXTGUHry645Bk4ZYYC82RbccfPQ0wA/
	 R5Zo1V8AijZ+7M456oi+I4XOKttQPuBZ32cvh/pSiI9TWdXWzRMErbiZ8DUDNfJVvyWxK
	 /TuZMBI/mpYQHF2j3EAIvRef9Mtc0v2DxwULliuI3PyTIxvK07zA9s7fXix5Uhba8Jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K2wh2NRP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCD2606A325;
	Wed, 18 Nov 2026 23:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K2wh2NRP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D28A1F000C4;
	Wed, 18 Nov 2026 23:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045906;
	bh=SLGuC3peLJ5yxcDpjebiBB5iB5Qr6nxdfz+6sA6M5AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K2wh2NRPmD54gVf4KUNSOTva/AQ+mmj+PoR1yByi68b547DTMKKUmM7ZLEpvzXoVB
	 fhWamJPcWn12CxXxRtM16H/MeAVedRIA3Vkepn6duLJMyi5YM3yetXMVJqDhSSVYsX
	 5CEvxIU7OL/y0Ar5MCB+Pf5Cdmfo9foFRq2YfSvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1091/2857] mount: refuse setns() with a shared fs_struct again
Date: Wed, 18 Nov 2026 15:35:25 +0100
Message-ID: <20261118150240.905803151@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 948e604aca8af30490accf7d46d44814ffa26f80 ]

mntns_install() refuses to switch the mount namespace of a task that
shares its fs_struct, since root and cwd of the others would move to a
namespace they are not in.  It looks at nsset->fs for that.  If more
than the mount namespace is asked for, that is a private copy made by
prepare_nsset(), which has one user by definition; commit_nsset() then
writes root and cwd of the copy to the fs_struct of the task.

A thread of a process with two threads, pidfd of a task in another
mount namespace:

	setns(pidfd, CLONE_NEWNS)			-EINVAL
	setns(pidfd, CLONE_NEWNS | CLONE_NEWUTS)	0

and after the second call the other thread, still in the old mount
namespace, has lost its cwd (/tmp became /) and sees the mounts of the
other namespace under /.

Look at the fs_struct that is going to be changed.  The second call then
fails with -EINVAL like the first one.

Fixes: 303cc571d107 ("nsproxy: attach to namespaces via pidfds")
Cc: stable@vger.kernel.org # v5.8+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index cb3b702de4447..211c2f1fa5e9a 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4775,7 +4775,7 @@ static int mntns_install(struct nsset *nsset, struct ns_common *ns)
 	if (is_anon_ns(mnt_ns))
 		return -EINVAL;
 
-	if (fs->users != 1)
+	if (current->fs->users != 1)
 		return -EINVAL;
 
 	get_mnt_ns(mnt_ns);
-- 
2.53.0



