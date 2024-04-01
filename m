Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AFD0383BA;
	Mon,  1 Apr 2024 16:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987462; cv=none; b=rGTW99NtHDiRsanDfJM35AqbLXFnrvT9J3h1qfxKm0pxYpsv6yI1Xc233jv7Xb2XNvlkvZyggxwJbUXO60JsFIJ/MvUFdV5PFxfrxTCW9hmMkqawFws7/l8RVDeI/5IdoUuOZOwC+x9Z2TdVyTeqU2Q9sC8SK/LnUb5SV1sIHPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987462; c=relaxed/simple;
	bh=8fWAN33YEh6crzDThWBAzslX6hfzpMwqQGRn+PFtcl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JpCsn+K7cpaJ8VH28wrYYpulYFtdoS/YUyj+ZNSZTAswqlVEl+sPuHaqxv6DST9zciR70MGN5EpvYg3OqdYtEYhbC7qMl1tW0SHhVWSEpLt/tc+ih91obSuzJz1IJXZlG4wr4lfukox8HXEx+Nxz8arKST3+Nz8PY5TqXCFeXVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r6rupiWV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r6rupiWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DFFEC433C7;
	Mon,  1 Apr 2024 16:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987462;
	bh=8fWAN33YEh6crzDThWBAzslX6hfzpMwqQGRn+PFtcl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r6rupiWVfGOG0bGCDEjmLlevjw2LQABFDMobDpeT38xa+U9Hh9Hm6WY3Migb+PQrF
	 /MhJLyLjK33BgWpHYq/Di00X8diuUsAusMUrLXFVKiyviJvuvOmAyQ9uLHZS7cWcho
	 6grEu5tRKJOIEfzXE5tDb8l4b3Hyp/MS4zuJT7hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Zhang <zzqq0103.hey@gmail.com>,
	Jinghao Jia <jinghao7@illinois.edu>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 266/399] kprobes/x86: Use copy_from_kernel_nofault() to read from unsafe address
Date: Mon,  1 Apr 2024 17:43:52 +0200
Message-ID: <20240401152557.127534698@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 4e51653d5d871f40f1bd5cf95cc7f2d8b33d063b ]

Read from an unsafe address with copy_from_kernel_nofault() in
arch_adjust_kprobe_addr() because this function is used before checking
the address is in text or not. Syzcaller bot found a bug and reported
the case if user specifies inaccessible data area,
arch_adjust_kprobe_addr() will cause a kernel panic.

[ mingo: Clarified the comment. ]

Fixes: cc66bb914578 ("x86/ibt,kprobes: Cure sym+0 equals fentry woes")
Reported-by: Qiang Zhang <zzqq0103.hey@gmail.com>
Tested-by: Jinghao Jia <jinghao7@illinois.edu>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/171042945004.154897.2221804961882915806.stgit@devnote2
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/kprobes/core.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index a0ce46c0a2d88..a6a3475e1d609 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -335,7 +335,16 @@ static int can_probe(unsigned long paddr)
 kprobe_opcode_t *arch_adjust_kprobe_addr(unsigned long addr, unsigned long offset,
 					 bool *on_func_entry)
 {
-	if (is_endbr(*(u32 *)addr)) {
+	u32 insn;
+
+	/*
+	 * Since 'addr' is not guaranteed to be safe to access, use
+	 * copy_from_kernel_nofault() to read the instruction:
+	 */
+	if (copy_from_kernel_nofault(&insn, (void *)addr, sizeof(u32)))
+		return NULL;
+
+	if (is_endbr(insn)) {
 		*on_func_entry = !offset || offset == 4;
 		if (*on_func_entry)
 			offset = 4;
-- 
2.43.0



