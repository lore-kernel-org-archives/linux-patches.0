Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE90187325;
	Tue, 10 Sep 2024 09:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961423; cv=none; b=KirUlC1mejq48mYB4OUdUlIuFL/PBr7M+K/PKFW1Uzb/+duVolqks3cM+ZmXOmAqVIGE2aHIOyizeJQ+tJMj2Ck/y/Hf5EjznZAyUD7S+hPMObCHffuBnJF3ed7nQdaVEbiT5WIH/doM3PwcUw0pQjv/J1I8UgHqVQDPXBshq04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961423; c=relaxed/simple;
	bh=dJUq9hzOtDwq+MdVK8Yw2jBY79lDjNeoNETPAX4fgKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lwneTIq7g/DsAfN7+8NQFIaGML+XDDEK8OIJMN5zUh8I64SDbB6B57/GQuEqE4vXNdJ0Ft1F+j5gik70QBb5HPQfozO+OuHMEIShACIUF3hsZMoXUcc4qzXMVA7aWNuH6dQfydG7MsKOYYgNZbPRZCrGOuks9F3w9GPnLcpGhTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gpd+78h4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gpd+78h4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1549BC4CEC3;
	Tue, 10 Sep 2024 09:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961423;
	bh=dJUq9hzOtDwq+MdVK8Yw2jBY79lDjNeoNETPAX4fgKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gpd+78h4AU3z6M5Rn3FxXvfLRx+9omET1+zOck4NgRnauilVM1G1Mb9Zqum9hYu2v
	 WNs9Wy1HjhmzyQaNkhssTuunJP/ARSKklVUxkN7eH+m0Jjf49bp1LHRDROYnX/9T+t
	 wXLe06Y/cAjUsLqaUPpvr4S/ADSU0R8m8CNHI+ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Zheng Yejian <zhengyejian@huaweicloud.com>
Subject: [PATCH 6.10 064/375] tracing: Avoid possible softlockup in tracing_iter_reset()
Date: Tue, 10 Sep 2024 11:27:41 +0200
Message-ID: <20240910092624.370308978@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Yejian <zhengyejian@huaweicloud.com>

commit 49aa8a1f4d6800721c7971ed383078257f12e8f9 upstream.

In __tracing_open(), when max latency tracers took place on the cpu,
the time start of its buffer would be updated, then event entries with
timestamps being earlier than start of the buffer would be skipped
(see tracing_iter_reset()).

Softlockup will occur if the kernel is non-preemptible and too many
entries were skipped in the loop that reset every cpu buffer, so add
cond_resched() to avoid it.

Cc: stable@vger.kernel.org
Fixes: 2f26ebd549b9a ("tracing: use timestamp to determine start of latency traces")
Link: https://lore.kernel.org/20240827124654.3817443-1-zhengyejian@huaweicloud.com
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Zheng Yejian <zhengyejian@huaweicloud.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3958,6 +3958,8 @@ void tracing_iter_reset(struct trace_ite
 			break;
 		entries++;
 		ring_buffer_iter_advance(buf_iter);
+		/* This could be a big loop */
+		cond_resched();
 	}
 
 	per_cpu_ptr(iter->array_buffer->data, cpu)->skipped_entries = entries;


