Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFB5281379;
	Thu, 13 Feb 2025 14:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457212; cv=none; b=DKBGPhoe7Hnm+KogfLC4YPDtqKk5bgmanJJ7gt6nGTy6l4sIg/bqfU+96oXebqi2+okpvN/IgiWGZCPJyKXtBlBrQ7xZIecww6nxu+OktDEGT23c3BD2IVgWUe9uSGHVDxnDJBQDtEnU9Mb75Hhi5ultH3Z7mHY0APG9SXXarwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457212; c=relaxed/simple;
	bh=lSYT3lIUaiYpOKZ8EY9hPc1woe3+/RUMDZTzBWEJmNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tMsphnFDbXSM8ShvYUN8nR2z18nxIyYwc76aBCNxZw5fZSCbg4q77mKASRzKQLOw8TjmgjNhaQn5ut1HV/kIoKEs4s/blgwQktVU9/8FGJJpbVXAktEGKGJdxYFSSi/ci9EnvbUpXNtG3QaMMKcLMTs3eBmyek2/kC+Gt62WZbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nVm6u7X8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nVm6u7X8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989FBC4CEE4;
	Thu, 13 Feb 2025 14:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457212;
	bh=lSYT3lIUaiYpOKZ8EY9hPc1woe3+/RUMDZTzBWEJmNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nVm6u7X8UZ215msIvn5ZL845de/jCfga2wZuQeR6AMc540xmgXKAMXD7pQ5AGcNeV
	 caP+wFhmhl8MYXepi3oAAF5dF+CtJgOzcuBI81UKAwM2BjQDzliE46z/xxV5MsnrHA
	 kOSBCaMKnWJEWj+nKjxCc+J2ncgZ8BXM8nFIyq2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/422] ring-buffer: Make reading page consistent with the code logic
Date: Thu, 13 Feb 2025 15:23:16 +0100
Message-ID: <20250213142438.378640603@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeongjun Park <aha310510@gmail.com>

[ Upstream commit 6e31b759b076eebb4184117234f0c4eb9e4bc460 ]

In the loop of __rb_map_vma(), the 's' variable is calculated from the
same logic that nr_pages is and they both come from nr_subbufs. But the
relationship is not obvious and there's a WARN_ON_ONCE() around the 's'
variable to make sure it never becomes equal to nr_subbufs within the
loop. If that happens, then the code is buggy and needs to be fixed.

The 'page' variable is calculated from cpu_buffer->subbuf_ids[s] which is
an array of 'nr_subbufs' entries. If the code becomes buggy and 's'
becomes equal to or greater than 'nr_subbufs' then this will be an out of
bounds hit before the WARN_ON() is triggered and the code exiting safely.

Make the 'page' initialization consistent with the code logic and assign
it after the out of bounds check.

Link: https://lore.kernel.org/20250110162612.13983-1-aha310510@gmail.com
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
[ sdr: rewrote change log ]
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 703978b2d557d..28fad7bcfcf86 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -7059,7 +7059,7 @@ static int __rb_map_vma(struct ring_buffer_per_cpu *cpu_buffer,
 	}
 
 	while (p < nr_pages) {
-		struct page *page = virt_to_page((void *)cpu_buffer->subbuf_ids[s]);
+		struct page *page;
 		int off = 0;
 
 		if (WARN_ON_ONCE(s >= nr_subbufs)) {
@@ -7067,6 +7067,8 @@ static int __rb_map_vma(struct ring_buffer_per_cpu *cpu_buffer,
 			goto out;
 		}
 
+		page = virt_to_page((void *)cpu_buffer->subbuf_ids[s]);
+
 		for (; off < (1 << (subbuf_order)); off++, page++) {
 			if (p >= nr_pages)
 				break;
-- 
2.39.5



