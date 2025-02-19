Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3461C760D;
	Wed, 19 Feb 2025 09:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956032; cv=none; b=hTk51pQEdrurWSQv9VhPhGJA/u5OlP8qmAvCrMFUtz4MSjcVo2A42GkwEipEfI8hOzRo9385c25AYtt58qYsYzDjB+n5FEkI+fZZ9daSMFVSppMAk+uu52uMmCrK3sboPVjllMnkJNtUnrb/c/IlwvVj97Mic/qKZ8Rux1LtboY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956032; c=relaxed/simple;
	bh=NSTJ+ZWUDtygRziFMbroxWNggpkq3QnRppsOLmJF/ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/0t9nT+Z2tKbTH6QCgSd5TltBQ/1WU1sUXv5CqgWKmrzCU4ol8b9FGSVIpqynp0R+5a6N5WjfxKK1YRZ+BbMClYbMlJFAr2mqz++0zAYcu/LS6gWhe+FTK+VTsUVn3RXSjB2Funad3X1z7NxOW2lGEIPTOxe2LHwQBiLkcIWhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L0kTCKo/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L0kTCKo/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA8EC4CED1;
	Wed, 19 Feb 2025 09:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956032;
	bh=NSTJ+ZWUDtygRziFMbroxWNggpkq3QnRppsOLmJF/ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L0kTCKo/EVapvXb6W3ATBj+zwh9yNURcmVC/1BY84BP++R98DrnDgymV2iUhmoj6a
	 d50SefkmG5Wr9Z8tUfObqL/OxoVQYlmzTaEhIIXLBwD/0YYz5byQRIt7nF0T/Aw88O
	 /V/ULKdCl5tEUKDTFOhtm0Fa1vQVky1L9BodRWuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/578] select: Fix unbalanced user_access_end()
Date: Wed, 19 Feb 2025 09:20:15 +0100
Message-ID: <20250219082653.340195462@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



