Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F0D2DC792;
	Thu, 17 Sep 2026 18:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670692; cv=none; b=pyDB6l2Zceh2P7ngPbtolCAdddh21pIHuy+7Yj4AbcXsBfViBMpnEY4YdY/qYyrR1tV43UOuaFIB1AaH7plBvuf+70bhw21Y3vpVwStd7Arse5PIfNlaK4dMsP836El3ERfKsFbDzw+ttcV/5Q6pQjyCDo1QYIhNP/gSHowl9j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670692; c=relaxed/simple;
	bh=P1WaPws+SNpDt8903wqMkwBz1mG8ukag8kXIdEok4iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMTyDIbP0D3oTaf1oN7GmsXxOB4vVXrEkhDj5J5aJ/x7bK890303RpSjVODgj+Zn8jknXzKCeHa6MTcLvxUm5Jia2fzWvqQyIwryoEM/qNxHcrR3kMiakInBP3E4FJaZhd7XEx+XnCIDIdFhuun35LVQYr/kvUPZ0ZSS61FNDfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fvEyg4mq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fvEyg4mq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26EA41F000FF;
	Thu, 17 Sep 2026 18:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670690;
	bh=UbLzlCqzUZymj67n8iShWtQtLV6wPi4tNXhQuu7atiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fvEyg4mqUghfUNRBG5zz5sC/9nvBI5n6pyfeuZSe3OuFaNiEzcH0abb7kUHQkGXIP
	 RrFe8lkn1fGDVvNr3XzRL5I6CvbWR21ikCvrEi+NfnYkElddTXkLEuLWJ+EJHjnAWY
	 2OYYtgHckBrONJHdx/fAS0ZCYqM55rbMHwK/uha8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0740/1102] Bluetooth: btintel_pcie: validate packet_len before skb_put_data
Date: Thu, 17 Sep 2026 16:11:23 +0100
Message-ID: <20260917151558.977963848@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiran K <kiran.k@intel.com>

[ Upstream commit 6436e1b5331b1aebf905c13e0880a37032719b75 ]

btintel_pcie_submit_rx_work() reads packet_len from rfh_hdr without
checking if it exceeds the RX buffer size. An oversized packet_len
can lead to an out-of-bounds read in skb_put_data().

Validate packet_len to ensure it is non-zero and does not exceed
BTINTEL_PCIE_BUFFER_SIZE - sizeof(*rfh_hdr), logging an error when
invalid.

This issue was reported by Claude Mythos. It can be simulated either by
using customized firmware configured to return an invalid packet_len or
by modifying rfh_hdr->packet_len in the driver before calling
btintel_pcie_submit_rx_work().

Fixes: c2b636b3f788 ("Bluetooth: btintel_pcie: Add support for PCIe transport")
Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index 7acfa6e657984..3be64a209e04b 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -739,7 +739,9 @@ static int btintel_pcie_submit_rx_work(struct btintel_pcie_data *data, u8 status
 	rfh_hdr = buf;
 
 	len = rfh_hdr->packet_len;
-	if (len <= 0) {
+	if (len == 0 || len > BTINTEL_PCIE_BUFFER_SIZE - sizeof(*rfh_hdr)) {
+		bt_dev_err(data->hdev, "Invalid packet_len %d (max %zu)", len,
+			   BTINTEL_PCIE_BUFFER_SIZE - sizeof(*rfh_hdr));
 		ret = -EINVAL;
 		goto resubmit;
 	}
-- 
2.53.0



