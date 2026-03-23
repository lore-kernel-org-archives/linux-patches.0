Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97553AE6EE;
	Mon, 23 Mar 2026 14:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275073; cv=none; b=RTLCJJ4t2KafJ3PMd4UA3W+2Vgeik+0/FUsZ6y57/j41AMwdSLaamlEMKBUlmjmi1vHPRpHrjeo91ycfnoh9S3MxjwAIJrjDu2iJWv89XQTITZIW6fZo0L1SRZD/J79gHDYT10WGG4ZbDMArC1yFNUVfxN4YEeELcq7d6ZTn1wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275073; c=relaxed/simple;
	bh=O98PyuiM5jPiR9BkgNaeyLWYQpWE8OjECKUCe6cbRgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MgVD69ekbbRXjyxRWpTzRp+BYpMe7pkMq7LXozarUo3nCI2W2boUaSYvsXFFjR0NpfCj4aVnEvMqu+fM2jX1q9VCPb96zdwzeMnU4a+qZeODoz8p4qjb7xogJSB3NhJjcP7nWGo72axrvHZ2M/bPOWC1rMSOF9G0GfMy18G36Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7ouLZA6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7ouLZA6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7BCC4CEF7;
	Mon, 23 Mar 2026 14:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275073;
	bh=O98PyuiM5jPiR9BkgNaeyLWYQpWE8OjECKUCe6cbRgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7ouLZA6Pk2NTPxfGeoqDC4F8JTK0+WO9d/dxGiFlOkVI0kGF5T8yZKb8NpSz1Bk6
	 cm/+0P0NnpO09ZEEV9GO3yAHmAlf0L5Gxk1RpTP+3AfcNReJJ4j+87T7oroGTxrmSd
	 lqtj9QvVjP+eRNPfD/U+wlY+Z4wxP5EvrCjPouPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 210/212] tools/bootconfig: fix fd leak in load_xbc_file() on fstat failure
Date: Mon, 23 Mar 2026 14:47:11 +0100
Message-ID: <20260323134510.420829481@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

From: Josh Law <objecting@objecting.org>

[ Upstream commit 3b2c2ab4ceb82af484310c3087541eab00ea288b ]

If fstat() fails after open() succeeds, the function returns without
closing the file descriptor. Also preserve errno across close(), since
close() may overwrite it before the error is returned.

Link: https://lore.kernel.org/all/20260318155847.78065-3-objecting@objecting.org/

Fixes: 950313ebf79c ("tools: bootconfig: Add bootconfig command")
Signed-off-by: Josh Law <objecting@objecting.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bootconfig/main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/bootconfig/main.c b/tools/bootconfig/main.c
index 55d59ed507d54..643f707b8f1da 100644
--- a/tools/bootconfig/main.c
+++ b/tools/bootconfig/main.c
@@ -162,8 +162,11 @@ static int load_xbc_file(const char *path, char **buf)
 	if (fd < 0)
 		return -errno;
 	ret = fstat(fd, &stat);
-	if (ret < 0)
-		return -errno;
+	if (ret < 0) {
+		ret = -errno;
+		close(fd);
+		return ret;
+	}
 
 	ret = load_xbc_fd(fd, buf, stat.st_size);
 
-- 
2.51.0



