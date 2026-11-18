Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031358;
	b=rOotKZ7JK+0j9aPxwtKwSWvvIWHdWd4SNjqmsJUSnHj+TqeDPUFdCmIyCMEYeX1mdzia
	 cRmDx6NReovvx5yRcDwxwoshEYFD37mX0y5hhJ6A0Y/GcXRKPln8RrqaDtu9aM0KHZZb1
	 nJr6r3m22Ta61x8JZvXk83sql1WsFWVlwYglnk3gwoMUwb/HhK29Ytd08RKLF5079z1uI
	 ja3mnvGPpbtVL5ttzXkCz83b5Emq7Ps0HMX4+DxKVvYQAS9Nj79U+vIOb02ONMEr/9UU2
	 QlWNVpe9hUA8tmwx6Rjt81Dtwqe3DZvK+dUpuZBjoAF/cOC+PTjgTPnQFjbzNgcj5VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031358;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lnwUSI3UqLQmbC2JlIhFFJMryGkKvY1vmZ4RzgVAK8M=;
	b=p7LOBnm44zGIz3nBiecJlVSuKoEvd5fT16mO74eqG7ScqchAtqcsfw93KAa1TXyvIn8k
	 yqN80x/ruvupbThH77jT5CL4N/8EYpXI/OyIr393WKwA/E8KFCruk+yXlfOHbqr1Pin3q
	 XWYZdF5zS7kuHcO04B9YkaInwefyP85PnROpAf3lpGU6AFq33lDeqDliCmz2x/PJthV4e
	 ByYkmw9anmpGGczFq+j7oVn39m38q9fKQQ9fXoVcnU8Cd/1nqLMrpzMwgIaWgq0mWFL3O
	 qmigFek+0fiRyLyh2+Zi/otWBPtcaLQ4coSBBdV4AbMjBXM4kamFXUQhoGMHoAnnT0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ILyQgTkz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3333606A320;
	Wed, 18 Nov 2026 19:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ILyQgTkz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DB31F000C4;
	Wed, 18 Nov 2026 19:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031357;
	bh=lnwUSI3UqLQmbC2JlIhFFJMryGkKvY1vmZ4RzgVAK8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ILyQgTkzv8pqa66vnjPgrjGQRcN7NL9dWWZIp239mh6MLb+vBPfq6+UhQQ7T4k6E+
	 bF7NEiYQlH3cQ6AaokgOdn626lwP2eazAgf4Hmcs8QQwSritE91ySganm+u3WEBHtp
	 E03yME8td3LnQUvRz6oPXNnUXcsRNhuxOC+tdG54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Jason Andryuk <jason.andryuk@amd.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1013/1756] x86/PVH: dont truncate initrd address/size
Date: Wed, 18 Nov 2026 15:52:20 +0100
Message-ID: <20261118150050.471273587@linuxfoundation.org>
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

From: Jan Beulich <jbeulich@suse.com>

[ Upstream commit fcc43d1d6bf5fbd41e1e308b17187f9b759df56a ]

Consuming merely the lower halves of the provided values isn't very
useful. (While generally loaders try to place it below 4G, especially
when it's huge it may not fit there.)

Fixes: 7243b93345f7 ("xen/pvh: Bootstrap PVH guest")
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Jason Andryuk <jason.andryuk@amd.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>

Message-ID: <9698d810-6664-4a9d-a847-18ad124261e0@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/platform/pvh/enlighten.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/platform/pvh/enlighten.c b/arch/x86/platform/pvh/enlighten.c
index 2263885d16bad..5ae3ea60d934f 100644
--- a/arch/x86/platform/pvh/enlighten.c
+++ b/arch/x86/platform/pvh/enlighten.c
@@ -83,7 +83,9 @@ static void __init init_pvh_bootparams(bool xen_guest)
 		struct hvm_modlist_entry *modaddr =
 			__va(pvh_start_info.modlist_paddr);
 		pvh_bootparams.hdr.ramdisk_image = modaddr->paddr;
+		pvh_bootparams.ext_ramdisk_image = modaddr->paddr >> 32;
 		pvh_bootparams.hdr.ramdisk_size = modaddr->size;
+		pvh_bootparams.ext_ramdisk_size = modaddr->size >> 32;
 	}
 
 	/*
-- 
2.53.0



