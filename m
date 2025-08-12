Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D2286331;
	Tue, 12 Aug 2025 17:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020623; cv=none; b=TRdpzTusdFkSdDPPOEWh2WRKUiVijnYu5SrMkpS6f9pLsnuhB9lR2leCDAhyvVSLESchmb1l14PTuwPILoyTwJrYvRd52+XvlZ5342dQeSAm7CLfmEgTHcXY1JXRF8S5yntsTXRSy8ly1bgC9ydj0XaTdq9vtAHTiL+WQ3S/PTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020623; c=relaxed/simple;
	bh=xpnVV7xE6RkO2oox1rBl3an9w29KaGv7MWeBonOuEHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jr1SAa4JUYvETnWDkMC3Pvq7sWvJDK0j0L7NXXYNUQJLW86AnSYbkpTo1JzE+FKlceXddtfR/LfU19PAkojamLYHvc2ZvDD6emRYIE0H1RVqtHlz+1Q3JRBHr5piM4FnPVR53vljfAzde/mv4eGIxNidKdRcsAY0qJiG9td36ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PpmTeAia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PpmTeAia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5315C4CEF0;
	Tue, 12 Aug 2025 17:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020623;
	bh=xpnVV7xE6RkO2oox1rBl3an9w29KaGv7MWeBonOuEHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PpmTeAiaoYOQPb95Fn4gghvT9IYfKU8daye+qfDz1s9mGgTCc9HrzYeODpALawsIy
	 Rbok/isWGeguWVLE4qqpIo/aSCzDMuuCiQ099pDedv4twCpbTeuB36AuOjHXyeO2gK
	 iC14i6ozpQwKMqzWYdNu6KSewWcC8Hrvndp1e7nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Quentin Monnet <qmo@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 101/253] bpftool: Fix memory leak in dump_xx_nlmsg on realloc failure
Date: Tue, 12 Aug 2025 19:28:09 +0200
Message-ID: <20250812172953.027066589@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 526a332c48e6..7c9e86faab6c 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -353,17 +353,18 @@ static int dump_link_nlmsg(void *cookie, void *msg, struct nlattr **tb)
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
@@ -382,6 +383,7 @@ static int dump_class_qdisc_nlmsg(void *cookie, void *msg, struct nlattr **tb)
 {
 	struct bpf_tcinfo_t *tcinfo = cookie;
 	struct tcmsg *info = msg;
+	struct tc_kind_handle *tmp;
 
 	if (tcinfo->is_qdisc) {
 		/* skip clsact qdisc */
@@ -393,11 +395,12 @@ static int dump_class_qdisc_nlmsg(void *cookie, void *msg, struct nlattr **tb)
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



