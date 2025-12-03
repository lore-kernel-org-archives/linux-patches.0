Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC32D3081AF;
	Wed,  3 Dec 2025 15:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776453; cv=none; b=Gf9Rs4v7idV7HbKouhDivBKx+G/xc1XDn8T+z1F4CNvpQe/Nv+WOImQbBD+5KERJcs9Sef36FlnFPGNmXK0auYoGFIJyT3KQhJ1lFXBKB8CfRp6uwQCCrbw95d/o7t0pjJapLpkBqLqz8s6toooYTr1lquzBarUjcVA/H6SeBPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776453; c=relaxed/simple;
	bh=HgN4G4ZkYTfJjajVmp9/VID/gdaJXvYv5PWM94LpIuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2vhuhiKkj0Uqi96xghP21ZgfzNYmcHYJWl5/aGJFKUHzY5lxZ5WS436JXpTguMfYe9xFrKdujsfAhSJwChFuCRJ/MLv85e+yTBCJQDKZRIHhOO34iB3X4Tip/kCai8nX7x8H4Ua0yKd5bnRgBp13fYV0GtcCJMjPL2kn5OddJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DDtzCPWW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DDtzCPWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B07FC4CEF5;
	Wed,  3 Dec 2025 15:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776453;
	bh=HgN4G4ZkYTfJjajVmp9/VID/gdaJXvYv5PWM94LpIuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DDtzCPWWW8SdehkN3Hn1NF5MG6r+phQipEXBMPJCSUWIidJhMxxYe0NHAjfAcfH5O
	 HKmtWENLP1BFe116x8NI+lHch3Vh1/AshipwbvJ/TGkgQ4on84556l758BhC/HvXRJ
	 eaKo6aniRdrdSotcrAQ6EG4TgEKqMPhOV0xSPOrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 170/300] tracing: Fix memory leaks in create_field_var()
Date: Wed,  3 Dec 2025 16:26:14 +0100
Message-ID: <20251203152406.918143926@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a0342b45a06da..f499838d9103f 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2729,14 +2729,16 @@ static struct field_var *create_field_var(struct hist_trigger_data *hist_data,
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



