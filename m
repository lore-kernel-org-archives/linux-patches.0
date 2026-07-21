Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B13E46D088;
	Tue, 21 Jul 2026 17:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656085; cv=none; b=cyqbVsW5qv7LhF2BWEopGI4g5713hP0ul1+zwsrTSoKNWyEw8f29+9CTds+ymqyG1WwqR00AEl67nfRzaZCPJT6zVUrl+TSnJQLZ98GVIIiqMaHD2+itWQpQIxt2BxaHq5qZ5NcZlbS5RprjlSPyclB89JVR4JfCHfSrXBZFCEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656085; c=relaxed/simple;
	bh=7G04rZNwHy/heUNGzSpEDhQk4YMVEQTzi766h51kSgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evKW2Jb/yuMtIrUtLnKvq9sALIWrHmpwy3DzrmfHhByEz9zXB7+HS169odLYSUjcHvZ9BRmrsIwGsHhhBGhPuz+wL5z6CdD1qW8sOHP7nWKJO8CHPCNuT8USGjJPXZ68B/+O6/JHugLp4r1w5dmH8ANbFzvthOtOEqpYG4Qb2h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlVsZZA8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlVsZZA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9107E1F00A3D;
	Tue, 21 Jul 2026 17:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656080;
	bh=W1K1qH026qTnBeYGLjW6TL2w5Od2Mt8JTFYtaWCbeEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vlVsZZA8Bkj+lxbxMeBZ4QOj2NNOggCpEz9gWysdB7vkZ9jcQmZtN89da14u8nBcX
	 bn1nX9VmaIy376KWwpaX9MNcC0qQ+3KltqDg/FNoTPqVxiCeBiBFq//h3YwWV1reqI
	 23qJdVf1Nl2Ng6ZmGpejNSoRZOiUhlfZP2whayyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0253/1611] libbpf: Harden parse_vma_segs() path parsing
Date: Tue, 21 Jul 2026 17:06:09 +0200
Message-ID: <20260721152520.730658578@linuxfoundation.org>
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
index c174b40866738a..63d628029ad4ea 100644
--- a/tools/lib/bpf/usdt.c
+++ b/tools/lib/bpf/usdt.c
@@ -460,10 +460,10 @@ static int parse_elf_segs(Elf *elf, const char *path, struct elf_seg **segs, siz
 
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
@@ -472,8 +472,13 @@ static int parse_vma_segs(int pid, const char *lib_path, struct elf_seg **segs,
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
 		pr_warn("usdt: failed to get absolute path of '%s' (err %s), using path as is...\n",
@@ -496,8 +501,11 @@ static int parse_vma_segs(int pid, const char *lib_path, struct elf_seg **segs,
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



