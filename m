Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B451AB6C9;
	Tue,  3 Dec 2024 16:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242776; cv=none; b=st2z31REIBeqGQoEPg/iKHBiuUF8r/2xDl6SD4IydPCBWy/zj5gm2gUAmRtTH+cQ5mryMjQnUSsOKbl3y143jegLut5mQrcq0k9a/t9wgujmyNDH3kyZoNEeCA4vdsojMXgLQj/dw8b9TKvbIKquhHOMUbEqff8lFiExWGclHGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242776; c=relaxed/simple;
	bh=1BqIz83JQuxaOvAC5OFfUswzdY58aK0D+lm4YQokmD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QrZGMi53MewZ0mDVPIs/kWOmZcV3ZRqkZe1AIUai6qFMLOgS17+HiN3jfZRfnIDQe+G/jV3nakPLIwsNw0W9uoZvnPQmqwVTjorU1SipsFrpbi9KHdT41IHKuOrCs1/u+ZMvpF7cg8it3yCtz1WZbQCnHdrKP4eGkm+CfgqXfO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zmgBsnaa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zmgBsnaa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD55AC4CECF;
	Tue,  3 Dec 2024 16:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242776;
	bh=1BqIz83JQuxaOvAC5OFfUswzdY58aK0D+lm4YQokmD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zmgBsnaa7nJ/ZuuKJCJPjMV9RlH/Lcai9mV/WM7I6/hnUt5D76sHcLU43S2pxR/am
	 ukQD5iN4laCLL2aybLMOYZuWK6NGGqpQYri+HQYtwqTWwC0okSsOW1i+s64nSENnR9
	 kmfZKv+NHGPkIEynyQPhXM6Ni7yR+ZLee4svB71I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 806/826] Rename .data.unlikely to .data..unlikely
Date: Tue,  3 Dec 2024 15:48:53 +0100
Message-ID: <20241203144815.198261251@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index eeadbaeccf88b..706f660fec657 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -350,7 +350,7 @@
 	*(.data..decrypted)						\
 	*(.ref.data)							\
 	*(.data..shared_aligned) /* percpu related */			\
-	*(.data.unlikely)						\
+	*(.data..unlikely)						\
 	__start_once = .;						\
 	*(.data.once)							\
 	__end_once = .;							\
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 58d84c59f3dda..48e5c03df1dd8 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -401,7 +401,7 @@ static inline int debug_lockdep_rcu_enabled(void)
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



