Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33EC44AB6A;
	Tue, 21 Jul 2026 21:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668889; cv=none; b=daJT7j4HGHzcF4ucEUVeM5OdRdCtpwnZdOm1xrEJuezf0to8iW0JgoSZDV63X6NKz8SbfjkcOXdW6pZsqHHxBaaMpgrVIzPI95QNMRgEq0YA0VUuo7CKCd/ePUFNE2Qn1KDkQ2Z6DE2hh4WNpaEHffFyNaWXKnqBufMnOaRchEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668889; c=relaxed/simple;
	bh=7IOU7h4KISYBovauBmoLFiI05pQewldCOgbxx1PiRyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qsx/VaK4q+eZNfPOFwTgpliQ6LFi/HUFBFBcACHhsqdoMHKWbeA/zMpK3WLjSnaBgSIuuU4hiMIjB7LMqTonDqOEc9GPFVNF74Z6kxEBpr7f03M6324uRu1AosIClg/zk6Hg0loTHW1AqwOPBEq0f36tgNZrzlF4CRFCQwtOr5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rYR0mBXv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rYR0mBXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06EB1F00A3A;
	Tue, 21 Jul 2026 21:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668887;
	bh=oOCnCTNlKiB4Qf83fbb6ExX4w9iG/hdQXw1PAvwcylU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rYR0mBXvIsXoNRBpKM63K3YUjb5P9LLeg/pMBBjJ89MqDhEJQ0BYXVl/tTfhmdiyP
	 2NyGMC99PxIlI7yblt2bzKKgLY9Gv6ZrWoyt8Gwy+XkGBq0D9EDeX8K+Odjc70M03d
	 6mTVxycHxVmEw9IBkrNq14X4xHen5eynDklkOfn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0347/1067] libbpf: Harden parse_vma_segs() path parsing
Date: Tue, 21 Jul 2026 17:15:48 +0200
Message-ID: <20260721152432.361155889@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit fee9a38174f4c6454fb1fbaf2b9b5a1cca9070d0 ]

parse_vma_segs() in tools/lib/bpf/usdt.c parses /proc/<pid>/maps
with two widthless scansets, "%s" into mode[16] and "%[^\n]"
into line[4096]. A VMA name in maps is not limited to that local
buffer; a deeply nested backing path can produce a maps record long
enough to overflow the stack buffer.

Bound both scansets to the declared buffer sizes ("%15s" for mode[16]
and "%4095[^\n]" for line[4096]) and drain any residue past line[4094]
with "%*[^\n]" before the trailing "\n". Without the drain, the residue
of an over-long record would stay in the stream and break the next
"%zx-%zx" parse, so the loop would exit early and silently skip later
maps records.

Also stop using sscanf(..., "%s") to peel the /proc/<pid>/root prefix
from lib_path. Parse the pid and prefix length with "%n", check for the
following slash, and copy the remainder with libbpf_strlcpy(). That
removes a second unbounded stack write and preserves paths containing
spaces.

Fixes: 74cc6311cec9 ("libbpf: Add USDT notes parsing and resolution logic")
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/bpf/20260522201353.1454653-1-michael.bommarito@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/usdt.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/usdt.c b/tools/lib/bpf/usdt.c
index b8e83712a5d724..28b0042a524ad4 100644
--- a/tools/lib/bpf/usdt.c
+++ b/tools/lib/bpf/usdt.c
@@ -443,10 +443,10 @@ static int parse_elf_segs(Elf *elf, const char *path, struct elf_seg **segs, siz
 
 static int parse_vma_segs(int pid, const char *lib_path, struct elf_seg **segs, size_t *seg_cnt)
 {
-	char path[PATH_MAX], line[PATH_MAX], mode[16];
+	char path[PATH_MAX], line[4096], mode[16];
 	size_t seg_start, seg_end, seg_off;
 	struct elf_seg *seg;
-	int tmp_pid, i, err;
+	int tmp_pid, n, i, err;
 	FILE *f;
 
 	*seg_cnt = 0;
@@ -455,8 +455,13 @@ static int parse_vma_segs(int pid, const char *lib_path, struct elf_seg **segs,
 	 * /proc/<pid>/root/<path>. They will be reported as just /<path> in
 	 * /proc/<pid>/maps.
 	 */
-	if (sscanf(lib_path, "/proc/%d/root%s", &tmp_pid, path) == 2 && pid == tmp_pid)
+	/* %n is not counted in sscanf() return value, so initialize it. */
+	n = 0;
+	if (sscanf(lib_path, "/proc/%d/root%n", &tmp_pid, &n) == 1 &&
+	    n > 0 && pid == tmp_pid && lib_path[n] == '/') {
+		libbpf_strlcpy(path, lib_path + n, sizeof(path));
 		goto proceed;
+	}
 
 	if (!realpath(lib_path, path)) {
 		pr_warn("usdt: failed to get absolute path of '%s' (err %d), using path as is...\n",
@@ -479,8 +484,11 @@ static int parse_vma_segs(int pid, const char *lib_path, struct elf_seg **segs,
 	 * 7f5c6f5d1000-7f5c6f5d3000 rw-p 001c7000 08:04 21238613      /usr/lib64/libc-2.17.so
 	 * 7f5c6f5d3000-7f5c6f5d8000 rw-p 00000000 00:00 0
 	 * 7f5c6f5d8000-7f5c6f5d9000 r-xp 00000000 103:01 362990598    /data/users/andriin/linux/tools/bpf/usdt/libhello_usdt.so
+	 *
+	 * Some VMA names can be longer than the local buffer. Bound the
+	 * writes, but still consume the rest of the line.
 	 */
-	while (fscanf(f, "%zx-%zx %s %zx %*s %*d%[^\n]\n",
+	while (fscanf(f, "%zx-%zx %15s %zx %*s %*d%4095[^\n]%*[^\n]\n",
 		      &seg_start, &seg_end, mode, &seg_off, line) == 5) {
 		void *tmp;
 
-- 
2.53.0



