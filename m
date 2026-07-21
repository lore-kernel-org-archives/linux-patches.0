Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1046630EF9A;
	Tue, 21 Jul 2026 19:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662659; cv=none; b=AWGdGOp04qQuAcNn/pjgwf0Kg9rlkDzI0fJD569pcl+EQ8SkZskgDcv61V2XMCYtTqyzR2n5eXTwlPurlYFT11uFH0//CU2ZG0fv1B9xnKDvFOIHhsFCWbPZehrRKE4AoN6MjOofzo7gUGSa6Um3WxI4Y9Mu27YBjlOs3+eirGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662659; c=relaxed/simple;
	bh=ITz1NJiN9tF7IQADZTwi8UYojuNerHT4SQP2CTexwzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHVAfK1zN7S2ovFv38mIbUZz8j1B5Vt2lyTcC+kmBYoP393E0bcTWzYvaovUVVtSt3+E/nNlR8rQJt+jh0PwDNAslgu68dHgt1qpNQ08EtRRQoBHqe83PgPEPF9CxmR/mFEP80UJyCRgnJGu/ejcMoNzuIl6QQ58fbCuMmIalkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E5uSxgYa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E5uSxgYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757871F000E9;
	Tue, 21 Jul 2026 19:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662658;
	bh=ZORzKQxGneG+8lNflS4ID1itJaTdBuD29f1GVODDCLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E5uSxgYaP9jAUPv0DC/JwTODRuM7igv6KW9amd4k2W1agPSOVu0wUz35/yvpLMWPS
	 P0dzv04RUZdRmmdscVHsgEyjgpCl2cXfROpIb5Us84oh/04aZ8cTQyfMYne1UG1KKy
	 1rXDrJ93emTl7vxsQu3RTc3TQDpLoASwa1oGF89w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Kan Liang <kan.liang@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0528/1276] tools lib api: Fix filename__write_int() writing uninitialized stack data
Date: Tue, 21 Jul 2026 17:16:11 +0200
Message-ID: <20260721152457.936315485@linuxfoundation.org>
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
index 3c7a8a0605710e..9cc161630c2919 100644
--- a/tools/lib/api/fs/fs.c
+++ b/tools/lib/api/fs/fs.c
@@ -376,12 +376,13 @@ int filename__write_int(const char *filename, int value)
 {
 	int fd = open(filename, O_WRONLY), err = -1;
 	char buf[64];
+	int len;
 
 	if (fd < 0)
 		return err;
 
-	sprintf(buf, "%d", value);
-	if (write(fd, buf, sizeof(buf)) == sizeof(buf))
+	len = sprintf(buf, "%d", value);
+	if (write(fd, buf, len) == len)
 		err = 0;
 
 	close(fd);
-- 
2.53.0



