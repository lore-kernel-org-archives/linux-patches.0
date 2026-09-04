Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4F4415F01;
	Fri,  4 Sep 2026 05:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498308; cv=none; b=N6X1X6Tp00g9YS9X/pzFOISuIpoTicYCdu3j1A182q4BjTIb0NsGtTOvQtbSOr6epFo6nkLiqFrxW+r9ay8wXkZ5XyVQ7qB8HRFX4V9vH6XoTq3ZemdxlyiOu3K5cqWZJC1/Ewm0ONLP7ewin2HodCpfr85ubY/zN13aAJzsYeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498308; c=relaxed/simple;
	bh=/FMFcmFK5FbxwDf5gC8srRj5/XqEjOFxSONCXE1bGEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnZixVnphjYskVsBHP5sdpeQYPp1VAwUVceM8fV8kI/jWj5oaR1AYDFathFo93KGZRFPffmqHonZgl07sCuLdUPxdS/q/77GX9hl6k0U+hnbffmVO9MfWtCNhwkQgPyrOVpVVTv3jbx9buTwTwYbeMx8eeuB21Wp4No6T7BY1vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pc+qpPxA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pc+qpPxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BFFF1F00A3D;
	Fri,  4 Sep 2026 05:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498307;
	bh=OrT6LdWagfkmTs8XN30dQf/7u5T+VxGxIJmDlOx9XxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pc+qpPxAnhw7YyQdn+wgtZtCvXbwbBbH8IbW+kb7VuYpbDsS9mMJdHjsuJGvLvwWK
	 Lt7ew8LNbBG1WZkG1YxfDrLdUmSVIJ8M3frNizV8GPrL5fKQVtbkyceHln1lhzrozG
	 egZntED3GeHHI3V4WBtTiEq2RoTxmRaYdfQ/lPbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>
Subject: [PATCH 7.2 017/713] clocksource/drivers/nxp-pit: Fix IRQ leak on cpuhp_setup_state error path
Date: Fri,  4 Sep 2026 06:49:45 +0200
Message-ID: <20260904045804.210977763@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: WenTao Liang <vulab@iscas.ac.cn>

commit 05520e035f8332c8e33f3011b5ca016fde61793d upstream.

When cpuhp_setup_state fails after pit_clockevent_per_cpu_init has
successfully called request_irq, the error handling jumps directly to
out_pit_clocksource_unregister without freeing the registered IRQ.

This leaks the IRQ line and, since kfree(pit) follows, leaves a
dangling pointer registered as the interrupt handler's dev_id,
potentially leading to a use-after-free if the IRQ fires afterwards.

Fix it by calling pit_clockevent_per_cpu_exit to properly release the
IRQ before falling through to the existing cleanup chain.

Suggested-by: Greg KH <gregkh@linuxfoundation.org>
Fixes: bee33f22d7c3 ("clocksource/drivers/nxp-pit: Add NXP Automotive s32g2 / s32g3 support")
Cc: stable@vger.kernel.org
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Link: https://patch.msgid.link/20260628130700.45680-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clocksource/timer-nxp-pit.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/clocksource/timer-nxp-pit.c
+++ b/drivers/clocksource/timer-nxp-pit.c
@@ -328,8 +328,10 @@ static int pit_timer_init(struct device_
 	if (pit_instances == max_pit_instances) {
 		ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "PIT timer:starting",
 					pit_clockevent_starting_cpu, NULL);
-		if (ret < 0)
+		if (ret < 0) {
+			pit_clockevent_per_cpu_exit(pit, pit_instances);
 			goto out_pit_clocksource_unregister;
+		}
 	}
 
 	return 0;


