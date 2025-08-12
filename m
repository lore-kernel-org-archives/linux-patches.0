Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60EA12FDC52;
	Tue, 12 Aug 2025 17:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021579; cv=none; b=jPdCYBmIMGn+CpxM3gFq3MB7BLgix8f4S7iMelkbyzEM4qobAPAdKMLTPLLyFQRjk2rMGe2UyJu4S0Z/HyY/XP9ADYI5zYRXDHPg3MO+6LwpyKsNjPkHh0QMTYdDVXYHfwa1rFQIgwoCUOOE8e2MAsm8e6SgmhsySVjUKtidPVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021579; c=relaxed/simple;
	bh=rg9YN0/M819/mVpht11D1XtKJ5l6oJsJU15jvGEqKcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDKioo3vdcA60rsXkXVJlmAXrPiBRU+TkNIbxgtEOoy0c3WDG4lFnuvC7pDtbZSb+ojOPFizXysZINJsTXwhxybQxSb7GYaYC6WVgZp61urW9U1uAQcyloKjY61lrSt/EpHWOY5nv6M1lqqw7H9Xkx6N+hZWns5/RyGiP12rd+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bd1HheAv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bd1HheAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20EFC4CEF6;
	Tue, 12 Aug 2025 17:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021579;
	bh=rg9YN0/M819/mVpht11D1XtKJ5l6oJsJU15jvGEqKcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bd1HheAvH9Vy7GwikRIlnhMjVUV3u1Ew2ojJQELiZSHergmIgMaZTOGcVL5f4jYTh
	 /uIzkwH+GiEPQFNCjJ0Wsb4WURNjP2Yyn8pxIwC0NmBwRk1lcBnVmwgoj5/MxP/KFe
	 UAS9lxFbZYsVkjXP2lFkt56Uw5SdLwRWz14xDlpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 164/262] module: Restore the moduleparam prefix length check
Date: Tue, 12 Aug 2025 19:29:12 +0200
Message-ID: <20250812173000.082248691@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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
index 962cd41a2cb5..061e19c94a6b 100644
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
 	__used __section("__param")					\
-- 
2.39.5



