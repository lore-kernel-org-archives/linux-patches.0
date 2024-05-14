Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5897E5FEE4;
	Tue, 14 May 2024 10:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684167; cv=none; b=RLftgEneMSXSJ4a60bQtOfoWRtTl5WCqQBEd6OHIvkKwlEfuzzL5Q8OujytmzvmXAd8aFye32i+df/uepUf9MVdFboeCXp+/5pEChZJumKEzZOFS3j8Su6QoxXCTfurglMRIgkAxmwSMqIiV/iwqFHM5LCMGSLMFZ5shscZl8jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684167; c=relaxed/simple;
	bh=A0vsFi8ztQJSwOmRz0W+4IsebCF/dV3Jy7eKpgo9kw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TT4Bav9zHUEfPw+JD/zj9IeJZhqwzEF+9UcPoQ5jo8EgwuTMEhL3iiq9UjnsLhObhJmP6DgpohEBueb9Y+zyt06wMEOfIGEJIDH4nGu2pElsUECLpSLv1GHwqzR4a9EIvnOcxsn9tHspjhT/HzVafMONeunQWL1TE0OfAUaX52c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UGAcTMiX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UGAcTMiX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40184C2BD10;
	Tue, 14 May 2024 10:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684167;
	bh=A0vsFi8ztQJSwOmRz0W+4IsebCF/dV3Jy7eKpgo9kw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UGAcTMiXYQ2iOvHDR8qZd54fRBpXizo8Y3/pUTQv697HbDqTkwZXdcarEaAWlaRl6
	 GEQ6xCMfNz4J3GuIhXhjTzKZuWcyfcaDrTvsaDCEaEbReVOPEeKJAU95zzGVQxO4N3
	 L67casG2zojEzRXGoH2UxwtRG36U0zXBSNMcMek4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Jiang <quic_tjiang@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.8 334/336] Bluetooth: qca: fix info leak when fetching board id
Date: Tue, 14 May 2024 12:18:58 +0200
Message-ID: <20240514101051.237740772@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 0adcf6be1445ed50bfd4a451a7a782568f270197 upstream.

Add the missing sanity check when fetching the board id to avoid leaking
slab data when later requesting the firmware.

Fixes: a7f8dedb4be2 ("Bluetooth: qca: add support for QCA2066")
Cc: stable@vger.kernel.org	# 6.7
Cc: Tim Jiang <quic_tjiang@quicinc.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btqca.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -235,6 +235,11 @@ static int qca_read_fw_board_id(struct h
 		goto out;
 	}
 
+	if (skb->len < 3) {
+		err = -EILSEQ;
+		goto out;
+	}
+
 	*bid = (edl->data[1] << 8) + edl->data[2];
 	bt_dev_dbg(hdev, "%s: bid = %x", __func__, *bid);
 


