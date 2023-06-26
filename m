Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFB914AA4
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:32:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC649C433C0;
	Mon, 26 Jun 2023 18:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804333;
	bh=pAPPvlxusULTo+cYlKKNigMfKkf7GTkB/bKoYXu/nm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IrAxAe1eD1YVEFCAyiXNnxqWc5VT5mtXfw/VedtiSexGkG02aQHdPiOh7wSNf0YzT
	 X/F3j6ZK5b2609GmEE3wLqIDcCqvq+hrvgE6qDPDhGpEh9U7htV+5OqHvOwT72RdEN
	 /ppvtjaZavoSuAJyKMk+tNaF8ZBOaReepGb+OJYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 121/170] bpf: Force kprobe multi expected_attach_type for kprobe_multi link
Date: Mon, 26 Jun 2023 20:11:30 +0200
Message-ID: <20230626180805.991815493@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit db8eae6bc5c702d8e3ab2d0c6bb5976c131576eb ]

We currently allow to create perf link for program with
expected_attach_type == BPF_TRACE_KPROBE_MULTI.

This will cause crash when we call helpers like get_attach_cookie or
get_func_ip in such program, because it will call the kprobe_multi's
version (current->bpf_ctx context setup) of those helpers while it
expects perf_link's current->bpf_ctx context setup.

Making sure that we use BPF_TRACE_KPROBE_MULTI expected_attach_type
only for programs attaching through kprobe_multi link.

Fixes: ca74823c6e16 ("bpf: Add cookie support to programs attached with kprobe multi link")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20230618131414.75649-1-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 6c61dba26f4d9..8633ec4f92df3 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3383,6 +3383,11 @@ static int bpf_prog_attach_check_attach_type(const struct bpf_prog *prog,
 		return prog->enforce_expected_attach_type &&
 			prog->expected_attach_type != attach_type ?
 			-EINVAL : 0;
+	case BPF_PROG_TYPE_KPROBE:
+		if (prog->expected_attach_type == BPF_TRACE_KPROBE_MULTI &&
+		    attach_type != BPF_TRACE_KPROBE_MULTI)
+			return -EINVAL;
+		return 0;
 	default:
 		return 0;
 	}
-- 
2.39.2



