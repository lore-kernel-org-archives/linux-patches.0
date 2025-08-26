Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B3035083D;
	Tue, 26 Aug 2025 14:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218778; cv=none; b=Wsb9ROcjb0aPVhV+U7FNovY6bX3PIAqbAuERv9bYFj0np0BcvNdDw1JEFxaRttmLyRQJcP9fYqPCHuWerpdNVzu9y7BkndgImksAHC0QqV1hWPPKFyPO7QK0FctY7sEOIbgAjErHeCCWRPBI8+AXC8pE+DwLa9llzl6YYQbEU0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218778; c=relaxed/simple;
	bh=NJQsJvFP+HYCWiZBOV4V3Vk4EaD6hilBwK5IOzVi+pI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2WBH89TxJOBZrBxXIEQxSZGJJV73EHNrNLdMyDyh+6+8xcNeC0ZAlliJ5d9XHSEEWl2IB5iqbzctApz9nDTMNeHpNk1I/NRB6SoSWy6Rni/rXeG3uYN+uyMRp70kZ2ZeJ59CiMQY9NZmfNcCBvp6TD6LGy7SlLfirZEjlg1s+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+uLuZU0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+uLuZU0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850E8C4CEF1;
	Tue, 26 Aug 2025 14:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218777;
	bh=NJQsJvFP+HYCWiZBOV4V3Vk4EaD6hilBwK5IOzVi+pI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+uLuZU0+D8/Mp8uohS1JV7GSPSJoAr5F2+kkAeDhxRFXBHVfmprZpE7ES8UR52A+
	 gzLqyts1gnkfU7aLmvp104vt40vs+npXBV8gxkrLcRbWz3vyUNnnVftQcvvHoBYmSe
	 DJziA5+uB2S56SQ6ZpSWrOxTd2YQqEFQkz98G7E4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 130/403] module: Restore the moduleparam prefix length check
Date: Tue, 26 Aug 2025 13:07:36 +0200
Message-ID: <20250826110910.332607705@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 4d5a851cafe8..6e9062caa7df 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -214,10 +214,9 @@ struct kparam_array
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



