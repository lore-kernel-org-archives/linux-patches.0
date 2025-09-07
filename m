Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0494BD528;
	Sun,  7 Sep 2025 20:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276852; cv=none; b=VGupyNjKETiVYWmQYIugIPHg4RKP7zvV7YUlu7HO+Juakuk64gl8Eb3KQQQwpSD6pXBZoXRaZtZdxvdzTxL2bbnINWd1M+gLgbn9tifRllVsmLWMk757yueszeAPoc7/QKy1mpgSCHGnSWvKkkB4RHVVrc64hxvlsZmwTcJ0G3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276852; c=relaxed/simple;
	bh=kTimx8RHTPstV8EAcKQ8pDLaULfCJKR4B4qS8xApY04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfeKfPM8VeVH+Ik6XRfCVi9iFsTAbcYVVCjBHjyuG/BLMjsWXSuTTHfVPbfiVJgIpN809pXyhvCzTrJAODPcFFWxC1Nt4Jl30zq6X9RntNsRactdsxTEtIbNyuuNTsaHf9qvYdYRVvHKAFDBDkfb5pYOHwwXAOrmFmaktSg7aSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pW/6dGax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pW/6dGax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50274C4CEF0;
	Sun,  7 Sep 2025 20:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276851;
	bh=kTimx8RHTPstV8EAcKQ8pDLaULfCJKR4B4qS8xApY04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pW/6dGaxl/HqpmiFOscVhpQtr91VyaHt+kZRhvp44NzqePPClk6/ipZvpo5TkLHek
	 HUWy1R/VMYmhDXNR/9akds3qEsiOcNHmTwcA0r6J/nmPEHfFVAA2yFFoSUeRML1TDX
	 XQnWToiby+QXPe9CN1nZnzpe4+gBTYas4464jIZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 001/175] bpf: Add cookie object to bpf maps
Date: Sun,  7 Sep 2025 21:56:36 +0200
Message-ID: <20250907195614.926527578@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 12df58ad294253ac1d8df0c9bb9cf726397a671d ]

Add a cookie to BPF maps to uniquely identify BPF maps for the timespan
when the node is up. This is different to comparing a pointer or BPF map
id which could get rolled over and reused.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20250730234733.530041-1-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h  | 1 +
 kernel/bpf/syscall.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 1150a595aa54c..fcf48bd746001 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -306,6 +306,7 @@ struct bpf_map {
 	bool free_after_rcu_gp;
 	atomic64_t sleepable_refcnt;
 	s64 __percpu *elem_count;
+	u64 cookie; /* write-once */
 };
 
 static inline const char *btf_field_type_name(enum btf_field_type type)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index ab74a226e3d6d..27cacdde359e8 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -35,6 +35,7 @@
 #include <linux/rcupdate_trace.h>
 #include <linux/memcontrol.h>
 #include <linux/trace_events.h>
+#include <linux/cookie.h>
 
 #include <net/netfilter/nf_bpf_link.h>
 #include <net/netkit.h>
@@ -51,6 +52,7 @@
 #define BPF_OBJ_FLAG_MASK   (BPF_F_RDONLY | BPF_F_WRONLY)
 
 DEFINE_PER_CPU(int, bpf_prog_active);
+DEFINE_COOKIE(bpf_map_cookie);
 static DEFINE_IDR(prog_idr);
 static DEFINE_SPINLOCK(prog_idr_lock);
 static DEFINE_IDR(map_idr);
@@ -1360,6 +1362,10 @@ static int map_create(union bpf_attr *attr)
 	if (err < 0)
 		goto free_map;
 
+	preempt_disable();
+	map->cookie = gen_cookie_next(&bpf_map_cookie);
+	preempt_enable();
+
 	atomic64_set(&map->refcnt, 1);
 	atomic64_set(&map->usercnt, 1);
 	mutex_init(&map->freeze_mutex);
-- 
2.50.1



