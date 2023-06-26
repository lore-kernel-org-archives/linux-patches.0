Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230D4134B3
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:21:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907BFC433C0;
	Mon, 26 Jun 2023 18:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803676;
	bh=PIjjKVmZQ320dfLxqLy0VJY/NsmorB4h19c0vikRn68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O1OQeRnqZHIq/quLs/PmGhs4jfgp6TJV8DvLArkeAj2/uhbIusvOLGDwqWyYxWotw
	 qDu5xDQDWdJDU+VAL0Ecl2GaRM/RgCYVZancinn86X9FH03TMXI+EufEE67m0A26tV
	 GM2QbIfWDbVj7sd/6ATAwFzJA6FTtwyInJ54Dl6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 139/199] bpf: Force kprobe multi expected_attach_type for kprobe_multi link
Date: Mon, 26 Jun 2023 20:10:45 +0200
Message-ID: <20230626180811.698715648@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
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
index adc83cb82f379..8bd5e3741d418 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3412,6 +3412,11 @@ static int bpf_prog_attach_check_attach_type(const struct bpf_prog *prog,
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



