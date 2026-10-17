Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04F617BED0;
	Sat, 17 Oct 2026 16:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253956; cv=none; b=Zihf5dXERAKh4ckVcEHNgGVUb+BKzDjVbJjiFYtfsdvHOHRIE23RU4mV9N8n8O4U/bF+2zLd9Z1VLqHKpT/K/HhrRw8BqRrx39GyW3o7SrxWZRg8O/lUgPEYfD9fJmeLSBfipv0eI9CiAvZkGwjW7kHLKTXe6lfVU3zHctsOtEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253956; c=relaxed/simple;
	bh=c/YAFXMQGKDSjzc3k968lI/3zaBzt64Wn4AHjI/Hm5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=saIptisi4SUJP8qoJ772CnUDTfaFH/GQCw0tAk2ZudM1w8scnj2dZqkPjyu/YzH3MCdZ/mAJ5Dw9gUA2ujRbRHMvFBYfpn/ipIeljYzwKZHppWrdkIuiIoXgI7jdVAiCi6L3NU3r4QycBAYDhvLphQG25QgX8mSA9at6uD41x8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wKa0kUzs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKa0kUzs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D971F000C4;
	Sat, 17 Oct 2026 16:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253954;
	bh=sJWW12iijXWqiS9Am2hy8/3Pu4C3FMkEtrgJ9WhcPoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wKa0kUzs4aUaCLr4H5am5dnmAQ2bXcbXReJthQZTB+cNCJ22bYvLPzscnkRbOvw35
	 E2sxXvfotUrKIN3GN7Y0O3satDieNtEhcFSwtX1HRuO5z+5vXgJq3g1dIU1o4KbJHr
	 pBSmWLm6/9XVicURTeptPectgm4irO1AR1b+13Ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Daniil Dulov <d.dulov@aladdin.ru>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 248/869] ring-buffer: Fix possible dereference of uninitialized pointer
Date: Sat, 17 Oct 2026 17:51:29 +0200
Message-ID: <20261017160043.416552141@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Daniil Dulov <d.dulov@aladdin.ru>

[ Upstream commit f1547779402c4cd67755c33616b7203baa88420b ]

There is a pointer head_page in rb_meta_validate_events() which is not
initialized at the beginning of a function. This pointer can be dereferenced
if there is a failure during reader page validation. In this case the control
is passed to "invalid" label where the pointer is dereferenced in a loop.

To fix the issue initialize orig_head and head_page before calling
rb_validate_buffer.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Link: https://patch.msgid.link/20260213100130.2013839-1-d.dulov@aladdin.ru
Closes: https://lore.kernel.org/r/202406130130.JtTGRf7W-lkp@intel.com/
Fixes: 5f3b6e839f3c ("ring-buffer: Validate boot range memory events")
Signed-off-by: Daniil Dulov <d.dulov@aladdin.ru>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index c54e7e910b436..ca6a4d0f3ef37 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1888,6 +1888,8 @@ static void rb_meta_validate_events(struct ring_buffer_per_cpu *cpu_buffer)
 	if (!meta || !meta->head_buffer)
 		return;
 
+	head_page = cpu_buffer->head_page;
+
 	/* Do the reader page first */
 	ret = rb_validate_buffer(cpu_buffer->reader_page->page, cpu_buffer->cpu);
 	if (ret < 0) {
@@ -1898,8 +1900,6 @@ static void rb_meta_validate_events(struct ring_buffer_per_cpu *cpu_buffer)
 	entry_bytes += local_read(&cpu_buffer->reader_page->page->commit);
 	local_set(&cpu_buffer->reader_page->entries, ret);
 
-	head_page = cpu_buffer->head_page;
-
 	/* If the commit_buffer is the reader page, update the commit page */
 	if (meta->commit_buffer == (unsigned long)cpu_buffer->reader_page->page) {
 		cpu_buffer->commit_page = cpu_buffer->reader_page;
-- 
2.53.0



