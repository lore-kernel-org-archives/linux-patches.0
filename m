Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED6A4A24;
	Mon, 14 Oct 2024 14:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916638; cv=none; b=i+RhkDtFBn+UNVu9dfbQJdLoAt1REJcwm7EN+hDfjwcn8IrfTj4FEPJIX29a7MYzzsnHSqSmaDP842iUKhkAWFrAOtwdbjRcd21KBOxvCpWrQJAXywMHotHNkcO4GU8napkFDnhWtG8kpDnDYWzQiGWuORa4rxKKjR+3w8ZV9h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916638; c=relaxed/simple;
	bh=M3PTGWyJHbrBS7Ybj3MXs+Af78B41pfOZFaomQxbA3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U7NwXkHzwmQBRUahLw58uActVSb5rDy8OeldBdv90/PIvlbMV93bL31PgOK2UR9t1oqEnSMPjYytwPzswT2cETxgViAhFWy/z1VdGnfKhdiKOTK00igj+J5mlGbyJEbDb18s9lrKCxPMXLuwV3kej7s6FTKGtg4tMmwFvqMjFJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D+0uUrPj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D+0uUrPj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8838FC4CEC3;
	Mon, 14 Oct 2024 14:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916637;
	bh=M3PTGWyJHbrBS7Ybj3MXs+Af78B41pfOZFaomQxbA3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D+0uUrPjAWnsE7uxVV7F39tURkK+iixcy84V6dSi0QSPldKwUt5iZukIglgpe2Qei
	 kqAKyWPVJKlA8jn6WA3iP/1beJcPSO/1NKhC79OMjvpgnPOWDJv2tBV6GH4ITnqPLE
	 k9HhfnP4LWyVwDJ1Z+9MfCg5rS7lB0i474dsLJD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/213] pds_core: no health-thread in VF path
Date: Mon, 14 Oct 2024 16:18:49 +0200
Message-ID: <20241014141043.891906972@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit 3e36031cc0540ca97b615cbb940331892cbd3d21 ]

The VFs don't run the health thread, so don't try to
stop or restart the non-existent timer or work item.

Fixes: d9407ff11809 ("pds_core: Prevent health thread from running during reset/remove")
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Link: https://lore.kernel.org/r/20240210002002.49483-1-shannon.nelson@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index 6d589ac532a3d..eddbf0acdde77 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -451,6 +451,9 @@ static void pdsc_remove(struct pci_dev *pdev)
 
 static void pdsc_stop_health_thread(struct pdsc *pdsc)
 {
+	if (pdsc->pdev->is_virtfn)
+		return;
+
 	timer_shutdown_sync(&pdsc->wdtimer);
 	if (pdsc->health_work.func)
 		cancel_work_sync(&pdsc->health_work);
@@ -458,6 +461,9 @@ static void pdsc_stop_health_thread(struct pdsc *pdsc)
 
 static void pdsc_restart_health_thread(struct pdsc *pdsc)
 {
+	if (pdsc->pdev->is_virtfn)
+		return;
+
 	timer_setup(&pdsc->wdtimer, pdsc_wdtimer_cb, 0);
 	mod_timer(&pdsc->wdtimer, jiffies + 1);
 }
-- 
2.43.0



