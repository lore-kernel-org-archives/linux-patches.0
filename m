Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35715352071;
	Tue, 26 Aug 2025 14:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217453; cv=none; b=P5gD1GRMIdCvqNpyplX3BVkKgHTgphqIChzZCo8wLPtu1TrbaTOlfdhOAcwNMfKs1JRP13/JlPYlxw/iN5y2NMfdY28Bj6gy+UtwckhSlY2cfJgm0tBnIvnLoP5knjbK5LWp6lC8BF5ZqwcOGCLAkpmxRg3JwFmvOadsejMqfI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217453; c=relaxed/simple;
	bh=ZwbN4QhHh3+L5L3VBeP5EpxvEb8W6Ez/GuO9qirH55A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BN9UyOv2uQBbHbbULmbGaCn9W7b9PHwbP6s/o9OvEsynrYYQz7qJxkRy+AsZ0d6nt3rv22FkqK57YkkkKfdZvrR5pcZaiRlPuKiS84KeQcE3Ciq4beaOlZ7ex86mWg5ZMneVjph3/xIBhClEey+MxWgEL9VoAQFNPZw391Cub30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AzkBv5Kv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AzkBv5Kv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3459C4CEF1;
	Tue, 26 Aug 2025 14:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217453;
	bh=ZwbN4QhHh3+L5L3VBeP5EpxvEb8W6Ez/GuO9qirH55A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AzkBv5KvMw/TlKw/DlJRuEb7pMhO1PqhtrDmTmemvydQcNu1onW1ebpVWDH4MlHuI
	 dXvbjWLnHNEGcXg7j1GnpCPFweViOkzMXIkXU7iKmOBSPlEKqLBOSsNI3dSHPAow4G
	 j3AWCur0mgROsdd8NkZPREWh+9ndPFV3W1U6oKeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 149/523] module: Restore the moduleparam prefix length check
Date: Tue, 26 Aug 2025 13:05:59 +0200
Message-ID: <20250826110928.163601060@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

From: Petr Pavlu <petr.pavlu@suse.com>

[ Upstream commit bdc877ba6b7ff1b6d2ebeff11e63da4a50a54854 ]

The moduleparam code allows modules to provide their own definition of
MODULE_PARAM_PREFIX, instead of using the default KBUILD_MODNAME ".".

Commit 730b69d22525 ("module: check kernel param length at compile time,
not runtime") added a check to ensure the prefix doesn't exceed
MODULE_NAME_LEN, as this is what param_sysfs_builtin() expects.

Later, commit 58f86cc89c33 ("VERIFY_OCTAL_PERMISSIONS: stricter checking
for sysfs perms.") removed this check, but there is no indication this was
intentional.

Since the check is still useful for param_sysfs_builtin() to function
properly, reintroduce it in __module_param_call(), but in a modernized form
using static_assert().

While here, clean up the __module_param_call() comments. In particular,
remove the comment "Default value instead of permissions?", which comes
from commit 9774a1f54f17 ("[PATCH] Compile-time check re world-writeable
module params"). This comment was related to the test variable
__param_perm_check_##name, which was removed in the previously mentioned
commit 58f86cc89c33.

Fixes: 58f86cc89c33 ("VERIFY_OCTAL_PERMISSIONS: stricter checking for sysfs perms.")
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Reviewed-by: Daniel Gomez <da.gomez@samsung.com>
Link: https://lore.kernel.org/r/20250630143535.267745-4-petr.pavlu@suse.com
Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/moduleparam.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index f25a1c484390..2c9d43eed9c7 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -282,10 +282,9 @@ struct kparam_array
 #define __moduleparam_const const
 #endif
 
-/* This is the fundamental function for registering boot/module
-   parameters. */
+/* This is the fundamental function for registering boot/module parameters. */
 #define __module_param_call(prefix, name, ops, arg, perm, level, flags)	\
-	/* Default value instead of permissions? */			\
+	static_assert(sizeof(""prefix) - 1 <= MAX_PARAM_PREFIX_LEN);	\
 	static const char __param_str_##name[] = prefix #name;		\
 	static struct kernel_param __moduleparam_const __param_##name	\
 	__used								\
-- 
2.39.5



