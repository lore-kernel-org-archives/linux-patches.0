Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B51B4779B2;
	Fri,  7 Aug 2026 15:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117314; cv=none; b=MLMB5LllwYNBChD4tKNXkRVZCwloflxlTagANNMNEW14rJu2Fd+r/DZ2zw5PAkZop9K20KukhIGl3p5dd3NTsHjcAOq0+rFhQsnnB1Fehwie4DS5s20no9futyxiZxQCh2vgLS7I9w3qn2Y5UXqaLMThJqD18eflGUoFdlIDsmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117314; c=relaxed/simple;
	bh=G7xMcYZE9dSsUoIuWjLbWGSknIeO6dOHP5l3QQtzuaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=trVU3ckQ7mUa6zAYQdEWzY+7vRtF1wDtLvWlt2XBw8U2baNwWfAiAidOWMWzbL5Tb6WnZ0+8/2fHHWFc8d4jTWlZJXqGFbZy+v41+W99jhCGadBN1n8PjKGAJTtT9kSQ1mtaXCgoO6qVJSng2Nw4gIB3zVMeIyd9lvsicg6l1lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LnxdYW/S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LnxdYW/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807751F000E9;
	Fri,  7 Aug 2026 15:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117313;
	bh=1qYCm40S4bMrvqzSu0wkUSoJJWKRmr3G08CYcsaJPGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LnxdYW/SJhiC6Q+Q3qlI/JxWJBr/CMt8TqgXUaH9LDJKKpjdLjTa9dyrGsw+GCus9
	 dJ1Ux+PRsVuuPsIr25BplOv2rxwkV9yUHfK3itol7HTtgy0LKCjMq537ntNEMyQKz6
	 0gydSW5J3TDl9FmX5+Zx4XEce4EzR2VyurxjWc8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	David Carlier <devnexen@gmail.com>,
	Dima Ruinskiy <dima.ruinskiy@intel.com>,
	Moriya Kadosh <moriyax.kadosh@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 7.1 276/438] igc: remove napi_synchronize() in igc_down()
Date: Fri,  7 Aug 2026 16:37:52 +0200
Message-ID: <20260807143433.867404820@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit 5ffab5b9589c50e4cfc0cf36ffd76c89422d4019 upstream.

When an AF_XDP zero-copy application is killed abruptly, the XSK pool is
torn down but NAPI keeps polling. igc_clean_rx_irq_zc() then returns the
full budget on every poll, so napi_complete_done() never clears
NAPI_STATE_SCHED.

igc_down() calls napi_synchronize() before napi_disable(), so it spins
forever waiting for that bit and the interface never goes down. Drop the
napi_synchronize() and let napi_disable() do the job -- it sets
NAPI_STATE_DISABLE, which forces the stuck poll to complete. Reorder it
ahead of igc_set_queue_napi() so the NAPI mapping is cleared only after
polling has stopped, matching the recent igb fix b1e067240379.

Fixes: fc9df2a0b520 ("igc: Enable RX via AF_XDP zero-copy")
Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Dima Ruinskiy <dima.ruinskiy@intel.com>
Tested-by: Moriya Kadosh <moriyax.kadosh@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5352,9 +5352,8 @@ void igc_down(struct igc_adapter *adapte
 
 	for (i = 0; i < adapter->num_q_vectors; i++) {
 		if (adapter->q_vector[i]) {
-			napi_synchronize(&adapter->q_vector[i]->napi);
-			igc_set_queue_napi(adapter, i, NULL);
 			napi_disable(&adapter->q_vector[i]->napi);
+			igc_set_queue_napi(adapter, i, NULL);
 		}
 	}
 


