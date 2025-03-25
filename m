Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA5F25D91C;
	Tue, 25 Mar 2025 12:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906333; cv=none; b=d9flcyCuRX1PMibHvHLxNgr/kxpc3OiEAqe25iqQn4v8qnRNqpSGNIze8b682fEOw05OHYiYYlH7aTOuiaN6XQTZEhCaIEiGxaan69aE80TpfTFbDGeSevXKeBHRJ5IcTfua5tYJRZib8sn+TC0qYNIedwXPX3l30/YWNza9f9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906333; c=relaxed/simple;
	bh=umdlJZoNZRZO+NGUKKz6ubV86vC9uSs3VUnogpWAqtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPe8CZLrfsBH7PoXhrSQOu1cV/Nx3SvJJphHrkZ/7Gi73x2DVuF8UilzHMK6AIQ0oiQ1znkFOCHZTFZLUqtmbIHPOz9z4FJH8SEfw7QHCCHVpuEv9ozNigoolhQbSBqZlchxbQwy7EFqIXzAJuEzgnbjcdoTMvRODLC0R3fFJKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tTsiYzBU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tTsiYzBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA35C4CEE4;
	Tue, 25 Mar 2025 12:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906332;
	bh=umdlJZoNZRZO+NGUKKz6ubV86vC9uSs3VUnogpWAqtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tTsiYzBUjw0gsznsKE7KnIdK9RLFGGYGWEl8mweJaCZsK3eIAD3fE92lupOvdoQXL
	 s2576Qhzgd5mQbThmStA2K2VBCH7Uimn3GFwYx0y5Q1XyuXtwubQq+KJ4l+rStweLj
	 KGo+6WsT5PXEEi/lp34DO+5L2/fuvOnefYZyqQwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 034/116] tracing: tprobe-events: Fix to clean up tprobe correctly when module unload
Date: Tue, 25 Mar 2025 08:22:01 -0400
Message-ID: <20250325122150.084780669@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 0a8bb688aa824863716fc570d818b8659a79309d ]

When unloading module, the tprobe events are not correctly cleaned
up. Thus it becomes `fprobe-event` and never be enabled again even
if loading the same module again.

For example;

 # cd /sys/kernel/tracing
 # modprobe trace_events_sample
 # echo 't:my_tprobe foo_bar' >> dynamic_events
 # cat dynamic_events
t:tracepoints/my_tprobe foo_bar
 # rmmod trace_events_sample
 # cat dynamic_events
f:tracepoints/my_tprobe foo_bar

As you can see, the second time my_tprobe starts with 'f' instead
of 't'.

This unregisters the fprobe and tracepoint callback when module is
unloaded but marks the fprobe-event is tprobe-event.

Link: https://lore.kernel.org/all/174158724946.189309.15826571379395619524.stgit@mhiramat.tok.corp.google.com/

Fixes: 57a7e6de9e30 ("tracing/fprobe: Support raw tracepoints on future loaded modules")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_fprobe.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_fprobe.c b/kernel/trace/trace_fprobe.c
index 99048c3303822..092c31907c71a 100644
--- a/kernel/trace/trace_fprobe.c
+++ b/kernel/trace/trace_fprobe.c
@@ -977,10 +977,13 @@ static int __tracepoint_probe_module_cb(struct notifier_block *self,
 					reenable_trace_fprobe(tf);
 			}
 		} else if (val == MODULE_STATE_GOING && tp_mod->mod == tf->mod) {
-			tracepoint_probe_unregister(tf->tpoint,
+			unregister_fprobe(&tf->fp);
+			if (trace_fprobe_is_tracepoint(tf)) {
+				tracepoint_probe_unregister(tf->tpoint,
 					tf->tpoint->probestub, NULL);
-			tf->tpoint = NULL;
-			tf->mod = NULL;
+				tf->tpoint = TRACEPOINT_STUB;
+				tf->mod = NULL;
+			}
 		}
 	}
 	mutex_unlock(&event_mutex);
-- 
2.39.5



