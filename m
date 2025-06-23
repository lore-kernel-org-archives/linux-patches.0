Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F70B250C06;
	Mon, 23 Jun 2025 13:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685711; cv=none; b=NSJuEu6w+TThaFhS+S65DHYPOE5iEZh46D/Ha/UlawPA5wvsCNNC8FSEhlZaVLFn4pMNW5HfPb31/fBCYG6lzCRoWNQNmWcyIgHIHjdtOUWnyMPI03x3KjdjDtXFqy0yxCP1KnmhCkQlaWy6Yjv2l41Dng5LH3MJrtJcEUQnSZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685711; c=relaxed/simple;
	bh=lMeENYXfUGO+NgnsThHCcOb9l1dbqMqKOFl/B2xZJYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRlX6eKfbuDjH1Vr6vb3hFtcFX3QWEm8xMKmXtLknZGosmrdCqh4XqFWs//5x4CumMzO1UWqI3Sf4KhUdV1RhRks41RV5C2aVOD9Fsm9KRThq1AY9UF314KK41Bs8ATfRDqyTlOcZE5l0woqS+ziLFraCDIaIXuHFFaNuznTMuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cbM3rDPQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cbM3rDPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BE0C4CEF7;
	Mon, 23 Jun 2025 13:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685711;
	bh=lMeENYXfUGO+NgnsThHCcOb9l1dbqMqKOFl/B2xZJYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cbM3rDPQqMnZfp/z3FJKqxOdw1bRx3KkXk0vIqL0ptqiQpbFTNWvXugXWagDoCh/+
	 gM0xQicuRCXrd80nUihZ5vPf/M0aXafpk7vJ6E3/pJcisQkWTp47jqGiNU97hRN3iV
	 1/RYYAqj+GSxAymfmPrEe9DqaBqSsKm5SCTYi/nA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 114/222] Input: ims-pcu - check record size in ims_pcu_flash_firmware()
Date: Mon, 23 Jun 2025 15:07:29 +0200
Message-ID: <20250623130615.534147907@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit a95ef0199e80f3384eb992889322957d26c00102 upstream.

The "len" variable comes from the firmware and we generally do
trust firmware, but it's always better to double check.  If the "len"
is too large it could result in memory corruption when we do
"memcpy(fragment->data, rec->data, len);"

Fixes: 628329d52474 ("Input: add IMS Passenger Control Unit driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/131fd1ae92c828ee9f4fa2de03d8c210ae1f3524.1748463049.git.dan.carpenter@linaro.org
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/ims-pcu.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -845,6 +845,12 @@ static int ims_pcu_flash_firmware(struct
 		addr = be32_to_cpu(rec->addr) / 2;
 		len = be16_to_cpu(rec->len);
 
+		if (len > sizeof(pcu->cmd_buf) - 1 - sizeof(*fragment)) {
+			dev_err(pcu->dev,
+				"Invalid record length in firmware: %d\n", len);
+			return -EINVAL;
+		}
+
 		fragment = (void *)&pcu->cmd_buf[1];
 		put_unaligned_le32(addr, &fragment->addr);
 		fragment->len = len;


