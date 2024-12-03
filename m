Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4931F7558;
	Tue,  3 Dec 2024 15:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241095; cv=none; b=FGtgmTUh0nYF3uszHhwG0dLBXkuDUR3FDXJ3/lT3DUa1xBrG/JEnuyIqbMA3XEAHnm3y/ZiC0QrXf6Y9JOx889Himi28/X4oVPkGV9FSEMp/2pfSqdxXU1VWRMSrWnNRblfqTkomKBMuWmA6QdDvl/woQDXyPiHsPPB1WfMkRlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241095; c=relaxed/simple;
	bh=qlveK9bVWodoCR74QF8txbmvd9st1Z2T8ciWZbpQEGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BiNzN5E1lVijYn3fJ7YqDukVNDf4SuVikbsQxbtuPTB1NO8TMc0Z7BmPQnCOrFFl8vQsqrf8KlqqSeoqe4VZq+06eOO7uk6ryOUg/itNBOpQQTunB1bnivUcUEvgaF6x7Fl9SSOMUlJyEif8lZ6H+RIRuzVPAchmvEv3Sua4TRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uo+hP7sa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uo+hP7sa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811D3C4CECF;
	Tue,  3 Dec 2024 15:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241095;
	bh=qlveK9bVWodoCR74QF8txbmvd9st1Z2T8ciWZbpQEGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uo+hP7sa/OLzctUAHYyZP22rzKdyWPCljXUS/lriLd1s2n+IQ12yYBdP8GDcoKpR9
	 q6ta/C595lumz19s+7BgYR+0NNSs4wgAyjb1aCML4zzaeqQeWzu9uLRteJS6DyzJU9
	 nTEIgCWICCXrsXvXlr92JlXI/tYJAuyrxCVFIDuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 324/826] bpf: Force uprobe bpf program to always return 0
Date: Tue,  3 Dec 2024 15:40:51 +0100
Message-ID: <20241203144756.400524830@linuxfoundation.org>
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

[ Upstream commit f505005bc7426f4309880da94cfbfc37efa225bd ]

As suggested by Andrii make uprobe multi bpf programs to always return 0,
so they can't force uprobe removal.

Keeping the int return type for uprobe_prog_run, because it will be used
in following session changes.

Fixes: 89ae89f53d20 ("bpf: Add multi uprobe link")
Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20241108134544.480660-3-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 630b763e52402..792dc35414a3c 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -3205,7 +3205,6 @@ static int uprobe_prog_run(struct bpf_uprobe *uprobe,
 	struct bpf_prog *prog = link->link.prog;
 	bool sleepable = prog->sleepable;
 	struct bpf_run_ctx *old_run_ctx;
-	int err = 0;
 
 	if (link->task && !same_thread_group(current, link->task))
 		return 0;
@@ -3218,7 +3217,7 @@ static int uprobe_prog_run(struct bpf_uprobe *uprobe,
 	migrate_disable();
 
 	old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
-	err = bpf_prog_run(link->link.prog, regs);
+	bpf_prog_run(link->link.prog, regs);
 	bpf_reset_run_ctx(old_run_ctx);
 
 	migrate_enable();
@@ -3227,7 +3226,7 @@ static int uprobe_prog_run(struct bpf_uprobe *uprobe,
 		rcu_read_unlock_trace();
 	else
 		rcu_read_unlock();
-	return err;
+	return 0;
 }
 
 static bool
-- 
2.43.0



