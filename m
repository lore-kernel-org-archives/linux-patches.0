Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB4619E810;
	Tue, 10 Sep 2024 10:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963570; cv=none; b=n72WpaeKHROeWHV6kDq9GnNM/iDEif4qzo19+/4Tt+W0N4cqrIae1EQeYl3EALYYcKaBi2Tc6sP3vMTxS3TrkFGAF9QMz6XTWVmnz71zzbVYLBh/zp+2WQIqV6vpzw1BK/qdywNlLMN/QoP9Gto/TUTC/aOm0I12sWmB8IeNN0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963570; c=relaxed/simple;
	bh=sWiH8vE6WK8zEpzxGjwHHT3/pwqNwz8ipKbdC5mTagE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BX4V2XzzvNjbRMm4pn8TGLuFFzASk5ageFfA0LN01mjYuE6YBCHFyVZC/1uX0IAtqn2BkQTrMQkcDw+cKZLgii/VL7/6ubYVZDB3byW1XI95GjfkXvaW86N5nu3gkh1PLuc+5Ya+zBObKo+y0aAOfvuh8U/xAYnu9RI/hJASoM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uCmjDIB5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uCmjDIB5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0B5C4CEC6;
	Tue, 10 Sep 2024 10:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963570;
	bh=sWiH8vE6WK8zEpzxGjwHHT3/pwqNwz8ipKbdC5mTagE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uCmjDIB5s8bLZ6EPRdkraH4dqV1Izv1h+BFGCEIhKBoIEBKIAftb8Eabigt/nWSlD
	 ExOpdA44jMPeWOVrr3COlU0fyq/0wj8EfKcrMI23/50svAiz/fYQrs+c0sPsLBQLVu
	 jsm5BoIxaPMaVnbPyig4iojamh2bq0hf3Q9tgx0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Zheng Yejian <zhengyejian@huaweicloud.com>
Subject: [PATCH 5.15 085/214] tracing: Avoid possible softlockup in tracing_iter_reset()
Date: Tue, 10 Sep 2024 11:31:47 +0200
Message-ID: <20240910092602.226833026@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4068,6 +4068,8 @@ void tracing_iter_reset(struct trace_ite
 			break;
 		entries++;
 		ring_buffer_iter_advance(buf_iter);
+		/* This could be a big loop */
+		cond_resched();
 	}
 
 	per_cpu_ptr(iter->array_buffer->data, cpu)->skipped_entries = entries;


