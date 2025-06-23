Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECAE61E5B71;
	Mon, 23 Jun 2025 21:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713823; cv=none; b=kJywKn5qdQVUIn4N9ep/jTj7Kj/Os17UkYv+okxexm7lMRAgmmV5ROminzlpu+eJNwa/zpgrYj0BdVlm9896XeIX0hjB7P2UFqbBxfG7xCuhzdZHg1w3PZsiolVWslpS/DqCpFynMviaiMVvUtcE/hitC8nHvnFBGATnUus8NaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713823; c=relaxed/simple;
	bh=1XGppuLFuU2T0+4Lawc8zSDoQioEjiVMNtfCWwMiEAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/71r/gyih+LmTJKUAPoLvKxUsxQW/XMBmYY9INhxtezFK0wXUHSB+SP2baESxKWTyJF6UnjRWCeRCoX6FE0spWfQnHvL6ra/A1Qc86DkS5Z3Z/qve93q+I7ZbK5zcbbbcY01g4OX05zTayHBfF/C/J7QyEDIjzMaWsFmQwfn6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KnrwP9++; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KnrwP9++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844FBC4CEEA;
	Mon, 23 Jun 2025 21:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713822;
	bh=1XGppuLFuU2T0+4Lawc8zSDoQioEjiVMNtfCWwMiEAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KnrwP9++IDa8sN0GNxuNdCYDqk9nVrYDWp12ufMej0vi3MiAd9VJVNseFVTvy2mti
	 yXEs2nM2ckLo9wsknP/e2g8wGiXbotJ1hkvJ0JqopxgpEhf+9nRgpdbW3qF9D+kbpp
	 GIY4aJGJtDm8qdzuHrGPXxzXqOOhtThFbss55Tm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 188/355] Input: ims-pcu - check record size in ims_pcu_flash_firmware()
Date: Mon, 23 Jun 2025 15:06:29 +0200
Message-ID: <20250623130632.333978802@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


