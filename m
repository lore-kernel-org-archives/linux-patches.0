Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027251;
	b=oMGZIPybnC6uSztC4rDe4fxECUqaYa23smIrY0Is6Ncy1ZRvxuBjV2yeSG31Gy1AE6V9
	 8YygDNedAQbvbY01UUL9r6HqkUzzcVD+I2qzHFsALce4ilB/KdWMarvm4Ib5OMktmzgK7
	 VTStRHyiZa9+z2kRsBoDv3BhaAol8HrpMHTxxMEDhmLAjF+ZAqVr2CuuDYC1YMfqU1wEi
	 FyhVWX33k8qzGvbPh+gy2XJ2zVtGMZ39tFI0dWE3aI6LSh/8IX7wA1xV2bTtMAnIfZh+E
	 Ku0U1egTEkclq2Zi2JlckXgtzOtajp45/QT+aYt4ByBy7psANsllGmmUjcHChGNhPfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027251;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MenXhuYC35g2+M/ZExMHtxS15xchJi3cNjl2Vu5DgWA=;
	b=n1LuTkG3kzDB3Dak9cuL5kewMZ9q5TmHV162nP9k6EiNQG5GjBDVZ86wz4G+4vqmMy4M
	 Up8cMWusAXbCXIrXG6QOFtwrKBJ3I/H6oBfT6QdjnZAXBxZYqZspnsNUzFhSPLTfs9jUD
	 eYYzOL2Gym80/rVBFomXugxA85+pVKB4lvXPIkQh2L+o2WIxANOPS60oD8osWW5F6SS3g
	 aCF9ltRyAN49U0bqLpIuS9Z2zfqUUxio4FFmgcQTB/5yTaR168e2z5WjXS2C/C0NZk5Jq
	 yAIdHDyGtkAFMoq9b+gTqKiSNKQlIjM//J2H5DHEMBvUrm0NTwhekmnsEtv6aqR/PMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iwwAo5lB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8A6606A33D;
	Wed, 18 Nov 2026 18:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iwwAo5lB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15D81F000C4;
	Wed, 18 Nov 2026 18:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027251;
	bh=MenXhuYC35g2+M/ZExMHtxS15xchJi3cNjl2Vu5DgWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iwwAo5lBII2XapegjCmnPRzKpylo568VIBIlVn7qJjqlN8tiDL29//KIjsA8dmSda
	 rVUlII9CZrrw23Y8CTV++6q4+egBkMXY7r5QXuEGUGu+29OYn058pr12FizyWQ0ncO
	 +Rrt+4zCHbwUqpBCpk6uN2ywUkScHsDgfjCHJR44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1722/2151] bpf: Read the probe of a perf event under event_mutex
Date: Wed, 18 Nov 2026 15:57:37 +0100
Message-ID: <20261118150224.565097498@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 3ccd700543f16a2b2ab656f35dcaeb6bd7c45e22 ]

For a perf event on a kprobe or uprobe event which was made in tracefs,
bpf_get_kprobe_info() and bpf_get_uprobe_info() look the probe up by
name in the list of dynamic events, and hand a pointer to its symbol or
file name back to the caller. None of the callers holds event_mutex.

The perf event keeps its trace event alive, nothing else. Other dynamic
events are removed from the list and freed during the walk. And a probe
which shares its event with other probes can be deleted while the event
is in use, so even the probe which is found can be freed, together with
the string, before the caller has measured and copied it. The result is
a use-after-free in the walk, in strlen() and in the copy to user space,
or a NULL pointer dereference.

The readers are BPF_OBJ_GET_INFO_BY_FD and fdinfo of a perf link, for
whoever holds a descriptor of the link, and BPF_TASK_FD_QUERY. The other
side is anybody who may write to dynamic_events, kprobe_events or
uprobe_events.

Take event_mutex in bpf_get_perf_event_info() and give the caller a copy
of the name, which it has to free.

Fixes: 41bdc4b40ed6 ("bpf: introduce bpf subcommand BPF_TASK_FD_QUERY")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-10-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c     | 17 +++++++++++------
 kernel/trace/bpf_trace.c | 13 +++++++++++++
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 8e4689034b422..d2f4cd5eaaa0d 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3909,19 +3909,19 @@ static int bpf_perf_link_fill_common(const struct perf_event *event,
 		*ulenp = 1;
 	}
 	if (!uname)
-		return 0;
+		goto out;
 
 	if (buf) {
 		err = bpf_copy_to_user(uname, buf, ulen, len);
-		if (err)
-			return err;
 	} else {
 		char zero = '\0';
 
 		if (put_user(zero, uname))
-			return -EFAULT;
+			err = -EFAULT;
 	}
-	return 0;
+out:
+	kfree_const(buf);
+	return err;
 }
 
 #ifdef CONFIG_KPROBE_EVENTS
@@ -3978,6 +3978,7 @@ static void bpf_perf_link_fdinfo_kprobe(const struct perf_event *event,
 		   name, offset, missed, addr,
 		   type == BPF_FD_TYPE_KRETPROBE ?  "kretprobe" : "kprobe",
 		   event->bpf_cookie);
+	kfree_const(name);
 }
 #endif
 
@@ -4031,6 +4032,7 @@ static void bpf_perf_link_fdinfo_uprobe(const struct perf_event *event,
 		   name, offset, ref_ctr_offset,
 		   type == BPF_FD_TYPE_URETPROBE ?  "uretprobe" : "uprobe",
 		   event->bpf_cookie);
+	kfree_const(name);
 }
 #endif
 
@@ -4129,6 +4131,7 @@ static void bpf_tracepoint_link_show_fdinfo(const struct perf_event *event,
 		   "event_type:\t%s\n"
 		   "cookie:\t%llu\n",
 		   name, "tracepoint", event->bpf_cookie);
+	kfree_const(name);
 }
 
 static void bpf_probe_link_show_fdinfo(const struct perf_event *event,
@@ -5623,11 +5626,13 @@ static int bpf_task_fd_query(const union bpf_attr *attr,
 		err = bpf_get_perf_event_info(event, &prog_id, &fd_type,
 					      &buf, &probe_offset,
 					      &probe_addr, NULL);
-		if (!err)
+		if (!err) {
 			err = bpf_task_fd_query_copy(attr, uattr, prog_id,
 						     fd_type, buf,
 						     probe_offset,
 						     probe_addr);
+			kfree_const(buf);
+		}
 		goto put_file;
 	}
 
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index af5ab3b2e3d59..1d30f154078f2 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2151,6 +2151,7 @@ int bpf_probe_unregister(struct bpf_raw_event_map *btp, struct bpf_raw_tp_link *
 	return tracepoint_probe_unregister(btp->tp, (void *)btp->bpf_func, link);
 }
 
+/* On success the caller releases *buf with kfree_const() */
 int bpf_get_perf_event_info(const struct perf_event *event, u32 *prog_id,
 			    u32 *fd_type, const char **buf,
 			    u64 *probe_offset, u64 *probe_addr,
@@ -2160,6 +2161,12 @@ int bpf_get_perf_event_info(const struct perf_event *event, u32 *prog_id,
 	struct bpf_prog *prog;
 	int flags, err = 0;
 
+	/*
+	 * The list of dynamic events is walked, and a probe which has siblings
+	 * can be deleted, with its strings, while its event is in use.
+	 */
+	guard(mutex)(&event_mutex);
+
 	prog = event->prog;
 	if (!prog)
 		return -ENOENT;
@@ -2200,6 +2207,12 @@ int bpf_get_perf_event_info(const struct perf_event *event, u32 *prog_id,
 #endif
 	}
 
+	if (!err && *buf) {
+		*buf = kstrdup_const(*buf, GFP_KERNEL);
+		if (!*buf)
+			err = -ENOMEM;
+	}
+
 	return err;
 }
 
-- 
2.53.0



