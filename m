Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176CD63B3
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781D1C433C7;
	Sun, 17 Sep 2023 19:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694978427;
	bh=XpcsLhqD5V8d5NlIrDxpMMTySxMuNpjyW5VFTRJdtLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IXa4fJqYFk2vFpu0uWd+KdTJzYDMSaPuzkqa1OhYoG3YtWMwF0W05fcmbySyBUpGk
	 fPePYjA3dDzefSO7UkqO8ZYShOgLn3C7oJ4BpR7yPbzP3VwVCp+oPtkTgUCw0lygXD
	 UOQzXPZPMykKAniMKqcffVlrYbAb2J5+S7e6aMU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/406] kprobes: Prohibit probing on CFI preamble symbol
Date: Sun, 17 Sep 2023 21:08:22 +0200
Message-ID: <20230917191102.413316318@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit de02f2ac5d8cfb311f44f2bf144cc20002f1fbbd ]

Do not allow to probe on "__cfi_" or "__pfx_" started symbol, because those
are used for CFI and not executed. Probing it will break the CFI.

Link: https://lore.kernel.org/all/168904024679.116016.18089228029322008512.stgit@devnote2/

Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kprobes.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 86d71c49b4957..f1ea3123f3832 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1628,6 +1628,17 @@ int __weak arch_check_ftrace_location(struct kprobe *p)
 	return 0;
 }
 
+static bool is_cfi_preamble_symbol(unsigned long addr)
+{
+	char symbuf[KSYM_NAME_LEN];
+
+	if (lookup_symbol_name(addr, symbuf))
+		return false;
+
+	return str_has_prefix("__cfi_", symbuf) ||
+		str_has_prefix("__pfx_", symbuf);
+}
+
 static int check_kprobe_address_safe(struct kprobe *p,
 				     struct module **probed_mod)
 {
@@ -1646,7 +1657,8 @@ static int check_kprobe_address_safe(struct kprobe *p,
 	    within_kprobe_blacklist((unsigned long) p->addr) ||
 	    jump_label_text_reserved(p->addr, p->addr) ||
 	    static_call_text_reserved(p->addr, p->addr) ||
-	    find_bug((unsigned long)p->addr)) {
+	    find_bug((unsigned long)p->addr) ||
+	    is_cfi_preamble_symbol((unsigned long)p->addr)) {
 		ret = -EINVAL;
 		goto out;
 	}
-- 
2.40.1



