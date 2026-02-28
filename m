Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D455337522C;
	Sat, 28 Feb 2026 17:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301559; cv=none; b=TzwNvShl4tu5We0gYO0VEsmXhkkpQSbGetyEo163IIRNt88sXen3FaXKvMbOj3x5zOdi3Dv/u/TkGbpRoCB5mWghoXg32Tx47vil6LKBPBJZZKxsgyD90IilEq9pfIFlrknExSq44tKQRZUKWo6MLaMn2/Vl9Ptgyi6wq0j+ICg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301559; c=relaxed/simple;
	bh=+L6gcfszHhopQ/ct/MO6Sf2rL2jdjO8xEMOQswj+OaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4xOWLm2nZB8wmN6g/j0IcHoav9JDjVxP9fwICNNWyX6wT4uZD+KNf0aMpvU0zh+oZRDvEDAQ/B55/JmtpR9zYEL4WLIK4dULh6u4d+Uc3anqVNRlbweCYTDeWX62edp575AA1u7lk4XucIIX1zYpRF0Uo8fMQPigTYAUSpEY1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y7wrOQY2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y7wrOQY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14D7C116D0;
	Sat, 28 Feb 2026 17:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301559;
	bh=+L6gcfszHhopQ/ct/MO6Sf2rL2jdjO8xEMOQswj+OaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y7wrOQY225qOTujuezhBYfQp+rby2N6MEKpVT0yVB/J6VmTrU2QNUA9V1CvmfTxsY
	 7J5T4Umvp+Lmxc1/41sWkCVaOYlTdT8MgGeMzdEOIg1pl9n4g9wmTUTKgfqjsE7QKk
	 +Np1ogktY9rk4nwnAXrsgN0oZCVK8jF/n8LPdPyqcdIHcWSR5sCQtIpWgnkCPVDbnW
	 w1eyb865KVsakG6MjDg4x/jF9JWl7GkrPvtSVcqm9uz0MiPSoUq9Ee7nQMY2Q4buAS
	 bwGHmwsnRiLNGs9LA2M9BkECAeAqUv9zh//X/XNVrS5oT+HOLYW48CnGyJYdfxz1kC
	 sySFhHyP7YbKw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Daniil Dulov <d.dulov@aladdin.ru>,
	stable@vger.kernel.org,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 743/752] ring-buffer: Fix possible dereference of uninitialized pointer
Date: Sat, 28 Feb 2026 12:47:34 -0500
Message-ID: <20260228174750.1542406-743-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
 kernel/trace/ring_buffer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 3ba08fc1b7d05..fdb3153bbf487 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1883,6 +1883,8 @@ static void rb_meta_validate_events(struct ring_buffer_per_cpu *cpu_buffer)
 	if (!meta || !meta->head_buffer)
 		return;
 
+	orig_head = head_page = cpu_buffer->head_page;
+
 	/* Do the reader page first */
 	ret = rb_validate_buffer(cpu_buffer->reader_page->page, cpu_buffer->cpu);
 	if (ret < 0) {
@@ -1893,7 +1895,6 @@ static void rb_meta_validate_events(struct ring_buffer_per_cpu *cpu_buffer)
 	entry_bytes += local_read(&cpu_buffer->reader_page->page->commit);
 	local_set(&cpu_buffer->reader_page->entries, ret);
 
-	orig_head = head_page = cpu_buffer->head_page;
 	ts = head_page->page->time_stamp;
 
 	/*
-- 
2.51.0

