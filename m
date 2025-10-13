Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A88310782;
	Mon, 13 Oct 2025 15:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368079; cv=none; b=OXRwd3UDlNU7oaxsBri5A2rAfLiwofJuFF4VF+kBumGK25UExUvzP4+z2CCIQzemP8lZ5aWX5t0VmfnhsR+MSCByhk3Jouune05pdFQEqoG4tHgkR0da0/yVHb7UKwbPWEVsTzLA57dPpDv9LM/aarDNyHNN/iloxTDF8W7kFJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368079; c=relaxed/simple;
	bh=XPaWwdrgwUOqSQT5Pmvykketc30hBLVw92WjclSh8ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lhk13+oUB5lWEXkcsSwG8NBSpShOUA0RA5bAGN8Q6DmLvGbmGjzOTSSEOmM+3IM/RXz7t+K3C6VTflaWQI16YBFslR35VAivS5OiisCXfj6OccnUxVtv+WFgWXVN3su4DQAHvr8sV0GmqkOwMCefgAMhoGBsHne+7ovJc+1wtME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g/pl+wcA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g/pl+wcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E07C4CEE7;
	Mon, 13 Oct 2025 15:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368078;
	bh=XPaWwdrgwUOqSQT5Pmvykketc30hBLVw92WjclSh8ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g/pl+wcAZltImZjSy1rIU1S378QBGwiZd7w7dM5ietymgLGOZgDYXP3ebBgSUuVK2
	 kJa9x6Na4c5BlGSbbK+wbu4qhE4+BjcA3jIwj58dyQiQlkb94xijIEb1P6TN+CF154
	 aoCl718GwSlEfVF4NG/zbyey3BxsmNNqqPyWzf2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Linton <jeremy.linton@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Oleg Nesterov <oleg@redhat.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 008/262] uprobes: uprobe_warn should use passed task
Date: Mon, 13 Oct 2025 16:42:30 +0200
Message-ID: <20251013144326.425185738@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Jeremy Linton <jeremy.linton@arm.com>

[ Upstream commit ba1afc94deb849eab843a372b969444581add2c9 ]

uprobe_warn() is passed a task structure, yet its using current. For
the most part this shouldn't matter, but since a task structure is
provided, lets use it.

Fixes: 248d3a7b2f10 ("uprobes: Change uprobe_copy_process() to dup return_instances")
Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/uprobes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index e60f5e71e35df..c00981cc6fe5b 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -114,7 +114,7 @@ struct xol_area {
 
 static void uprobe_warn(struct task_struct *t, const char *msg)
 {
-	pr_warn("uprobe: %s:%d failed to %s\n", current->comm, current->pid, msg);
+	pr_warn("uprobe: %s:%d failed to %s\n", t->comm, t->pid, msg);
 }
 
 /*
-- 
2.51.0



