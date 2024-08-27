Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3011C688E;
	Tue, 27 Aug 2024 15:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771952; cv=none; b=qEkeXMue0ERe4DhlSuNrhTcQWHUyQDAJHTxyvXKZjasARaeI/SYcH5j1keYL5jENQiYI3BPaePuQYuBXMe49R273r7xBSrUyJ0qk069tZYXcEycbe6Nyjf1O8oCxlm7tgWfld9vhK0S3ltADju8jn05cEdrEoWTJCT2eC6imCNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771952; c=relaxed/simple;
	bh=EtnsMetHgYP7vZeliFDknJiff2twx3mveX2PCR9Q2h0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOu6RAFVkVVeZyCcA2EolWJZwGK/tnpu9KLNem3DrmihjyVfxRpSwgEuxMDos3gzt9Vl7rubZhhe031UMmxZSEf47sK6+KygTHpN42yo1tC+hcvWLIkJVxuUoSUXxJYVFQlgJEHChAtBwReRVLBE5d/i/tbYjmnXoZ1WffU80eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A8ozKVna; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A8ozKVna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE82C61067;
	Tue, 27 Aug 2024 15:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771952;
	bh=EtnsMetHgYP7vZeliFDknJiff2twx3mveX2PCR9Q2h0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A8ozKVnapBb62xU0HKi97EVqyc6mUUFq8KC6X/0WC27YOn/fC146Y6bbr/luKcqIW
	 JmwldmE+9JkYx1HGDkQcr5TQkJpUuoF7OJpzdvxbUo0XI4CT8cre3Rgbb1rVYIUBN/
	 hbm+m46ceWkPsVt12nOSvsdN5J+yOmFfGUMtaAec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8b2a08dfbd25fd933d75@syzkaller.appspotmail.com,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/321] bpf: drop unnecessary user-triggerable WARN_ONCE in verifierl log
Date: Tue, 27 Aug 2024 16:35:47 +0200
Message-ID: <20240827143839.713603791@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 920061e38d2e1..cd1b7113fbfd0 100644
--- a/kernel/bpf/log.c
+++ b/kernel/bpf/log.c
@@ -22,9 +22,6 @@ void bpf_verifier_vlog(struct bpf_verifier_log *log, const char *fmt,
 
 	n = vscnprintf(log->kbuf, BPF_VERIFIER_TMP_LOG_SIZE, fmt, args);
 
-	WARN_ONCE(n >= BPF_VERIFIER_TMP_LOG_SIZE - 1,
-		  "verifier log line truncated - local buffer too short\n");
-
 	if (log->level == BPF_LOG_KERNEL) {
 		bool newline = n > 0 && log->kbuf[n - 1] == '\n';
 
-- 
2.43.0



