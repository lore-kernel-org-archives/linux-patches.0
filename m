Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F56F3A7F41;
	Sat, 17 Oct 2026 17:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256883; cv=none; b=g/SWqwRBsWjs9rEGuYFHEIcFaqgjj0jSuf5omEH0ViPYqPSawTCTL1u98MgCn0059gYJHqC8eW+VdRB5wgwrIYQRNlj+vDRpe5IgkZ8xvpoSR9oPinM5/YpHm0ilNysmD5MKLQoP/jAKjr9bwtVAreLtn8m7NqVFDpyRNeChfs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256883; c=relaxed/simple;
	bh=IczpOUAQcWuIbdsoC+0I+fz6hOyDfhh+mjxBU7Q7rgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2SWOL+e8o37Umt8VqqM6dXdCF2pPy02nJS5ABbJnRbQPzKI2LgoBX59wMhskkl2696WgCIVUVljv1/zf9QBcY3frsSSDy2q1+D76Huyor62qZHpyEP/0txfc8FxIINfMGINdASOgbdRQiSrX8vIzXJ33suvkQIGDgtA3YBlpvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=glktVYvB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="glktVYvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC4D1F000C4;
	Sat, 17 Oct 2026 17:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256882;
	bh=thLAaCLkj0ZQ0U0XGiq8nh3IiTojMvMahze4LntiSjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=glktVYvBpuHj702tjszsQn4DIN2wCnTzzynVVex0hDIeFCIw+NGybNwDraI4tlqg5
	 tLqOeLbGcYZ/rDzSVyTuwh4y79/l0oKQefamzgVWQLJgY26yS1YzpLFLaANCYBsIhC
	 jpKa8/zvO8CM81kwfb7hV+MzPgy+q5dA7n1vE6XA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0380/1674] perf: Require kernel access for text poke events
Date: Sat, 17 Oct 2026 17:44:12 +0200
Message-ID: <20261017160440.869029538@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted context for the missing kernel-callchain condition while retaining perf_allow_kernel(&attr). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index a986ed1ad221a..3169742fd98ad 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12647,7 +12647,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (err)
 		return err;
 
-	if (!attr.exclude_kernel) {
+	if (!attr.exclude_kernel || attr.text_poke) {
 		err = perf_allow_kernel(&attr);
 		if (err)
 			return err;
-- 
2.53.0



