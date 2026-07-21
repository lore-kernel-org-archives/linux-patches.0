Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB8246AA73;
	Tue, 21 Jul 2026 15:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648085; cv=none; b=dsqCAPVp2GsW7qybx0jAe0RZ5QOAsJPlBxGUBudpYRQOz7Raei7YpQ5Aj2AYG2ftkPbwrVoDC34H1QhRAFd60oztWQ3xUss1wfcU+JCtnuxYC0CZrOy2ag0T/4sPJnXFlFO+t/9oIzIg5Pv3XU2V3izomMDKtxesKOjfohF1Cqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648085; c=relaxed/simple;
	bh=2IQyqZgCg8G4nISLc1EOARU1zSm+xdoxyuoxRjUxzgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsMsouAHzN0QjOo8Ts6u7aBzAVnR5IwMjW1o4+0vBCv8v+9pcAI1rjfrTRfs3VzmL1008/7rLuVf9EN/OTCAz3xeSpzA9Yt8f4ImXZ6sxEtr/ECqcWy6bA31BptPviB36IFd1/7gXXWhonr6WVPep1VMB0vIZk4gbQdHu6giBpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S2iLp6Dc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S2iLp6Dc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9921E1F00A3A;
	Tue, 21 Jul 2026 15:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648084;
	bh=jbHXPvTZPLipXoiHjh/E+cLkr7oVFiZOhDDeTTQQ+2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S2iLp6Dcmc4u9vjxj7d6lQvXfXMiAoI/KWMjyKRuhPG78QpDeuDykDMoeGSgBw/ri
	 kTqZtbIreia+4MFnHwg9OlUUWv56fV3Nqq2bLsPDqieFLH6XED46ocQjTi7OyISSTX
	 qOVJe6GHchy9DiX1XwpEkMBFgUtCZHPS/1Wh1uUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Tomlin <atomlin@atomlin.com>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0065/2077] libbpf: Report error when a negative kprobe offset is specified
Date: Tue, 21 Jul 2026 16:55:38 +0200
Message-ID: <20260721152554.227239365@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Tomlin <atomlin@atomlin.com>

[ Upstream commit ad35d8018669fd2eea76e3f74eb050fd3d2fb690 ]

In attach_kprobe(), the parsing logic uses sscanf() to extract the
target function name and offset from the section definition. Currently,
if a user specifies a negative offset (e.g., SEC("kprobe/func+-100")),
the input is not explicitly caught and reported as an error.

This commit updates the logic to explicitly notify the user when a
negative integer is provided. To facilitate this check, the offset
variable is changed from unsigned long to long so that sscanf()
can accurately capture a negative input for evaluation.

If a negative offset is detected, the loader will now print an
informative warning stating that the offset must be non-negative,
and return -EINVAL.

Additionally, free(func) is called in this new error path to prevent
a memory leak, as the function name string is dynamically allocated
by sscanf().

Fixes: e3f9bc35ea7e9 ("libbpf: Allow decimal offset for kprobes")
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
Acked-by: Mykyta Yatsenko <yatsenko@meta.com>
Link: https://lore.kernel.org/bpf/20260419030944.1423642-1-atomlin@atomlin.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 3a80a018fc7d50..83aae7a39d36de 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -12280,7 +12280,7 @@ bpf_program__attach_kprobe_multi_opts(const struct bpf_program *prog,
 static int attach_kprobe(const struct bpf_program *prog, long cookie, struct bpf_link **link)
 {
 	DECLARE_LIBBPF_OPTS(bpf_kprobe_opts, opts);
-	unsigned long offset = 0;
+	long offset = 0;
 	const char *func_name;
 	char *func;
 	int n;
@@ -12302,6 +12302,13 @@ static int attach_kprobe(const struct bpf_program *prog, long cookie, struct bpf
 		pr_warn("kprobe name is invalid: %s\n", func_name);
 		return -EINVAL;
 	}
+
+	if (offset < 0) {
+		free(func);
+		pr_warn("kprobe offset must be a non-negative integer: %li\n", offset);
+		return -EINVAL;
+	}
+
 	if (opts.retprobe && offset != 0) {
 		free(func);
 		pr_warn("kretprobes do not support offset specification\n");
-- 
2.53.0



