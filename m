Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B39211715
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DCE6C433C8;
	Mon, 11 Sep 2023 15:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444847;
	bh=rh3l9Ofqf5Dw/EkjsaxfloDaysEqYC80xcP163eDBFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EqROTuPxQ3zol+w4yJNMaEsnadCqItJan5ER6qAFE9D8xkZBkmwAo4ChkD+DRrJz1
	 Wmt1URB1supDeZocngFOOCcZPK5qt088fVfuhxyly6M5XhD+qoyzbQazDOab0VhGhk
	 LsgDFteCA7yovJG1mZzF9kODyv4nIgg0lE/eKZ/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexander Lobakin <alobakin@pm.me>,
	Quentin Monnet <quentin@isovalent.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 138/600] bpftool: Define a local bpf_perf_link to fix accessing its fields
Date: Mon, 11 Sep 2023 15:42:51 +0200
Message-ID: <20230911134637.683033717@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Lobakin <alobakin@pm.me>

[ Upstream commit 67a43462ee2405c94e985a747bdcb8e3a0d66203 ]

When building bpftool with !CONFIG_PERF_EVENTS:

skeleton/pid_iter.bpf.c:47:14: error: incomplete definition of type 'struct bpf_perf_link'
        perf_link = container_of(link, struct bpf_perf_link, link);
                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helpers.h:74:22: note: expanded from macro 'container_of'
                ((type *)(__mptr - offsetof(type, member)));    \
                                   ^~~~~~~~~~~~~~~~~~~~~~
tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helpers.h:68:60: note: expanded from macro 'offsetof'
 #define offsetof(TYPE, MEMBER)  ((unsigned long)&((TYPE *)0)->MEMBER)
                                                  ~~~~~~~~~~~^
skeleton/pid_iter.bpf.c:44:9: note: forward declaration of 'struct bpf_perf_link'
        struct bpf_perf_link *perf_link;
               ^

&bpf_perf_link is being defined and used only under the ifdef.
Define struct bpf_perf_link___local with the `preserve_access_index`
attribute inside the pid_iter BPF prog to allow compiling on any
configs. CO-RE will substitute it with the real struct bpf_perf_link
accesses later on.
container_of() uses offsetof(), which does the necessary CO-RE
relocation if the field is specified with `preserve_access_index` - as
is the case for struct bpf_perf_link___local.

Fixes: cbdaf71f7e65 ("bpftool: Add bpf_cookie to link output")
Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20230707095425.168126-3-quentin@isovalent.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/skeleton/pid_iter.bpf.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/skeleton/pid_iter.bpf.c b/tools/bpf/bpftool/skeleton/pid_iter.bpf.c
index e2af8e5fb29ec..3a4c4f7d83d86 100644
--- a/tools/bpf/bpftool/skeleton/pid_iter.bpf.c
+++ b/tools/bpf/bpftool/skeleton/pid_iter.bpf.c
@@ -15,6 +15,11 @@ enum bpf_obj_type {
 	BPF_OBJ_BTF,
 };
 
+struct bpf_perf_link___local {
+	struct bpf_link link;
+	struct file *perf_file;
+} __attribute__((preserve_access_index));
+
 struct perf_event___local {
 	u64 bpf_cookie;
 } __attribute__((preserve_access_index));
@@ -45,10 +50,10 @@ static __always_inline __u32 get_obj_id(void *ent, enum bpf_obj_type type)
 /* could be used only with BPF_LINK_TYPE_PERF_EVENT links */
 static __u64 get_bpf_cookie(struct bpf_link *link)
 {
+	struct bpf_perf_link___local *perf_link;
 	struct perf_event___local *event;
-	struct bpf_perf_link *perf_link;
 
-	perf_link = container_of(link, struct bpf_perf_link, link);
+	perf_link = container_of(link, struct bpf_perf_link___local, link);
 	event = BPF_CORE_READ(perf_link, perf_file, private_data);
 	return BPF_CORE_READ(event, bpf_cookie);
 }
-- 
2.40.1



