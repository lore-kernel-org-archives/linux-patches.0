Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D1836166F;
	Wed,  8 Apr 2026 18:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673124; cv=none; b=NoKSVHf2U6vzBiyplxgadjlzo11OylKmol74q6wFWF1Ofc72ULO96zAw8EPSOJzyHgIgmFgaFEoSnXHeh7CwY8iEv3sdzzUT7CYPC8zzMByYHCc4VCXYSCwUPpqXv031DF+rhewVFtaMWTJB6dQkDsmanKQAC44Vg9Cu5skFpxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673124; c=relaxed/simple;
	bh=zoAOOSX2BCKQY+nNsWg6ytpZYNpnIkGOc5Vx9xMf/3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ifg+4zMbtc7RsjtXeJ+tRGk1JPppVAuRhykdK2lUAmoGZ26pGWTVdz1/V39n3v9H4HdIlT4Qm5cE0fHZ83g8E5oDyctzs2r/WqXGvfFdfQlHLFhTTsdHND5vvdgXpDraCp24Ugyl0//9Jr+XpdCXhtGcTH4VDaFjzObW3pdHJi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ybv0CsbK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ybv0CsbK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B058C2BCB0;
	Wed,  8 Apr 2026 18:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673124;
	bh=zoAOOSX2BCKQY+nNsWg6ytpZYNpnIkGOc5Vx9xMf/3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ybv0CsbKhgZuVX+i9PJbpV4VtgOX4Gn334W7AZac6cQY20rLGey/+ppJ04WmdWLfy
	 dmJ70A7xVvqGkicWcvWYvzX3/pKdZQXFiGpQyx4y0MjB6KNpyD7PoTZVVR91F05We8
	 p9WzcerPbvNuKysJ9fSysEI53rVSsXBE6yZwk0tA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 078/277] Bluetooth: hci_sync: call destroy in hci_cmd_sync_run if immediate
Date: Wed,  8 Apr 2026 20:01:03 +0200
Message-ID: <20260408175936.777474026@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit a834a0b66ec6fb743377201a0f4229bb2503f4ce ]

hci_cmd_sync_run() may run the work immediately if called from existing
sync work (otherwise it queues a new sync work). In this case it fails
to call the destroy() function.

On immediate run, make it behave same way as if item was queued
successfully: call destroy, and return 0.

The only callsite is hci_abort_conn() via hci_cmd_sync_run_once(), and
this changes its return value. However, its return value is not used
except as the return value for hci_disconnect(), and nothing uses the
return value of hci_disconnect(). Hence there should be no behavior
change anywhere.

Fixes: c898f6d7b093b ("Bluetooth: hci_sync: Introduce hci_cmd_sync_run/hci_cmd_sync_run_once")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index e94b62844e1ef..635ce5929dc5d 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -801,8 +801,15 @@ int hci_cmd_sync_run(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
 		return -ENETDOWN;
 
 	/* If on cmd_sync_work then run immediately otherwise queue */
-	if (current_work() == &hdev->cmd_sync_work)
-		return func(hdev, data);
+	if (current_work() == &hdev->cmd_sync_work) {
+		int err;
+
+		err = func(hdev, data);
+		if (destroy)
+			destroy(hdev, data, err);
+
+		return 0;
+	}
 
 	return hci_cmd_sync_submit(hdev, func, data, destroy);
 }
-- 
2.53.0



