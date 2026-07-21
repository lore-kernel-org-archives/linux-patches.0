Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B080333ADB0;
	Tue, 21 Jul 2026 19:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661434; cv=none; b=isCThTL2KwutItDZPWyQjNgnDoHCbf6t1NrXp6NaVihGZVf/Ur1PVTr8vxuDlnaP0ZTRivieB77q4lfy2/VgLx4KE4rFPGoWxQWEpvqLwPmHyyiuUHD3zp2enYj1dd0Ozd8lzxT4BhWW+9iSZ6AUvOAsanD3Ff+FsQwT6GUIEJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661434; c=relaxed/simple;
	bh=Kc9/NI0IXFGnqJI4zVUrEmPC7oFTpyEtrvifXRFZrqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cR99G5LqitvVFtl6XoibkU/ucrA0E4KRRTVfzZQEQ2nlcUX1xLrMs5AN9Q3r4ay9m9fkxO0YVby8LLBI66KewtvmSCLdny7EE54WJcMUuzdFRZX5PyXC9taarbNz/d3lwiZaBMaaQRyVO/sZWw2J9SLh8pGfXuwKPYkRsFgb5zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nFsaIeSr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nFsaIeSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2201D1F000E9;
	Tue, 21 Jul 2026 19:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661433;
	bh=oiQGEhJvCeY9P0pIPqQSEXNHBAeIhNWBC3cJjEKAmhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nFsaIeSrkOZMNDGJqolHCTVOuXQfK9ch6NlsncaHNEZ+c8WA+ePa5khexhZvZFwMa
	 psN+VIgsp08HEOnhXf10oqyAHkH80Oc+bMDKSYqvhABY1HMq18btAxSQbTSSqQw/UD
	 q1P4lDlTo/ghaPCL8XdjsIVw7iOpQTJMqAXyx3jY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Tomlin <atomlin@atomlin.com>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0065/1276] libbpf: Report error when a negative kprobe offset is specified
Date: Tue, 21 Jul 2026 17:08:28 +0200
Message-ID: <20260721152447.542280638@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 7d496f0a9a30d1..9bbf7a3b87de7b 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -11626,7 +11626,7 @@ bpf_program__attach_kprobe_multi_opts(const struct bpf_program *prog,
 static int attach_kprobe(const struct bpf_program *prog, long cookie, struct bpf_link **link)
 {
 	DECLARE_LIBBPF_OPTS(bpf_kprobe_opts, opts);
-	unsigned long offset = 0;
+	long offset = 0;
 	const char *func_name;
 	char *func;
 	int n;
@@ -11648,6 +11648,13 @@ static int attach_kprobe(const struct bpf_program *prog, long cookie, struct bpf
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



