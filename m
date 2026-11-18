Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056085;
	b=Yjid2xabc7kwb8+Hq5SbDGgJqC+c+0XDAyTpyg98mq9nryJJzk/vpwAr1vIi6LE89tNi
	 4DpP0sl24NGOd8kW9LjfqQim8V5eRAIBKpRN50TTTQlaZ3SyImQWa4gNhC5dGTIiKTAsE
	 HN0jICkVckNSiPslukKG2G/q3glHcFJyPqz8Wx75JoTKxAo99LpNvbB/9ZiDTU5rRdY8A
	 jajYlt76O/lhFAbsInTLh9Z0U1pXgJqpbU0jOTkzW9shYcbr5SvXoBIq3aOIXOAu3rY9M
	 43sBjvjiSkHwm5JXBf4TH9LyFkNhEtY7aPhl1zXs9jMHfGwKEE5YhydXWQB/NHvC0/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jrkFJPopZwmye9E4xcFgl9UAB6lb2yUBbGLya9Z3aPA=;
	b=nwBrKj6WHL3wS8nmx/1NlV46QDkihXgIpZdLaE1MUaFxAK24ex/IETQmYDYjkhf00/ru
	 sVr+zXDmdMQxXtSj/ypaU6bxB30faUAmOuctPI86Z9LllE0+UdjxdQ2E4hR6eMq1c9Ceg
	 +pkHDX47sKskAH2jUDjfLKpwWtqtQQhiARYvWF0kHTehXcPOEC818vJDeX+PfwIcqq6+n
	 qpFZHe4YsBUBs+4U45IK8+NNiWxWjK6ej1M2heQff97SMhLxPsHwOEYUEh31kzph31KMi
	 Y+pS/RGjn/Alpwow3zpxmowKxwugkEz+osgH/gBXR3yNsKkmCfAzcwvT/JztxPxJqyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="l/uE7EM2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54558606A320;
	Thu, 19 Nov 2026 02:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l/uE7EM2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABFFA1F000C4;
	Thu, 19 Nov 2026 02:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056085;
	bh=jrkFJPopZwmye9E4xcFgl9UAB6lb2yUBbGLya9Z3aPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l/uE7EM2/M0ebPkN3hs25Pn1ExIiRumbDBp8tmp59Di6RwwE2+imlDPlbLTr3Ekls
	 ++FDAwymTpPIBssxa/pRUYpMh2ZeK2r0N+01QpwgsudebHvokgiXaO4LYHWXI2BOET
	 moVjIXT0tw6DPcS4C/GfP1u+xJ/91ASxEOtV9Oag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Jason Andryuk <jason.andryuk@amd.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1821/2214] x86/PVH: dont truncate initrd address/size
Date: Wed, 18 Nov 2026 15:58:17 +0100
Message-ID: <20261118150124.307350707@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ed0442e354344..443ce7547cc78 100644
--- a/arch/x86/platform/pvh/enlighten.c
+++ b/arch/x86/platform/pvh/enlighten.c
@@ -82,7 +82,9 @@ static void __init init_pvh_bootparams(bool xen_guest)
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



