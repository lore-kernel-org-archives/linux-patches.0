Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061870;
	b=g25AOhcbLfzXNHo8/0EvRucsZhWr0Sw4Taf5GBjx3Z2R0z2aMWdo1lW7/c87AvRavwDU
	 tIbZPYH38odLRZkn+dJn7fnmXTs/X+B9KiuiOckQwLRFGtiC5gwdpR5qJtbHxLOvrW+88
	 qHVLlxqOAjFkw2ilUoSSr2zq3ZCsLg2shWVAntuxEG/tgUUL4VdJK15NOHAxO/8p8yZVE
	 mfdgIN2Td0hZjkrn0+RJmStwLcgddha9y9drUzaB3Dz1J84RRWEb6ArYPGlkyrDVG+YQs
	 LhXmbv3xT/ADlZncMHk4/GJYFSrLFPZ+ViiwDomhgfhjpnpexNGLp9mMpRpJ4vbEVvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061870;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/YH2+vlv0GQWOBIvlaM1gpz0YUzJrhXVVMdDwsFhBb4=;
	b=jNjyLpQR0fb6geC8K8CsbbzCMeyJ2tyGjJrTU8VeFvrx3Gm+nr40p8soX88XNflCpGKt
	 v4qyD+6kNz8P+Bqvq8Ett3t6cFfFzStHqn2Du1zoF3JUab0Qsk9nVfbNt2mDZmnEp7do/
	 gllqRGa9ewkFR3DQ/XoOMyplCrQXal37FAu/Mw5/TpRkioHkcWU3kVtE6NXOnSupOwFNZ
	 k1F/tHuEGF6zOH1I4KIRVXqaezNpg0+IbYmT5LoB7UCCun0CM2sFz8yvCqIqXdxNBHEiN
	 r8gBlQ0e1flb8CRu7w70nh5sE02aEBUSRSRu3NwyC44X9jpYrWGOs3eXeDbt0e8BuVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vBGuTpzW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAAC606A32E;
	Sat,  7 Nov 2026 14:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vBGuTpzW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2811F0089F;
	Sat,  7 Nov 2026 14:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061870;
	bh=/YH2+vlv0GQWOBIvlaM1gpz0YUzJrhXVVMdDwsFhBb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vBGuTpzWkwmB7UfBWJcQtJcyv8AfV+flw5vQfidM5dez19pe+4oWykXbETUPfmB6H
	 zkQ3estl81HpufkBg0IEzSsZY078svLv9ikGukJjJgMJvLmhZIJbya1dxuyarU1vyQ
	 9kYoHNOEwJ/FEX1Z5NAXB6yTXSanVfI+m3z+1J34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0885/1536] media: rc: Fix race between bpf(BPG_PROG_ATTACH) and device unregister
Date: Sat,  7 Nov 2026 08:48:21 -0500
Message-ID: <20261107135022.482465087@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

[ Upstream commit b3f5daf3222999d3f92f606a4eb5e35ab90fd0e4 ]

Mark the device as unregistered before tearing down raw IR/bpf
state, so that racing bpf(BPF_PROG_{ATTACH,DETACH,QUERY}) calls
cannot slip in between ir_raw_event_unregister() completing and
dev->registered being cleared.

Fixes: dccc0c3ddf8f ("media: rc: fix race between unregister and urb/irq callbacks")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/rc-main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index fb52ed2d4ef6b..eb19ee6765dfb 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -2030,18 +2030,18 @@ void rc_unregister_device(struct rc_dev *dev)
 	if (!dev)
 		return;
 
+	mutex_lock(&dev->lock);
+	dev->registered = false;
+	if (dev->users && dev->close)
+		dev->close(dev);
+	mutex_unlock(&dev->lock);
+
 	if (dev->driver_type == RC_DRIVER_IR_RAW)
 		ir_raw_event_unregister(dev);
 
 	del_timer_sync(&dev->timer_keyup);
 	del_timer_sync(&dev->timer_repeat);
 
-	mutex_lock(&dev->lock);
-	if (dev->users && dev->close)
-		dev->close(dev);
-	dev->registered = false;
-	mutex_unlock(&dev->lock);
-
 	rc_free_rx_device(dev);
 
 	/*
-- 
2.53.0



