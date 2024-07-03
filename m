Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD88194A54;
	Wed,  3 Jul 2024 11:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005117; cv=none; b=YQ7ILbQEZqKeRdT5Ri+aAqV51yUls68OpHJms6S3eaBmx7FypVH6kEe5Xd769dFwwS1sITyatcBBZ9yUM8faOvW91N7JPpS+afRWDxmlqLl7/pQoLgjBXjh9EpLGdNqK0SlRlDLszMO6hREMQUST6gmqgUKKdz3KA9ldfEECWXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005117; c=relaxed/simple;
	bh=1+lEzGqHGb939x/MMYimyBe3780pz31YayPHXaKBrBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJi4YEBmN6seg2Agej2XQORYccP94JdXP3HvjNFplAoB8PMdKbjV+pc/TYEedfrrv1mMIKnDth5h+mNChD1nbYapIpIJbpjxKro9eqxO5fZHp2uKhYdC8MCGKznm9dgm0U8hObzRJUO/XlqTuOxcXkk4+z5q+Jv6yY8scBAekb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RmNCwVS9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RmNCwVS9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6652C2BD10;
	Wed,  3 Jul 2024 11:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005117;
	bh=1+lEzGqHGb939x/MMYimyBe3780pz31YayPHXaKBrBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RmNCwVS9gq7ZgiLP7HNCG873NwvfpaDdurZYiDlsZesPCVue7bw/UHcMY4qK+MsXY
	 AjANKpBtZ7bMWnjVsXnYXZ5dE3mSodS7Wx+oRAvl60B7hQ0+ISUC6pe1OFtQFrNt+6
	 MOmpeo64d3zi/Bet3RUeb1wcQunpmwS7iRVYng0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.10 267/290] hexagon: fix fadvise64_64 calling conventions
Date: Wed,  3 Jul 2024 12:40:48 +0200
Message-ID: <20240703102914.237219541@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 896842284c6ccba25ec9d78b7b6e62cdd507c083 upstream.

fadvise64_64() has two 64-bit arguments at the wrong alignment
for hexagon, which turns them into a 7-argument syscall that is
not supported by Linux.

The downstream musl port for hexagon actually asks for a 6-argument
version the same way we do it on arm, csky, powerpc, so make the
kernel do it the same way to avoid having to change both.

Link: https://github.com/quic/musl/blob/hexagon/arch/hexagon/syscall_arch.h#L78
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/hexagon/include/asm/syscalls.h |    6 ++++++
 arch/hexagon/kernel/syscalltab.c    |    7 +++++++
 2 files changed, 13 insertions(+)
 create mode 100644 arch/hexagon/include/asm/syscalls.h

--- /dev/null
+++ b/arch/hexagon/include/asm/syscalls.h
@@ -0,0 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <asm-generic/syscalls.h>
+
+asmlinkage long sys_hexagon_fadvise64_64(int fd, int advice,
+	                                  u32 a2, u32 a3, u32 a4, u32 a5);
--- a/arch/hexagon/kernel/syscalltab.c
+++ b/arch/hexagon/kernel/syscalltab.c
@@ -14,6 +14,13 @@
 #undef __SYSCALL
 #define __SYSCALL(nr, call) [nr] = (call),
 
+SYSCALL_DEFINE6(hexagon_fadvise64_64, int, fd, int, advice,
+		SC_ARG64(offset), SC_ARG64(len))
+{
+	return ksys_fadvise64_64(fd, SC_VAL64(loff_t, offset), SC_VAL64(loff_t, len), advice);
+}
+#define sys_fadvise64_64 sys_hexagon_fadvise64_64
+
 void *sys_call_table[__NR_syscalls] = {
 #include <asm/unistd.h>
 };


