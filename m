Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72742F6196;
	Fri, 10 Oct 2025 13:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102273; cv=none; b=jYNRTrP6z0pUwHp21rK17YEqL9qjPE1fdsTdMXmOIIvTMrsi68aVHJCwup3d5tEc8uqYVkGUA2oYJkvSOm89NHBj4U5Ag0hyU3DADSTxNgm2RPe3BthQELhGvKGgwG6fab0tp4OrGNUdzLm1dex6nswl7hZFpGXP4W+d2I0F2jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102273; c=relaxed/simple;
	bh=ezmHTRoZz+VW30TmnIyZK81IPq3A8KqWQu8V0W2fYbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GIOuRrDQcwdU4FjRdZ4fXl+C7bsF0RtbSZ4Jhk4trJGC/13V2j1jCnBGjDpTb0/8Lm6KkOqu0v9vxRmyzBCHTNdOpaZiffuDFTYCOCxDuN/yjDfq4m8h1VkFI9oUye4WYAYDTMvpmT07Jz4P3j+B9LDMQF9Y60bn3qwI5M9YJ7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pwcd3/3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pwcd3/3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038C0C4CEFE;
	Fri, 10 Oct 2025 13:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102273;
	bh=ezmHTRoZz+VW30TmnIyZK81IPq3A8KqWQu8V0W2fYbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pwcd3/3kXRShPDkeWQbreSJmMNCNeif1zGqbCDECOXsydLzwUvw15nmT0bYrUfdfg
	 M9gnlKX4tPN+WGT9vzYZP1M/YMsrT+DSehEemdTVNE2+F7h0LVnB+UsJKxyoKvFNzJ
	 Y86vLQnECsm7Vgi3fUfG7ZkcplFccc2hffEhmyEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	syzbot+ddc001b92c083dbf2b97@syzkaller.appspotmail.com,
	Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.17 26/26] ring buffer: Propagate __rb_map_vma return value to caller
Date: Fri, 10 Oct 2025 15:16:21 +0200
Message-ID: <20251010131332.156305992@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.204964167@linuxfoundation.org>
References: <20251010131331.204964167@linuxfoundation.org>
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
@@ -7273,7 +7273,7 @@ int ring_buffer_map(struct trace_buffer
 		atomic_dec(&cpu_buffer->resize_disabled);
 	}
 
-	return 0;
+	return err;
 }
 
 int ring_buffer_unmap(struct trace_buffer *buffer, int cpu)


