Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F3137883C;
	Thu, 30 Jul 2026 14:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422888; cv=none; b=qEMiRaq39FRmTeI7jZqrG2ls2E4Of7g48IyVhD1BDpgiqX47FwnAh1B8AWXcnWTTEDvEK/mUYFjUKenbUMheKQ2Do7fn+WLr1syX4FalIr5fmglTkNqofiJsUwEhrJBFN9yEvdCaFAwd8xZ4Zl+o4P0xTvexpHlMPs7uO1c2xRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422888; c=relaxed/simple;
	bh=5Ola0/6dSjjIYaWSnkRFMqULxRZvlWK06r8KUp2SOnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUi59FbuuXNDQJusEjXZWLEJu6XhSh08tzscEGTkWXEJjLhMhAGPFHAHWjqe8vxY/F+0pt+2qoKQjn3syDY0JyaLzZtX4CG9cPjVffR6etxxEREQCingGH8AGEWtQKsbUNOQEuEyokuVlX0x1DpQMQJw0JyQblk1oco/vWH5yho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MS5BbEZI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MS5BbEZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A621F00A3A;
	Thu, 30 Jul 2026 14:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422887;
	bh=db5IoQdcss4+TI9O5zblgfzo/LTUPtwVqdzannaggE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MS5BbEZIWzixDcD+P1GvY8dqQFARQ8wVkRpDjLMDZDsezwfEzkZsabbEariCLw/Qw
	 Q8mxvCxzQQ5sj7lPma2AV7AnHPGKZXaSf2YrbbsDEZ/39dc7oA5Ym9jRcdLiDM6WM4
	 No5tFbALmrwu9mLmkjJBcBoEkLX3sWvCimX2Kb6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.1 590/744] tracing: Delay module ref count for "enable_event" trigger
Date: Thu, 30 Jul 2026 16:14:23 +0200
Message-ID: <20260730141456.822152197@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit e091351b38818ef620d27f44f4bfd625f13afbff upstream.

Triggers are now delayed from freeing, but can still be triggered until
after the RCU grace period has ended. The freeing of the enable_event data
is put into the private_data_free() callback, but the put of the module
refcount is done immediately.

It is possible that if a module is removed that has an event that would
enable (or disable) it is still active, it can read the data of the module
after it is removed causing a use-after-free bug.

Move the trace_event_put_ref() that releases the module into the delayed
callback so that the module can not be removed until any reference to its
events are finished.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260724132415.1b5005db@gandalf.local.home
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260724030523.19081-1-devnexen%40gmail.com
Fixes: 61d445af0a7c ("tracing: Add bulk garbage collection of freeing event_trigger_data")
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_trigger.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index 46e60b70a4bb..ad83419cb420 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -1726,7 +1726,10 @@ int event_enable_trigger_print(struct seq_file *m,
 
 static void enable_trigger_private_data_free(struct event_trigger_data *data)
 {
-	kfree(data->private_data);
+	struct enable_trigger_data *enable_data = data->private_data;
+
+	trace_event_put_ref(enable_data->file->event_call);
+	kfree(enable_data);
 }
 
 void event_enable_trigger_free(struct event_trigger_data *data)
@@ -1741,7 +1744,6 @@ void event_enable_trigger_free(struct event_trigger_data *data)
 		/* Remove the SOFT_MODE flag */
 		trace_event_enable_disable(enable_data->file, 0, 1);
 		data->private_data_free = enable_trigger_private_data_free;
-		trace_event_put_ref(enable_data->file->event_call);
 		trigger_data_free(data);
 	}
 }
-- 
2.55.0



