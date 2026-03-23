Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF2C2798EA;
	Mon, 23 Mar 2026 15:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279385; cv=none; b=jJLNzdjn5D2qLPRw6TtX+dLy+/zk5d8h6RLASJMyuIvXCIwXg11glODxrur1/oCOY5buyy8NZcrnPL/bxZod3HKRGIQ+BLkUfsoiKiZWRKH1L6k9ZfkFRYNnIlh6LYGlMDQStGpoP+ETmTjRtY/2FPwKiFMAER275T/e95WyK5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279385; c=relaxed/simple;
	bh=5sq22l0Xo9eBbQUCNKPLKfRfOit3kXkMi+3Iz/8vrVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLG1e5B37cSvHt7tq87aJbXPgbvCFvUPktBQwOQnbAenCsMuJoi2DTEHMGfBnJMQjYHEanLRSxfpyLmbkKOKnvIhd7Dpc0QtLp/xu+taWPfzWCWyQp5tg55F7JrczYyCVadyJHGpbp+U0IQEJvvft0OENXrekQKq8z8KfWSmIDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zh7b6yMb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zh7b6yMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E63BC4CEF7;
	Mon, 23 Mar 2026 15:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279384;
	bh=5sq22l0Xo9eBbQUCNKPLKfRfOit3kXkMi+3Iz/8vrVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zh7b6yMb/xh6Gy0wiKLkYubbAAsl4zlk9O/QzsJFOq1aS5YOAME6w9Ge87Y5vzsJP
	 5YtYDm3tS6aGV4c7uIBEShPfv4SkxyzyioiPlYSp6pyuOrvW/KtSoTduEIisoQwsoh
	 1qKKVCw4qUlOPFaVEhSmNZ9Mv8ZnYGDTTyG4wX5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 567/567] tools/bootconfig: fix fd leak in load_xbc_file() on fstat failure
Date: Mon, 23 Mar 2026 14:48:07 +0100
Message-ID: <20260323134548.045480227@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8a48cc2536f56..32cf48f2da9a1 100644
--- a/tools/bootconfig/main.c
+++ b/tools/bootconfig/main.c
@@ -157,8 +157,11 @@ static int load_xbc_file(const char *path, char **buf)
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



