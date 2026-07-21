Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E646B47124C;
	Tue, 21 Jul 2026 18:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657320; cv=none; b=bWAI+kPgAK+b5GtRnglYahwuTOJ41hWaeW/jolWUj+GCqreRF097Q6fmSK8ZLZ1aY2+/TudT/4gKlX5ksXlOx+RaTGwzJ7SxPV/4tZ6lJRVhnr6vwFnO6gmj/0zZkKIX8DtlJaNzZOb60E8ODYkHAU6vhadpalDVZlZhr+LLAZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657320; c=relaxed/simple;
	bh=IEuXsL57gwd1x245XFT1Wk7wwqsVbQu+OdeDAQWZ5H4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTLqxZW8hPGaYTohWjJc8ZRUtK/aCLGAKZNzWNA6FuRgU2lJsseBfbb+Uf3bHEG0GEDnqFDqEhg+4eklbLfi5h9P2iFuZ/0BpNKegtl/1Z5/ZJxDLCXXcJsX0/sPaaXq09fCbVaBHpP8ke4rTuMCKemRucjGbe9rLCNeJsmAnbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mSJHIww7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSJHIww7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590891F00A3A;
	Tue, 21 Jul 2026 18:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657319;
	bh=7Ab2odTQhYHqf06emTQ8odunDg+t5AsNQ1oK9q6R1tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mSJHIww7fNKZ45O8zJpdZ9TH/hjphn81k12i/kE0wBVutNEluM5FlO+/tnYXvutwj
	 dO47JutKg2WlsXCQL4Y8h0Cporrdj3zmtC1aHfA6iuzwuX+eACIwynpMXuvI0e6WSb
	 fzZOcE/X6RHShax3YWp/ial4DNJzQtMRiYfOpBuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Kan Liang <kan.liang@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0720/1611] tools lib api: Fix filename__write_int() writing uninitialized stack data
Date: Tue, 21 Jul 2026 17:13:56 +0200
Message-ID: <20260721152531.575243279@linuxfoundation.org>
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

[ Upstream commit 438ece06185696e14c63c6113d5e2d34ec0a9680 ]

filename__write_int() formats an integer into a 64-byte buffer with
sprintf() then passes sizeof(buf) (64) as the write length.  This
writes all 64 bytes including uninitialized stack data past the
formatted string.  Most sysfs files reject the oversized write,
making the function always return -1.

Fix by capturing the sprintf() return value and using it as the
write length.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: 3b00ea938653d136 ("tools lib api fs: Add sysfs__write_int function")
Cc: Kan Liang <kan.liang@intel.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/api/fs/fs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/lib/api/fs/fs.c b/tools/lib/api/fs/fs.c
index 3cc302d4c47b16..d16911818d4d35 100644
--- a/tools/lib/api/fs/fs.c
+++ b/tools/lib/api/fs/fs.c
@@ -376,12 +376,13 @@ int filename__write_int(const char *filename, int value)
 {
 	int fd = open(filename, O_WRONLY), err = -1;
 	char buf[64];
+	int len;
 
 	if (fd < 0)
 		return -errno;
 
-	sprintf(buf, "%d", value);
-	if (write(fd, buf, sizeof(buf)) == sizeof(buf))
+	len = sprintf(buf, "%d", value);
+	if (write(fd, buf, len) == len)
 		err = 0;
 
 	close(fd);
-- 
2.53.0



