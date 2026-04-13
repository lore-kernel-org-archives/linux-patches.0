Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24AB82C0F69;
	Mon, 13 Apr 2026 16:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096313; cv=none; b=NGLYZ5dWkvVMIt6gzyh8+xzfFA1WI8eMS9Z533q/zGIJ0/49H1kaS62FyL1DZrZ0uBAU0hKqcfMImRltJ16YH6xu5QVmjHhoFkbUhKV26rgkpH1beILYJgj1R73qVlmHqmASBHfWe2c1dlTADeoZrtjFZjXQmgzj4zIICKa92zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096313; c=relaxed/simple;
	bh=FRCGuzEAd0UC/VErfaL0WlhrR+wvDJVYkMO07yHTDh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJoFhpc6fk+YPdanaQzHgJkgcMfgkVi/YXdNDTHsO499HYYhqRkIGjQ86wB6SAk/ZCPlQhb8vY/DRVaeU1sMo0WG3r0LZOGcPv93NwWNR9TC13nzpGyfZvoT6nV2QyYKibfmft8QMIrEXup0VPepgr9DFW5dw4eirnE3q/l1K5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SW0BuKe1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SW0BuKe1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE959C2BCAF;
	Mon, 13 Apr 2026 16:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096313;
	bh=FRCGuzEAd0UC/VErfaL0WlhrR+wvDJVYkMO07yHTDh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SW0BuKe1sUlDHL9xBOaGdaVKFCViQEPySeTsBVB4DMV6FevKzy+qY2J8VCrDR2QeT
	 Z8SFRhn+78KkUR4aDtA7rwv6Qh8byRj6ql0Cpw3BxUcQKZAtYx1iVgdTbnr9PP0CY9
	 RJQZPu7sJDN6zBrIVye+2DoDiQJJkx7lsgRdZBig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Alex Dvoretsky <advoretsky@gmail.com>,
	Patryk Holda <patryk.holda@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.19 49/86] igb: remove napi_synchronize() in igb_down()
Date: Mon, 13 Apr 2026 17:59:56 +0200
Message-ID: <20260413155733.399466843@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Dvoretsky <advoretsky@gmail.com>

commit b1e067240379f950a0022208e0685f3465c211cb upstream.

When an AF_XDP zero-copy application terminates abruptly (e.g., kill -9),
the XSK buffer pool is destroyed but NAPI polling continues.
igb_clean_rx_irq_zc() repeatedly returns the full budget, preventing
napi_complete_done() from clearing NAPI_STATE_SCHED.

igb_down() calls napi_synchronize() before napi_disable() for each queue
vector. napi_synchronize() spins waiting for NAPI_STATE_SCHED to clear,
which never happens. igb_down() blocks indefinitely, the TX watchdog
fires, and the TX queue remains permanently stalled.

napi_disable() already handles this correctly: it sets NAPI_STATE_DISABLE.
After a full-budget poll, __napi_poll() checks napi_disable_pending(). If
set, it forces completion and clears NAPI_STATE_SCHED, breaking the loop
that napi_synchronize() cannot.

napi_synchronize() was added in commit 41f149a285da ("igb: Fix possible
panic caused by Rx traffic arrival while interface is down").
napi_disable() provides stronger guarantees: it prevents further
scheduling and waits for any active poll to exit.
Other Intel drivers (ixgbe, ice, i40e) use napi_disable() without a
preceding napi_synchronize() in their down paths.

Remove redundant napi_synchronize() call and reorder napi_disable()
before igb_set_queue_napi() so the queue-to-NAPI mapping is only
cleared after polling has fully stopped.

Fixes: 2c6196013f84 ("igb: Add AF_XDP zero-copy Rx support")
Cc: stable@vger.kernel.org
Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Alex Dvoretsky <advoretsky@gmail.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Patryk Holda <patryk.holda@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2203,9 +2203,8 @@ void igb_down(struct igb_adapter *adapte
 
 	for (i = 0; i < adapter->num_q_vectors; i++) {
 		if (adapter->q_vector[i]) {
-			napi_synchronize(&adapter->q_vector[i]->napi);
-			igb_set_queue_napi(adapter, i, NULL);
 			napi_disable(&adapter->q_vector[i]->napi);
+			igb_set_queue_napi(adapter, i, NULL);
 		}
 	}
 


