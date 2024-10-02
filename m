Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40351D07AD;
	Wed,  2 Oct 2024 14:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877965; cv=none; b=snJSUBfR2dfHc3VKWWS79/baJHVYiELpqqvGAXTylFSn8PbIWnP3a8Wg7CfNWMKSEF1V8Q4zzNXuKCOa/trrMbekSUWe5jGAvnlCNTAZlVov7k/GFWwJXkwVBsb6U3JWZJv2JZNVlBa2Z0JOBtmzHeqaEMc4tI12B3dIoNU0CKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877965; c=relaxed/simple;
	bh=u6aHO6HVeFpfZ08qtkxbeQZzVMiNpbNS0GS/M30j2y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azWyLmeRu/DRdwXApINP9dkNctJ+TImC80Bathzio5e0Gsdmku3kz3rllG5bYItfg/zykP6VDU7I9UR9Ar9MueSQIvCSrl0HZRM4A2TAos7aOZ1ZZ6tWzpYYf60k/1bMhIKglEIzLdLpfmuJVhGnLqV5a+X52WqDQy7DfwGBkbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zzy3HH6w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zzy3HH6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39878C4CEC2;
	Wed,  2 Oct 2024 14:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877965;
	bh=u6aHO6HVeFpfZ08qtkxbeQZzVMiNpbNS0GS/M30j2y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zzy3HH6wzdCP4Xg7jh/Q9ktKYOfRDmk7V5mPnzzQFmBYvY5IcTFMX5piJ+z8HZAxJ
	 kSeJ0agwiGQhG18T9anmootjx9W/MaGkW30PzVE/B5uLf9BE3KDWF/qiWDAtoP4cJa
	 PqdLd5RmtNTnC3E56ajUKluuGhsJ/m15OdMQbBqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 255/634] selftests/bpf: Fix arg parsing in veristat, test_progs
Date: Wed,  2 Oct 2024 14:55:55 +0200
Message-ID: <20241002125821.163366667@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit 03bfcda1fbc37ef34aa21d2b9e09138335afc6ee ]

Current code parses arguments with strtok_r() using a construct like

    char *state = NULL;
    while ((next = strtok_r(state ? NULL : input, ",", &state))) {
        ...
    }

where logic assumes the 'state' var can distinguish between first and
subsequent strtok_r() calls, and adjusts parameters accordingly. However,
'state' is strictly internal context for strtok_r() and no such assumptions
are supported in the man page. Moreover, the exact behaviour of 'state'
depends on the libc implementation, making the above code fragile.

Indeed, invoking "./test_progs -t <test_name>" on mips64el/musl will hang,
with the above code in an infinite loop.

Similarly, we see strange behaviour running 'veristat' on mips64el/musl:

    $ ./veristat -e file,prog,verdict,insns -C two-ok add-failure
    Can't specify more than 9 stats

Rewrite code using a counter to distinguish between strtok_r() calls.

Fixes: 61ddff373ffa ("selftests/bpf: Improve by-name subtest selection logic in prog_tests")
Fixes: 394169b079b5 ("selftests/bpf: add comparison mode to veristat")
Fixes: c8bc5e050976 ("selftests/bpf: Add veristat tool for mass-verifying BPF object files")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/392d8bf5559f85fa37926c1494e62312ef252c3d.1722244708.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/testing_helpers.c | 4 ++--
 tools/testing/selftests/bpf/veristat.c        | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/testing_helpers.c b/tools/testing/selftests/bpf/testing_helpers.c
index d5379a0e6da80..4230420ef2940 100644
--- a/tools/testing/selftests/bpf/testing_helpers.c
+++ b/tools/testing/selftests/bpf/testing_helpers.c
@@ -220,13 +220,13 @@ int parse_test_list(const char *s,
 		    bool is_glob_pattern)
 {
 	char *input, *state = NULL, *test_spec;
-	int err = 0;
+	int err = 0, cnt = 0;
 
 	input = strdup(s);
 	if (!input)
 		return -ENOMEM;
 
-	while ((test_spec = strtok_r(state ? NULL : input, ",", &state))) {
+	while ((test_spec = strtok_r(cnt++ ? NULL : input, ",", &state))) {
 		err = insert_test(set, test_spec, is_glob_pattern);
 		if (err)
 			break;
diff --git a/tools/testing/selftests/bpf/veristat.c b/tools/testing/selftests/bpf/veristat.c
index b2854238d4a0e..fd9780082ff48 100644
--- a/tools/testing/selftests/bpf/veristat.c
+++ b/tools/testing/selftests/bpf/veristat.c
@@ -784,13 +784,13 @@ static int parse_stat(const char *stat_name, struct stat_specs *specs)
 static int parse_stats(const char *stats_str, struct stat_specs *specs)
 {
 	char *input, *state = NULL, *next;
-	int err;
+	int err, cnt = 0;
 
 	input = strdup(stats_str);
 	if (!input)
 		return -ENOMEM;
 
-	while ((next = strtok_r(state ? NULL : input, ",", &state))) {
+	while ((next = strtok_r(cnt++ ? NULL : input, ",", &state))) {
 		err = parse_stat(next, specs);
 		if (err) {
 			free(input);
@@ -1493,7 +1493,7 @@ static int parse_stats_csv(const char *filename, struct stat_specs *specs,
 	while (fgets(line, sizeof(line), f)) {
 		char *input = line, *state = NULL, *next;
 		struct verif_stats *st = NULL;
-		int col = 0;
+		int col = 0, cnt = 0;
 
 		if (!header) {
 			void *tmp;
@@ -1511,7 +1511,7 @@ static int parse_stats_csv(const char *filename, struct stat_specs *specs,
 			*stat_cntp += 1;
 		}
 
-		while ((next = strtok_r(state ? NULL : input, ",\n", &state))) {
+		while ((next = strtok_r(cnt++ ? NULL : input, ",\n", &state))) {
 			if (header) {
 				/* for the first line, set up spec stats */
 				err = parse_stat(next, specs);
-- 
2.43.0



