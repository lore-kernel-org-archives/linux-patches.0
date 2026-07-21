Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7913439322;
	Tue, 21 Jul 2026 22:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671896; cv=none; b=YKFC5LKJ/M/uuQHm/7igkAEFqI4tjOEQ4VojHXjaQSbc3cd3T5vboA0BUNGFGyOXTAaVXPe//7+a+HGvlIcdXPqJWPRxJU5p59hC75pb7ZW2AM9diiaqsRed0QaZ6sDTKPwzTYWVv3tGPY0V62O63RPLXAs4KwtMRc4UQhcg34M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671896; c=relaxed/simple;
	bh=uxBGk9BEnoZhRzaWDXug84MXMZPgjY9HCKNgZyW+cOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0hDJrLmgS1WkOcQz7+0nfyysBjzOu1oQMEqQ5YihNo72y4GIR9NMHUKss2LBXz0h+hWt/4kn9gJalvg0OyXkR3RsZgvFHqM9MrcuhXkoiSLLnri3lXGusS6L4WXf4nwdIoOdBrNuou+K0Gn3+B6H/NPJJfFpXeMUgtWHy5+jRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nzuJeg4a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nzuJeg4a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D4F1F00A3A;
	Tue, 21 Jul 2026 22:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671893;
	bh=4XPxsOqjy8cznUfVnhEUfCDPXl3HcondiLH4l84u+sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nzuJeg4a8GUAKgY2rY8RRIrmJjjWN/C0/xFIvCXeQdxkBCTaZcuADZo2mPBB90sjW
	 AtJtJ3508qS/JDwW8verj3ZapVa3Ejss1gD1ynu+aZcIjTR/5h7fioqPgkF8kG13PQ
	 JhNZ08nhGnLku2fiiklD9WUxBrx1QLLFJg5ueBTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Kan Liang <kan.liang@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 420/843] tools lib api: Fix filename__write_int() writing uninitialized stack data
Date: Tue, 21 Jul 2026 17:20:55 +0200
Message-ID: <20260721152415.483996350@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e102714c6845e8..e13034cb0b6315 100644
--- a/tools/lib/api/fs/fs.c
+++ b/tools/lib/api/fs/fs.c
@@ -432,12 +432,13 @@ int filename__write_int(const char *filename, int value)
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



