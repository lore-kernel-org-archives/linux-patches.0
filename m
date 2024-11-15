Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1124D18859F;
	Fri, 15 Nov 2024 06:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653551; cv=none; b=Ewt6D0J9oQHHjnPMa+zph95CcKO6+AuIJVt9T76Ku4vBT/4rlGd0KLyDeX0NzlQoTQqRXO2UeM09sDPBSKSYsOkYAhGfgJdPMP97MaQR/r6LoPFPk0HUD0lsGVhoQ/6K33n+L524cncIc5xyNYeof6sX26exsiPUiQLd7R0dkDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653551; c=relaxed/simple;
	bh=PKH06QetWjAvarJzhdYHzkD7rRKtz2V3LgxcyrV0MkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zzio2yW00Ve6aYPCkt6o82DLa8hQlK/YVrxJfKFhdMa+Wj3HOCeupmaqKlbdnQ8ZCYjLBUfU3UmWZah6EUYFb5gGe86BtPWQfLnaxgiZqcJg3EzS/Th1pMxXZx4XU2cfZIM27YS7syuaBxtBUok5TYiVHlwZ2nphNhMzme0fQ/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UvK8OCAU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UvK8OCAU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77EEAC4CECF;
	Fri, 15 Nov 2024 06:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653550;
	bh=PKH06QetWjAvarJzhdYHzkD7rRKtz2V3LgxcyrV0MkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UvK8OCAUXyPHvte/QS6nebOQaEaojclQRoWpdVvgEI40uQ107VriCutZ/tgF1OQ9a
	 toZa/bMTcIpQqT7CJPZ3pgJlrNX5uXwiIu7PyWh7T9Iih5BCbOItGZyBGEs/P+Fimr
	 riscYn1xDoMFF/doRCPKc7iqJmNObKtsIkzc45ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 39/48] bpf: Check validity of link->type in bpf_link_show_fdinfo()
Date: Fri, 15 Nov 2024 07:38:28 +0100
Message-ID: <20241115063724.376073136@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
References: <20241115063722.962047137@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 8421d4c8762bd022cb491f2f0f7019ef51b4f0a7 ]

If a newly-added link type doesn't invoke BPF_LINK_TYPE(), accessing
bpf_link_type_strs[link->type] may result in an out-of-bounds access.

To spot such missed invocations early in the future, checking the
validity of link->type in bpf_link_show_fdinfo() and emitting a warning
when such invocations are missed.

Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20241024013558.1135167-3-houtao@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 8a1cadc1ff9dd..252aed82d45ea 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2963,13 +2963,17 @@ static void bpf_link_show_fdinfo(struct seq_file *m, struct file *filp)
 {
 	const struct bpf_link *link = filp->private_data;
 	const struct bpf_prog *prog = link->prog;
+	enum bpf_link_type type = link->type;
 	char prog_tag[sizeof(prog->tag) * 2 + 1] = { };
 
-	seq_printf(m,
-		   "link_type:\t%s\n"
-		   "link_id:\t%u\n",
-		   bpf_link_type_strs[link->type],
-		   link->id);
+	if (type < ARRAY_SIZE(bpf_link_type_strs) && bpf_link_type_strs[type]) {
+		seq_printf(m, "link_type:\t%s\n", bpf_link_type_strs[type]);
+	} else {
+		WARN_ONCE(1, "missing BPF_LINK_TYPE(...) for link type %u\n", type);
+		seq_printf(m, "link_type:\t<%u>\n", type);
+	}
+	seq_printf(m, "link_id:\t%u\n", link->id);
+
 	if (prog) {
 		bin2hex(prog_tag, prog->tag, sizeof(prog->tag));
 		seq_printf(m,
-- 
2.43.0



