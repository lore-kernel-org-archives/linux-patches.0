Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AC0A47;
	Mon, 28 Oct 2024 06:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097962; cv=none; b=BKbykQXIlsUFhlsAyY5PLWaO7ueTo5MfDxUDpVgJMYd/mBBrxEkrt+aOVGos7YmLA9Dled7FQ/bD0gX0nmTLM0KrHNZ4E6BTd98n4+Zw63C2re61ZwSd2n4aduHalQ3/S5AS76Usa9bJLecL/59AwThazCYVEtAXlmzu494YBDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097962; c=relaxed/simple;
	bh=b3AEUU+z0tf/CnAhHsk0dTDDl88PIbya5weOYgxo/OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TxKVh/qkQhR/JUn4u4bhTkegCsZ53DS9oIbrXT3IEvvrmjPpt0u52lynuaMiBEtrL7/AsMBD/7hCh0h0hMGczpHx+1WjZ5qWo8aTHg8n3Et1UpCzVzZ7ex9V0TdPnRQ52W4kZw44Jz8Su3hoR1QOj40N6HRvynOTx8NIXovTNYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qeeLejQS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qeeLejQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786C7C4CEC3;
	Mon, 28 Oct 2024 06:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097962;
	bh=b3AEUU+z0tf/CnAhHsk0dTDDl88PIbya5weOYgxo/OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qeeLejQSpbtsgv1FeBhnRYIpfj8Ip+BQ7G4l2UaFO7wpGIKWhGfhTXA/5QUBJ9xCs
	 ooBl23cf8Qs2eFp5x0J4v4Ry1XFPoLvsoySrayAPA8Nyea3pSjJi+voSBMj7Re8ypc
	 DCd75CqeH2b/QFuSvRu65FtM8hjV7INbRQFA3TtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Lobanov <m.lobanov@rosalinux.ru>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 002/261] iio: accel: bma400: Fix uninitialized variable field_value in tap event handling.
Date: Mon, 28 Oct 2024 07:22:24 +0100
Message-ID: <20241028062312.070860035@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Lobanov <m.lobanov@rosalinux.ru>

[ Upstream commit db9795a43dc944f048a37b65e06707f60f713e34 ]

In the current implementation, the local variable field_value is used
without prior initialization, which may lead to reading uninitialized
memory. Specifically, in the macro set_mask_bits, the initial
(potentially uninitialized) value of the buffer is copied into old__,
and a mask is applied to calculate new__. A similar issue was resolved in
commit 6ee2a7058fea ("iio: accel: bma400: Fix smatch warning based on use
of unintialized value.").

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 961db2da159d ("iio: accel: bma400: Add support for single and double tap events")
Signed-off-by: Mikhail Lobanov <m.lobanov@rosalinux.ru>
Link: https://patch.msgid.link/20240910083624.27224-1-m.lobanov@rosalinux.ru
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/bma400_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/accel/bma400_core.c b/drivers/iio/accel/bma400_core.c
index e90e2f01550ad..04083b7395ab8 100644
--- a/drivers/iio/accel/bma400_core.c
+++ b/drivers/iio/accel/bma400_core.c
@@ -1219,7 +1219,8 @@ static int bma400_activity_event_en(struct bma400_data *data,
 static int bma400_tap_event_en(struct bma400_data *data,
 			       enum iio_event_direction dir, int state)
 {
-	unsigned int mask, field_value;
+	unsigned int mask;
+	unsigned int field_value = 0;
 	int ret;
 
 	/*
-- 
2.43.0



