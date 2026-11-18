Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041866;
	b=FsZZuz8pWxwJ+7SDhu4NPoRgh9BgZokcGto88xbd9ddFD3bow0gqbCBojJAaWFq4A8c7
	 1dOcJgsr/FR/YBoEF5afsgFyEzXyHFe8HznX+GJrMEv/41fb98iit9ogYw20ACxtveAKq
	 Inb5Vh+VChuLZ8CEcyE/G4pUDexu0i5Z6S8m+fcWltMdJx9E31zmbgvTbio8hEiYOdfm4
	 9qyLQIBqBvzuQCmsVE7Ex5rBF124wdl6Dev2c+ZPyVKvU05jxnPLb7MOYIR+LPXMVSYmP
	 xTgCVu1/HmDLXfJ+LjS1VsAo+4jRDo+Kr5NY9jlPAiZsMZNKjKPJiSVeXcKvdlegZcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041866;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T4tw2pnhJ/GXYeOAxPkPBnpxB5v8ygZ6vs0oDGkcOCU=;
	b=oXFsl+D0JitzJaJJOJFpduIBuSLTG7xrm0qFtjj5kVf0b8fsmbNJKxcNBu2e+AuKujd7
	 sLpcun+hIh8a4Jp8HFLrBFQQKBCjhmJybIAnGZT9fmHJxb3diSLf1L+eNvgSb4aphGLMX
	 LjVyhE2GVKSEEboM179BqzpmKLkLQulV8f6omhtbdlv+iPz8oJzSubDVhlNpsPDrFnF7C
	 9M6ZZN1W7B3umC/JZEn8mAXOdKdWEbT4UBdPWrkmC7ZIYd2OeygYFGD3ZSp8Vrma9WxLB
	 86lHVJAqdqpaj/gypCa4AFUbBkqNyLePcb/Rc18q3b/5AV++/Srku3hmDVGkAuzBvMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DSML1Yaj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B709606A32A;
	Wed, 18 Nov 2026 22:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DSML1Yaj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED8F1F000C4;
	Wed, 18 Nov 2026 22:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041866;
	bh=T4tw2pnhJ/GXYeOAxPkPBnpxB5v8ygZ6vs0oDGkcOCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DSML1YajXBrstZAEmPNc9mEYD0zCnWqB/0Pin33LyUexZPm8LPDbuu8UxpzzHiEb8
	 BppWH535/XIXxXJjH13hsUZVmyWIshdZk8N+uatNB86DwpoE9ysyAB/+DIcK3JPUQp
	 ZHNGKjJK2VMXJop3hpESEgJqbWE5cyWyE5nuSPqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2965/3318] tracing: Clamp the printed end of a histogram bucket at U64_MAX
Date: Wed, 18 Nov 2026 15:59:47 +0100
Message-ID: <20261118150449.241798752@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

[ Upstream commit 289e2a775de434ccab2d107076bc78362ce288bd ]

A key with the ".buckets=N" modifier is stored as the start of its bucket,
and hist_trigger_print_key() prints the range it covers as start to
start + N - 1. That addition overflows once the start is within N of
U64_MAX:

  # echo 'hist:keys=offset.buckets=10' >> \
      events/syscalls/sys_enter_lseek/trigger
  # ./seeker 5 -1                      # lseek(0, 5) and lseek(0, -1)
  # cat events/syscalls/sys_enter_lseek/hist
  ...
  { offset: ~ 18446744073709551610-3 } hitcount:          1
  { offset: ~ 0-9 } hitcount:          1
  ...

18446744073709551610 + 10 - 1 does not fit in 64 bits, so the range ends
below where it starts.

The bucket does end at U64_MAX: it holds every value hist_field_bucket()
maps onto its start, and there is no value above U64_MAX. Clamp the printed
end there. Printed honestly the group is shorter than the size asked for,
which histogram.rst does not mention, so say it there.

Link: https://patch.msgid.link/20260914132346.2234731-1-donggeunyoo.kernel@gmail.com
Fixes: de9a48a360b7 ("tracing: Add linear buckets to histogram logic")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Assisted-by: Claude:claude-fable-5
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/trace/histogram.rst | 3 +++
 kernel/trace/trace_events_hist.c  | 7 ++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/Documentation/trace/histogram.rst b/Documentation/trace/histogram.rst
index 3c9b263de9c24..1f4ca14c25802 100644
--- a/Documentation/trace/histogram.rst
+++ b/Documentation/trace/histogram.rst
@@ -1943,6 +1943,9 @@ the ".buckets" modifier and specify a size (in this case groups of 10)::
       Entries: 16
       Dropped: 0
 
+Keys are 64-bit, so the group holding the largest values is truncated where
+that range ends and can be smaller than the size asked for.
+
 To save stacktraces, create a synthetic event with a field of type "unsigned long[]"
 or even just "long[]". For example, to see how long a task is blocked in an
 uninterruptible state::
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index c3fb3cc447e31..1c8e42716b76d 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -5548,9 +5548,14 @@ static void hist_trigger_print_key(struct seq_file *m,
 				   *(u64 *)(key + key_field->offset));
 		} else if (key_field->flags & HIST_FIELD_FL_BUCKET) {
 			unsigned long buckets = key_field->buckets;
+			u64 end;
+
 			uval = *(u64 *)(key + key_field->offset);
+			end = uval + buckets - 1;
+			if (end < uval)
+				end = U64_MAX;
 			seq_printf(m, "%s: ~ %llu-%llu", field_name,
-				   uval, uval + buckets -1);
+				   uval, end);
 		} else if (key_field->flags & HIST_FIELD_FL_STRING) {
 			seq_printf(m, "%s: %-50s", field_name,
 				   (char *)(key + key_field->offset));
-- 
2.53.0



