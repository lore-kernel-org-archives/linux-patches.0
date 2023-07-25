Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0D115ACF
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2704C433C8;
	Tue, 25 Jul 2023 10:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282396;
	bh=KK4AJoIaLPPm3zQMlhPjAJ75YEDERv0cDA6Wgc4knj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=neJH+HnjAQZXfxg7+G0a3YImwbSg39hyxhle6gjmcrOjQHQMj7pJsMwRvlwndyy6x
	 lsF5EOnKJA0biIF5sJnJwDYYGJsoxaPTzucuTUP9/wmigNaMN7pfBkgeN1Pmv5yOU9
	 OfvX7a82MsnLVKKO4JyjsdSsScOKeqG31jh0aF+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8b2a08dfbd25fd933d75@syzkaller.appspotmail.com,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 114/227] bpf: drop unnecessary user-triggerable WARN_ONCE in verifierl log
Date: Tue, 25 Jul 2023 12:44:41 +0200
Message-ID: <20230725104519.493722641@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit cff36398bd4c7d322d424433db437f3c3391c491 ]

It's trivial for user to trigger "verifier log line truncated" warning,
as verifier has a fixed-sized buffer of 1024 bytes (as of now), and there are at
least two pieces of user-provided information that can be output through
this buffer, and both can be arbitrarily sized by user:
  - BTF names;
  - BTF.ext source code lines strings.

Verifier log buffer should be properly sized for typical verifier state
output. But it's sort-of expected that this buffer won't be long enough
in some circumstances. So let's drop the check. In any case code will
work correctly, at worst truncating a part of a single line output.

Reported-by: syzbot+8b2a08dfbd25fd933d75@syzkaller.appspotmail.com
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20230516180409.3549088-1-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/log.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/bpf/log.c b/kernel/bpf/log.c
index 046ddff37a76d..850494423530e 100644
--- a/kernel/bpf/log.c
+++ b/kernel/bpf/log.c
@@ -62,9 +62,6 @@ void bpf_verifier_vlog(struct bpf_verifier_log *log, const char *fmt,
 
 	n = vscnprintf(log->kbuf, BPF_VERIFIER_TMP_LOG_SIZE, fmt, args);
 
-	WARN_ONCE(n >= BPF_VERIFIER_TMP_LOG_SIZE - 1,
-		  "verifier log line truncated - local buffer too short\n");
-
 	if (log->level == BPF_LOG_KERNEL) {
 		bool newline = n > 0 && log->kbuf[n - 1] == '\n';
 
-- 
2.39.2



