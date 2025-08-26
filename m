Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8E83451A0;
	Tue, 26 Aug 2025 14:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218744; cv=none; b=hWWB52ebbentx/j2Mg8GbXyXKMy9Qk2lVWGZASR/wKm7Pmc9eYc1gXi+Ge5pKquwqrc8pxPd7Ez8RZCCbJV+mrxhbwSpprfNwT9CI/v1vsxhl6Ji3ZatQXV7KEnukMzl5hLTIoShMwbdEEClYfs1rboGPOwaJTk98+Hgo9pKRKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218744; c=relaxed/simple;
	bh=f/V3kX7u9qLVt7d+38T9GDVaMY500BPO8jN9Gsygxk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8yTs9OmjnK8yf32c63AsJXHGdFE+bKnv4m+wP7ZHjbeV5ojhH/7gDrTPIPaw3TBJJo78q5sTeVo8vHBOjCbK7ssPUJgrzkWyi7ShcY2g3QzvyNaTNr4iOoofQQX41+gsF1i5rxMOIze9/0S1KleZGekd3Eq3UeVGr7E13tQQNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sIdTK0q3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sIdTK0q3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E3CC4CEF1;
	Tue, 26 Aug 2025 14:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218744;
	bh=f/V3kX7u9qLVt7d+38T9GDVaMY500BPO8jN9Gsygxk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sIdTK0q3zm0wtkZjK3pLnFgNFuS2LRbTbTNmLG3wu9sfgf7/w9q5CywaJehAX8Q8T
	 W52oQRYb11ru9koVGY6dpG3R/rjRYGympMsw9jQCqjh03Y5kGX7w7iliA2QJ41NfrU
	 zpYWGHvEQtZlQwM9mLOK+y62O6VUhMAr/6Gc2y3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Quentin Monnet <qmo@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 085/403] bpftool: Fix memory leak in dump_xx_nlmsg on realloc failure
Date: Tue, 26 Aug 2025 13:06:51 +0200
Message-ID: <20250826110909.008866375@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index c6787a1daa48..c2953b2bf130 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -87,17 +87,18 @@ static int dump_link_nlmsg(void *cookie, void *msg, struct nlattr **tb)
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
@@ -116,6 +117,7 @@ static int dump_class_qdisc_nlmsg(void *cookie, void *msg, struct nlattr **tb)
 {
 	struct bpf_tcinfo_t *tcinfo = cookie;
 	struct tcmsg *info = msg;
+	struct tc_kind_handle *tmp;
 
 	if (tcinfo->is_qdisc) {
 		/* skip clsact qdisc */
@@ -127,11 +129,12 @@ static int dump_class_qdisc_nlmsg(void *cookie, void *msg, struct nlattr **tb)
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



