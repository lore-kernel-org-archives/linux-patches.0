Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F7F303CAF;
	Tue, 11 Nov 2025 01:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825438; cv=none; b=Vh711PwvOLP61zjTrUsEd99Osen5f9alRp1v6QecOsP2xlqXWmixRV101SfUz5TWhlWCjmHuM01tKNIgDzNhNzI0VgugjY123pm9PScXdXZ7rp1GKr6AoLYbH6JJqnh0Cjqfx/nRoouYqxmPix4usWdkg8wpyWLRXvfFWRhOpOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825438; c=relaxed/simple;
	bh=C5XNF6hFFnm2x/zKduhCnWv/OT5IaAjjNNe89a/ffMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbQ8VHLxOWfHC4RJltKScTWvSi+mecoNLIsmeNxq/c2fMzuAD81FxtyibMuaLAbqR2R6lq5wz2WYO50bwmu5Ys0zTLCpoaAh7RNgqChoxT8y+IT/ZiZ0uit3gP5KjVBFNz2o7Ehf2qaC4QxEdjV1eqNARuNyO9Bft2ce/wQwHqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qQEezulx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qQEezulx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9CEC16AAE;
	Tue, 11 Nov 2025 01:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825438;
	bh=C5XNF6hFFnm2x/zKduhCnWv/OT5IaAjjNNe89a/ffMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qQEezulxrEHrLQj3OU+qRQBuPcZ9aGq1Md6H9Ga5LGiFKDjQOQ168ynkyomJ8I1Ir
	 623iBymZlavFmirxgRQ2AgPo7ukcyxOpidaQ65Os0I1DJeyh49OnGBstzdNjD7sx7i
	 sOKWUqq4DWts3vY8SWa/nNaOCGl2Ahb02jj3o91k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 800/849] tracing: Fix memory leaks in create_field_var()
Date: Tue, 11 Nov 2025 09:46:10 +0900
Message-ID: <20251111004555.771425124@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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
index 1d536219b6248..6bfaf1210dd24 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -3272,14 +3272,16 @@ static struct field_var *create_field_var(struct hist_trigger_data *hist_data,
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



