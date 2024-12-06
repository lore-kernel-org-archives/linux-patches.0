Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D3514D29D;
	Fri,  6 Dec 2024 14:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496064; cv=none; b=ComhPcd+DyOj5uXhP8Xt5NaC5zUM52Ndu8YV7Fel2pr1JeuO1Pg2/tfa6khsQWtiS8i9GpmpNyZNgJaMGH0OSHqEtmUnSGQ/c7LB+RzNi6OST3G7ZgpiDcBNSd1zZj55wT90feGLxCeWjwzOQLrhmMoy/MFDDbcwhl9LiHi8cEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496064; c=relaxed/simple;
	bh=g0vTPuuL/rw5JnH6weiuKPy+Bd+8ZCC9LPqd8PsO0AU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CoZsUfqI3mJA2KD866acW5YsJ+4j3r9sXJCiifJLKn5zOAohdYAo2pGifZE+TX0HvORhIW0WfGdL7sKoiYqmY3o9WLRK1wu8TMwYefBLU4tfami/EYcyyTQwFfs70DB2yBlkSF00TsLcVgWe7tFQLsGlrY2vKFKEinGgIzEEr9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MNHYJ8+W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MNHYJ8+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C025C4CEDC;
	Fri,  6 Dec 2024 14:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496063;
	bh=g0vTPuuL/rw5JnH6weiuKPy+Bd+8ZCC9LPqd8PsO0AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MNHYJ8+WjKAurmL4vHceaJpJXnLFKHpLXZPfIwOsfSxjFokfks5Hh/13h/WRexgxn
	 VwVJYNzSfqRm8rUcmFHBz2hKy81pAfS/qB2bwAdUM+mSIdc9eEoWvquZU0rZOA4jUA
	 fSl2bHrkRyK3XkdrD6GjwM7POid5SfPSuqx06Ibc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 040/146] tracing: Fix function timing profiler to initialize hashtable
Date: Fri,  6 Dec 2024 15:36:11 +0100
Message-ID: <20241206143529.208787109@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit c54a1a06daa78613519b4d24495b0d175b8af63f upstream.

Since the new fgraph requires to initialize fgraph_ops.ops.func_hash before
calling register_ftrace_graph(), initialize it with default (tracing all
functions) parameter.

Cc: stable@vger.kernel.org
Fixes: 5fccc7552ccb ("ftrace: Add subops logic to allow one ops to manage many")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -883,6 +883,10 @@ static void profile_graph_return(struct
 }
 
 static struct fgraph_ops fprofiler_ops = {
+	.ops = {
+		.flags = FTRACE_OPS_FL_INITIALIZED,
+		INIT_OPS_HASH(fprofiler_ops.ops)
+	},
 	.entryfunc = &profile_graph_entry,
 	.retfunc = &profile_graph_return,
 };


