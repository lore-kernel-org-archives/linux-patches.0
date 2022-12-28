Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53431863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:25:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC41C433EF;
	Wed, 28 Dec 2022 15:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241151;
	bh=2qceR9AcN3nFhGHT2+Op9iWgbpDKsdi52uZZXhTeoE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hnm7gKl1g/Cq0BdIVk7KV+EOEG/+u1gZcks+zvsgoRcHXR/7AV4itHVDRV3p3LDHK
	 ZGiGkPnlCw26DKeAu0RvojYdG7aEqWGdMG4TlHfibkfTOxkYr3d9vOqFZGQsBTcQrO
	 O028eVQRtOE/QoMt62lMNPVU2fgihXl4JYRZjjwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0213/1146] libbpf: Fix null-pointer dereference in find_prog_by_sec_insn()
Date: Wed, 28 Dec 2022 15:29:12 +0100
Message-Id: <20221228144335.932302242@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shung-Hsi Yu <shung-hsi.yu@suse.com>

[ Upstream commit d0d382f95a9270dcf803539d6781d6bd67e3f5b2 ]

When there are no program sections, obj->programs is left unallocated,
and find_prog_by_sec_insn()'s search lands on &obj->programs[0] == NULL,
and will cause null-pointer dereference in the following access to
prog->sec_idx.

Guard the search with obj->nr_programs similar to what's being done in
__bpf_program__iter() to prevent null-pointer access from happening.

Fixes: db2b8b06423c ("libbpf: Support CO-RE relocations for multi-prog sections")
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20221012022353.7350-4-shung-hsi.yu@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index a0d3cc39ea73..b9a29d105376 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4115,6 +4115,9 @@ static struct bpf_program *find_prog_by_sec_insn(const struct bpf_object *obj,
 	int l = 0, r = obj->nr_programs - 1, m;
 	struct bpf_program *prog;
 
+	if (!obj->nr_programs)
+		return NULL;
+
 	while (l < r) {
 		m = l + (r - l + 1) / 2;
 		prog = &obj->programs[m];
-- 
2.35.1



