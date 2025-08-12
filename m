Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797341A3029;
	Tue, 12 Aug 2025 19:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025745; cv=none; b=HFGs1OJA5phtJ7M2zNnyMkoFWFTlbSN/xkSUQLLXY2XZp1Z8pYYYTKW9ZzCg+LLv01Fsz0lMJYONqMJVKUv/Q6zNRMEKCbKxKHTCGjyM5sHNppNbgNV87CAJpr1V1Wf9jHpW8MVaY2w9nnIHp9B1MTQbm+x0JI8fLe4+1VGoE+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025745; c=relaxed/simple;
	bh=5Nc4hRJB8DalxJ1U8V6hjw7V3o44beP6hrYHdTi85Qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gbJKudS8OgsX4e1Ev9pCLqtZGJn0Nl6A5AuBTyPKoir3AycLtjsTV5niCJZmYyMdADBeucxZYzL4iqTaHC+KS9/Nmzcd/nhRtNlu9JsIB4crWdtxR8Vr09fLwWLOZOcnwEJ4awKR5d/Qwv9N8JIqlEay13Er6pBsewQCslVB+Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nSLPhUvc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nSLPhUvc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECA4C4CEF0;
	Tue, 12 Aug 2025 19:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025745;
	bh=5Nc4hRJB8DalxJ1U8V6hjw7V3o44beP6hrYHdTi85Qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nSLPhUvcLAer8O2s/6G291P9tGfIci70+AmRpLy5RI2PXl4GkkBuPWwf1cuVt9ZvD
	 lzv8zIsIOLiUc/bEFEZ7BGF1LUjW48R7u+Bfp2gZagB4EFxpONbdX0MI+k7+t+vFBy
	 RYMe1Ymb7wBNnQKuIkCuIzK5Fmecli4ThuvQOi6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Quentin Monnet <qmo@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 114/480] bpftool: Fix memory leak in dump_xx_nlmsg on realloc failure
Date: Tue, 12 Aug 2025 19:45:22 +0200
Message-ID: <20250812174402.203212747@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Chen <chenyuan@kylinos.cn>

[ Upstream commit 99fe8af069a9fa5b09140518b1364e35713a642e ]

In function dump_xx_nlmsg(), when realloc() fails to allocate memory,
the original pointer to the buffer is overwritten with NULL. This causes
a memory leak because the previously allocated buffer becomes unreachable
without being freed.

Fixes: 7900efc19214 ("tools/bpf: bpftool: improve output format for bpftool net")
Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
Reviewed-by: Quentin Monnet <qmo@kernel.org>
Link: https://lore.kernel.org/r/20250620012133.14819-1-chenyuan_fl@163.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/net.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index 64f958f437b0..cfc6f944f7c3 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -366,17 +366,18 @@ static int dump_link_nlmsg(void *cookie, void *msg, struct nlattr **tb)
 {
 	struct bpf_netdev_t *netinfo = cookie;
 	struct ifinfomsg *ifinfo = msg;
+	struct ip_devname_ifindex *tmp;
 
 	if (netinfo->filter_idx > 0 && netinfo->filter_idx != ifinfo->ifi_index)
 		return 0;
 
 	if (netinfo->used_len == netinfo->array_len) {
-		netinfo->devices = realloc(netinfo->devices,
-			(netinfo->array_len + 16) *
-			sizeof(struct ip_devname_ifindex));
-		if (!netinfo->devices)
+		tmp = realloc(netinfo->devices,
+			(netinfo->array_len + 16) * sizeof(struct ip_devname_ifindex));
+		if (!tmp)
 			return -ENOMEM;
 
+		netinfo->devices = tmp;
 		netinfo->array_len += 16;
 	}
 	netinfo->devices[netinfo->used_len].ifindex = ifinfo->ifi_index;
@@ -395,6 +396,7 @@ static int dump_class_qdisc_nlmsg(void *cookie, void *msg, struct nlattr **tb)
 {
 	struct bpf_tcinfo_t *tcinfo = cookie;
 	struct tcmsg *info = msg;
+	struct tc_kind_handle *tmp;
 
 	if (tcinfo->is_qdisc) {
 		/* skip clsact qdisc */
@@ -406,11 +408,12 @@ static int dump_class_qdisc_nlmsg(void *cookie, void *msg, struct nlattr **tb)
 	}
 
 	if (tcinfo->used_len == tcinfo->array_len) {
-		tcinfo->handle_array = realloc(tcinfo->handle_array,
+		tmp = realloc(tcinfo->handle_array,
 			(tcinfo->array_len + 16) * sizeof(struct tc_kind_handle));
-		if (!tcinfo->handle_array)
+		if (!tmp)
 			return -ENOMEM;
 
+		tcinfo->handle_array = tmp;
 		tcinfo->array_len += 16;
 	}
 	tcinfo->handle_array[tcinfo->used_len].handle = info->tcm_handle;
-- 
2.39.5



