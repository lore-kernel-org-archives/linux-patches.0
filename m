Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B95227EBD;
	Tue,  8 Apr 2025 11:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112637; cv=none; b=OuwPd30qgCsARND8i2rCYoh767lO8nopsCul3uIWV7eLMOAJ2omCCtDEypfuZaH40vgax2Ru/N1X4B/29gVuwVWUCLh0GyyCkQHbsAPLgZy8zo8GnFWLSIPlH95LhlFc66pSq7OupMCSGOUWltmn/mZnZHVb+cMF3P5SYWJ6QEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112637; c=relaxed/simple;
	bh=/qwqKm1SPO6cMACNUyjjsnl+zP28iN9hBQXLuKK58g8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+4fNwRbhjST98iUVkPAe4PVTYH9jk9Zc8uHbMTsjS7WyZ3iVqHWAm/eHA0j+8PAcpzqFLdHlDDi2prIE9Xcbf46zMI0+svDGHh29cFMFSHQOGEcPaNlIOW3YWtdhZ4jwQ6EatqVVAe0a002hapDXqCi9bdpochLRJ20EazZ48M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2mtzofJF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2mtzofJF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABE9C4CEE5;
	Tue,  8 Apr 2025 11:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112637;
	bh=/qwqKm1SPO6cMACNUyjjsnl+zP28iN9hBQXLuKK58g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2mtzofJFzme3edTdV9sVrFee/VlEEQOZfn+zbS+Z4Xw22rrjPjLnLGwT6F7AXwvwu
	 JvYSy+KfBocU+ddPV46gCLCJE2GHuPG5evtqaw0UMKbcygDhuIt0EAkCjCfBpSyHN2
	 LA1n2XsjR1v8kc+oz9GdUF7jJwdd2woFSCSrx5gc=
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
Subject: [PATCH 5.15 142/279] perf/ring_buffer: Allow the EPOLLRDNORM flag for poll
Date: Tue,  8 Apr 2025 12:48:45 +0200
Message-ID: <20250408104830.175396149@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 98588e96b5919..3e1655374c2ed 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -19,7 +19,7 @@
 
 static void perf_output_wakeup(struct perf_output_handle *handle)
 {
-	atomic_set(&handle->rb->poll, EPOLLIN);
+	atomic_set(&handle->rb->poll, EPOLLIN | EPOLLRDNORM);
 
 	handle->event->pending_wakeup = 1;
 	irq_work_queue(&handle->event->pending_irq);
-- 
2.39.5



