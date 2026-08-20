Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D353C377A82;
	Thu, 20 Aug 2026 17:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248498; cv=none; b=R/7V2QztxLKSCyPplPXRzvVCNmua+t2cvqzvVC42zkyuyCiE7gbjYgD1KFaKcPngbeKourRcK412wMo4BlykHGSIKspAooX4iUHIt/IH0Kg9wrdqLfc8JmQRldDxiT67+4jaa+rrTt41Gif2LhjI17W4ExehNGieCadD/fsgXVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248498; c=relaxed/simple;
	bh=N9Yzjcvo4q1SEppyJATvzAuXTUvh+vRx6Fq2gFFo2rQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vy3teLRXNZFYhWNJaQAvv3yevVOPOlBlwDN78Ihw/fW2QToT5yHgnB9pvtJUV3rD1OlupOnKyX0NQfN81OYAqzlLQvK45TJRQW4Mz935R7+MWtnumTThF6fOKBU3wBHlijryJQgCjNxKzdlEn1sUwjcXphuq81CzN9Bee3o4a0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jJhQkzEG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jJhQkzEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A94B1F000E9;
	Thu, 20 Aug 2026 17:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248497;
	bh=xuXUeP0JrPD/TnlPkxLuBBT4FNHfa063eOghOMur9FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jJhQkzEG98heThxZyJgrJSYM0Xq2zLS5JZbYyZ9vJ4YZvO6bRyDxehZdvf/12RERB
	 fAiWd4HNGS04fRBznrZg1chohw8KHBDn7RJ3kabKaPipfQShqd2AF+GS/HPZ4DitD7
	 XlvEsc5lOai3y7Hi1TTEehel730P8FXqvj68wbGg=
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
Subject: [PATCH 6.1 248/303] igc: remove napi_synchronize() in igc_down()
Date: Thu, 20 Aug 2026 16:56:24 +0200
Message-ID: <20260820145300.901204371@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5034,7 +5034,6 @@ void igc_down(struct igc_adapter *adapte
 
 	for (i = 0; i < adapter->num_q_vectors; i++) {
 		if (adapter->q_vector[i]) {
-			napi_synchronize(&adapter->q_vector[i]->napi);
 			napi_disable(&adapter->q_vector[i]->napi);
 		}
 	}


