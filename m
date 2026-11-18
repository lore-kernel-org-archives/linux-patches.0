Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019497;
	b=i5DB8RHP/wyaNazy5zumyWlrVMypNH2vllzkxrnpGbbUjIpFbktTrhTc+NT1hMnhNhdy
	 5lub4Q6j4V/WGOIhlKEa3oRmBCKWPl0lsG1TThWOH21fqpaq7mvkU4dZzqYzstjPBASqB
	 4Y1YMXMFZpeD3RjmAZ8ZOKMyD09ei5RlczhB/LQC16wTEtwjhk3kmMq9EdNAgPzGIhmTk
	 0vReVRefvaExPxwxUyjzk6qsjPMKKyCmxcEMx0yDjd7P7xjZR6aYNRVdj2t/1wyC5L3Md
	 qbUBXDeQnDPq8POz7YolmoQM7sHzNWRwTn9XRLw2xrlwTGi+8aFnsHBvir6GK7/Utrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019497;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3yp6bAwdwa5EKXxWEVFVob6JSUhVjQg05qSCx4+Ovzk=;
	b=RlL5nhdcWK+RnOTTKEf1P7HwGw7PCHYpczdo660QfMJLfAzyYDqWm74ptcOrFEgf+t1H
	 1BbFAAGRSexYMl+bU1YKcSCnebfQYmDJ9GzyRbDCvH+24G/58cpDyOxKnVoZnaOrxRzwp
	 7UCXkIxuGJF5RdaiJQ573CWM+/KuhtR3k5661v2rigxP7x61jhWT8lwkhx++R/ESYEbMz
	 knYaX6qVMarnTOBvyQEI+0ahLfJJ5+U9wJLLM6ih3HiZo7S1KmRIjf8KcDnPBXSXWbVl3
	 mwFzSkwQy19z+A8/e2ePCQyGDGHKetT9otB3uwRugl651g8serYoSEqNFSPMl9xn7yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="I2v1GQ8/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACF7606A7F3;
	Wed, 18 Nov 2026 16:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I2v1GQ8/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1491F00933;
	Wed, 18 Nov 2026 16:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019497;
	bh=3yp6bAwdwa5EKXxWEVFVob6JSUhVjQg05qSCx4+Ovzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I2v1GQ8/5VqVE7vGvri5aDEZG7BaGXrb51aR3gKsCozamxEJTW0KJLS9oJbLz1AOS
	 SfNP1jBi2/rIULjkUwfBBY2umz8luHeXZfS7LjCXG8VRqKoJt+5qfs+COk4OUgti06
	 OxcXRLOL4bhv9Oh+NN92s+pwBRzd/48fvGH5YL0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1575/2651] vfio/pci: Drain eventfd RCU callbacks on module exit
Date: Wed, 18 Nov 2026 15:46:55 +0100
Message-ID: <20261118150344.628976206@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 6757054e9d875..9bce419c52c8f 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2675,6 +2675,7 @@ static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set)
 static void vfio_pci_core_cleanup(void)
 {
 	vfio_pci_uninit_perm_bits();
+	rcu_barrier();
 }
 
 static int __init vfio_pci_core_init(void)
-- 
2.53.0



