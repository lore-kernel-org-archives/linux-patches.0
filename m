Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83A33955F4;
	Tue, 21 Jul 2026 15:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649324; cv=none; b=cP86UupK/FQbjFVHS7WRk3JgmdsYKGSh0LlJ1DQBsvdVOy9WprwR7Kxe/Y4GJs+LAPkvcUM4YxCTi0DMyz6FZt4NesfbWj/hZBXaJcWbt7Iv2myKFY+VRIiu0Hp7nbgrLLH2KEfyqIhvQNv+CtjpI8e1vQtsvAD5E4fyY0bexBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649324; c=relaxed/simple;
	bh=1G97xnSZF5P/Uf2a0RkqKoopeZL4N9H8eSPuu51+rMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3N20vsS+DBJtYS60lg03XWl2CjRdu2jKfnHzQCN6AWkzL8ADXVkPtXC2YWsBcN5r2MnnFpESdYpbm9WSRcqZdn5/kTr1TCYRGnIWo7cvoVQ6jLpxM0UtoGXQs2Lx83dI0dv60ZEvnEE+CQGJUExUvXBWt/4szb4SxrbXvGVy4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pGjI6PR8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pGjI6PR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2ED1F000E9;
	Tue, 21 Jul 2026 15:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649323;
	bh=ivGjHrkd/Qq3syialepXFczlkOmU/7oK/wxMZ4hp340=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pGjI6PR8hDzWpx5QIbT7bTOqDxWXGEeYgjHfxDQZZkRhkwFgMGuGMcygR5Sidkulg
	 G5rmOPRcDw5bPoyGG8pMHZ8oDVNjXe/oTwgoWKHrAeRNSZVfqjN3adYT5mMca9Z5lJ
	 UZFrzeQHbznoOSmEDo6aohn9LVoXMKlig6gi1FAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0534/2077] filelock: fix break_lease() stub signature for CONFIG_FILE_LOCKING=n
Date: Tue, 21 Jul 2026 17:03:27 +0200
Message-ID: <20260721152605.400977046@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 4bbcff264b678859cc404669bd145bcd6819804b ]

The CONFIG_FILE_LOCKING=n stub for break_lease() takes a 'bool wait'
argument, whereas the CONFIG_FILE_LOCKING=y version and every caller pass
an openmode as an 'unsigned int mode'. The mismatch was introduced when
__break_lease() was reworked to use flags: only the stub was switched to
'bool wait', a stray leftover from the neighbouring break_layout()
helper. The real prototype kept 'unsigned int mode'.

This was harmless until O_WRONLY changed from the octal literal 00000001
to (1 << 0). clang's -Wtautological-constant-compare then fires on the
implicit shift-to-bool conversion at the first FILE_LOCKING=n caller:

  fs/open.c:112:29: warning: converting the result of '<<' to a boolean
                    always evaluates to true [-Wtautological-constant-compare]
    112 | error = break_lease(inode, O_WRONLY);

Restore the stub's parameter to 'unsigned int mode' so it matches the
real prototype and every caller. The stub still just returns 0, so there
is no functional change; it removes the type inconsistency and silences
the warning.

Root cause diagnosed by Nathan Chancellor.

Fixes: 4be9f3cc582a ("filelock: rework the __break_lease API to use flags")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202606071029.DKCs8WOs-lkp@intel.com/
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/filelock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/filelock.h b/include/linux/filelock.h
index 5f0a2fb3145060..77e1cc4afbaa89 100644
--- a/include/linux/filelock.h
+++ b/include/linux/filelock.h
@@ -564,7 +564,7 @@ static inline bool is_delegated(struct delegated_inode *di)
 	return false;
 }
 
-static inline int break_lease(struct inode *inode, bool wait)
+static inline int break_lease(struct inode *inode, unsigned int mode)
 {
 	return 0;
 }
-- 
2.53.0



