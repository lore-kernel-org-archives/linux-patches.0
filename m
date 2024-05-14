Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB9E142911;
	Tue, 14 May 2024 11:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686053; cv=none; b=jjc9B8WPNmzukbvwWkwKxJhs9/bARlOGyqdmLwfRaGF2ptzxrvlfBYuzsbhXNvO9813KT4KaoKbyo/hEqb198gTKwZO1vyhWOLKnq+3LMSPm9gNn1qJXXbQgp8PCmU0gRGB5yN2dS+1wqpqvssVoYmQ4RVi3gqbl6m/W5vhNrR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686053; c=relaxed/simple;
	bh=sdckKerdB3sKwN822QannyUICCCJ+39bR+9ZbZw9uU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrVQwe4ACS8OdpBE2xFZ48ugjNJYixZSy9lzlb6PIPyjYBQP/hClkvAunZdwr6a4/wWob7LQTEnQ2Wnp8jIZbWWYN1KOmP+HDT9VGokM5RAmcCHFozX83qnQyB/u9aG+Qwwi4q9IMQINPml1CJPuqnGnOgoq69J8RET2CxXlCpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TdKaIorO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TdKaIorO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97ECFC2BD10;
	Tue, 14 May 2024 11:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686053;
	bh=sdckKerdB3sKwN822QannyUICCCJ+39bR+9ZbZw9uU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TdKaIorOzoW/oKC3EFc/i/VARCU0vPhB3i0CR75x+K3ar4WBHNR9P6rF4PrKjncIB
	 JsltaF2d8zs5XuKYrm+CjggK32etuHCvjj3B+Z8NahnCOcPDF1iPHERhrnU8G+7Q8d
	 zC/GRPn21PrDxgDTBHLteGBMHDzO/jlmY/OsMCFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Jiang <quic_tjiang@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 299/301] Bluetooth: qca: fix info leak when fetching board id
Date: Tue, 14 May 2024 12:19:30 +0200
Message-ID: <20240514101043.554055617@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


