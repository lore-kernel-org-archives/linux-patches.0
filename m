Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426ED612D7;
	Tue, 20 Feb 2024 21:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463577; cv=none; b=mUTIqQrBDov7S3b9E4+ehY1MqOL2N3vzJfe4xLVA6R+HV4a0zdzjIC/A9ta8oe6o7Xef+JjruYc5IEeRU3SHSTHQRY2BFDsFUpXjsG2uOIy/3q5Qur6hH7d5BZr/RgaRcTuiWEyP8rO1o977yVmojxZht7JRAQ4qo5fxtwOAUTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463577; c=relaxed/simple;
	bh=9rlQKsCwH/NIzURY1j0dHlFWwhDYvH51Tj1nLIcUqhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWqSi7Mgp3/fieUyUVncGcxH/ahmGblbVFFBLfzsEgOOD0X3cTRYqNT2irAwp43UBqBo5Qhn7GXRyyHFtwm3kIljk8WCjYZ1Pcs+vjLVaEY4jaaU3Td+ZESiO2/Uy7+j0R63R7L/8QTLWBPIQuTmYv5hGijasw8SOgmzM5+6iAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rcBP0M0r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rcBP0M0r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77A0C433C7;
	Tue, 20 Feb 2024 21:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463577;
	bh=9rlQKsCwH/NIzURY1j0dHlFWwhDYvH51Tj1nLIcUqhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rcBP0M0rPETQXDi0N+eGdY0G01QvW3Hp9Y5Qx1DtVA36cFxQzd1Qg+hKVra+8cWFL
	 TLymXdhtIDmXXiXUHjfHUSTPDpintW3fQwOTJ/FOJLZSr53DxkUymTnV+Xy0ApAxrK
	 aOjr8uFzbe1lLCoPuWkGsCJgs1oIBfdQjbo3bzFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 058/331] tracing/trigger: Fix to return error if failed to alloc snapshot
Date: Tue, 20 Feb 2024 21:52:54 +0100
Message-ID: <20240220205639.415802874@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 0958b33ef5a04ed91f61cef4760ac412080c4e08 upstream.

Fix register_snapshot_trigger() to return error code if it failed to
allocate a snapshot instead of 0 (success). Unless that, it will register
snapshot trigger without an error.

Link: https://lore.kernel.org/linux-trace-kernel/170622977792.270660.2789298642759362200.stgit@devnote2

Fixes: 0bbe7f719985 ("tracing: Fix the race between registering 'snapshot' event trigger and triggering 'snapshot' operation")
Cc: stable@vger.kernel.org
Cc: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_trigger.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -1470,8 +1470,10 @@ register_snapshot_trigger(char *glob,
 			  struct event_trigger_data *data,
 			  struct trace_event_file *file)
 {
-	if (tracing_alloc_snapshot_instance(file->tr) != 0)
-		return 0;
+	int ret = tracing_alloc_snapshot_instance(file->tr);
+
+	if (ret < 0)
+		return ret;
 
 	return register_trigger(glob, data, file);
 }


