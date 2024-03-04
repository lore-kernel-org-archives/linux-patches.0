Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760FD7C083;
	Mon,  4 Mar 2024 21:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587876; cv=none; b=qTAUmQ3UgXVwHS7Dssp+OlhJ+vJ0nel4ZX/4HIhIGaJgcKdifrsqVBqEx/qOpYum/uGWJUEge0s6wNXDCc+ZTIX+4fvP/tFwhofk87RJ3AvaPyW6W7uM7tjVv0EQjd0MWK0kWf+BZU46tFGwWX9Ht6scJPGxJ8mscmUmO3Ulogc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587876; c=relaxed/simple;
	bh=go2k7jM8rbzmXuwfHusUmysWHE9GGr7uGBmSvUffi3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mc2kvR6JnjBIY5CLFTbr4AXEg/eNT25ddEJTUG6EBlvIBcXR61V1Moea9kW+Am2A+g9epCY1ZI0O8fYMGfhwh1WV6apCUEFp2RXgGXSH7On39BPvXSAG4Y/wd7tVpPpCwXMvxfaYCwrn8LVK+FZYdhaPh8BDi39HKTihEbOqWaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=skvCa1by; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="skvCa1by"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6587C433F1;
	Mon,  4 Mar 2024 21:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587876;
	bh=go2k7jM8rbzmXuwfHusUmysWHE9GGr7uGBmSvUffi3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=skvCa1by01kIgWKNT/IpBMtwcgUMegAbqsRABSO4O/0VL4ybOH4K+SOrZJd6C87lw
	 iRg6ySExXIricBxB0HqLOL9i/ADKvTwdaAZepBzRZkAdJ7ryISRGAMzZeCj7kmuSLf
	 DPTPTfAbfDPm2bwMhr8msPKhHE9bEzzy/lkmt5vU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <olsajiri@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.7 116/162] fprobe: Fix to allocate entry_data_size buffer with rethook instances
Date: Mon,  4 Mar 2024 21:23:01 +0000
Message-ID: <20240304211555.480806046@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 6572786006fa96ad2c35bb31757f1f861298093b upstream.

Fix to allocate fprobe::entry_data_size buffer with rethook instances.
If fprobe doesn't allocate entry_data_size buffer for each rethook instance,
fprobe entry handler can cause a buffer overrun when storing entry data in
entry handler.

Link: https://lore.kernel.org/all/170920576727.107552.638161246679734051.stgit@devnote2/

Reported-by: Jiri Olsa <olsajiri@gmail.com>
Closes: https://lore.kernel.org/all/Zd9eBn2FTQzYyg7L@krava/
Fixes: 4bbd93455659 ("kprobes: kretprobe scalability improvement")
Cc: stable@vger.kernel.org
Tested-by: Jiri Olsa <olsajiri@gmail.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/fprobe.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
index 6cd2a4e3afb8..9ff018245840 100644
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -189,9 +189,6 @@ static int fprobe_init_rethook(struct fprobe *fp, int num)
 {
 	int size;
 
-	if (num <= 0)
-		return -EINVAL;
-
 	if (!fp->exit_handler) {
 		fp->rethook = NULL;
 		return 0;
@@ -199,15 +196,16 @@ static int fprobe_init_rethook(struct fprobe *fp, int num)
 
 	/* Initialize rethook if needed */
 	if (fp->nr_maxactive)
-		size = fp->nr_maxactive;
+		num = fp->nr_maxactive;
 	else
-		size = num * num_possible_cpus() * 2;
-	if (size <= 0)
+		num *= num_possible_cpus() * 2;
+	if (num <= 0)
 		return -EINVAL;
 
+	size = sizeof(struct fprobe_rethook_node) + fp->entry_data_size;
+
 	/* Initialize rethook */
-	fp->rethook = rethook_alloc((void *)fp, fprobe_exit_handler,
-				sizeof(struct fprobe_rethook_node), size);
+	fp->rethook = rethook_alloc((void *)fp, fprobe_exit_handler, size, num);
 	if (IS_ERR(fp->rethook))
 		return PTR_ERR(fp->rethook);
 
-- 
2.44.0



