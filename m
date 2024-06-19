Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79ED1E492;
	Wed, 19 Jun 2024 13:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804009; cv=none; b=An8D8hCbhBZjk8gZp/FwyBC6z/HuCf3VJ5lmzetmPnymWUKAXnvweIcJMUhj7rZoR4NFKD6DaRYHtSlAaIPxaRhTt4TkRW3JmRTaMtGHEqmXccL+jin5WhWING5eI/6/IL1vUtUrVH7tPE4dPvzYpUfGQP73rO8U9yhyva3VEt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804009; c=relaxed/simple;
	bh=TIszte8/k9NxIgCbigQe3nHIfn8qDqn1Mhh8xagRENU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AyeCz2UcmEFNGcMa35dU1KXnXtlmaxwAYXoVsT+DPWT4tWZG7EjCge6D/eR+UcKadPBB2WlihqLiNBFp9f4yRVJMsGEykj/vbUbK9g8v33YZhte2NorDOs9ubg5tL4eU/28odMf5EEhqx53ACGgBZnAbxKplQaZARUlvtPxu3ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KHHSg0aZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KHHSg0aZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B07DC2BBFC;
	Wed, 19 Jun 2024 13:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718804009;
	bh=TIszte8/k9NxIgCbigQe3nHIfn8qDqn1Mhh8xagRENU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KHHSg0aZIWquT4sc0HYlfuPAgl6dQITJMNt8XpcT1VY+lD/f08iz7J1Nvg//04joD
	 SdJHQuiZK8LIZhNFVFCAOuQQckbnEk5JuDE9Ns6CkG+N3wXDt4GwDdTOriXg/Udvcl
	 SJVXTQozi6PLX00o1hVTmVXVePEmmGs7hApLIZNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Baoquan He <bhe@redhat.com>,
	Dave Young <dyoung@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 179/217] fs/proc: fix softlockup in __read_vmcore
Date: Wed, 19 Jun 2024 14:57:02 +0200
Message-ID: <20240619125603.593758673@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rik van Riel <riel@surriel.com>

commit 5cbcb62dddf5346077feb82b7b0c9254222d3445 upstream.

While taking a kernel core dump with makedumpfile on a larger system,
softlockup messages often appear.

While softlockup warnings can be harmless, they can also interfere with
things like RCU freeing memory, which can be problematic when the kdump
kexec image is configured with as little memory as possible.

Avoid the softlockup, and give things like work items and RCU a chance to
do their thing during __read_vmcore by adding a cond_resched.

Link: https://lkml.kernel.org/r/20240507091858.36ff767f@imladris.surriel.com
Signed-off-by: Rik van Riel <riel@surriel.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/vmcore.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -383,6 +383,8 @@ static ssize_t __read_vmcore(struct iov_
 		/* leave now if filled buffer already */
 		if (!iov_iter_count(iter))
 			return acc;
+
+		cond_resched();
 	}
 
 	list_for_each_entry(m, &vmcore_list, list) {


