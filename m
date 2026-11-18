Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032174;
	b=rZEjDEVODPUd9fgi0rG6WhDGO3FF7MW+QFPb2ObMhtF4GJBfdAVElb+U6Z/mDZ5oVGKq
	 LI++G6mnLkgK280DD3kge1rzouTsVWNty0EyfNE6cnju04LmgyIQu/DUoeDT7JwyGhGRm
	 R7hnd7zt6mLdMOCdD/xgaZN5nZg1fISvUxcLgchITltMp0ZBl/tkniNadQfYCi2PCqlVg
	 D4ZbHzzL6uOYkTg5iPYjR34ooUsUQv504WALq8xkli3t2AioSB1rvD63dJi3M8EGELCL8
	 Iq+uuEuJtsuII1YtyOJ6qfogYEiTrDeAhvOoI8kQICkIB0YmOuf+l9yRimaTalzKnew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+5Qt4hAE/JS+8QjIjXVWsTfhspeZ+cBohp1+/ZPZTjQ=;
	b=l2l7w36feYcCfyjE91tdybWlr+RVw2ai8lxPTcntTuxcBw7Ed4tSdkRfit3jhh+B+MWE
	 3cv/uffv9S0RvnhYfsIyK5RWnOmxD4xFBBFeuQyR6HMR/w74soq3tRyUxl0kpiPny/Ozt
	 Ue2NO2YNroVoCuQP9Xc0AD5BBIJ3uBBGh3LgajHGiZYV6UmLwux7UA8Gi1jBVdvSr/ix9
	 8Ve2LmJYrdrzzc04wTmmO8R+S622jidQzWIA+jcJGr6+wBfnkkgSMU8VNFyRjxXOfZwig
	 iHskbiGtzwu3JMf+APFdV14YhBpVEFRkVlzi1m/FOkOspY0rUnNlwgolFDPogvL9hXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zDyH/Tx2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5267A606A31C;
	Wed, 18 Nov 2026 20:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zDyH/Tx2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BBD1F000C4;
	Wed, 18 Nov 2026 20:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032174;
	bh=+5Qt4hAE/JS+8QjIjXVWsTfhspeZ+cBohp1+/ZPZTjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zDyH/Tx2Z32aEjyJJP9UEgBLvlaJxUKdQcE2jbQd3Qmum6ydB+ZI8L8WSvm7zjSJJ
	 CTahUoNxDqKvmcDUwUKhg+EV3oDemhRWFF9aLV/VgPzgDWtZdqNWNmBkV70UMfyqUK
	 odGnbTx01tQsQR66JBy+msiRcckfU6K31Ew/eYVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1317/1756] tracing: Clamp the printed end of a histogram bucket at U64_MAX
Date: Wed, 18 Nov 2026 15:57:24 +0100
Message-ID: <20261118150101.880332767@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4ad9c0da7984c..1b597f735f851 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -5547,9 +5547,14 @@ static void hist_trigger_print_key(struct seq_file *m,
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



