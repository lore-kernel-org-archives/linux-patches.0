Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C626E145348;
	Mon,  6 Jan 2025 15:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178468; cv=none; b=SVh0XXFsEhXIMlKOQhRPsuL9UOAeoD+xurVDXGIcaBiNFGqvll9BqwcQPwTNkEXnzD1VpASbI+p1l4u/Nr+H+QNroAO3WCr5bv+qgK+TJdjVXpi1xNNH1HAIWeiZpXZjCI+Cd9VUiR6ZyWD3rSHRcy8d5RHdIi6DXXbxEt7L2tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178468; c=relaxed/simple;
	bh=Os7kmIzJ5Ziu9Ki4TiI7JSw4kXufDITAZ06573UVOQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrenFscBFluholA4y0H/eEBez4uIwyt6GzotAz8CAYgr2Muocy4vkUm/df8g13Ix5WT1B8L5X9w5zi/yIxLUxCeD9KHU2+EiLffxTEZxuByMzU2lzA0LkKPNOX1NOXJGhgqRnoaA1uX8b3b0Swy89aO3CYnr6jAdgIGsKPy1a0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RHU4/fcH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RHU4/fcH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C90FC4CED2;
	Mon,  6 Jan 2025 15:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178468;
	bh=Os7kmIzJ5Ziu9Ki4TiI7JSw4kXufDITAZ06573UVOQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RHU4/fcHx0yyCFZ8BeHzH/iOIjpizTAxkhDat3fdjqJp6A6ltMi6eZerMkehuZvoq
	 QGeSHrF/41bB62igzZkArMRuwjWbLNuYOXNLixqj9RjgqlbUa6lQY4qtFonnTuKvjV
	 FjGy7+3z0pqcVu3fTXE5l16Bb9084Q3c7EtPCBHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0aecfd34fb878546f3fd@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/138] tracing: Prevent bad count for tracing_cpumask_write
Date: Mon,  6 Jan 2025 16:17:25 +0100
Message-ID: <20250106151137.812882554@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Xu <lizhi.xu@windriver.com>

[ Upstream commit 98feccbf32cfdde8c722bc4587aaa60ee5ac33f0 ]

If a large count is provided, it will trigger a warning in bitmap_parse_user.
Also check zero for it.

Cc: stable@vger.kernel.org
Fixes: 9e01c1b74c953 ("cpumask: convert kernel trace functions")
Link: https://lore.kernel.org/20241216073238.2573704-1-lizhi.xu@windriver.com
Reported-by: syzbot+0aecfd34fb878546f3fd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0aecfd34fb878546f3fd
Tested-by: syzbot+0aecfd34fb878546f3fd@syzkaller.appspotmail.com
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 3ecd7c700579..ca39a647f2ef 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4910,6 +4910,9 @@ tracing_cpumask_write(struct file *filp, const char __user *ubuf,
 	cpumask_var_t tracing_cpumask_new;
 	int err;
 
+	if (count == 0 || count > KMALLOC_MAX_SIZE)
+		return -EINVAL;
+
 	if (!zalloc_cpumask_var(&tracing_cpumask_new, GFP_KERNEL))
 		return -ENOMEM;
 
-- 
2.39.5



