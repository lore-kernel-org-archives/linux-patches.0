Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B23B3AF676;
	Tue, 21 Jul 2026 20:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666793; cv=none; b=QwMoc1vj593rLRig25EENRX40ppBjSkgCvrvjYInXYDJwO3wjq8XMgk2QlZnFJpqCvcqd8U+D4wRAH7axSjevFxkk88ittoUzFVaQBobuHQmqLDEW8NMFgYsu2SqFYx7RQ6StVdDL6EV46ESlep4SeWOif3C8QflWi3QGI1fXx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666793; c=relaxed/simple;
	bh=NbDNTygPKY/92Ul581/+kXNgNanJW8ErpPuUUD2ZAOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dfen2tHgdJHxcgjccrn/wmbDBF5r8WhsoUchuQjMh3s5E+Se/lR97IbbnTIQVEDUxXF4nzzDAFavjp08TZOtxbDYehSDfFW1ovpF40a6xF/vLYYeVkeYrWryO520pGDdk7iwb7IoLkXOz0YsyhUGM/VRT9TUVeaFopl8Ge15k58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l5kV0zK8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5kV0zK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36411F00A3D;
	Tue, 21 Jul 2026 20:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666792;
	bh=HFljfF+Au0Ao2zeIFE0iNB3Uxn0gctMw2qoz040/Odg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l5kV0zK8C+SZl9UMDpL8fo5iwHYvVQYLMDvTuHD+ooqlAtooEKzxGnb00PxjShHKZ
	 qlt46RQtPtmkfd60oOCAKAAuV4zx/EkZyTzkMK1OXmgpmOTMFgZvhnjQ5rSvf4XI8b
	 +Y4BZKopCo/nrsS6aAT224jChML3YPmgV6cKOJAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0816/1266] tracing: eprobe: read the complete FILTER_PTR_STRING pointer
Date: Tue, 21 Jul 2026 17:20:53 +0200
Message-ID: <20260721152500.118880137@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f1f12ce5efb0ab..6330d25ac6536e 100644
--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -314,7 +314,7 @@ get_event_field(struct fetch_insn *code, void *rec)
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



