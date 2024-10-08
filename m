Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13AB81DE88B;
	Tue,  8 Oct 2024 13:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392484; cv=none; b=MOBUCukdelQ0UpDEYHHGhAi0B46QQw/n3LOtmCz4PmsuWsLuNCwFI1J92QjqSPzDRo+ua7HPuvGz3pbzuHY69cr5Q6NFBmvzVZWFB65Ca5qX/NY9b/MPv7MywoMI5pZ5NIhZ3T7GgSKLrwlob+HTvsiihG6/qmRZGpH0PAL4C1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392484; c=relaxed/simple;
	bh=oQeuID/8/+3aR9dQu42ygwzzvSWuu/Q1UGKcEkL7ZaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A59xeq3gyUQORETw3kyHxgXg8O4QDLN8el9wdMrixQWprK3e5SpvKVSUttKKjSAVcjAaFfN/LgN3ViDegrJxMXy+kbPlfiNlar0Jki47SzFgzxe8j2uCzfHB8yajpydUzN8EIuKq5iCU+mzRsbYCCKQ7TojgBih9cwccR8wnyOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sDdKQqS1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sDdKQqS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D41DC4CEC7;
	Tue,  8 Oct 2024 13:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392483;
	bh=oQeuID/8/+3aR9dQu42ygwzzvSWuu/Q1UGKcEkL7ZaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sDdKQqS1CYqQOIoULwBtG1wWo+pUNPxMTGvm4nL7YEcSxlbmTlffHkPOMO+VizMML
	 y/adyzSIsqm9ewRZlj5mePsRal2eYiKk0IThZXEn1h6uL0kt8hz8yGEgZP0CKY5tav
	 Li/AXGbHeRESt3cQ5fErKv4onYMg3FkaS/wKgPVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youssef Esmat <youssefesmat@google.com>,
	Daniel Bristot de Oliveira <bristot@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>
Subject: [PATCH 6.11 428/558] sched/core: Clear prev->dl_server in CFS pick fast path
Date: Tue,  8 Oct 2024 14:07:38 +0200
Message-ID: <20241008115719.115698296@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Youssef Esmat <youssefesmat@google.com>

commit a741b82423f41501e301eb6f9820b45ca202e877 upstream.

In case the previous pick was a DL server pick, ->dl_server might be
set. Clear it in the fast path as well.

Fixes: 63ba8422f876 ("sched/deadline: Introduce deadline servers")
Signed-off-by: Youssef Esmat <youssefesmat@google.com>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Juri Lelli <juri.lelli@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/7f7381ccba09efcb4a1c1ff808ed58385eccc222.1716811044.git.bristot@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5828,6 +5828,13 @@ __pick_next_task(struct rq *rq, struct t
 		}
 
 		/*
+		 * This is a normal CFS pick, but the previous could be a DL pick.
+		 * Clear it as previous is no longer picked.
+		 */
+		if (prev->dl_server)
+			prev->dl_server = NULL;
+
+		/*
 		 * This is the fast path; it cannot be a DL server pick;
 		 * therefore even if @p == @prev, ->dl_server must be NULL.
 		 */


