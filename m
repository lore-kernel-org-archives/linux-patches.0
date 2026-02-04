Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45E02D877F;
	Wed,  4 Feb 2026 15:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218313; cv=none; b=hZOyuaaevWIbYZ+M1tf6jeQbdBB0hS/wvHyGVNKhXQbbGanonhyvRaX6BLjC56cYIDBslf3WaItrIul1NlNPVDf42JOlfoovw5Xk76IO+4brpzLZiTZxKBUn1AnGdQJ67JKOJmpKw0iUjxYOxO2+2wMsGzrHC4eKVXlO7IQ2blw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218313; c=relaxed/simple;
	bh=YkOFGcXnQJDCv+CX6dhVwHXGCmik1vtv4Vd5WpUT4Lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=abVc0/YRcGas6MW2DOH1rBNoIgTVcnODAcTMaHsPzpJ5lGMsqdoGmCxTvvfckbwaAw4NxC4d/SCo8Mj9zEHUpIQOU/lu4JNhIIe54sVRDHWz424sJcudgqPEnf6qNb9/SS9eAc/0UFCrnhB71YjCpFvQrKvgaQvSjuQ76wGqoDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MYSddzwr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MYSddzwr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5720BC4CEF7;
	Wed,  4 Feb 2026 15:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218312;
	bh=YkOFGcXnQJDCv+CX6dhVwHXGCmik1vtv4Vd5WpUT4Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MYSddzwrOFQMUhvqREzeWL7db9lg8TlK38bB8TiMJd0he7KK7z2wPuO/IlAHALsq7
	 serGHotG7l03EKaJK92H/CpsIOoPZmHsx9ZZaoq82EfmJ5KGyIxiLuhKvKmzyhozaI
	 3kTh9AfdXTAsQ62AzyCMSIQqgl7lRhCXufQBMZhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <dwagner@suse.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 240/280] nvme: fix PCIe subsystem reset controller state transition
Date: Wed,  4 Feb 2026 15:40:14 +0100
Message-ID: <20260204143918.264973072@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilay Shroff <nilay@linux.ibm.com>

[ Upstream commit 0edb475ac0a7d153318a24d4dca175a270a5cc4f ]

The commit d2fe192348f9 (“nvme: only allow entering LIVE from CONNECTING
state”) disallows controller state transitions directly from RESETTING
to LIVE. However, the NVMe PCIe subsystem reset path relies on this
transition to recover the controller on PowerPC (PPC) systems.

On PPC systems, issuing a subsystem reset causes a temporary loss of
communication with the NVMe adapter. A subsequent PCIe MMIO read then
triggers EEH recovery, which restores the PCIe link and brings the
controller back online. For EEH recovery to proceed correctly, the
controller must transition back to the LIVE state.

Due to the changes introduced by commit d2fe192348f9 (“nvme: only allow
entering LIVE from CONNECTING state”), the controller can no longer
transition directly from RESETTING to LIVE. As a result, EEH recovery
exits prematurely, leaving the controller stuck in the RESETTING state.

Fix this by explicitly transitioning the controller state from RESETTING
to CONNECTING and then to LIVE. This satisfies the updated state
transition rules and allows the controller to be successfully recovered
on PPC systems following a PCIe subsystem reset.

Cc: stable@vger.kernel.org
Fixes: d2fe192348f9 ("nvme: only allow entering LIVE from CONNECTING state")
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1213,7 +1213,10 @@ static int nvme_pci_subsystem_reset(stru
 	}
 
 	writel(NVME_SUBSYS_RESET, dev->bar + NVME_REG_NSSR);
-	nvme_change_ctrl_state(ctrl, NVME_CTRL_LIVE);
+
+	if (!nvme_change_ctrl_state(ctrl, NVME_CTRL_CONNECTING) ||
+	    !nvme_change_ctrl_state(ctrl, NVME_CTRL_LIVE))
+		goto unlock;
 
 	/*
 	 * Read controller status to flush the previous write and trigger a


