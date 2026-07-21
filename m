Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867993B52FF;
	Tue, 21 Jul 2026 21:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669834; cv=none; b=sKaX98th0tYLW3nEa9rpH9yHKzDKXDr7G/kx3dGGCV4qSKTVZD29uuLSb7dZNIZMws9Dhykd+Lqc7KGald6aj8b71YscQbMXFu0jcK9q+DtyYJqL8zE3hutER9DY9sDAnDpVosuWZOq/u8lJwIwb150ncvtJeY+ULeWAVP4cavw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669834; c=relaxed/simple;
	bh=7PeTA65knHvmadQoEp7dAmuqXpDdG1xBBzAm3HGLMyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ka2VJfEp8mjeHoNzyVun5s/ZdCaY9S6PiEF23jBMTfqWyIk1o9JZEYTmUGO/j2thhGLTRgiNIcTFpbkMkJfAu/pZEgR91F0s2ROfrClEOBTIasahiZB+XWv3zQfbDYKO6eWylc9w8DQ9osqt96h5i53gknIh2hEt0h9geGB4G/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t6nlgDXH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t6nlgDXH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E443C1F000E9;
	Tue, 21 Jul 2026 21:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669833;
	bh=A5t5imh23uubfHuIJrvquAUbMZzC4potagqGYOtxx4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t6nlgDXHaByKWB77Z5QucEcM3b95C37Lnb31NYZ/93SAhxow1DOxmpvwbWUOsnfcD
	 zKcGCWJFUEy09vncYACU4E4+UpHWzJQE9YrghAEj9qYxHkVB/PNFfDYaM2vT5ulioN
	 a5D7Tb6H57od7hUKp4D4EDmvqJLTy/u9XxkIjp3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0661/1067] tracing: eprobe: read the complete FILTER_PTR_STRING pointer
Date: Tue, 21 Jul 2026 17:21:02 +0200
Message-ID: <20260721152439.382352164@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Kaiser <martin@kaiser.cx>

[ Upstream commit 206b25c09080cc20fd4c2bea12d59df4b7ba2121 ]

For a char * element in an event, the FILTER_PTR_STRING filter type is
used. When the event occurs, a pointer is stored in the ringbuffer.

If an eprobe references such a char * element of a "base event", the
stored pointer is truncated when it's read from the ringbuffer.

$ cd /sys/kernel/tracing
$ echo 'e rcu.rcu_utilization $s:x64 $s:string' > dynamic_events
$ echo 1 > tracing_on
$ echo 1 > events/eprobes/enable
$ sleep 1
$ echo 0 > events/eprobes/enable
$ cat trace
   <idle>-0  ...: (rcu.rcu_utilization) arg1=0x4f arg2=(fault)
   <idle>-0  ...: (rcu.rcu_utilization) arg1=0x2 arg2=(fault)

The problem is in get_event_field

	val = (unsigned long)(*(char *)addr);

addr points to the position in the ringbuffer where the pointer was
stored. The assignment reads only the lowest byte of the pointer.

Fix the cast to read the whole pointer. The output of the test above
is now

<idle>-0 ... arg1=0xffffffff81c7d3f3 arg2="Start scheduler-tick"
<idle>-0 ... arg1=0xffffffff81c57340 arg2="End scheduler-tick"

Link: https://lore.kernel.org/all/20260620145339.3234726-1-martin@kaiser.cx/

Fixes: f04dec93466a ("tracing/eprobes: Fix reading of string fields")
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_eprobe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_eprobe.c b/kernel/trace/trace_eprobe.c
index 2a75cf3aa7bf88..66ad0b70c6c17d 100644
--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -340,7 +340,7 @@ static unsigned long get_event_field(struct fetch_insn *code, void *rec)
 			val = (unsigned long)addr;
 			break;
 		case FILTER_PTR_STRING:
-			val = (unsigned long)(*(char *)addr);
+			val = *(unsigned long *)addr;
 			break;
 		default:
 			WARN_ON_ONCE(1);
-- 
2.53.0



