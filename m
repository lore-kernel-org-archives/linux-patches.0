Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E66249F9;
	Tue, 11 Mar 2025 15:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706336; cv=none; b=sy2EC0KYAJV555kvxr6xYhxQPCKMpnpwDal66dyzvlxVhcfP3/nl+Igz/2ZTynPTf8zjmyaDn6UeNlnnQE1AEV/02IfQtxS4/joeggg2jFs3LC0BdNa2BAsSneIH9H/cbAFgJBy/Yv1Bwxh13rm2vmTn5URMG0WxD5Gnd76g5y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706336; c=relaxed/simple;
	bh=kzS51p2HxKzqOrzPNgyDylNkNv5MA7oJJFa7anSJRko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sla8I4G/5Fa2lLH01wUT9fe24vZ3tjg6H1R/Guu2Lpd92OG97FeU4MRMEhrCRgasZmukfMLOwRYr/ge/qaT4f0kutwnktSTAr0uO7tNFtGyYxXRDn25VBYHskzVteAIcaJE5yZ8ks2T0uc663ZxMGJG/28t6CLlvBIgDAYSHodo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qKoXs5HL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qKoXs5HL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB252C4CEE9;
	Tue, 11 Mar 2025 15:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706336;
	bh=kzS51p2HxKzqOrzPNgyDylNkNv5MA7oJJFa7anSJRko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qKoXs5HLdNoyDlYEL6fR0ZmzpuCFQjOWN5DQ+QqTccThfPUuQRZPjdBHvWwFBt5iR
	 9S65IhUYSNLmxYU3jiM79GU6SWb9bD0QgUSLmct9GXanH7LVZALBx+BSHQvErOBhUY
	 j9auP03JHyP3MEkCZ3c/bst4D6bOceU5pmQ1biJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 006/462] select: Fix unbalanced user_access_end()
Date: Tue, 11 Mar 2025 15:54:32 +0100
Message-ID: <20250311145758.603210064@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



