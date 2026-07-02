Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55EE33A70E;
	Thu,  2 Jul 2026 16:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011042; cv=none; b=MPEff399pY9a9PgYAJbDw6ZoEeLclXKQ1adPtr94SmHpXpzZYXA+m43pdG/Mo+G+vTTJtiufk7KRIH/83bgXQ/HQh6Ku281xdfkVIxiC6kPxkobBDqS/Vnmp3LRj8M9B9FPqyrnqQv1O6KMFH5ipc4JpzQtpwZnKHHqfWgZWLJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011042; c=relaxed/simple;
	bh=v5kaJEO49ZY2NMM+UfgabeaKG0Eu3ta8pWbDgckZGhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCfsOulqPQ1P/MQa+pv9c3dczcTSFx8k0rnEpkRrMYvFV584ipwyaOqhLK9lbMwCoZlk4UJ8MW+AdnBRxuIEcmMXWWXh9GTn+/QiBl8vuvYSOB5/R8k1ufhQG3V2VHUUd7w0Dsvfrm6l9Dzju+HK4NSvJxrYRuYTaRy8LChBS8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d1++A8qh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d1++A8qh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379871F000E9;
	Thu,  2 Jul 2026 16:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011041;
	bh=CKFYn5q9dKzcgnM/HXav50n4lsQ4lDkokav/1Rh6jOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d1++A8qhenrSc5Vr3m4HV80U6nDDZNP7LkjI2kaXLQ4p6GDr5AlceHagMRlRyi2eU
	 p1yyk7B/Job0hOId2qOh7aC4Ec4tmqnqr8NEdpbyFz/q17bAcoZMy+7jp1PuMeRegP
	 /deF3DO3Fy5QIvGYBZar07j6WzyOaoTWbtukKotw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.6 132/175] wifi: ath11k: fix warning when unbinding
Date: Thu,  2 Jul 2026 18:20:33 +0200
Message-ID: <20260702155118.593533808@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>

commit 8b7a26b6681922a38cd5a7829ace61f8e54df9b7 upstream.

If there is an error during some initialization related to firmware,
the buffers dp->tx_ring[i].tx_status are released.
However this is released again when the device is unbinded (ath11k_pci),
and we get:
WARNING: CPU: 0 PID: 6231 at mm/slub.c:4368 free_large_kmalloc+0x57/0x90
Call Trace:
free_large_kmalloc
ath11k_dp_free
ath11k_core_deinit
ath11k_pci_remove
...

The issue is always reproducible from a VM because the MSI addressing
initialization is failing.

In order to fix the issue, just set the buffers to NULL after releasing in
order to avoid the double free.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Cc: stable@vger.kernel.org
Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260420110130.509670-1-jtornosm@redhat.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath11k/dp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/ath/ath11k/dp.c
+++ b/drivers/net/wireless/ath/ath11k/dp.c
@@ -1039,6 +1039,7 @@ void ath11k_dp_free(struct ath11k_base *
 		idr_destroy(&dp->tx_ring[i].txbuf_idr);
 		spin_unlock_bh(&dp->tx_ring[i].tx_idr_lock);
 		kfree(dp->tx_ring[i].tx_status);
+		dp->tx_ring[i].tx_status = NULL;
 	}
 
 	/* Deinit any SOC level resource */


