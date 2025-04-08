Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBA026A0AF;
	Tue,  8 Apr 2025 12:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113977; cv=none; b=A6apXcy2dHQkr9ch3Qbi0WkRRzMrPgfx9K/OkO5bBJcOTo79WUhTVfQhJf/eppRSF8HSm7T+jpzR5osHD2j/h1VlB6pceXXtkjMx1XJnYoiIud5hAu8UTLEKSSAuxs6ChmzJTgocZyXf7Ms5eu5jO0AZaw06fI8XKjqx2PIUJyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113977; c=relaxed/simple;
	bh=thZ1sDa82j6aQbYRVLZyh3ppDUGKJmShqmIXYxpkdD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+EEaFrsYxVNg0Z2CcMpfSKcPzy0JfyzpaJ9IuU89ABQfDROWypQ+303cWx+QbrkzsKNuUggBffrXJ4PjhUyzLJhxA6W6sIv52TEjwAERYBpGwyQ7gBn6fLd/ppfJqRuk6loNjF2NPT3sTiNQOjm3GqFTGYL+OfFRMszXq8vkT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KbGkJvuL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KbGkJvuL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316D5C4CEE5;
	Tue,  8 Apr 2025 12:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113977;
	bh=thZ1sDa82j6aQbYRVLZyh3ppDUGKJmShqmIXYxpkdD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KbGkJvuLXdhFYRKmT5uG3d8Up0SzCQljgIh8o/RVjg+CSUZMRunX2CfK5naaGdu+o
	 nA7wKvdlHgJObMSdrWFIi8jdPq8GNgDVE6FvyzWFiL8Eu69mfMJoEcZClxHW4EkrGg
	 Py5keXJAs/3W/bWiENFOlkSgUzqEM59aJg5cWNFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Chen <chen.dylane@linux.dev>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 091/154] perf/ring_buffer: Allow the EPOLLRDNORM flag for poll
Date: Tue,  8 Apr 2025 12:50:32 +0200
Message-ID: <20250408104818.239417254@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

From: Tao Chen <chen.dylane@linux.dev>

[ Upstream commit c96fff391c095c11dc87dab35be72dee7d217cde ]

The poll man page says POLLRDNORM is equivalent to POLLIN. For poll(),
it seems that if user sets pollfd with POLLRDNORM in userspace, perf_poll
will not return until timeout even if perf_output_wakeup called,
whereas POLLIN returns.

Fixes: 76369139ceb9 ("perf: Split up buffer handling from core code")
Signed-off-by: Tao Chen <chen.dylane@linux.dev>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20250314030036.2543180-1-chen.dylane@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/ring_buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 679cc87b40f4b..0611477e4dadd 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -19,7 +19,7 @@
 
 static void perf_output_wakeup(struct perf_output_handle *handle)
 {
-	atomic_set(&handle->rb->poll, EPOLLIN);
+	atomic_set(&handle->rb->poll, EPOLLIN | EPOLLRDNORM);
 
 	handle->event->pending_wakeup = 1;
 	irq_work_queue(&handle->event->pending);
-- 
2.39.5



