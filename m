Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2456042DA53;
	Tue, 21 Jul 2026 19:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662627; cv=none; b=e5HLUgOF4eo1W9pzwH5UuEl35vMp+E3Sk3uu6UEJwAZ0SlbGTChvoujPDHyPdDtsPyncgR1D6wRcvevXG3ruJHFELTPC/B6H/90S/U1oGZ+qn8QorhPpbqq6qBRe/uIMD5sLzWiAL54Ut+CoQq3Bmzuensn4fnNdfeevoA7gJ9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662627; c=relaxed/simple;
	bh=QnJW8HpL2dUuvjSrZcmtN/O432eaHRlLCvj7ftN6J0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0deYQH4h1cncE4Orug6tbE0fplIsQsIwDCyhEqY+ytK7tWhKEgWlh3RjPGQk/Wa5OUUj5Y1vYv02X7mZ/U4htJkmf3EuZHy6erKj0HzhVC8TlqzweJPQdd35EEy9Amh/gGSic0IzSoxWzi4g92iB3NUTynyWnSCmytuQ1vgE8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ghf9/xGA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ghf9/xGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8911F000E9;
	Tue, 21 Jul 2026 19:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662626;
	bh=HTnvDZ4w15vk8AkE9Z0eQlWTZY9hDUUZXr/0a20dCdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ghf9/xGAtIMGQtqU6ioV3GcqEscl4iKtEWd9zNSJ2lcdSN2fx/CVZsvYZ/Ncfdr+r
	 3lRguFf/XkbSIaZh4gAS/6Ay9TF2acPQbyzOtsZMe3XcEWdW7DP8WgrwYJsPnGrlOM
	 ECVI4MzvyGbuO2IRp05tAG3mu6Fqx+WzstYvluMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0517/1276] tools lib api: Fix missing null termination in filename__read_int/ull()
Date: Tue, 21 Jul 2026 17:16:00 +0200
Message-ID: <20260721152457.682784906@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 52b1f9678499b13b7aeb0186d9c6f486c043283f ]

filename__read_int() passes a stack buffer to read() using the full
sizeof(line) and then hands it to atoi() without null-terminating.
If a sysfs file fills the 64-byte buffer exactly, atoi() reads past
the array into uninitialized stack memory.

filename__read_ull_base() has the same issue with strtoull().

Fix both by reading sizeof(line) - 1 bytes and explicitly
null-terminating after a successful read.

Fixes: 3a351127cbc682c3 ("tools lib fs: Adopt filename__read_int from tools/perf/")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/api/fs/fs.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/lib/api/fs/fs.c b/tools/lib/api/fs/fs.c
index 337fde770e45fe..3c7a8a0605710e 100644
--- a/tools/lib/api/fs/fs.c
+++ b/tools/lib/api/fs/fs.c
@@ -294,11 +294,14 @@ int filename__read_int(const char *filename, int *value)
 {
 	char line[64];
 	int fd = open(filename, O_RDONLY), err = -1;
+	ssize_t n;
 
 	if (fd < 0)
 		return -1;
 
-	if (read(fd, line, sizeof(line)) > 0) {
+	n = read(fd, line, sizeof(line) - 1);
+	if (n > 0) {
+		line[n] = '\0';
 		*value = atoi(line);
 		err = 0;
 	}
@@ -312,11 +315,14 @@ static int filename__read_ull_base(const char *filename,
 {
 	char line[64];
 	int fd = open(filename, O_RDONLY), err = -1;
+	ssize_t n;
 
 	if (fd < 0)
 		return -1;
 
-	if (read(fd, line, sizeof(line)) > 0) {
+	n = read(fd, line, sizeof(line) - 1);
+	if (n > 0) {
+		line[n] = '\0';
 		*value = strtoull(line, NULL, base);
 		if (*value != ULLONG_MAX)
 			err = 0;
-- 
2.53.0



