Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020737;
	b=PhpH4YbBDY1ukKTF1xb7nOV+PPsMsxG5s/qigQYCT+PMdUPni2L/4OqGfzktbJIhA6vN
	 7Kyk1zM/7yGJRitJzGkYLvNZchdYON8W0E9n7FJhGOgKcV2xXqIMyxtxHKesiHy2GybN/
	 Lb37Xq2FNUPakFcPlmIjny2CWUZaXSB2jH3r7+kpBic5/sqNI6XIL9mXv/M+GvFX9MGAJ
	 cOU6dMcH4yjdvSdWaxvDCLFCrKMaduYorcxQ+ABcOSH2J00l0tL/1JTcmozOnsVGI9TfV
	 axSReQ1t+AMMaAE/0Rpg3B/XCD926v2SVGr2CWSnReRFNG2W0rXQEZjVlGe5jgxQ75Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020737;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6wwQBsRQg4DVms2lnQx17dWqXgY3Lwfma4Kkb2I3ns0=;
	b=V37X/CPD7D6BOl8nHUfqA95R+C46IhVWaNTq6GY/AOMpCBDC63gXH6B9O9L3gzMR0JYv
	 3wnfyEn173oFutwQsOsBY8gEfix44nRisbIGMYxzsoJuGYNQxROiDjhGbrQGbzC0yJ5bh
	 UChYUFYn3ZWwa/dPN2Zk75OgVaBR2+kQHTvP0donkPB3YlAfUMZbo/qEdL8rwZzmtZtmP
	 ZXY+8sW3Mt8ryOyO4n4zHm02HBoHN93sj4lc9TsnyDUc23SVHpHcu6tKaBQhqIYvufzG1
	 dKTzCSUVTthhJ89VCGDiSyFMTj46+NpZjjkindlUReTPNK5zpUk3bPx0MQeJDDqfaBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LszyWpDe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217CF60A5BE9;
	Wed, 18 Nov 2026 16:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LszyWpDe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3957E1F000CA;
	Wed, 18 Nov 2026 16:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020736;
	bh=6wwQBsRQg4DVms2lnQx17dWqXgY3Lwfma4Kkb2I3ns0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LszyWpDeKQ43KVwCid4Ak0+X0+dwA9s9ENz55CROYfUHdQBmMv7Aeqs2xDmCqjIF6
	 NinVR4sSXAknnHWC8AKJs5oewkF0wgWC6Y1I8YvK7MMo+BIdhHZRljdPQB0sWuFIwG
	 IKch9vYxW2G+FYYX9QkMmpBz5puKa5x8Oj7UAvgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2008/2651] tracing: Clamp the printed end of a histogram bucket at U64_MAX
Date: Wed, 18 Nov 2026 15:54:08 +0100
Message-ID: <20261118150358.568059766@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 340bcb5099e7a..97b67f05f5eae 100644
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
index 64d89f5fb9d93..3cda5d3131b18 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -5568,9 +5568,14 @@ static void hist_trigger_print_key(struct seq_file *m,
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



