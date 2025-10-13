Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8414B30C374;
	Mon, 13 Oct 2025 15:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368899; cv=none; b=Z3YooTzgiZCHtUsB2w3G4uCBLUMY4oKn/CB5+EfJod/5KFzQq1KAwdO8OlUaPuyhV8arPbYngKboQoSSOX0R39yJ6QiQ5tsjQRfd3M8N2iuKimPW3rpSUcsxwB0kNgCRV2aBrj2wOpI21A3dDbdEogMZNL/TW9Y0rIZCu+xVRg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368899; c=relaxed/simple;
	bh=3bYHLU8C1gpEPad03qhnazQBUm+qpWTwtiajahEPB10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s496fXmHrnL6MtQxl+ALOlwApC8NBHI0KwAzwqR4o83ioJOHxrn/UrCKGqIwAXOczkLwXPK5OxNCmasr0EiIF1yVKjcJuu5JHoHat/dHjA39WzvccAzvDkXvXHeL8KI9H8lFZXRSyEPwILMr7RqkDIekpa0UXxGP1m+s5cGRLas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bQg47f9+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bQg47f9+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B5DC4CEFE;
	Mon, 13 Oct 2025 15:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368899;
	bh=3bYHLU8C1gpEPad03qhnazQBUm+qpWTwtiajahEPB10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bQg47f9+69DkE4Mct+3s9nERRbO/bWBPNwyT9IzNh5nNGb0NDpUKi/cTCBcnD/QNn
	 vxjxsEYgZsJAZFPH4ah7xa4J1LgfMIxRuv3VYiNkWyyNQHag7ND0sEPORE/P6v8HIp
	 /SDoEHiGEHJbpAQrpEAhH9V9YhVVfTCe0WI4izms=
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
Subject: [PATCH 6.17 024/563] uprobes: uprobe_warn should use passed task
Date: Mon, 13 Oct 2025 16:38:05 +0200
Message-ID: <20251013144412.164353943@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 7ca1940607bd8..4b97d16f731c1 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -121,7 +121,7 @@ struct xol_area {
 
 static void uprobe_warn(struct task_struct *t, const char *msg)
 {
-	pr_warn("uprobe: %s:%d failed to %s\n", current->comm, current->pid, msg);
+	pr_warn("uprobe: %s:%d failed to %s\n", t->comm, t->pid, msg);
 }
 
 /*
-- 
2.51.0



