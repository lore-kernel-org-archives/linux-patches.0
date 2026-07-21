Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EBC46D544;
	Tue, 21 Jul 2026 18:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657291; cv=none; b=GP3df2ipzo6b8/OVGe6p4MeeQ1LQxuyvogEhZ/d44BWCQ0muMAFwbHLU/lSYf4AUkuE7i1raMnyeLENANvA/P+k4D62jqiOxot3SUsP/iOw19MFlo3CaTid11o0tn31jTCV9M539RT1RvHBmFgjOhvopH+mFXs8hKFJOX33+310=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657291; c=relaxed/simple;
	bh=0ITT+7408n2W4yU/bELIy3Re3ol0x1fJWVXqFAFQ0ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujapgUcurP+TiigygyHg+KcMeVZ7auVSOaja1K3vXq62aZwet7PF498t4kqn/fjd861dv/qgP14Ft9hKhoc6hXqCaYUZ7loyJ1w9deYuW6YCa9N4bNCSeXVFjLq4Admao++Dvj0UBJp4PQQu2/rV+OxfKcEfBN+fbkRNtR50/C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P0e+yBFj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P0e+yBFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3BF11F00A3A;
	Tue, 21 Jul 2026 18:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657288;
	bh=i8+kkllEMTPsxTcOrpEHgQcAXMImuaxCngwBa4e2gi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P0e+yBFjn9Y41jN1Ky2B3ZNelYtZU99vlSlw/mgvvyCrvcUzoVDYU/B1zuZ4c0HoJ
	 nwF7wbvmAb3ksU1yjGjvLn84c+C9hmZLn6x3nG1PP5oNkXX2t7rbKysp8RuxWHZOaw
	 dUQl5GMiAE8tZ4F1BqOMJ6iXlUTBJyRhRp4/J5rM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0709/1611] tools lib api: Fix missing null termination in filename__read_int/ull()
Date: Tue, 21 Jul 2026 17:13:45 +0200
Message-ID: <20260721152531.329762654@linuxfoundation.org>
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



