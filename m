Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B8C3D3D04;
	Thu, 15 Jan 2026 17:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499507; cv=none; b=grasJ8GPYtTtjSQtlcZWttENE486nlNAaeyq0PB7ZxJTYJ6z5+YuYr00zN8NQYQAZnLHW1fKCyOhKTY3weGCgCvirt/amB6SRu029aBfW/KCS24pD3u0Vlpe/HvGe9Ck+UrTckxmTg/Sont3GrCIwvJzhRuFyjW3E9pc2SLegLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499507; c=relaxed/simple;
	bh=dMz84Q2iKghKK3CXSLsS6U/2PpXdLdF8f2NJ7D2sR20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Go/LkBTAX95aucu4GXoALuslsY7KFNK0sJ1jc4pseAhyHD8+1UZONT0FAf0Z/eoMdAOIAH5XOPy09Bo3q6pdTRbIA8OuBzakgea7kHYTADIRPl1pF9x4vL4dha8trhaGgAQSS7CNj24YZ/73jh/CtxSN2pDPBLxhhZHQHV9TgtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BvBoau5U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BvBoau5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD25C116D0;
	Thu, 15 Jan 2026 17:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499507;
	bh=dMz84Q2iKghKK3CXSLsS6U/2PpXdLdF8f2NJ7D2sR20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BvBoau5U1w/X+XLGYgKMh3DGT8J7pP+KFOlVEJEC7TGmNhfvyHWywvHg1eT0Ulkfx
	 IgNXdsBtXdczESXb3jEuJByCC3CDKY1OV5vL5ktE4NFZMLmpSMUDz/rYom+YbLZSC3
	 rsZ8Y14sy1xWJpF6zOK6KRwnAAoNq9KnKiv8LJKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 251/451] parisc: Do not reprogram affinitiy on ASP chip
Date: Thu, 15 Jan 2026 17:47:32 +0100
Message-ID: <20260115164239.971192549@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit dca7da244349eef4d78527cafc0bf80816b261f5 upstream.

The ASP chip is a very old variant of the GSP chip and is used e.g. in
HP 730 workstations. When trying to reprogram the affinity it will crash
with a HPMC as the relevant registers don't seem to be at the usual
location.  Let's avoid the crash by checking the sversion. Also note,
that reprogramming isn't necessary either, as the HP730 is a just a
single-CPU machine.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/parisc/gsc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/parisc/gsc.c
+++ b/drivers/parisc/gsc.c
@@ -154,7 +154,9 @@ static int gsc_set_affinity_irq(struct i
 	gsc_dev->eim = ((u32) gsc_dev->gsc_irq.txn_addr) | gsc_dev->gsc_irq.txn_data;
 
 	/* switch IRQ's for devices below LASI/WAX to other CPU */
-	gsc_writel(gsc_dev->eim, gsc_dev->hpa + OFFSET_IAR);
+	/* ASP chip (svers 0x70) does not support reprogramming */
+	if (gsc_dev->gsc->id.sversion != 0x70)
+		gsc_writel(gsc_dev->eim, gsc_dev->hpa + OFFSET_IAR);
 
 	irq_data_update_effective_affinity(d, &tmask);
 


