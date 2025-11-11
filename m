Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73DF335095;
	Tue, 11 Nov 2025 01:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825309; cv=none; b=XxU9AR+qobOIrjHSSL1sbNc9PSoAgqQtMCAZY4AYiD5R5HTb9H0fcMrTZIVxxa6cq0NNlYQRQ4VxubwyIy/CbCNxt4my2KS10ZpDWGJIfcYeKmyLQsZD3WtzvgmSzvSp8y/f5d8uY98t/Ff9BPlxr0JPmCq75WaaRV07W3FTISk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825309; c=relaxed/simple;
	bh=onvhz68yEVLUK//9KDx5TM9RGeswb3KZ4bC+ORPB5og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CD/zKsE6ZfwC0xsCYpd8zqOdO5wolkWIUUPUmyi7gdchTx+Tg4v5g0msva1sNuKqySME1ZjNBPuzwqWSB51lkI9ffm4iEwLqybPCfgFRzrkhreCynl1WxITTx7RpNzDTZnJ4DHBug1u4GHmOwwfhTshttFFCmvo0+V6DWQ/7UCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bDIYshuQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bDIYshuQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D17EC113D0;
	Tue, 11 Nov 2025 01:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825309;
	bh=onvhz68yEVLUK//9KDx5TM9RGeswb3KZ4bC+ORPB5og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bDIYshuQfoMPoyCZ4fc5nRiPeSAcfe9C7XDlyHranlkfg9bewFwlV7CR00NzRs+Ez
	 QlnN51OItj3D/9lobtexTEQlXF12wQFIBUJ9hvQYuvDmc99mWQ2dL3jznS+oTKg+H3
	 E+bRELsIDR2cB/ML1OtWXtjz8vmj1AYCZjetmqw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beau Belgrave <beaub@linux.microsoft.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.17 747/849] tracing: tprobe-events: Fix to register tracepoint correctly
Date: Tue, 11 Nov 2025 09:45:17 +0900
Message-ID: <20251111004554.497407349@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 10d9dda426d684e98b17161f02f77894c6de9b60 upstream.

Since __tracepoint_user_init() calls tracepoint_user_register() without
initializing tuser->tpoint with given tracpoint, it does not register
tracepoint stub function as callback correctly, and tprobe does not work.

Initializing tuser->tpoint correctly before tracepoint_user_register()
so that it sets up tracepoint callback.

I confirmed below example works fine again.

echo "t sched_switch preempt prev_pid=prev->pid next_pid=next->pid" > /sys/kernel/tracing/dynamic_events
echo 1 > /sys/kernel/tracing/events/tracepoints/sched_switch/enable
cat /sys/kernel/tracing/trace_pipe

Link: https://lore.kernel.org/all/176244793514.155515.6466348656998627773.stgit@devnote2/

Fixes: 2867495dea86 ("tracing: tprobe-events: Register tracepoint when enable tprobe event")
Reported-by: Beau Belgrave <beaub@linux.microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Tested-by: Beau Belgrave <beaub@linux.microsoft.com>
Reviewed-by: Beau Belgrave <beaub@linux.microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_fprobe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_fprobe.c b/kernel/trace/trace_fprobe.c
index ad9d6347b5fa..fd1b108ab639 100644
--- a/kernel/trace/trace_fprobe.c
+++ b/kernel/trace/trace_fprobe.c
@@ -106,13 +106,14 @@ static struct tracepoint_user *__tracepoint_user_init(const char *name, struct t
 	if (!tuser->name)
 		return NULL;
 
+	/* Register tracepoint if it is loaded. */
 	if (tpoint) {
+		tuser->tpoint = tpoint;
 		ret = tracepoint_user_register(tuser);
 		if (ret)
 			return ERR_PTR(ret);
 	}
 
-	tuser->tpoint = tpoint;
 	tuser->refcount = 1;
 	INIT_LIST_HEAD(&tuser->list);
 	list_add(&tuser->list, &tracepoint_user_list);
-- 
2.51.2



