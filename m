Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242F7148832;
	Fri,  6 Dec 2024 15:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498542; cv=none; b=Bv4IVPqDB+R0VWx56b5Hw8ACIi4Cjr9iTB2Kora5Ya0wRKptg3zEejAyzRZwFIzG225nKYIGy+cKhJoMSSz6b9XSC33dxGS459HXaog/Q0a6yfpEZcEGy2DkaBdAZti2i1du4HW1UR/Ya/OAahbeJOlA+04zFJNUuVD8+IlGOH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498542; c=relaxed/simple;
	bh=cUZi38TtzXfPN2ajc+exRaCpr8UFdE2mEy/MAOaDD7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6rVWkQlGIvqcEdpcWZNomff7b2r6R772ffXmVyPhdtwYeBxzeT5lPAHr1pndss7+stt/5zI9TeyGQZ6WfDo2y6YuDKOuTouOC6+PnBMk78zqK5oPeGP3287QNEzhs9UmezJ30h4hkiMfWOHx67abe0WB7+Qzy8rUsMaRn4KKOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OOctt4CB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OOctt4CB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 885AFC4CED1;
	Fri,  6 Dec 2024 15:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498542;
	bh=cUZi38TtzXfPN2ajc+exRaCpr8UFdE2mEy/MAOaDD7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OOctt4CBUE8B7T3cFHU63xIiALohyXhXR2MzJisVyTvfca8kmx7V3QYfsZWvFZAwS
	 UTj2b01ryq+RPy+5wQ2S3kPuXOvz+tzJbS0ixkA96GExs3CgPJpw+Xs9NeI8FjMIJ0
	 XduflK8VQ9pz9fSe3J/n8uFBkRf2XpnXQrDYP1+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 588/676] Rename .data.unlikely to .data..unlikely
Date: Fri,  6 Dec 2024 15:36:47 +0100
Message-ID: <20241206143716.338259275@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5793aedb24c6d..cb12f164caf1e 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -347,7 +347,7 @@
 	*(.data..decrypted)						\
 	*(.ref.data)							\
 	*(.data..shared_aligned) /* percpu related */			\
-	*(.data.unlikely)						\
+	*(.data..unlikely)						\
 	__start_once = .;						\
 	*(.data.once)							\
 	__end_once = .;							\
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 6466c2f792923..7602d1f8a9ecb 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -398,7 +398,7 @@ static inline int debug_lockdep_rcu_enabled(void)
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



