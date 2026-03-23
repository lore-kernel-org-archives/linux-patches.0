Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B4C3B388C;
	Mon, 23 Mar 2026 16:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283241; cv=none; b=Y6UQkW+0M/OgM1OluzDk5W3wUrfusoiJWs+qw/INkBPF9CSp8QWhKWvV4uDqWSal12gauKeB4cOaH3bYGl7N+LLSKfu1B7ZAaPXIo7+MAdnO0m/tZ1LmdEKlBttXdHYpme8Slq7IFk/4Pq2ZCpMU1/Vpt41aCdQqkTyl5Lm2BKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283241; c=relaxed/simple;
	bh=jUDaXqQt7Ae2EqHBxU1yhasGopStIpTNfY3S+c3CEf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IU0q0PWnri1RHmjIvaxftAllJz/5cDEA8db3KwxwZjzguUxuP7UzZCwRby07q+sfCTBT6BG/EtGr671CirZVGbOr1NCMfqVts2qWasEcFgmgk1iA5Iy3M/XF8X7IlzjAiC7xVC7e2Ls1RL1X92MNjy+eV5WsfWI1ppy1uWBXZTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0n8fC+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0n8fC+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12AF2C4CEF7;
	Mon, 23 Mar 2026 16:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283241;
	bh=jUDaXqQt7Ae2EqHBxU1yhasGopStIpTNfY3S+c3CEf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0n8fC+YNzZUkYbwv0UaroMPKtk2q+hrAm3odW2XoFmlA1F0UdqPdkDTuT/TIhAIL
	 rElGjSNbWKkNDafi4NVgnlKvsmsJQSxUqUs92kjMMVLr1/d2Wq/k1kOxZ0+DLqLtGO
	 as7q6woDTTjfXLxzrNlZZhxHnvU5qI1SyZxk7arI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 453/481] tools/bootconfig: fix fd leak in load_xbc_file() on fstat failure
Date: Mon, 23 Mar 2026 14:47:15 +0100
Message-ID: <20260323134536.252249532@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



