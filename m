Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCECA1C84DE;
	Fri, 10 Oct 2025 13:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102393; cv=none; b=hlk99rnS84FLyahbkdn0/v2etLvksP2+EHyHxR0uw6/ztLg+67QlajJjKBMvK9147Hwvdf9h3/u/XVJKHmB/+yUevWTbPUlC2Xiybsklgq5P1y3AYl83c4eA6IK1KNBJ+GN6I0oCnIM26vyK4w6oQbd+08AA+9TR+B1zEM8qun0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102393; c=relaxed/simple;
	bh=s2vBnt+KaDr1AXd7p/ZlELPpv4Y+hEuF0N1xmU2aj9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I09T/DF0wdAMZcrTlsaowsnx13t0SQ4KAGwVHnZ2Xj1FOTJxXK4pR6ht4Z1bqI4OV83qhgPUfo8zq2UUsfNLg1kHuS9Y5J2bTkkDMMBCbgbkDhfdWCUJo1hYYBBS+6LYCJEyF9rlRLFwh3wwTruAHFifST60WEG8xUvwalWIeek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=va9EaytC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="va9EaytC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444E2C4CEF1;
	Fri, 10 Oct 2025 13:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102393;
	bh=s2vBnt+KaDr1AXd7p/ZlELPpv4Y+hEuF0N1xmU2aj9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=va9EaytCdG6j0nnLuX3nZLGfm2nbfzCyQhsVEI6H3lso06Y5H+0C35UGv0kGPTJBD
	 J9oAxliFvmAKJusU8V+b4LczOm9g/K+BV8R2UIWpPshuVvrA2ceeZVJ63qTWH4DBto
	 LaVA2mGKdHHVwM5DxPktjPMffTLt+uqRsJmD8smc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	syzbot+ddc001b92c083dbf2b97@syzkaller.appspotmail.com,
	Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.16 41/41] ring buffer: Propagate __rb_map_vma return value to caller
Date: Fri, 10 Oct 2025 15:16:29 +0200
Message-ID: <20251010131334.890825324@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>

commit de4cbd704731778a2dc833ce5a24b38e5d672c05 upstream.

The return value from `__rb_map_vma()`, which rejects writable or
executable mappings (VM_WRITE, VM_EXEC, or !VM_MAYSHARE), was being
ignored. As a result the caller of `__rb_map_vma` always returned 0
even when the mapping had actually failed, allowing it to proceed
with an invalid VMA.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20251008172516.20697-1-ankitkhushwaha.linux@gmail.com
Fixes: 117c39200d9d7 ("ring-buffer: Introducing ring-buffer mapping functions")
Reported-by: syzbot+ddc001b92c083dbf2b97@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?id=194151be8eaebd826005329b2e123aecae714bdb
Signed-off-by: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -7180,7 +7180,7 @@ int ring_buffer_map(struct trace_buffer
 		atomic_dec(&cpu_buffer->resize_disabled);
 	}
 
-	return 0;
+	return err;
 }
 
 int ring_buffer_unmap(struct trace_buffer *buffer, int cpu)


