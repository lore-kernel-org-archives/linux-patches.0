Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C35425178A;
	Mon, 12 May 2025 17:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071841; cv=none; b=OWOCIrW39UOVAge6Tu8YryxXTzPaiux+YCtLgNen2NybyE9c5vtMnGHTjGexw+pxQ7D8f54XyJAzFwfmIm7lKixKbJkE5QAkWCsrNCedXY9kIblirDOsS+YjA0jrLsWtXTAkRqXePZEw/SchCvroUJ8gbJrnN6w3habeqxyIT5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071841; c=relaxed/simple;
	bh=mpcCpEJ3I3TVaqyRCRTDZc0oHUDv6P2jh4dzbMEQcyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nwTpyhCGStDTnXK9tykolOfjg27CSL+ZypDkZzk3CiKsJispVi7y/CLSI0Y+a8Fb4sP81h5h44T/uEVVc1I8NayHGtXybJQrGJ2UFv1i7fJWilYG/mSju6fCeulz76iwkQSr+PLdBNXZSM1d2rk5GI50me7w5j4WadKvfYR6zg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HbLr9yK9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HbLr9yK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A910C4CEE9;
	Mon, 12 May 2025 17:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071841;
	bh=mpcCpEJ3I3TVaqyRCRTDZc0oHUDv6P2jh4dzbMEQcyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HbLr9yK9X6BQSz+fWHpJjXkmLykybYoQSXJdAtVZYP6HblzLsLDNzPm5IJw0AzKzm
	 8bInyKfyz4OOMFjEFKRhe3bxzyaQGL0hhr1SVbtKo+KHs5Tl/BcT/P0DZsPJ6DUjf3
	 KUXnQDLSg9Xd0yQfmt+64GpD559Zt2oIyWhnu4ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 048/197] fbnic: Cleanup handling of completions
Date: Mon, 12 May 2025 19:38:18 +0200
Message-ID: <20250512172046.346261680@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Duyck <alexanderduyck@fb.com>

[ Upstream commit cdbb2dc3996a60ed3d7431c1239a8ca98c778e04 ]

There was an issue in that if we were to shutdown we could be left with
a completion in flight as the mailbox went away. To address that I have
added an fbnic_mbx_evict_all_cmpl function that is meant to essentially
create a "broken pipe" type response so that all callers will receive an
error indicating that the connection has been broken as a result of us
shutting down the mailbox.

Fixes: 378e5cc1c6c6 ("eth: fbnic: hwmon: Add completion infrastructure for firmware requests")
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/174654720578.499179.380252598204530873.stgit@ahduyck-xeon-server.home.arpa
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
index 73e08c8c41630..e9b63755cdc52 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
@@ -933,6 +933,20 @@ int fbnic_mbx_poll_tx_ready(struct fbnic_dev *fbd)
 	return attempts ? 0 : -ETIMEDOUT;
 }
 
+static void __fbnic_fw_evict_cmpl(struct fbnic_fw_completion *cmpl_data)
+{
+	cmpl_data->result = -EPIPE;
+	complete(&cmpl_data->done);
+}
+
+static void fbnic_mbx_evict_all_cmpl(struct fbnic_dev *fbd)
+{
+	if (fbd->cmpl_data) {
+		__fbnic_fw_evict_cmpl(fbd->cmpl_data);
+		fbd->cmpl_data = NULL;
+	}
+}
+
 void fbnic_mbx_flush_tx(struct fbnic_dev *fbd)
 {
 	unsigned long timeout = jiffies + 10 * HZ + 1;
@@ -950,6 +964,9 @@ void fbnic_mbx_flush_tx(struct fbnic_dev *fbd)
 	/* Read tail to determine the last tail state for the ring */
 	tail = tx_mbx->tail;
 
+	/* Flush any completions as we are no longer processing Rx */
+	fbnic_mbx_evict_all_cmpl(fbd);
+
 	spin_unlock_irq(&fbd->fw_tx_lock);
 
 	/* Give firmware time to process packet,
-- 
2.39.5



