Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C0D334692;
	Tue, 13 Oct 2026 12:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895457; cv=none; b=UEYiORJvtX6yXfcRMmwE/yuaKygNK/WkULlx7px+HFP3YYeqeTz/4hBrlXlQQGn+B+6LT47aeB83py3EQ/cmQbS1buvk5zr52cyIg3m5ZTNNmOAdry/YdglOHWx1Zc+pqggS7lrJRgAXChU1j/qsrZgrIA9QXovJdlJrHIsW9fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895457; c=relaxed/simple;
	bh=pzGcWJyeJmFRoUaeTvQ1RU+zOjRXX6/T7A3k23q6CAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qjg+Fqmq7XluynHV2in2iqPWQE3MhJdl+kTIZ/wMD9RUAoBIhsIPkIsvsqu9tKnCgmVQp38HZ1fpj9SL3AL6LxQaNc/iJwrEnh3LmuvW1xBFX7VKdyKKGdYj6t7sKc0whZOfo1Ap22Jj+M/SXirMliv1zDhzEBRgXtx4pEv5SsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0er54iH2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0er54iH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC881F000FF;
	Tue, 13 Oct 2026 12:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895456;
	bh=9AUbWiSj5W1eLVRXnJeXgcD3n9JmlvZ2C/fHjWtochU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0er54iH2sSto1aymIWKIK/wXZgZKzMadVNsMfg3mli3KThKvHK91phjV9xtwnDIdQ
	 dpm+W6yiHTCatnjaqmDxkBPvDXK5M+Uys6DG7IK7OAynZ8rDynzblq3O64ox5LO9Tx
	 u0yCTxW2ftzVb4gdKQCVP/MZ3FxMPlHW8vYFI2Bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 282/497] perf: Require kernel access for text poke events
Date: Tue, 13 Oct 2026 13:37:29 +0200
Message-ID: <20261013112914.587252288@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhengchuan Liang <zcliangcn@gmail.com>

[ Upstream commit 357e8a77a501d96c9517f01f4a211eed5e9c9184 ]

Perf events with exclude_kernel=1 can be opened without kernel perf
access. However, exclude_kernel does not suppress text-poke sideband
records. Every PERF_RECORD_TEXT_POKE is marked PERF_RECORD_MISC_KERNEL
and contains a raw kernel instruction address.

An unprivileged task can therefore open and mmap a task-local software
event with text_poke=1. Both opening a count-only tracepoint event and
configuring UDP GRO for ESP-in-UDP cause updates to inline static calls;
the observer receives the relocated addresses of the modified instructions.
For a known kernel image, any such address reveals the runtime kernel
text base despite KASLR.

Call perf_allow_kernel() whenever attr.text_poke is set, regardless of
exclude_kernel. Events that neither monitor kernel execution nor request
text-poke records retain their existing permissions.

Fixes: e17d43b93e54 ("perf: Add perf text poke event")
Assisted-by: LLM
Signed-off-by: Zhengchuan Liang <zcliangcn@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/99131354c41e23188f778b92f90363775b482395.1790573390.git.zcliangcn@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 3791c84ffe2cf..41f05c932e15b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12893,7 +12893,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (err)
 		return err;
 
-	if (!attr.exclude_kernel ||
+	if (!attr.exclude_kernel || attr.text_poke ||
 	    ((attr.sample_type & PERF_SAMPLE_CALLCHAIN) &&
 	     !attr.exclude_callchain_kernel)) {
 		err = perf_allow_kernel();
-- 
2.53.0



