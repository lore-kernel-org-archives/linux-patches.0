Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046312;
	b=bOWNx3elFDpMMxVMBWj/2UTak0TJaQnnQgMZV7WAPu6eaFvVLN1GjuLp/vCSJXJPpY70
	 /8wEShOSv8ZxxUd58K1z+9nh8ZFTYqxecYjMF32AOvWoB98yimmej7O9C++8RHR/yfp4Q
	 GGfxSJXrHfeFUdcNmzgTVMq0ZOd+WOw3iSgvlfKNL0mDW5zRJQc+UosXFdpCHZlGtKOON
	 D7frhSmo06R+Kl3Ci3K1T51hEg/ytrdCfLsexKuR06R4LOdUMH/S7fjLULINXPBAaP29U
	 6kAix5eoiLAVbbxU4HvXLS53XCy71k+CI3NpduWlEWTxFygnAVrXZ3c8kPnewt5kw4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046312;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XPx9l1ht0pK7BMgF/X74nwYKKZEei5bW1GcC0OMjMGk=;
	b=zHaddnHWadqJBH7UWwFAycgibkI8EbvzYBMCDsjLL4V9bOUonvdcNsMAi4XyOaWX+0Yw
	 XLInjkchKC7KobXFHUyCJbpNO3Zc/1pIBcxzElryLbw0mQvfDtJ4mmolOSSD9Cqq55X+o
	 FCaaC2XgG2yf4ncvns0SaGvNI6oXXGBybvzWU1zzbft32b7+K54BdzER2PWCC3wcMkh4m
	 bvg3DCCgppzD2szSAlyh/96AQql4BTERC2HyMCfW+bsQ/K1Mprmz0wdESpC+he+8LYVHT
	 54bhyQljyUYyJN4t1+IHP4vFqvgqscFl4shpuqhDfp8aSXWrH+1/l4FDjpNKYMzNl6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ep9sKnMh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F62606A31C;
	Wed, 18 Nov 2026 23:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ep9sKnMh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580401F000C4;
	Wed, 18 Nov 2026 23:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046311;
	bh=XPx9l1ht0pK7BMgF/X74nwYKKZEei5bW1GcC0OMjMGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ep9sKnMhi7V15jiWy4UJ5Fi7TBZKePbstsiLDL0UnMSZavM9RN2mGIFCJd33WzLtM
	 BmybjxsQZg9LyExTi/edCLsA4xh53TKY3gtwUZdy/BC9bYZh68cXMSq3GKSBmwTrQj
	 2kz8aZEJgbuVs19QJR3QPsjIYBpDG4o6av/Ud+98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fang Xieyan <fangxy@xiaopeng.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1235/2857] vringh: reject empty / undersized indirect descriptor tables
Date: Wed, 18 Nov 2026 15:37:49 +0100
Message-ID: <20261118150246.024549713@linuxfoundation.org>
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

From: Fang Xieyan <fangxy@xiaopeng.com>

[ Upstream commit 60a792b97933a686316737838cd007d27963011e ]

move_to_indirect() validates an indirect descriptor table only with
"len % sizeof(struct vring_desc)".  A descriptor flagged
VRING_DESC_F_INDIRECT with len == 0 passes that test, so *desc_max is
set to 0 while *descs points at the empty table.  __vringh_iov() then
copies one struct vring_desc from descs[0] -- 16 bytes past the end of
the table -- before the "indirect_count > desc_max" loop detection
aborts the walk.  The over-read value is discarded when the walk aborts
and is never used to map anything, but the access itself is out of
bounds.

Reject any len smaller than one descriptor, alongside the existing
stride check, so an empty table is refused with -EINVAL and no
descriptor is ever fetched from it.

Fixes: f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
Cc: stable@vger.kernel.org
Assisted-by: Hawkeye:GLM-5.3-flash
Assisted-by: Qoder:Qwen3.8-Max
Signed-off-by: Fang Xieyan <fangxy@xiaopeng.com>
Message-ID: <20260926160755.21485-1-fangxy@xiaopeng.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vringh.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 4506f65396b02..060135750d601 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -197,8 +197,9 @@ static int move_to_indirect(const struct vringh *vrh,
 	}
 
 	len = vringh32_to_cpu(vrh, desc->len);
-	if (unlikely(len % sizeof(struct vring_desc))) {
-		vringh_bad("Strange indirect len %u", desc->len);
+	if (unlikely(len < sizeof(struct vring_desc) ||
+		     len % sizeof(struct vring_desc))) {
+		vringh_bad("Invalid indirect len %u", desc->len);
 		return -EINVAL;
 	}
 
-- 
2.53.0



