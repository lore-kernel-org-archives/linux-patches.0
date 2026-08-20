Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2160A469843;
	Thu, 20 Aug 2026 17:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247625; cv=none; b=K1HbE0GjAf8yDMpfLZmIwiMhILuxFJ4hUBiCmDzZNyxk9woqKsTDfHKEj/7GQcYNHkmPvA8+XH1Z3rPcdfS4S1j5jNERXLlyMzvnx75iv7xwoWctiD884/hcwlTpAOw2vWh4i9iIZOwG60f+tpQvOwjNybU6HXiBixqz5poVaKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247625; c=relaxed/simple;
	bh=I3jO/6abqAQ39rD8yY3gKScKRUWQ73PewE3D6pDvJhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMFvhQxf+hOwZreod2A12cr4cHu9l/bHO0C9RtHp/EuoRg1+35+pgRNVdhGlGWc9rCPizszfKyyknYJaRYlQjB3UEQwoRtLuDuCLBbFOK0qSxt4WKa0VH/KIAZMokvF2AxHj8v5sKJwaHqoXLoUrEhICh4YhjbiEmCuH+Urd9mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mKCT1mF3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mKCT1mF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1EE1F000E9;
	Thu, 20 Aug 2026 17:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247624;
	bh=wBk+ePtdU6hg7+fBDAMItTZI2rwBmHfJRan3O+ZpH4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mKCT1mF3c5TEJuCWuYQMBsEnRrw3pfeUObkWqAG7NiayugB7Kjm2KlbIuyHBY4iQD
	 0YGHCrQxmzGjieWCeGxvWKO4Auits9qDksQrp4XlZE5Caeth3sHdxZESPC8nETJujk
	 yP/S7yzNaH/e1oUXVPVY//Y1mANANP3obSRohHJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	David Carlier <devnexen@gmail.com>,
	Dima Ruinskiy <dima.ruinskiy@intel.com>,
	Moriya Kadosh <moriyax.kadosh@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 110/166] igc: remove napi_synchronize() in igc_down()
Date: Thu, 20 Aug 2026 16:56:09 +0200
Message-ID: <20260820145214.473395251@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

[ Upstream commit 5ffab5b9589c50e4cfc0cf36ffd76c89422d4019 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5085,7 +5085,6 @@ void igc_down(struct igc_adapter *adapte
 
 	for (i = 0; i < adapter->num_q_vectors; i++) {
 		if (adapter->q_vector[i]) {
-			napi_synchronize(&adapter->q_vector[i]->napi);
 			napi_disable(&adapter->q_vector[i]->napi);
 		}
 	}


