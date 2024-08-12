Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E13329CA;
	Mon, 12 Aug 2024 16:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479644; cv=none; b=vDXUSNgMrNsSBw2StUEcb6Tnzv99gFcgGT7y32bDmFO76XGy4NLTq5hXQiRos/gNeSHI66c5NzTjDU4HhR8flpS41AS9q5n9P0QNvslYF63ejPP3zqGvGIrMSQAXYQqIjiZ1Cv/aybHuDcNMmBqzpjxrFhQBLVnmv3H59kzrGPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479644; c=relaxed/simple;
	bh=lYXC+0wJdcwRMYhLqob9gnem2CiguNZqBEUWhTeDuIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFtzJZN5rLzh3hSicR9CctFzjolwzDQsFNGJMwHrMmxjFxLRissAAxBu9JsAPzH2N/sKgEhIEOgOEvRPV/MoMWQMuOxp+u22K7T6CbAHSb77Ns3Uzgj/UeDRRNZktx38RtEjTp75I+xoF3TG6+mbJXT1yvQm+ozUYjITEPsJQlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D5jnI0zq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D5jnI0zq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1421C32782;
	Mon, 12 Aug 2024 16:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479644;
	bh=lYXC+0wJdcwRMYhLqob9gnem2CiguNZqBEUWhTeDuIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D5jnI0zqP49AaCrY5X/upG8K3gKnc4DGkN5e6wQZHYdz4poehOAgU9RBkWPwqk/Gw
	 RuoAxDKEiziuwjrYg+coBgzTomeYxvfNJVS8GwKFRCyHeYoH04pqrUYPGh0dq74ubg
	 TLrKsR9d6EqFrR68RY22yFW4+QFOfnGAm3mEq6uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 149/189] padata: Fix possible divide-by-0 panic in padata_mt_helper()
Date: Mon, 12 Aug 2024 18:03:25 +0200
Message-ID: <20240812160137.878226473@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

commit 6d45e1c948a8b7ed6ceddb14319af69424db730c upstream.

We are hit with a not easily reproducible divide-by-0 panic in padata.c at
bootup time.

  [   10.017908] Oops: divide error: 0000 1 PREEMPT SMP NOPTI
  [   10.017908] CPU: 26 PID: 2627 Comm: kworker/u1666:1 Not tainted 6.10.0-15.el10.x86_64 #1
  [   10.017908] Hardware name: Lenovo ThinkSystem SR950 [7X12CTO1WW]/[7X12CTO1WW], BIOS [PSE140J-2.30] 07/20/2021
  [   10.017908] Workqueue: events_unbound padata_mt_helper
  [   10.017908] RIP: 0010:padata_mt_helper+0x39/0xb0
    :
  [   10.017963] Call Trace:
  [   10.017968]  <TASK>
  [   10.018004]  ? padata_mt_helper+0x39/0xb0
  [   10.018084]  process_one_work+0x174/0x330
  [   10.018093]  worker_thread+0x266/0x3a0
  [   10.018111]  kthread+0xcf/0x100
  [   10.018124]  ret_from_fork+0x31/0x50
  [   10.018138]  ret_from_fork_asm+0x1a/0x30
  [   10.018147]  </TASK>

Looking at the padata_mt_helper() function, the only way a divide-by-0
panic can happen is when ps->chunk_size is 0.  The way that chunk_size is
initialized in padata_do_multithreaded(), chunk_size can be 0 when the
min_chunk in the passed-in padata_mt_job structure is 0.

Fix this divide-by-0 panic by making sure that chunk_size will be at least
1 no matter what the input parameters are.

Link: https://lkml.kernel.org/r/20240806174647.1050398-1-longman@redhat.com
Fixes: 004ed42638f4 ("padata: add basic support for multithreaded jobs")
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Waiman Long <longman@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/padata.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -516,6 +516,13 @@ void __init padata_do_multithreaded(stru
 	ps.chunk_size = max(ps.chunk_size, job->min_chunk);
 	ps.chunk_size = roundup(ps.chunk_size, job->align);
 
+	/*
+	 * chunk_size can be 0 if the caller sets min_chunk to 0. So force it
+	 * to at least 1 to prevent divide-by-0 panic in padata_mt_helper().`
+	 */
+	if (!ps.chunk_size)
+		ps.chunk_size = 1U;
+
 	list_for_each_entry(pw, &works, pw_list)
 		queue_work(system_unbound_wq, &pw->pw_work);
 


