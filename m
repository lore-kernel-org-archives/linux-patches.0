Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D8B35A3B7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300913; cv=none; b=lb2c7341uTimZws3fHNnABll+rZT5e63biegeNeFtJgD3d3nk8XB5E0UKiH4za1YmurR3EkHHjOsKwjWb0/w+4lBpHMaWRgnpgKRSpn4NgGkTHoTOTsDlSEbkF87g6g+dEDeZ7yQbACefRdZiA73Bm65azUl/JRdTfYjOVcNLwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300913; c=relaxed/simple;
	bh=x3mFUwKG+WkAkFMJ/2Po3saOmtkk6EbTvNzoqVjfVOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClT2CULHyrDo9BFT+FQnE3g/HmzOtYLnAvwhw3ecrzq5XTUNQXkTas8Z7Rq4PEMrjyzGuf8cTU6zQhzEJxi4lusHu3SeCT2zpA7GEBW7w6o9lsbmPIQMHJekeyINOTceLEUaTymj+I6KerLajqvP4Y/FFZfTqfT118TRIUuUbkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PeUxvOvt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PeUxvOvt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A739DC116D0;
	Sat, 28 Feb 2026 17:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300913;
	bh=x3mFUwKG+WkAkFMJ/2Po3saOmtkk6EbTvNzoqVjfVOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PeUxvOvtDghByvKqJ7eSZutaluvvhh/k9dFpIY+JqS8Zuf/Ma5tTrQyOuZMyL+1AR
	 1/e87VpbZc5bEoBDMLyDW7pjmPjymFmMr0ttXUFHNKam8KH48YUFWTYtQZXJ2QPrXz
	 07bzJX9f60GY+5k74U4i734pr4RjwfheZ+sqYvNfAXypxJ7NXnzfa2dCV0IxV00bdw
	 6ma1GwTQcm43wCg2kJ66M31WSMTr/VBKuWay6RDZtZWaBQV/G/wtM2B5RvKw25q+la
	 hTZYbWHSrE9PI4PAEXKpwr6BiR5hhyMKd0gjeqXwph36dC05AyZO4bVWLjbZ6AQIXt
	 04ewoBvDYBpnw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jeffrey Bencteux <jeff@bencteux.fr>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 028/752] audit: add missing syscalls to read class
Date: Sat, 28 Feb 2026 12:35:39 -0500
Message-ID: <20260228174750.1542406-28-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jeffrey Bencteux <jeff@bencteux.fr>

[ Upstream commit bcb90a2834c7393c26df9609b889a3097b7700cd ]

The "at" variant of getxattr() and listxattr() are missing from the
audit read class. Calling getxattrat() or listxattrat() on a file to
read its extended attributes will bypass audit rules such as:

-w /tmp/test -p rwa -k test_rwa

The current patch adds missing syscalls to the audit read class.

Signed-off-by: Jeffrey Bencteux <jeff@bencteux.fr>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/audit_read.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/asm-generic/audit_read.h b/include/asm-generic/audit_read.h
index 7bb7b5a83ae2e..fb9991f53fb6f 100644
--- a/include/asm-generic/audit_read.h
+++ b/include/asm-generic/audit_read.h
@@ -4,9 +4,15 @@ __NR_readlink,
 #endif
 __NR_quotactl,
 __NR_listxattr,
+#ifdef __NR_listxattrat
+__NR_listxattrat,
+#endif
 __NR_llistxattr,
 __NR_flistxattr,
 __NR_getxattr,
+#ifdef __NR_getxattrat
+__NR_getxattrat,
+#endif
 __NR_lgetxattr,
 __NR_fgetxattr,
 #ifdef __NR_readlinkat
-- 
2.51.0

