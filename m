Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26350514766;
	Wed, 30 Sep 2026 17:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787801; cv=none; b=OEcCINRtKg1uiuWMb5hyYvBBXM7L7yN8uO+0ARwc/Xb/2HM7jrinCXL56txW8GXn5VNp+Ml0ktGAnO6orymdls6lq3dU+XAPihGmj3gfSCH1rDkNsLeCAQkNKxf0O69gYnbktHQQvrNjHFv1RRSw7aKKnOhSKYkWZsCfNeRmdqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787801; c=relaxed/simple;
	bh=LBoaAxdh4hhiXvXKgIlJNc34pARd+NDhmGvwUNQVKOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PD/OldNdrWQsdy6CiuumdPiVenI8sOfP0EdUBlZmwHxoB/sk2M+2E4ZGhZUGjxq76ft0AzXj/fXGlSWU7pvjnJkGparAEJLqDTzALbhx0+RTrJ7KT1rwklR6EUtL9m5SzltPKkbvb9tYoynOVO75LtZCnuE6v/z+FbeFHQAGzSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ByhUbft; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ByhUbft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8306B1F000FF;
	Wed, 30 Sep 2026 17:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787800;
	bh=vJzePXosuAVushYGk9VvUcMEOY1zAjuAtIxNtto+dCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ByhUbftNnGM0f2Xzr5EIBjBk7rXacmuhQmS5GUt80vrw/JRsqnem2t9Ey604Izz5
	 dKYDZ2zn9434jhv9czWpfbeMIZryFv/fr/xn3ALkhK34HylNi/+fcz/WEqf2eLYSJO
	 uhxA4XgcdTCkjbNTnqDhCddCPc0hB6v3iv/0xBb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 359/457] scsi: ufs: pltfrm: Add quirk for R-Car S4 lacking lanes-per-direction
Date: Wed, 30 Sep 2026 17:27:44 +0200
Message-ID: <20260930152353.754481829@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit c9ee6511332687ea714ad8ab86a53cb837d86eea upstream.

Since commit e72323f3b09f ("scsi: ufs: core: Configure only active lanes
during link"), the following error is observed on R-Car S4:

    ufshcd-renesas e6860000.ufs: Tx lane mismatch [config,reported] [2,1]
    ufshcd-renesas e6860000.ufs: link startup failed -67
    ufshcd-renesas e6860000.ufs: error -ENOLINK: Initialization failed with error -67
    ufshcd-renesas e6860000.ufs: probe with driver ufshcd-renesas failed with error -67

R-Car S4 has one UFS lane per direction, as described in section 152.1 of
its hardware manual.  Without lanes-per-direction, the UFS platform driver
defaults to two lanes.

Previously, the core used PA_CONNECTEDRXDATALANES and
PA_CONNECTEDTXDATALANES to configure the link without checking them against
lanes-per-direction, so the missing property did not prevent
initialization.

While fixing the R-Car S4 DTS is the proper solution, doing only that would
still break backwards compatibility with existing DTBs.  Hence add a quirk
to let lanes-per-direction default to one on R-Car S4.

Fixes: e72323f3b09f9c89 ("scsi: ufs: core: Configure only active lanes during link")
Reported-by: Koichiro Den <den@valinux.co.jp>
Closes: https://lore.kernel.org/20260911073058.253000-1-den@valinux.co.jp
Cc: stable@vger.kernel.org # 7.2+
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/ae0cc2bd764e6dfffce99db3d8b44a55887c508c.1789394185.git.geert+renesas@glider.be
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/host/ufshcd-pltfrm.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -206,7 +206,11 @@ static void ufshcd_init_lanes_per_dir(st
 		dev_dbg(hba->dev,
 			"%s: failed to read lanes-per-direction, ret=%d\n",
 			__func__, ret);
-		hba->lanes_per_direction = UFSHCD_DEFAULT_LANES_PER_DIRECTION;
+		/* Old R-Car S4 DTBs lack "lanes-per-direction = <1>" */
+		if (of_device_is_compatible(dev->of_node, "renesas,r8a779f0-ufs"))
+			hba->lanes_per_direction = 1;
+		else
+			hba->lanes_per_direction = UFSHCD_DEFAULT_LANES_PER_DIRECTION;
 	}
 }
 


