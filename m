Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D20318C003;
	Tue, 10 Sep 2024 10:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964041; cv=none; b=kQh0wyW5S0qJEYAA4hYMewljcuaYuYCIQhbleJiVPWAJ42z6aPSmfvw2uugP7Gvn+kwwRMG7U2rVUX7RA8gfsM1DzPTRIUqLv5vatZtng3ll1xoT+veE5kr8lasaJkXJrYjWvY+2N1LSR/AGghQzk/uy3a2FClf1o5EdaZKP9vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964041; c=relaxed/simple;
	bh=eoNo7AZtGJYU5ksIqKiFekhAInnClN4/rdb43FRZaEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kdCHdTh+W1HLbx7hHtVQmsBK3qNV6cIWt/Djv6ACyQunD7esI+b8tyhRxdW6p7D3mTnstgnG6HUjjGzlsIuW0sp0pDWCv+OuIhgm1dbS+AL3FxLqMXqp4p4WwVd5Fc4M11yGFghIPQItWviT3IGsXZ6caS0mSHteWx4JUFoX/2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxc1WHVN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxc1WHVN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D8CAC4CEC3;
	Tue, 10 Sep 2024 10:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964041;
	bh=eoNo7AZtGJYU5ksIqKiFekhAInnClN4/rdb43FRZaEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lxc1WHVNzr6vO7W52BVxQFbTjaqjMd1mRz5DMatkCVBRRrunxhB/7s2Xap3dlzGyV
	 GfK0UK4pi2N/RpEHhAGLxI7BYvQVCep8eR2EHoqpsJrxEvGJYopN24D4yPzujcGNet
	 9Pr5TlzEaQ9i/CyI35C4tbdze8hhOt9u4Ta0IE04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.6 047/269] fscache: delete fscache_cookie_lru_timer when fscache exits to avoid UAF
Date: Tue, 10 Sep 2024 11:30:34 +0200
Message-ID: <20240910092609.929071860@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

commit 72a6e22c604c95ddb3b10b5d3bb85b6ff4dbc34f upstream.

The fscache_cookie_lru_timer is initialized when the fscache module
is inserted, but is not deleted when the fscache module is removed.
If timer_reduce() is called before removing the fscache module,
the fscache_cookie_lru_timer will be added to the timer list of
the current cpu. Afterwards, a use-after-free will be triggered
in the softIRQ after removing the fscache module, as follows:

==================================================================
BUG: unable to handle page fault for address: fffffbfff803c9e9
 PF: supervisor read access in kernel mode
 PF: error_code(0x0000) - not-present page
PGD 21ffea067 P4D 21ffea067 PUD 21ffe6067 PMD 110a7c067 PTE 0
Oops: Oops: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Tainted: G W 6.11.0-rc3 #855
Tainted: [W]=WARN
RIP: 0010:__run_timer_base.part.0+0x254/0x8a0
Call Trace:
 <IRQ>
 tmigr_handle_remote_up+0x627/0x810
 __walk_groups.isra.0+0x47/0x140
 tmigr_handle_remote+0x1fa/0x2f0
 handle_softirqs+0x180/0x590
 irq_exit_rcu+0x84/0xb0
 sysvec_apic_timer_interrupt+0x6e/0x90
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20
RIP: 0010:default_idle+0xf/0x20
 default_idle_call+0x38/0x60
 do_idle+0x2b5/0x300
 cpu_startup_entry+0x54/0x60
 start_secondary+0x20d/0x280
 common_startup_64+0x13e/0x148
 </TASK>
Modules linked in: [last unloaded: netfs]
==================================================================

Therefore delete fscache_cookie_lru_timer when removing the fscahe module.

Fixes: 12bb21a29c19 ("fscache: Implement cookie user counting and resource pinning")
Cc: stable@kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20240826112056.2458299-1-libaokun@huaweicloud.com
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fscache/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/fscache/main.c
+++ b/fs/fscache/main.c
@@ -114,6 +114,7 @@ static void __exit fscache_exit(void)
 
 	kmem_cache_destroy(fscache_cookie_jar);
 	fscache_proc_cleanup();
+	timer_shutdown_sync(&fscache_cookie_lru_timer);
 	destroy_workqueue(fscache_wq);
 	pr_notice("Unloaded\n");
 }


