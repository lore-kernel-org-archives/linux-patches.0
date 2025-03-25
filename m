Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593A3E55B;
	Tue, 25 Mar 2025 12:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905916; cv=none; b=qcV4u4Tm81pdFgpb/PviKu4uvx1lxj4iwFSAWvYZLgVDSUugYuII+L5bd7K/dm+j9w+nvsfGCMoh7NiLltufJ6Txsz5xE/qZd4knkBcsC9Yn1fF5/NbXX0uZZtscUyAg8YaFm1IkqtyYcUjSsxNU436skebnt/rA3SQPaQ1mgHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905916; c=relaxed/simple;
	bh=KkzaCYxuZeiTtA0MJRVc4bFzkwhRg8ZXOKM+EevjYXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MN9Oqpn7VE++Zf35URAWf+MqoLxcvHlj4BwzDHD/smeFb2DLYBIfhOxaMmREMHTDu3gZKmno5bWxNCWf0f0wknasCHBS5sMLTd+Z+tSjrGfQicGQmL8wjwzwlqvg19Vr8x3NKJb2S5TLnIOfORq8EVn0knUkaR+qQ45kB7U1mFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LgDSo4ua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LgDSo4ua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E158C4CEE4;
	Tue, 25 Mar 2025 12:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905916;
	bh=KkzaCYxuZeiTtA0MJRVc4bFzkwhRg8ZXOKM+EevjYXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LgDSo4uaTTK0yWCl/AsObltC6c7BwuCguvVoHQ80gx6wtyi6hDEFSC65LpMemAbW0
	 6NL1zmYtPYR6QCpkc+7e6iQTEXWebRfXxSt89M675w04bhv5p2AGneZIzn8xpHRGwi
	 QNk810P85UjxWZmBC0dr5skDo7T+h8vRUfvgrJZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 035/119] tracing: tprobe-events: Fix to clean up tprobe correctly when module unload
Date: Tue, 25 Mar 2025 08:21:33 -0400
Message-ID: <20250325122149.959737496@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



