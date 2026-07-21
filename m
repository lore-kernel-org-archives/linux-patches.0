Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415391F03D9;
	Tue, 21 Jul 2026 22:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673881; cv=none; b=WfOMdpyTyRYLv0bC6iG+vYaY046ZjatQp9OCs1IyBMaAwtLLhYqvLqD1ezZW/e/4ZgAEVw/YT1AUxlC023OQPck6dSeXYz9EkpCcMlq8he20KUYCJ3lDtUwKJUiCQqCnTk7SQyihkrtxUi7XuSYqUnnYm6zUmiIEfd7FKjDPRvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673881; c=relaxed/simple;
	bh=ZKt5pLwuJqC635R5+OaXSlVIWVBuZwtmJZNWoDWq/Jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ymq/ccK4poxWdl8RRgR/rexjXniBDvmXZn/6YQuxnQQJzp/LgoRTtHbnwf/nccrROqTHPPirIX4Cyxjw1OF0/I6TfWP1z7zAOKgAxcsob6lefU2k5v2o99JZDMoW9UA1hkqx7o7V9RRGLc/PH/VYJYKig0MXmdQFhgEfOa4Kdlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=geWTxuOh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="geWTxuOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A201F000E9;
	Tue, 21 Jul 2026 22:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673880;
	bh=hBt+eOELG2WT10ir1K3pGTQiYhLsgorMxiExfNr6w/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=geWTxuOh6hC+Z4CYOkyeKcmrGjowHIrmcsezhu8LbP0BEK9X/3mpA3QdAP62lwTjt
	 X0ixOb7PXUkMxS3AVM/xxvapL94K395wNfLJtlZvMJrBEC+EEBqllRyxfrel94IH2p
	 r3ZApNweXdEiHy3ENkzzSwOUZK78uMYC3ZA+z6KU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 313/699] tools lib api: Fix missing null termination in filename__read_int/ull()
Date: Tue, 21 Jul 2026 17:21:12 +0200
Message-ID: <20260721152402.755965939@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 82f53d81a7a784..e102714c6845e8 100644
--- a/tools/lib/api/fs/fs.c
+++ b/tools/lib/api/fs/fs.c
@@ -321,11 +321,14 @@ int filename__read_int(const char *filename, int *value)
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
@@ -339,11 +342,14 @@ static int filename__read_ull_base(const char *filename,
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



