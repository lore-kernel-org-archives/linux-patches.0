Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38620142E86;
	Wed,  5 Feb 2025 13:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763514; cv=none; b=pSEte6WyW55e5K7MAHcsePXv9/LWKE0zOTsgayS7gs0tXf0zMg9mIZl8g3fk3Utvek22/9OSYPblEWVq0SinqtiwcfypcdxKTcjhPfmOXbtAKh+UrUIZ6Erl1463l9Ne5S5UsSa9O7ZOVzNAXK/ehpOwg5k3JjA5H4vOXNjYGA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763514; c=relaxed/simple;
	bh=kD2q4e4DGY275SBzsIed1xlVH5g/g6alMyKqzAqLW5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBdRN3UtrI97u7okw+fWanZvYcS9pfQyCbrEc1mKTxFu8dol99lqf4q6TFSrtOxASHfhWmlrv2I4WWHlRGkL1XpCOd1V4K94ljcd6/iobSoEc973BLxY5sHBEU4CiTyCYeMNAOVHzH0sRba3qV6H2X2GFYtQvC996r4c9Xc8dYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s7EeP38y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s7EeP38y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D04BC4CED1;
	Wed,  5 Feb 2025 13:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763514;
	bh=kD2q4e4DGY275SBzsIed1xlVH5g/g6alMyKqzAqLW5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s7EeP38ywvvPqS+USSzUxWd5rA650PhGzDJBKc95sKP9M5vHDrrO5FFRMfWPOjNHn
	 gulo2Gv//Y1noAznMZSr154sFqWY/5Djkt5vbuVdE1MT2NsAYHmk+h+HlSjpNtkRSC
	 er5RE0mjcx+zt0uKixdVELxSRRpnVexUXZ8I/i6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/590] select: Fix unbalanced user_access_end()
Date: Wed,  5 Feb 2025 14:36:19 +0100
Message-ID: <20250205134456.170755612@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a77907faf2b45..834f438296e2b 100644
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



