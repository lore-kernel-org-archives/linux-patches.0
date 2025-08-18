Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A36F31A04F;
	Mon, 18 Aug 2025 12:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521675; cv=none; b=gFTsc9DzpbXG1rbyMbv1DIYx6MxfHSt5ykMLV+DRSrGHoHD1dQe6R/XANh99Fz8L6F4uLg5gqmqRgG+uO/x6LS1hPLM2KRFIhMC0bjL6RapDesGdgdsIMvyr9VSOq68nOWihtQBROWvo2SUkerSvKdNbyeo7yzwrZj6V283PgNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521675; c=relaxed/simple;
	bh=K43SHj670n83h8SEMtykGxV7MWOWuluL052pp70zP70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ip+NplKnW5Qze4jEdQimn2plLI4j55tnkV9JIR8ZGKaGYRnvi2X3nPR18pd+FqMu+LI6lhReh3iadvLF5Khyv1Q/ognQ9JXYrJWcxop1SVMuckhwgRE+R2QPVNS891nqW8YB4W77cBLHiEoQbdx7hmH4bURK5sYZFH/1z6JNzTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CP5PoTRM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CP5PoTRM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3070C4CEEB;
	Mon, 18 Aug 2025 12:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521675;
	bh=K43SHj670n83h8SEMtykGxV7MWOWuluL052pp70zP70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CP5PoTRMGLw3WYFO9QQmUygruWPBrq0Rqpw5yTe9Ccxf0f3guQliaXn1rloW3x4pQ
	 sVS6lQW8021jXIOlTS/rjtZqDSrX0VjwzayRLApHascA9YKv2AR+W5A2nvyL3sDPdc
	 SvMAe2o1V08ynmEVekYJUa/aKHz1rbn0squ/CXNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 090/444] pidfs: raise SB_I_NODEV and SB_I_NOEXEC
Date: Mon, 18 Aug 2025 14:41:56 +0200
Message-ID: <20250818124452.320129466@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 1a1ad73aa1a66787f05f7f10f686b74bab77be72 ]

Similar to commit 1ed95281c0c7 ("anon_inode: raise SB_I_NODEV and SB_I_NOEXEC"):
it shouldn't be possible to execute pidfds via
execveat(fd_anon_inode, "", NULL, NULL, AT_EMPTY_PATH)
so raise SB_I_NOEXEC so that no one gets any creative ideas.

Also raise SB_I_NODEV as we don't expect or support any devices on pidfs.

Link: https://lore.kernel.org/20250618-work-pidfs-persistent-v2-1-98f3456fd552@kernel.org
Reviewed-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pidfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index 52b7e4f76732..5a8d8eb8df23 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -382,6 +382,8 @@ static int pidfs_init_fs_context(struct fs_context *fc)
 	if (!ctx)
 		return -ENOMEM;
 
+	fc->s_iflags |= SB_I_NOEXEC;
+	fc->s_iflags |= SB_I_NODEV;
 	ctx->ops = &pidfs_sops;
 	ctx->dops = &pidfs_dentry_operations;
 	fc->s_fs_info = (void *)&pidfs_stashed_ops;
-- 
2.39.5



