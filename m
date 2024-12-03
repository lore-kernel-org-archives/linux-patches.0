Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F201F9427;
	Tue,  3 Dec 2024 15:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239969; cv=none; b=uxTlDHfbxIEDU1avHaEK/n2WeUvlP2hjSm+rUOTU5RMZjPVK41aEBEZPtICdrqGzCRDn6PEZPFjFPCJi3xgjWutbXA58vHoNut33kIaODNwTbbfi6bmH8YWgmUW28MLWD+JlrqAoyRBWEgIWXa1kwGygH1FUKXdwH/Lits+eb+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239969; c=relaxed/simple;
	bh=a1Lx1MyLFcfFzb/O/HMzJstB3gGifxbyaKax/XP/yEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nVL4t78jIQU7C1F60/m6wqndIJvrq8Z40LAMKtPP+uDJu3JEp4BLlW2UneFtvM0m7BkyIdaN/i0FDB8c1IpW+5gqtFKp/8TsVU1NHE+ZKl5XQLuVYWgUHNeb/hVDg7abWNMdCHWGmy8SUnHvIZEn64pkUOrIEwBqEZZ/KqjE2xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j2y4sDDF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j2y4sDDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0195C4CECF;
	Tue,  3 Dec 2024 15:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239969;
	bh=a1Lx1MyLFcfFzb/O/HMzJstB3gGifxbyaKax/XP/yEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j2y4sDDFBjDAT/k4o+3+Nrx3Ka+87DMvtBiH6hHeWkjycRYwK69+IKQHVBWhKozLM
	 E8jkHvBfLk6Vfq1N2B/xCSIaSSO/JX/PlbpYXreTNwwNJf6Y0KV547NoJFTRiamA0K
	 uj5bk4L5+PptPOi5DLweMi79MgjeWKvhxXg9eP9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 797/817] Rename .data.unlikely to .data..unlikely
Date: Tue,  3 Dec 2024 15:46:09 +0100
Message-ID: <20241203144027.122250283@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit bb43a59944f45e89aa158740b8a16ba8f0b0fa2b ]

Commit 7ccaba5314ca ("consolidate WARN_...ONCE() static variables")
was intended to collect all .data.unlikely sections into one chunk.
However, this has not worked when CONFIG_LD_DEAD_CODE_DATA_ELIMINATION
or CONFIG_LTO_CLANG is enabled, because .data.unlikely matches the
.data.[0-9a-zA-Z_]* pattern in the DATA_MAIN macro.

Commit cb87481ee89d ("kbuild: linker script do not match C names unless
LD_DEAD_CODE_DATA_ELIMINATION is configured") was introduced to suppress
the issue for the default CONFIG_LD_DEAD_CODE_DATA_ELIMINATION=n case,
providing a minimal fix for stable backporting. We were aware this did
not address the issue for CONFIG_LD_DEAD_CODE_DATA_ELIMINATION=y. The
plan was to apply correct fixes and then revert cb87481ee89d. [1]

Seven years have passed since then, yet the #ifdef workaround remains in
place.

Using a ".." separator in the section name fixes the issue for
CONFIG_LD_DEAD_CODE_DATA_ELIMINATION and CONFIG_LTO_CLANG.

[1]: https://lore.kernel.org/linux-kbuild/CAK7LNASck6BfdLnESxXUeECYL26yUDm0cwRZuM4gmaWUkxjL5g@mail.gmail.com/

Fixes: cb87481ee89d ("kbuild: linker script do not match C names unless LD_DEAD_CODE_DATA_ELIMINATION is configured")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/vmlinux.lds.h | 2 +-
 include/linux/rcupdate.h          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 1ae44793132a8..bee5a71f4b41e 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -349,7 +349,7 @@
 	*(.data..decrypted)						\
 	*(.ref.data)							\
 	*(.data..shared_aligned) /* percpu related */			\
-	*(.data.unlikely)						\
+	*(.data..unlikely)						\
 	__start_once = .;						\
 	*(.data.once)							\
 	__end_once = .;							\
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 13f6f00aecf9c..1986d017b67fb 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -390,7 +390,7 @@ static inline int debug_lockdep_rcu_enabled(void)
  */
 #define RCU_LOCKDEP_WARN(c, s)						\
 	do {								\
-		static bool __section(".data.unlikely") __warned;	\
+		static bool __section(".data..unlikely") __warned;	\
 		if (debug_lockdep_rcu_enabled() && (c) &&		\
 		    debug_lockdep_rcu_enabled() && !__warned) {		\
 			__warned = true;				\
-- 
2.43.0



