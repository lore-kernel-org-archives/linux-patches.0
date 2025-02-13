Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E3026B080;
	Thu, 13 Feb 2025 15:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459356; cv=none; b=n8O0GM9j5IRrrcac8qPsArgV6NhbvbMisIZuFxhlAcDuPw3225VtlEUW98Q4qBhEwLF+6pg54Ehlwm61tkIYahaQhPx0fNVMB12mwkA0vvdLv46XeabpnhEBW2+uTbMN95V0ytfojbNt+nZq3HomCbi0YDRBwP7mNN+0Rh7kBTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459356; c=relaxed/simple;
	bh=A14zxewLCT8qoTJH2Q/WDe4oI/S3GUKz+TphIifGtqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkHfN9OO32gcoI7b4flhH103ZpBGbzcMImcQ2BpJT2bjzmLxsqak293oMHgWFE3unpwAl0c8AD4VhMtTkex16qJ//uDAX6q7JhKfkS8/YfUGw0K9KvPvEva56iWZp8Jc4vj6uVgzy5le7s4McqeQaA+jom6NHWPGxbT9WeEoaoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BoVP6D8T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BoVP6D8T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5DBC4CED1;
	Thu, 13 Feb 2025 15:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459356;
	bh=A14zxewLCT8qoTJH2Q/WDe4oI/S3GUKz+TphIifGtqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BoVP6D8TC762b/wQ4bfJUVyCwXAVV4rwI2HwmP8KKLLnljsU8m8LVeTJ55SuG3I1F
	 8HrPm2ffNopklTszjYjtmJblxm52bvD8R+e5o8OlGY4NI+Q1bVfvAnGlX84m4jR0Z+
	 dv4lT4s1Nb/63ilekEqYVOnBkxVj6zHvBg1GGHjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rafael Buchbinder <rafi@rbk.io>,
	Eyal Birger <eyal.birger@gmail.com>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 6.13 209/443] seccomp: passthrough uretprobe systemcall without filtering
Date: Thu, 13 Feb 2025 15:26:14 +0100
Message-ID: <20250213142448.682728790@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eyal Birger <eyal.birger@gmail.com>

commit cf6cb56ef24410fb5308f9655087f1eddf4452e6 upstream.

When attaching uretprobes to processes running inside docker, the attached
process is segfaulted when encountering the retprobe.

The reason is that now that uretprobe is a system call the default seccomp
filters in docker block it as they only allow a specific set of known
syscalls. This is true for other userspace applications which use seccomp
to control their syscall surface.

Since uretprobe is a "kernel implementation detail" system call which is
not used by userspace application code directly, it is impractical and
there's very little point in forcing all userspace applications to
explicitly allow it in order to avoid crashing tracked processes.

Pass this systemcall through seccomp without depending on configuration.

Note: uretprobe is currently only x86_64 and isn't expected to ever be
supported in i386.

Fixes: ff474a78cef5 ("uprobe: Add uretprobe syscall to speed up return probe")
Reported-by: Rafael Buchbinder <rafi@rbk.io>
Closes: https://lore.kernel.org/lkml/CAHsH6Gs3Eh8DFU0wq58c_LF8A4_+o6z456J7BidmcVY2AqOnHQ@mail.gmail.com/
Link: https://lore.kernel.org/lkml/20250121182939.33d05470@gandalf.local.home/T/#me2676c378eff2d6a33f3054fed4a5f3afa64e65b
Link: https://lore.kernel.org/lkml/20250128145806.1849977-1-eyal.birger@gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
Link: https://lore.kernel.org/r/20250202162921.335813-2-eyal.birger@gmail.com
[kees: minimized changes for easier backporting, tweaked commit log]
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/seccomp.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -749,6 +749,15 @@ static bool seccomp_is_const_allow(struc
 	if (WARN_ON_ONCE(!fprog))
 		return false;
 
+	/* Our single exception to filtering. */
+#ifdef __NR_uretprobe
+#ifdef SECCOMP_ARCH_COMPAT
+	if (sd->arch == SECCOMP_ARCH_NATIVE)
+#endif
+		if (sd->nr == __NR_uretprobe)
+			return true;
+#endif
+
 	for (pc = 0; pc < fprog->len; pc++) {
 		struct sock_filter *insn = &fprog->filter[pc];
 		u16 code = insn->code;
@@ -1023,6 +1032,9 @@ static inline void seccomp_log(unsigned
  */
 static const int mode1_syscalls[] = {
 	__NR_seccomp_read, __NR_seccomp_write, __NR_seccomp_exit, __NR_seccomp_sigreturn,
+#ifdef __NR_uretprobe
+	__NR_uretprobe,
+#endif
 	-1, /* negative terminated */
 };
 


