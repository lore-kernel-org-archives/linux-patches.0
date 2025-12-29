Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B033E2222CB;
	Mon, 29 Dec 2025 16:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025327; cv=none; b=cIljUPXzQaISzZ/rlHkcz7KdzuYbu9P6F8BGhR5mbfUGPjnSOK+3C6NFVZ1fnNd5Mzb0k/ON6zA+VqexoSy8BX0JVDkO6GsuDbm8VCWdCTb8RKSdDGIvZH9Wkb1zbBZ4m5+WdIFWa0c/WjNctSqanprq03s/EXkIHJqPdd7bFC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025327; c=relaxed/simple;
	bh=DF0FeAo3wYFF3pu4koczl8auHu371tUu1KT86bfLEaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lETckAnQyWSLZbFDJApFfjF0LlRgDTL6d/vdcXa+06mulriWLbsNqSGzk6YD9ELxJqOFf+zYYwTptxB0yCMoACRqZlIJa92hym295BhSN/K7Hy0xlU5qGjGYkC4cT8qFkJ2dxvnLpoIorEbne4QBpnLu+W6cfXU2HubSsfmCoTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Psbj5vA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Psbj5vA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA345C4CEF7;
	Mon, 29 Dec 2025 16:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025324;
	bh=DF0FeAo3wYFF3pu4koczl8auHu371tUu1KT86bfLEaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Psbj5vAowwknm0m2HcNLLCYL0mdHkds5JB0ZRjAN02VMQ6qkC128k9b4IDiyH4/i
	 RXHISILrap5x6iuec3CAGo5H1cfQ9ssyIPxhMgQnvI2rucyTbw12nS2KyhFWOVimA9
	 XqPQSDetpUR2fG+4D5wO24Hv0aNnPdIkSVdSELB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongxin Liu <yongxin.liu@windriver.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 166/430] x86/fpu: Fix FPU state core dump truncation on CPUs with no extended xfeatures
Date: Mon, 29 Dec 2025 17:09:28 +0100
Message-ID: <20251229160730.472646370@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongxin Liu <yongxin.liu@windriver.com>

[ Upstream commit c8161e5304abb26e6c0bec6efc947992500fa6c5 ]

Zero can be a valid value of num_records. For example, on Intel Atom x6425RE,
only x87 and SSE are supported (features 0, 1), and fpu_user_cfg.max_features
is 3. The for_each_extended_xfeature() loop only iterates feature 2, which is
not enabled, so num_records = 0. This is valid and should not cause core dump
failure.

The issue is that dump_xsave_layout_desc() returns 0 for both genuine errors
(dump_emit() failure) and valid cases (no extended features). Use negative
return values for errors and only abort on genuine failures.

Fixes: ba386777a30b ("x86/elf: Add a new FPU buffer layout info to x86 core files")
Signed-off-by: Yongxin Liu <yongxin.liu@windriver.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://patch.msgid.link/20251210000219.4094353-2-yongxin.liu@windriver.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/fpu/xstate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 28e4fd65c9da..5f54a207ace4 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1945,7 +1945,7 @@ static int dump_xsave_layout_desc(struct coredump_params *cprm)
 		};
 
 		if (!dump_emit(cprm, &xc, sizeof(xc)))
-			return 0;
+			return -1;
 
 		num_records++;
 	}
@@ -1983,7 +1983,7 @@ int elf_coredump_extra_notes_write(struct coredump_params *cprm)
 		return 1;
 
 	num_records = dump_xsave_layout_desc(cprm);
-	if (!num_records)
+	if (num_records < 0)
 		return 1;
 
 	/* Total size should be equal to the number of records */
-- 
2.51.0



