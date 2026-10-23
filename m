Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774733;
	b=deeYA4+dIrtLQq9u7JgMnU+uTvTJcLgfk9wJrZAH0R6AOQCjtpw06dsHNlnwRDgIMUun
	 RG49USDBXZ1f2MNWwilja1kVWgtoCHnE1BlU0cpMJKfilIh3r1NngBJWAbr+30r1Egz8S
	 NW8RlfcQJOZZUc2F9stVljmcaZiB+GbwVhxUkgjXHFSghbNrqDNe18w+AmH00p0jiyNS+
	 T/WGbQpoKpZdjg9ndudWp0mGduHb7Ohmj4a1X0JwtBARsPspx+l5aRb0Q/APSJ9t0ua8q
	 BhPnCguLw5C1K887IbLI83RXCv34Jv2QD1hRNo2k/BAQ6Z2aux/stPO8jQuw5yXEutQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774733;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VRmArm3hiUnpl4dDefsA28ZQla9ifzc0+eEJdnZ3ras=;
	b=AeAi33QXty+T+nJF/LBMQZM39D3PZMpvY9mgnEclME8IDWIBm+Ce+QZyn8aeaT0haVts
	 zZPTABOYlGAS0sWkp5ej6mcxGNO9vT3UDIjKtfJnIkiERG22Sinx5dweBhG4nReYB18Xw
	 tEuG40NMHqA9nh2YsxUL8BmieKeiQHnPzWqUJzE4Css3jvDfvK+mx/ULs6iJoOslbN3fR
	 BbIc+JSiloXtLemanQ7XyY52ozczEjEKdFOFaGEDAzjON/OKSNaXHiOddsxnvfBnOCCKS
	 S4i1rFWr6S1dcCHikqrh9xIR7IK5x5yPLZpNdNC8o2z3GGEvZI5A10nMR7mrJASeHgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SjqpO5dB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994CB606A31D;
	Fri, 23 Oct 2026 16:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SjqpO5dB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD71E1F01825;
	Fri, 23 Oct 2026 16:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774733;
	bh=VRmArm3hiUnpl4dDefsA28ZQla9ifzc0+eEJdnZ3ras=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SjqpO5dB50plMvIaOz6UeOPFitjetJXOoDBPAbt1yvvyvEkUkrRG76tst5EsspI6R
	 /RCn8aXfutIVtVgQaf+OFMDMOLkzTvMFLp7p+QyVNnC0Mhm5BI2LY5RmqYxYimKyTc
	 X1+oc+rmk+XwpHL+UPvtczklESO3Hijn3TWXfpVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	David Carlier <devnexen@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 141/242] ring-buffer: Do not show buffer_meta for CPUs without a buffer
Date: Fri, 23 Oct 2026 18:39:43 +0200
Message-ID: <20261023163717.113979488@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit 3f23cae09a4677a3f7c163a68388512cb231ff22 upstream.

The per_cpu/cpuN/buffer_meta files are created for every possible CPU,
but buffer->buffers[cpu] is only allocated once that CPU comes online.
Reading the file of a CPU that never came online dereferences a NULL
cpu_buffer in rbm_start().

Fail the open with -ENODEV when the CPU has no buffer, as the other
per CPU ring buffer interfaces do.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260914133506.4865-3-devnexen@gmail.com
Fixes: 950032ffcee7 ("ring-buffer: Add output of ring buffer meta page")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260913134906.6E8A01F000FF@smtp.kernel.org/
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2362,6 +2362,9 @@ int ring_buffer_meta_seq_init(struct fil
 	struct seq_file *m;
 	int ret;
 
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
+		return -ENODEV;
+
 	ret = seq_open(file, &rb_meta_seq_ops);
 	if (ret)
 		return ret;


