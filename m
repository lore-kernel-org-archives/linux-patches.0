Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049392;
	b=jJfxCnaIULftjF33Si7LbKSL+wm6JTj8qZPfezpW4Lke8v3VjrIjZiseBtcVF4K5D4vU
	 Bcmu2r9Fx9DbzJXx2+bqZyobkKF16HKvCGDbBeUSf7rfAOBnHmxoMe5q6sYgDafKdmaLC
	 +D3PUSleQn1bOncseF9fDIVl7nkztMMbyGGVGNMWjubFPuS5vO1Ngpyamf6I8pU0hHpy6
	 zS7NaTC71PIJ0QC4eciz/57gLN3gaSTNvbO+arnCywu2DXgqNUcgFI0tVBCHSWbZQufaj
	 SBKIN2g33j20WXHnEOPZJXKcA/CKLl/BQ8nQ3KJHeGn+YbvF6WPSszMtiH7XVh9yjvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=91rP5DxsSGzt+Qmy6dfgYyUvD2KnXqm8nJRZYZCS3qo=;
	b=BClxxJQ55AqQpiq3l0whCrdL152dMF3nDQe3oRnqJXpQFzjl3jgGfSxHmO/Yt9740YzV
	 qBbs5JotkjVg33oDCH858I10jJg5QqAySR9/5XFri/tVPDckcJ8JCLLpHVRs60Ir8+oXl
	 92zbvnBqkvbszu3KXyaUN00SBABu+Bbip0FIZY1VU1OTq3wh0SEBgkC0IocdB9P291FVR
	 tTVfgkyCUPciKl3Ek8LV/ESoG17FLx34Sx+PbMnFTBxhUfcVciF4prozSefYxN5BJeeho
	 GgdxpVjOEO11exeSSW+TNVvfLNePuN1PPEsGfnG73AUSzlURdsEIWua8cJMytqxcQPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OU30fsfK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04809606A31C;
	Thu, 19 Nov 2026 00:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OU30fsfK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531BA1F000C4;
	Thu, 19 Nov 2026 00:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049391;
	bh=91rP5DxsSGzt+Qmy6dfgYyUvD2KnXqm8nJRZYZCS3qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OU30fsfKn/yM1/JFQyKM2b9JNH5KHuE7W0ihaM7QZ3MIRte36kyNRAjBXxs7+dHQl
	 H7sNU/iTQrpSHHk0RhaNhlefcqqZOb9yLs9ZOf7xWMFBCSIhs0EKGXg8u18Qr/nl6T
	 WuTDsMEG5xH2KSBRIVUtxvqiHRzMNfk3UYsZPvKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Jason Andryuk <jason.andryuk@amd.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2335/2857] x86/PVH: dont truncate initrd address/size
Date: Wed, 18 Nov 2026 15:56:09 +0100
Message-ID: <20261118150325.608009252@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



