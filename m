Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468031891CA;
	Wed,  3 Jul 2024 11:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005739; cv=none; b=gmjRj1HfT9aXiCqhb3pzr7FDV0Pv1kZ4uwnxDW9hS5xDm4HtrOjkqUql/2+FBKpjIsFF+vvcZOXUjA/DsT6AP3WRmlUXafMs/M/xGQduYY4XIQnJzLnX9HzOxbLR4ijqToXnsMf/zluaHwss2k+6Zz9VH2xdjYRNG1aGMxvJG2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005739; c=relaxed/simple;
	bh=+kgjpxKrrfu3I0wsRxSIyJ47gIp64GHhK1mMcf5Whdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LImJUjEdRP2gaBef4nnr5rWjk8c5RRILYlzqIsu3vo9Y0JPJNpbYrBxVqdj0QSS0kVtiidCcak0cxPiAX/bJcUtDEyeRZyWsIld+ecR3/uQ/ykkLxgv97G5DJP23NTizp3AVJuUwRfS0boKp+H5d4mggHDoGUB5niXpRZbRynA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oSSw5ZE8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oSSw5ZE8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF42DC2BD10;
	Wed,  3 Jul 2024 11:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005739;
	bh=+kgjpxKrrfu3I0wsRxSIyJ47gIp64GHhK1mMcf5Whdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oSSw5ZE8sML2NBthcQrtjS31BEDYDLoBlFiXRMHZJ8X0jp5fmfbdPmo2Xe6/FaNS+
	 ab+IWt829vxW4FUyLg2Yb8Su05vT5U1Nf9R2XIuyD+lsdACHvMmIHnAHJGpJtxjniS
	 NGiWW1ijFJEwL1BeB5rFuLiHr+GqAWm25ezdlphw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Jiang <quic_tjiang@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 149/356] Bluetooth: qca: fix info leak when fetching board id
Date: Wed,  3 Jul 2024 12:38:05 +0200
Message-ID: <20240703102918.738928504@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -209,6 +209,11 @@ static int qca_read_fw_board_id(struct h
 		goto out;
 	}
 
+	if (skb->len < 3) {
+		err = -EILSEQ;
+		goto out;
+	}
+
 	*bid = (edl->data[1] << 8) + edl->data[2];
 	bt_dev_dbg(hdev, "%s: bid = %x", __func__, *bid);
 


