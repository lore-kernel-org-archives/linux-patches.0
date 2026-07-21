Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF288326D44;
	Tue, 21 Jul 2026 17:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655598; cv=none; b=bywJ6CzxpMtTbeh5QtJiblqRH0y6IPE4fjE6q/ZGnALw4t8kvjpt2am16EEbWY5dYXIzVmvPFuOg63Yche2vf3SRaFB1Shih/gbNK8zEnNme5WDeT9dHJ/D99MqXfZO5eZRiuKIAKprudbngNnK3f1szeVbaecF44XQi6qDFlP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655598; c=relaxed/simple;
	bh=O1eUXmgxfhaKP5jA5jrtb62JMFRZgXRJ9VUi/DxWJ7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WkCiLpWrBg2oQdrAdLGZjOLXQ7FUkliOacMpJgnFHMi7FMd59F6T72Ji4mIIRWZ25CadCYYUuFEzdv4Y0yP8ssmH6KIHAZQPK/L1XzUH8RDeCu+oo1xxiEzwMlwIJaVWR0obE7zwcT9qUGwwsgA+bTGHOXwJlrN6P77nTcGGdcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJXZDd6P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJXZDd6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4231F000E9;
	Tue, 21 Jul 2026 17:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655596;
	bh=JE5FqrGlowpkW/Q/sXLlt9qtjMTBloMqCnUph3Tv3Lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cJXZDd6P+6LpPw0rsAWBqbnkQPqvLctWdhvk+AcGVCjKCvGe0dHw4d11mZp0HvQZ9
	 uLzD5Fr4azDnfNwnPlBoG6KgrtkZKgpX2pU34Ym2Q8Jke5Q4BW7/pL2jOrX2FgAbaZ
	 fnSoFvbDych4VtVkEwo8w0tWktglKAzf3vzojgmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Tomlin <atomlin@atomlin.com>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0069/1611] libbpf: Report error when a negative kprobe offset is specified
Date: Tue, 21 Jul 2026 17:03:05 +0200
Message-ID: <20260721152516.387913421@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 84b6fb47a2f79d..3baa6025ecba04 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -11826,7 +11826,7 @@ bpf_program__attach_kprobe_multi_opts(const struct bpf_program *prog,
 static int attach_kprobe(const struct bpf_program *prog, long cookie, struct bpf_link **link)
 {
 	DECLARE_LIBBPF_OPTS(bpf_kprobe_opts, opts);
-	unsigned long offset = 0;
+	long offset = 0;
 	const char *func_name;
 	char *func;
 	int n;
@@ -11848,6 +11848,13 @@ static int attach_kprobe(const struct bpf_program *prog, long cookie, struct bpf
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



