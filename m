Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B75632B11D;
	Sat, 30 May 2026 17:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160650; cv=none; b=sNXC0rzCibvnKuXdkwWab5j6Zqqqsq55Trk6NlgO1RWJVTkbLECof1j+0xkNTnX71sEdXuceYxXt9Yz9v+KpoMrwsjNGipSa+kUhWNjtIQoTdjGnLHG1AtOVhjBB4cRMfd/HAWIZ/caNE6qbZXjJ7zPmWrXR0GWs/yj62dJbl1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160650; c=relaxed/simple;
	bh=WF9Yxlnt7sWkCQkx69o/r0OfTgmTJFy2uqOoQN0zcJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJQL7vFos1wOPp0kKfJfEcnccRdstnT40q+sYYfU6QGSagEO+exHB1HDwItpJJWMMigSJr9XCyZy6W/OK3GMWv/SeqQB9NivPd5VxiTnpdmNR8ac/GvQfzcMjjtJ1DfmB96T4l8E/5QWjwkNg1elewasOVMYFyzUOpM7SsHBBhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pJNIgo5H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pJNIgo5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7203F1F00893;
	Sat, 30 May 2026 17:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160649;
	bh=OgtVu3TbyhvI7UpNFX5vzzASo49U4PHDRIDmgyXjsSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pJNIgo5HkE4mh9gXdaaC4X2LvZbtQKyWW3CG9buvIMwfbxkYh1h3koXiaH8VPR7aY
	 WjZ22ADrxkrFm4eou/mz5IJ2x348TNLGioQyPvNMbqF30w7q+Frg/hRkEBhR69afc4
	 f1sRoezWwBkrScGwn4HXwBcxps4CDnhWjxrcQjDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@auroraos.dev>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 395/969] media: dib8000: avoid division by 0 in dib8000_set_dds()
Date: Sat, 30 May 2026 17:58:39 +0200
Message-ID: <20260530160311.205404521@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Sergey Shtylyov <s.shtylyov@auroraos.dev>

commit dde3c37af95cd6fa301c4906f33d627bc9dd874c upstream.

In dib8000_set_dds(), 1 << 26 (67108864) divided by e.g. 1 apparently can't
fit into 16-bit variable unit_khz_dds_val, being truncated to 0; this will
cause division by 0 while calling dprintk() with debugging enabled (via the
module parameter).  Use s32 instead of s16 to declare the variable, getting
rid of the cast to u16 in the *else* branch as well...

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

Fixes: 173a64cb3fcf ("[media] dib8000: enhancement")
Cc: stable@vger.kernel.org
Signed-off-by: Sergey Shtylyov <s.shtylyov@auroraos.dev>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-frontends/dib8000.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -2694,7 +2694,7 @@ static void dib8000_viterbi_state(struct
 
 static void dib8000_set_dds(struct dib8000_state *state, s32 offset_khz)
 {
-	s16 unit_khz_dds_val;
+	s32 unit_khz_dds_val;
 	u32 abs_offset_khz = abs(offset_khz);
 	u32 dds = state->cfg.pll->ifreq & 0x1ffffff;
 	u8 invert = !!(state->cfg.pll->ifreq & (1 << 25));
@@ -2715,7 +2715,7 @@ static void dib8000_set_dds(struct dib80
 			dds = (1<<26) - dds;
 	} else {
 		ratio = 2;
-		unit_khz_dds_val = (u16) (67108864 / state->cfg.pll->internal);
+		unit_khz_dds_val = 67108864 / state->cfg.pll->internal;
 
 		if (offset_khz < 0)
 			unit_khz_dds_val *= -1;


