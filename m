Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647D723AB9D;
	Mon, 23 Mar 2026 14:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277216; cv=none; b=jjuTbiFRHdCXz65Bzc8S0kqZNj2eA50GFbYjtr2zvcIUUFOcD5d0Vy3u/UI5UxoIO7jXLh7+rBwfVg25MaxXuzWKLhEM5ZHnkFo0R57HFfvg/lL70tboaAEach78YxT5FPm88RJO8lrrGe/mBTmXIDeMUirR2EWovOA+KKHDP/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277216; c=relaxed/simple;
	bh=0BRj6Sq+B/VL9R34qN5J+pnbEjuC7kk8bsTdmn+ClYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1Rpg/gmsaI7gMQUY11PeGN2THLUm6ZjGRxellA7JYj2m2x0ve/oUPJgM+Q5MiLqyAMhO76xt9A2UFvcsnIlIpeqgw8ZwKQf/YBjSDNkILLg5CKF6t4Yu8w08tF6ElVbDDxUKbnvZkYx47rhtFQolM1YM5KFawg9UH9Nq1yb1nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qSZeB8kN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qSZeB8kN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F227EC4CEF7;
	Mon, 23 Mar 2026 14:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277216;
	bh=0BRj6Sq+B/VL9R34qN5J+pnbEjuC7kk8bsTdmn+ClYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qSZeB8kNjT/9qtvb4Qo8Oo5CgISW4lx6ieedNHKpDIif9D28KzwHaHbvduwf/QUZE
	 BZfwSsUVhzQyBypogb0GKt8tpuWXruN44Di4jHh6nYUPgVwsJVyS/0w+rPG/uYNfZw
	 X12GJPK12PIqR81+iB4QMyQDbX1brNH3ewyC+e38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessio Belle <alessio.belle@imgtec.com>,
	Matt Coster <matt.coster@imgtec.com>
Subject: [PATCH 6.12 358/460] drm/imagination: Fix deadlock in soft reset sequence
Date: Mon, 23 Mar 2026 14:45:54 +0100
Message-ID: <20260323134535.351001937@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alessio Belle <alessio.belle@imgtec.com>

commit a55c2a5c8d680156495b7b1e2a9f5a3e313ba524 upstream.

The soft reset sequence is currently executed from the threaded IRQ
handler, hence it cannot call disable_irq() which internally waits
for IRQ handlers, i.e. itself, to complete.

Use disable_irq_nosync() during a soft reset instead.

Fixes: cc1aeedb98ad ("drm/imagination: Implement firmware infrastructure and META FW support")
Cc: stable@vger.kernel.org
Signed-off-by: Alessio Belle <alessio.belle@imgtec.com>
Reviewed-by: Matt Coster <matt.coster@imgtec.com>
Link: https://patch.msgid.link/20260309-fix-soft-reset-v1-1-121113be554f@imgtec.com
Signed-off-by: Matt Coster <matt.coster@imgtec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/imagination/pvr_power.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/imagination/pvr_power.c
+++ b/drivers/gpu/drm/imagination/pvr_power.c
@@ -408,7 +408,16 @@ pvr_power_reset(struct pvr_device *pvr_d
 	}
 
 	/* Disable IRQs for the duration of the reset. */
-	disable_irq(pvr_dev->irq);
+	if (hard_reset) {
+		disable_irq(pvr_dev->irq);
+	} else {
+		/*
+		 * Soft reset is triggered as a response to a FW command to the Host and is
+		 * processed from the threaded IRQ handler. This code cannot (nor needs to)
+		 * wait for any IRQ processing to complete.
+		 */
+		disable_irq_nosync(pvr_dev->irq);
+	}
 
 	do {
 		if (hard_reset) {


