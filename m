Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061660;
	b=sEal/Usberhn1P6AHpSocjnD3DjJ5mV3py1ceWTkivQ7Xj41S55Qq/lkM9G3FZmPCyLI
	 GtKhY2/WISz8LSYbxslciLwv5g+aden2h+zscj9PS44dC6DT/J7VifD5sVqNJNpjlTM2u
	 akp9yt8tSq6HyTE09ve/Rf9Eo8NlX0alez2nDHKvRva4QveC6wMydvLC+crNUm/uOfpXA
	 UNTVlcZ34XWVOwbQiti2IaXXeAlH45mPI4fB6UujGPrh7dTRgrl/LfvVIduuT0R4Yn7Q9
	 FQybagtHd3SIBhgHB7v+8AC6JeT3Q7akq7MIZjCKqVtFYQzZL6P+gNqoehhBHqEoVKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061660;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qCdHut/uu1zbJUxnXcx9YT0NZJXL3F/22vUuAyKuKbQ=;
	b=WvIG96RTnYGXvkHj+VP0YRFAkn5CJFoRqhg23pEmuQvpt1hVhm2evqewxGSfcAYuEIrK
	 auwUshOJOre1GX/8sz/r8Q9VF/T+N9AkhFUa+iAyak81FOa4hjlCc2/Tj9xjLqWyvx+HT
	 w4fgtHNF0sMezr9hfgg68+1EGySLcty6kEkgQP9tL2XWdqU/OcCF2m5z6PS0BdcK7ZENC
	 /Uqy4NEOvqhh6Oi1HEPLWZ7/7yv8b9scRBiCbrPED9BBdhpLrZLvwuSfCv7hT47tPeCsX
	 +4MIQAoUE90nu8xF1UIFjwrj4BP1TchbeNSnrM+fD2kFn8RiP5jQBKcfrq3a1Z9cLtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BJuaqWSu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5613C606A32D;
	Sat,  7 Nov 2026 14:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BJuaqWSu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B741F008A2;
	Sat,  7 Nov 2026 14:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061660;
	bh=qCdHut/uu1zbJUxnXcx9YT0NZJXL3F/22vUuAyKuKbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BJuaqWSuUu3lkkFvWyV0GDnNl2np6LuRPr1LzeIH1l37Hont9lE2C3qkXpFtUYvRD
	 1udDVH5Ux9kQhEpJgMMjoqWc4ylBg7uWTnFzaLJHyTEXTW+wIpYBZ5JQwsJR16U8CM
	 psINq4Zkvehz6y6li/E77S/nloIWyEtlX4XP1QTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.12 0718/1536] EDAC/mc: Really fix error path ordering in edac_mc_alloc()
Date: Sat,  7 Nov 2026 08:45:34 -0500
Message-ID: <20261107135017.662461291@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Jean Delvare <jdelvare@suse.de>

The backport of 51520e03e70d ("EDAC/mc: Fix error path ordering in
edac_mc_alloc()") to stable kernel branches is incomplete due to a
different memory allocation scheme. In v6.19 and earlier, the device
initialization must be moved further up so that all jumps to the
error label are covered.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: stable@kernel.org # v6.19-
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/edac_mc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index a3d4860c8fbe5..5771feec249eb 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -366,13 +366,13 @@ struct mem_ctl_info *edac_mc_alloc(unsigned int mc_num,
 	if (!mci)
 		return NULL;
 
+	mci->dev.release = mci_release;
+	device_initialize(&mci->dev);
+
 	mci->layers = kcalloc(n_layers, sizeof(struct edac_mc_layer), GFP_KERNEL);
 	if (!mci->layers)
 		goto error;
 
-	mci->dev.release = mci_release;
-	device_initialize(&mci->dev);
-
 	mci->pvt_info = kzalloc(sz_pvt, GFP_KERNEL);
 	if (!mci->pvt_info)
 		goto error;
-- 
2.53.0



