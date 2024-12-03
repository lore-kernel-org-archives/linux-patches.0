Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5B31DE8A5;
	Tue,  3 Dec 2024 15:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241091; cv=none; b=SL6RJzJhk19BdMetsyj1IFy8SNWA1i74HzMPUmLPbj9P2kR+btuoA2LXCj7JdWe7kC0I0sjcMcQKjs0fa6ywOjmRpq2AGVnkRaMiKpQdJcFGN/muZ/430ysBH8z1Dp0ovXmsV/7PUWsRD9ojSKPDBAzIhyAVNQOjh3zQmd/b2s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241091; c=relaxed/simple;
	bh=A6eOexWrf1LrxeI2SOQVe5GO5FX19KbkqP2MjsD1HZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a11w0d5Opxt5D3hEN7Qm4SUMTGzHvhhoIjXxEjLtp1WdrqJGljNQGzSKW+vLL5No8DQsuk5diqRN0jp3HJsfNVtJ8eWlMq4r5s9gSqFGbS7KoYzxYYbHprP++J3B2p1L6ImCcTHhslzluZT9Pqs+Bhzj1VhzWFApAEF97NNd9zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q330cSp0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q330cSp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2D5C4CECF;
	Tue,  3 Dec 2024 15:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241091;
	bh=A6eOexWrf1LrxeI2SOQVe5GO5FX19KbkqP2MjsD1HZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q330cSp0hWyvQKUuwkxl7GIAZQzHhpTpxCeGhAtuKCpxBQC+RfliiSr73ytlu6K6i
	 O0vNxacSiqcYZ8Y16K42chUPzxXm1p0aoYWvP50PH+AuMn3CwfuhYxG02RBvlHHwfV
	 AdkExTskyRXM1rh9zmqZ6qz/gp7gWHWaYIosYOSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 323/826] bpf: Allow return values 0 and 1 for kprobe session
Date: Tue,  3 Dec 2024 15:40:50 +0100
Message-ID: <20241203144756.361868870@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 17c4b65a24938c6dd79496cce5df15f70d9c253c ]

The kprobe session program can return only 0 or 1,
instruct verifier to check for that.

Fixes: 535a3692ba72 ("bpf: Add support for kprobe session attach")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20241108134544.480660-2-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 71a1877aac687..91317857ea3ee 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15988,6 +15988,15 @@ static int check_return_code(struct bpf_verifier_env *env, int regno, const char
 			return -ENOTSUPP;
 		}
 		break;
+	case BPF_PROG_TYPE_KPROBE:
+		switch (env->prog->expected_attach_type) {
+		case BPF_TRACE_KPROBE_SESSION:
+			range = retval_range(0, 1);
+			break;
+		default:
+			return 0;
+		}
+		break;
 	case BPF_PROG_TYPE_SK_LOOKUP:
 		range = retval_range(SK_DROP, SK_PASS);
 		break;
-- 
2.43.0



