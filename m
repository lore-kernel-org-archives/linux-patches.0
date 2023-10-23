Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE1514A81
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xkhHeuYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD56FC433C7;
	Mon, 23 Oct 2023 11:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059139;
	bh=PcmpkqieuFKhZnlzCbhBWYpPlh0aADngdvPyJGq582I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xkhHeuYlKz36DXyUMsQg1b4NtZqmQnWRX2IABTSYov9dtUt75cPBEtt5w2m99GBeP
	 4adRz9yV1+WKvV+bv3SBP+r8EkV9CDVRu5J/hAGGIr9qbQXDVWEMgBj2MDRC2dBrhW
	 zFr/W98JYsR4XpTS4uCWbpHGVtf2ulcaLuuawkYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"wuqiang.matt" <wuqiang.matt@bytedance.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.5 059/241] fprobe: Fix to ensure the number of active retprobes is not zero
Date: Mon, 23 Oct 2023 12:54:05 +0200
Message-ID: <20231023104835.349175234@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 700b2b439766e8aab8a7174991198497345bd411 upstream.

The number of active retprobes can be zero but it is not acceptable,
so return EINVAL error if detected.

Link: https://lore.kernel.org/all/169750018550.186853.11198884812017796410.stgit@devnote2/

Reported-by: wuqiang.matt <wuqiang.matt@bytedance.com>
Closes: https://lore.kernel.org/all/20231016222103.cb9f426edc60220eabd8aa6a@kernel.org/
Fixes: 5b0ab78998e3 ("fprobe: Add exit_handler support")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/fprobe.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -189,7 +189,7 @@ static int fprobe_init_rethook(struct fp
 {
 	int i, size;
 
-	if (num < 0)
+	if (num <= 0)
 		return -EINVAL;
 
 	if (!fp->exit_handler) {
@@ -202,8 +202,8 @@ static int fprobe_init_rethook(struct fp
 		size = fp->nr_maxactive;
 	else
 		size = num * num_possible_cpus() * 2;
-	if (size < 0)
-		return -E2BIG;
+	if (size <= 0)
+		return -EINVAL;
 
 	fp->rethook = rethook_alloc((void *)fp, fprobe_exit_handler);
 	if (!fp->rethook)


