Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFD242DA20;
	Tue, 21 Jul 2026 19:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660515; cv=none; b=DwfliCdhz4c3XY9gyeelEk3lGj99XlLw7CqinJgmnresQGDJqeS11rsaQqUNQuBA+w7jJe2naFRMp0FH+uX9PWmVkVr/te1hdign8kcc8SEytRIv9JrR7RCLA0MsAOssGh6s3EYTQYCz9Gefb28qthP4N+vKHRjhoEv7/HH9F2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660515; c=relaxed/simple;
	bh=P/dSenriwA2+P5gYH1F1JM+bqQJXM72l9gRf5z7K5O8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKcv/7pRitPMCem2g/fwTJizngCMKgXV6fnsS6jD7rFM0VHgVpgpguOdMwjlBokGw/1JGnDnHcHw51O1puBzQMKUZ2NPgpLMA/Fej67skhpiQe4qQ0IpJHr/9ZTTf80uZYuYe0tqnoUuyfZTUxl1mg1uqkTYQpITe1zbH7VFrT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZlYdXf+/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZlYdXf+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB531F000E9;
	Tue, 21 Jul 2026 19:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660512;
	bh=iVGfbMU4sQHqwZk6maH3YumJsjIfSsJYyEa58AtjLl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZlYdXf+/6H2fKCZYoKkSLu153lekHOaA1V98J4kPFqYTtQla3sEOQJn+m47fFGhP/
	 vskV/FPyg1/WiH7WvAyC5dv/uHugBI3Eea1WO2ADN5UsHHDA+G4EWfFZX2NNnVR6R2
	 WNvI+702ulTSZhgID5CGbYMVCcgdNCc8baUkydkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1006/2077] tools lib api: Fix missing null termination in filename__read_int/ull()
Date: Tue, 21 Jul 2026 17:11:19 +0200
Message-ID: <20260721152616.544639696@linuxfoundation.org>
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
index edec23406dbc61..3cc302d4c47b16 100644
--- a/tools/lib/api/fs/fs.c
+++ b/tools/lib/api/fs/fs.c
@@ -294,11 +294,14 @@ int filename__read_int(const char *filename, int *value)
 {
 	char line[64];
 	int fd = open(filename, O_RDONLY), err = -1;
+	ssize_t n;
 
 	if (fd < 0)
 		return -errno;
 
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
 		return -errno;
 
-	if (read(fd, line, sizeof(line)) > 0) {
+	n = read(fd, line, sizeof(line) - 1);
+	if (n > 0) {
+		line[n] = '\0';
 		*value = strtoull(line, NULL, base);
 		if (*value != ULLONG_MAX)
 			err = 0;
-- 
2.53.0



