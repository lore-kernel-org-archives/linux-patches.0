Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5893B313546;
	Wed,  3 Dec 2025 16:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778042; cv=none; b=BjhZgyhXALcf/Q1kd6X6KSjn+sVBSH2wWqH8NQeqhp3cY5aaN3ijRROZXaZDoSkSCsodD5+IRbSMn99fMeUyvDCT8tYWBRbBD5Fc1YXnyJZutlzlkN6Y8xvWOEx/FTlAKQgU/xAs8WVG4AQW2jDTt5snuFfAB+Wuk0oYON5Ru0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778042; c=relaxed/simple;
	bh=M556w7GiREA2SfvuQKhHu99pvVl7kpEgydm0dSOUpDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLYMiWD3M1hGOzPLDlWuuJxYNOU3RhMSv6XCfLM8RERCHcXej+5M6Kj1URKqjAFq2Sg1Cd6JdEhBqtAmHCSYHpaH199Z2f1SiG/Iyi0cHsRS4CTIKU3scxVUenNKWqTl5mAUU54zCJtklM15NErAkodGJdon+ke7UTgP/OT7BSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fU1PYHMI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fU1PYHMI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BCE5C4CEF5;
	Wed,  3 Dec 2025 16:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778042;
	bh=M556w7GiREA2SfvuQKhHu99pvVl7kpEgydm0dSOUpDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fU1PYHMIm9niCE7HFXO6CT9bzo34cMc+hZJk0H7PwmNYPA3uNEdUq9eqooN38dOnI
	 Z0QCd4XI33WJxjQYL4iksvCkSOjfXxnyCSi+tmlgfEGbCjH1hoQZIY0G2HRNUHBW6E
	 Ly5jmeRl9yYoyrEjx1Tapr+OUoXyGnvVF/aq14KU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 225/392] tracing: Fix memory leaks in create_field_var()
Date: Wed,  3 Dec 2025 16:26:15 +0100
Message-ID: <20251203152422.464323212@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 80f0d631dcc76ee1b7755bfca1d8417d91d71414 ]

The function create_field_var() allocates memory for 'val' through
create_hist_field() inside parse_atom(), and for 'var' through
create_var(), which in turn allocates var->type and var->var.name
internally. Simply calling kfree() to release these structures will
result in memory leaks.

Use destroy_hist_field() to properly free 'val', and explicitly release
the memory of var->type and var->var.name before freeing 'var' itself.

Link: https://patch.msgid.link/20251106120132.3639920-1-zilin@seu.edu.cn
Fixes: 02205a6752f22 ("tracing: Add support for 'field variables'")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index e7799814a3c8a..8795913425416 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2798,14 +2798,16 @@ static struct field_var *create_field_var(struct hist_trigger_data *hist_data,
 	var = create_var(hist_data, file, field_name, val->size, val->type);
 	if (IS_ERR(var)) {
 		hist_err(tr, HIST_ERR_VAR_CREATE_FIND_FAIL, errpos(field_name));
-		kfree(val);
+		destroy_hist_field(val, 0);
 		ret = PTR_ERR(var);
 		goto err;
 	}
 
 	field_var = kzalloc(sizeof(struct field_var), GFP_KERNEL);
 	if (!field_var) {
-		kfree(val);
+		destroy_hist_field(val, 0);
+		kfree_const(var->type);
+		kfree(var->var.name);
 		kfree(var);
 		ret =  -ENOMEM;
 		goto err;
-- 
2.51.0



