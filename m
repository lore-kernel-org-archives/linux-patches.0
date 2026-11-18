Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031380;
	b=sndr2tHg0b1GXNo5lJYHjA2Ims0RAjI9bfiQ4qpTakS6rgNhoaO7vtCWhqUBcRgSOHDS
	 p8NIZD50rHB2JunUiwSNAL9+VuhZtsWLvxbE3XQpOxSwheoyoc9ID9yX3bXT5qWAK2zB+
	 0lpZl3lIHrt1/YhtaXsGMqFKI4814cwDtwdMnnQp7YSYMOQgnjoJkZ9aKWXYMJtHNKCP5
	 TUhcob0cbtUCSFzkodtU6JvPjp/URh/+93x041B1zTAyHZOxtbWdIYA4R1zDStoj4HWHi
	 lWd1vO9NceWdLMJjEtDnE/2Tp/4YSTJJHPI6PKMOuFbesJSlfXaG660dlu6RVMnW4vQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031380;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hHsHJ+3Zk2e9A9MdxjzsH0H5nNaA8fEa04wWaPK7+Ok=;
	b=yPLidUvuXZDhDyJHhzgDibmPr+FzQp/YJi4CXWsQvjuTS3HH8yTHtBmUOdCOYVaF+xtf
	 6yHVvBjRZg33CYQXpfB5Fm83d3+oIqGzu8PsqcJ/9yRPvv2y9m83Le6FnvDH3ShRWpJQv
	 sAy4s00WvMGYmY5sf+qaB+nLvBqMfQdOFboJr6dvXBAevS9aHWkx48u3vNzIxNUVDTtaQ
	 s5BOIEQGsRs5wRH6rYupNro4CZZygOc9Th4fuURzS286KpB0p2qloxqseWhfyZib4MY2l
	 xcuv9MXneORn//Qw3XIGDX0wXuhGzUNlV6sj5hHTx+tVIxLbDyITpLBzXltMc+bk83Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1okoUrCH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9720560A2601;
	Wed, 18 Nov 2026 19:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1okoUrCH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60B21F000C4;
	Wed, 18 Nov 2026 19:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031380;
	bh=hHsHJ+3Zk2e9A9MdxjzsH0H5nNaA8fEa04wWaPK7+Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1okoUrCH8pntHSH6WUMz/cPpBrFleVJ7lnoNB8Nnaf9wUFJGppOi9reMUVLI+QkCB
	 2LUXxwS/UEjDcVBnZfIEGR0izEzobfnfvPU/axe9KvmxEajoVBFJ/sdBIZwAmbjCW/
	 t0fKhF45kEieiH+kM40QuI4B6NzxU6X9G2ZWV2do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1038/1756] vfio/pci: Drain eventfd RCU callbacks on module exit
Date: Wed, 18 Nov 2026 15:52:45 +0100
Message-ID: <20261118150051.386729193@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 3b2e9b05011ee74543b6d17401bb02f1df3b93ff ]

vfio_pci_eventfd_replace_locked() defers freeing replaced eventfds to
vfio_pci_eventfd_rcu_free(). A callback can remain queued after
close_device() returns and the device driver module reference is dropped.
Once the dependent driver is removed, vfio-pci-core can be unloaded while
the callback still points into its module text.

Wait for outstanding RCU callbacks before vfio-pci-core exits.

Fixes: 98693e0897f7 ("vfio/pci: Use RCU for error/request triggers to avoid circular locking")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://lore.kernel.org/r/20261003093806.544631-1-yaojiale02@163.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index e76e33e7d24b3..7a7c1683512f6 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2613,6 +2613,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_set_params);
 static void vfio_pci_core_cleanup(void)
 {
 	vfio_pci_uninit_perm_bits();
+	rcu_barrier();
 }
 
 static int __init vfio_pci_core_init(void)
-- 
2.53.0



