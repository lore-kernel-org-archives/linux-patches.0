Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432AC3A9DBC;
	Wed, 21 Jan 2026 18:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020426; cv=none; b=Nw/SMdu9Y7c8Qhp7zTtasjcjwQ9DjG3wb7Ded/U3pwghvRxnLxnfCDKKV4+Rr3X6hOw/V6ATw4y3hqp3LGFd6GEVFHAhi+3YK89NA1GpsF4fcpbUBfTa46HfKqUGIg8pGbjsCWSd/swVNjnb7j+C6LWbIuayW4EpEL3+eSlVtDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020426; c=relaxed/simple;
	bh=hLSZqKRt1brkrCrdzpg+YpR1XwHNY/0+vOasxEjPq04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ocObTh+ubi0Q5zw5DPnp9jDQLXWmKLoX0hxgkWbwA1YnoF6B/ueJjaRIdmxzq6y3XLuRPkDA1ZuS9FWs3/sATkvMi/Nfr1+oXDRDOq22ScpZveu4g3KhDAMtMhJHb4+j6/41KU5vOG4mu+Cc9w/BTEKTuL9Ssu6g+aiQnukNQOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b3o0zbCp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b3o0zbCp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1EEC4CEF1;
	Wed, 21 Jan 2026 18:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020426;
	bh=hLSZqKRt1brkrCrdzpg+YpR1XwHNY/0+vOasxEjPq04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b3o0zbCp30wj+yEgh+SGursXIDNj4V5YJsdcxArUSy8XrpyUrw2Neiyq67L00BZ9s
	 CsRJJwKQemA5QCiCumVF4BrDoNmmswIX0VxHSCsi8kOJWK1OIgGRoUD0qktEdahET6
	 Q+77/jl92BAw7aNPR4mUAQh6x+u15Hf7m9udB46s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <dwagner@suse.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 137/198] nvme: fix PCIe subsystem reset controller state transition
Date: Wed, 21 Jan 2026 19:16:05 +0100
Message-ID: <20260121181423.476939995@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilay Shroff <nilay@linux.ibm.com>

commit 0edb475ac0a7d153318a24d4dca175a270a5cc4f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1461,7 +1461,10 @@ static int nvme_pci_subsystem_reset(stru
 	}
 
 	writel(NVME_SUBSYS_RESET, dev->bar + NVME_REG_NSSR);
-	nvme_change_ctrl_state(ctrl, NVME_CTRL_LIVE);
+
+	if (!nvme_change_ctrl_state(ctrl, NVME_CTRL_CONNECTING) ||
+	    !nvme_change_ctrl_state(ctrl, NVME_CTRL_LIVE))
+		goto unlock;
 
 	/*
 	 * Read controller status to flush the previous write and trigger a


