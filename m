Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E835191466;
	Tue, 10 Sep 2024 09:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961435; cv=none; b=c7bnyxr5Mlp/zULApoznZuL5Uck8G9LznUKCXxOL+xI4RxcOaNtfyRnGLYFqMUombSzyQ3nO1tqfIXtA8ckWiFW9+sS75AId0iTcI12JxIvsjsCzZ5QWH7LZlOFmT6TaGH9UIVP0TCCCxkurTQ3cjx+XY3YV2LHV6+Lxq2KlHJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961435; c=relaxed/simple;
	bh=2HE8F5Tqbq4u/nwny2GAFND5QFbqgdrxaFU/1LR2+5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FsOSRBPk69JaPu6FFMyYKj2nMA6q2BJ9+ITO6GlNE+9KEy/hNH53Z0e+pFqzbiIUzHYt49lWzX9BU6tq7asFWGmN7I4kE1y+bTsU3pakVuw3EI9poDmE+tWzcGC3Dn9u8b0BgLMbtccvYzRaNC6fFDmRGjWoDFqdbMGT/GmGCog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rEQNF9ui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rEQNF9ui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDB4C4CEC3;
	Tue, 10 Sep 2024 09:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961435;
	bh=2HE8F5Tqbq4u/nwny2GAFND5QFbqgdrxaFU/1LR2+5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rEQNF9ui0eZ6+n2JqhyQALTQISotn2wUfz6+/DdZu91iTH36BuzstUhX1Q2Tf+pah
	 mmSnQE+QzeWHppzukIKcSGZ8Ck/iOhx9uZdZW1dz46aJ/3V+SkSWadauEo3sjoB0lh
	 w+fTjvZK9TiC5cOQ3he+e9RsYOgLwmPkyuRvbEcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.10 068/375] fscache: delete fscache_cookie_lru_timer when fscache exits to avoid UAF
Date: Tue, 10 Sep 2024 11:27:45 +0200
Message-ID: <20240910092624.499929110@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
 fs/netfs/fscache_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/netfs/fscache_main.c
+++ b/fs/netfs/fscache_main.c
@@ -103,6 +103,7 @@ void __exit fscache_exit(void)
 
 	kmem_cache_destroy(fscache_cookie_jar);
 	fscache_proc_cleanup();
+	timer_shutdown_sync(&fscache_cookie_lru_timer);
 	destroy_workqueue(fscache_wq);
 	pr_notice("FS-Cache unloaded\n");
 }


