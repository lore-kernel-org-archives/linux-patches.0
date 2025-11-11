Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAC72472A6;
	Tue, 11 Nov 2025 01:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824876; cv=none; b=W4MUkfmgsSxqVNcR+oNytdqwj1QVLjSRnZfOC1lFYlF0dNmziHyJ/rpjwRIeQQdZAcc/IWPdwF4N63XIqmpSBwJrBtmOrxC7psSrdyBBI9rY+4f3NKRq8AZMMD8wW/i6f8r7Lel7JzzRpJhnb4r8tI4RZOc3/8T6tvGodVxv6Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824876; c=relaxed/simple;
	bh=kl5GYNfS9EcXdMYoZ+stpHUoCe/hsj7BnCGT3OsKHO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llMkq1LAsOxhxMCSAY5M70BAGa41TCPBVJFVefdMX5iNR8hGTKHz+lqzxc4uYeFd3DbpyeqBM/DGRswd0xMdi/wrRK1qfeN/tHFpAuGvvl5ra9TgbcJEOyAjO/W/a9xf2flNnCrmLrng01r/MFqfscVJGRE11CjxNgl+Kx3j+8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AFqkmfno; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AFqkmfno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3E5C4CEFB;
	Tue, 11 Nov 2025 01:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824876;
	bh=kl5GYNfS9EcXdMYoZ+stpHUoCe/hsj7BnCGT3OsKHO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AFqkmfno7OX7bavF2+/GbWoohkt8fws7itbNNj7lt3SIRndDSeQBw9F1auRJuAsSI
	 twOVSfHEx3W98Qrp8hJrYuB1wGTL+I9speAa5+V5pTP5Q81Tgf1OB+JC80tPLy9t3L
	 M1BNCc7UXb+N0vWHBOOm9WhAmZCfo/VmaptqHDwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 542/565] tracing: Fix memory leaks in create_field_var()
Date: Tue, 11 Nov 2025 09:46:38 +0900
Message-ID: <20251111004539.178291240@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 3379e14d38e9b..84954b8918156 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -3251,14 +3251,16 @@ static struct field_var *create_field_var(struct hist_trigger_data *hist_data,
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



