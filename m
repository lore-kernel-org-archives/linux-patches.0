Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F788230BD4;
	Mon, 10 Mar 2025 17:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628723; cv=none; b=B+DhKvltfVu1eKO1fVkDTPK3oVFuxfQYInvB7Qzd/voPuJFOU6i+Z61YpxX9I1MPtEKYqcZinrHuyug2njB9he3rXdGWNb2cBhPTSv0nCiWJgjrOg4vdoWNGtkifeeIHmQC9dQbF18rW7GcvDV9xla0A0SPGm/buklKjHTZowCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628723; c=relaxed/simple;
	bh=Hdz+b4a+fb07yo1xWkxVMnQsK7M3rM37hxkb7u5oEVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnXaUAeXFX5at35gMd7E5VwnfJXQgjMWyVJPcbIhLdKT2pLNLjmq7hyqgbkKiArgPVQ4KTnBYONeXzt7Fr1z3KNzQfKSlSJfjHEBsVc7kFQeNdpaH8GVuy8fm2qmBbw9vF4+I/g6PAfwn9iXgXI/iWrYQq+p2d14qg/CZT9bZKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DkMxc1LP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DkMxc1LP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA312C4CEE5;
	Mon, 10 Mar 2025 17:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628723;
	bh=Hdz+b4a+fb07yo1xWkxVMnQsK7M3rM37hxkb7u5oEVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DkMxc1LPM2NV3iQN1z6ki2H643GbwK5Dsfx/y/DFkbemGtHF5FmfCd5+0MtwijGLJ
	 QUS4QsVCj1bvlSRYV7tk0grO7imy46/FW6Tf5KZ8NX00WWpqlWeH7qVkbFlDipK/D0
	 9xrAY1km/1eaFskPUwCCi/uJA4ktp04kzuxgKNqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/620] select: Fix unbalanced user_access_end()
Date: Mon, 10 Mar 2025 17:57:41 +0100
Message-ID: <20250310170546.178784755@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 344af27715ddbf357cf76978d674428b88f8e92d ]

While working on implementing user access validation on powerpc
I got the following warnings on a pmac32_defconfig build:

	  CC      fs/select.o
	fs/select.o: warning: objtool: sys_pselect6+0x1bc: redundant UACCESS disable
	fs/select.o: warning: objtool: sys_pselect6_time32+0x1bc: redundant UACCESS disable

On powerpc/32s, user_read_access_begin/end() are no-ops, but the
failure path has a user_access_end() instead of user_read_access_end()
which means an access end without any prior access begin.

Replace that user_access_end() by user_read_access_end().

Fixes: 7e71609f64ec ("pselect6() and friends: take handling the combined 6th/7th args into helper")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/r/a7139e28d767a13e667ee3c79599a8047222ef36.1736751221.git.christophe.leroy@csgroup.eu
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/select.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index 668a5200503ae..7ce67428582e6 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -787,7 +787,7 @@ static inline int get_sigset_argpack(struct sigset_argpack *to,
 	}
 	return 0;
 Efault:
-	user_access_end();
+	user_read_access_end();
 	return -EFAULT;
 }
 
@@ -1360,7 +1360,7 @@ static inline int get_compat_sigset_argpack(struct compat_sigset_argpack *to,
 	}
 	return 0;
 Efault:
-	user_access_end();
+	user_read_access_end();
 	return -EFAULT;
 }
 
-- 
2.39.5



