Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D555624113C;
	Tue, 29 Apr 2025 16:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945318; cv=none; b=WZy9594dA/lFufOtqE0vJuWKhy39qyaFGXnqaqOyRS/1qdpFhcSCr1WL4U0MKqPor00J7v/RtlAlE6rFvZKIsnEGyd74OCnAs/tMWQcrZQ7aNV3jAp5DFDmUPHYk1jIX0Ba5hJ6O2/t5IKTBWdNWIJfKi7OyWlNCgdFqVM2Oyt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945318; c=relaxed/simple;
	bh=/6S3Oihm5iwiShRHHX8h3klnfZ2aP8Z9U4TIxA7l0N0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cMYdG8oLQc66oz5UnNuh9PD9imDesthvOp2cLd4gc3+pDLTe4PhlhGy99lgkGPl4lgmIg9kI89qIJtzTSlQT4Lrf5e+Fx/19nO2SAHzNq6C9nNJ/9KriCx0qRAHyHOMHeccnNzBRHTWuTQFof8OklozyeeR5KaOBh1HpXtJ6z58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oWm2kM4R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oWm2kM4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C6DC4CEE3;
	Tue, 29 Apr 2025 16:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945318;
	bh=/6S3Oihm5iwiShRHHX8h3klnfZ2aP8Z9U4TIxA7l0N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oWm2kM4Re6j+O5H7ZhkOGQgVCW4EvpuWkXd1XpEEe3vG4fAkpCjrU4N1IjwlSW3V6
	 plBMrMduEb6ODhcYzYKSeZ4wWcW58M8OUhNpTqBlPva2WnKiWcvM/1kr9uaEy66Q90
	 2cRGKGOGpC685fAOD7qDKRQcp3tUUB+nkI7n+iTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhoumin <teczm@foxmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 072/179] ftrace: Add cond_resched() to ftrace_graph_set_hash()
Date: Tue, 29 Apr 2025 18:40:13 +0200
Message-ID: <20250429161052.328842589@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: zhoumin <teczm@foxmail.com>

commit 42ea22e754ba4f2b86f8760ca27f6f71da2d982c upstream.

When the kernel contains a large number of functions that can be traced,
the loop in ftrace_graph_set_hash() may take a lot of time to execute.
This may trigger the softlockup watchdog.

Add cond_resched() within the loop to allow the kernel to remain
responsive even when processing a large number of functions.

This matches the cond_resched() that is used in other locations of the
code that iterates over all functions that can be traced.

Cc: stable@vger.kernel.org
Fixes: b9b0c831bed26 ("ftrace: Convert graph filter to use hash tables")
Link: https://lore.kernel.org/tencent_3E06CE338692017B5809534B9C5C03DA7705@qq.com
Signed-off-by: zhoumin <teczm@foxmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5506,6 +5506,7 @@ ftrace_graph_set_hash(struct ftrace_hash
 				}
 			}
 		}
+		cond_resched();
 	} while_for_each_ftrace_rec();
 out:
 	mutex_unlock(&ftrace_lock);


