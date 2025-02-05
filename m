Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87735B640;
	Wed,  5 Feb 2025 13:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763292; cv=none; b=TRMk6+k7U0G74+UE9D4pXhVcIxXKvNGuvj2BjXmbThVibu0lKiym6B9b8QvNJgRpwUD/5HECAr6V2heCAmGUIIoQw3rKhk1qnj99T2aR0LFrh2X0kXg0vH/wEV8P/VUu7yEo/b348az/NvVR87y+HUPr/uNOF5oCZXXXx1yPBGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763292; c=relaxed/simple;
	bh=8Huco0Byn9KRG42oVM4UvBjAlYmAlgxutkW9nnWvy90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtIjwJFXSwhVUkbSWU3aiyCzpRiV40/ZBOSjkb+uudSEptQF6nrz98Z5IlDRRDZJTcJ22YMZ0kDxmuC2RTe4g87HruqjFrLIDb4xmThVxmwuLXDSL6RT0jhSNj9hR1R6QSB5IHwY1IChkGbkha1GbmUOwfkV7k5S1WM3Db5YI0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPUxpdQv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPUxpdQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48EFC4CED1;
	Wed,  5 Feb 2025 13:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763292;
	bh=8Huco0Byn9KRG42oVM4UvBjAlYmAlgxutkW9nnWvy90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wPUxpdQvGJu9JeAwxeLZ8um6UmQn+Mb6a2VcaEPxF+1cDXfuRF4kQWACBWYPt5agE
	 0LxUhwBH9C+bVq3sHCcjNOtSQfXQnK1cKGYOhN48P85EorwmCtM7eG5Lf2W72nuDSO
	 zBlrvm89IYNimyo7YZUKIbRJ/7QrjuSL/2gNbEak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/393] select: Fix unbalanced user_access_end()
Date: Wed,  5 Feb 2025 14:38:53 +0100
Message-ID: <20250205134420.840870119@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d4d881d439dcd..3f730b8581f65 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -788,7 +788,7 @@ static inline int get_sigset_argpack(struct sigset_argpack *to,
 	}
 	return 0;
 Efault:
-	user_access_end();
+	user_read_access_end();
 	return -EFAULT;
 }
 
@@ -1361,7 +1361,7 @@ static inline int get_compat_sigset_argpack(struct compat_sigset_argpack *to,
 	}
 	return 0;
 Efault:
-	user_access_end();
+	user_read_access_end();
 	return -EFAULT;
 }
 
-- 
2.39.5



