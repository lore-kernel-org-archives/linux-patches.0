Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605CE35C1B6;
	Fri,  9 Jan 2026 12:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962992; cv=none; b=OlOhvotpRWa5gYfl39FC4cMwWKzgwkdBGSDQq7RQ4Hj+29C/EuKpfgmzkMnAbnstolMXV+BJlAKZh86yPj1wXG+zvd4cSyqAXJf2Ip6ApXN83prQ6FOii+qmeG9SlzC6CCuARZCuex0+g5Vcd9YtFAvMouFnCeaSSNdKZrIWdFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962992; c=relaxed/simple;
	bh=JUD5bUOPNLUkTZ22CtgkgZoknJEZW21/35NOMdS0dWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9tDHEvwVKnJ/8PuqiwAd1OJLgI+UqYXkMVjEQ81xtKveH7ayVUTCQxDSgypHpK6Jxz9pWffevV+0QD8/eXBFZ0DmvFfGCdVNIap+ZAAnWMMngpwZUDuroVZE/NMst0ImX9SUwNa+ZOspNfT664q270oTXTc4GGJlVFf6oipNpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDsv1xZW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDsv1xZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E219EC4CEF1;
	Fri,  9 Jan 2026 12:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962992;
	bh=JUD5bUOPNLUkTZ22CtgkgZoknJEZW21/35NOMdS0dWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDsv1xZWVupmVh3DE2ECmiWC9eCgIrXO8fmRAeYgjU7W/eqwGkEFYcgrcBvXClSTN
	 l+Ehx2n9HeMGqZfTDU2u53Co3iMaFd11W0HaBJ8iYgvROATCEIeqlRF/iC38/fF6yM
	 liEni/kZQ6fAhn5wCgfDug6ta3sqhi8QSYzMZCAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Chen Yu <xnguchen@sina.cn>
Subject: [PATCH 6.1 527/634] fscache: delete fscache_cookie_lru_timer when fscache exits to avoid UAF
Date: Fri,  9 Jan 2026 12:43:25 +0100
Message-ID: <20260109112137.396227194@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ Changed the file path due to missing commit:47757ea83a54 ("netfs,
fscache: Move fs/fscache/* into fs/netfs/") ]
Signed-off-by: Chen Yu <xnguchen@sina.cn>
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


