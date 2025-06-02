Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3D01DDC11;
	Mon,  2 Jun 2025 14:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872805; cv=none; b=nK67Xm7UHgjo6XX3PInaH/37XZITCLatLz2GclcavRL0LtgHu/BzgqQ7io9QquF20Iyoxv4+l3J0CAteWlcfaSJPxM+VpINlmauYBPRiKa6Y7khL+IKKsCSAYRFttDhSghdNldB/k3Pc1TvEcv5ftHvDQjYUwbBEiHWYaiH/NfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872805; c=relaxed/simple;
	bh=H9Yqo47488DfNEtFmI3ysPlbfuvv8MV+4oC1cxBLX9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LeIhU9LHFBtkueKil+m/kNl1o+W9IbIQz58+CiwF4aBuY8cvyAo6COEV+vU6s5ofk8bYnU+E+59ofHDOTHxO2LDHWrstKAVAYwdlR6opYp97x7Lsh7yw5yvb3WFaNQfm3uuu+X48+eGM8Ef1aukKPYqqC3OlGYc6nsSxpB3vvDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15s9etrh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15s9etrh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB5AC4CEEB;
	Mon,  2 Jun 2025 14:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872805;
	bh=H9Yqo47488DfNEtFmI3ysPlbfuvv8MV+4oC1cxBLX9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=15s9etrhYSvt6RsX5n/bA36HSe05IRh6sfV3c5SFgJDM25D0BMjUGQSyaKuACMOFL
	 76xUiUgSZbngUX6a4Cdg6x7Qw4U2CtPrPHooWWii9WKgYCiUjoaSqJt8u3hR0ioMMh
	 nA7ia3T6z5zI9x/88k/EOCGjnVPfifzRJQNzNRjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Purva Yeshi <purvayeshi550@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 67/73] char: tpm: tpm-buf: Add sanity check fallback in read helpers
Date: Mon,  2 Jun 2025 15:47:53 +0200
Message-ID: <20250602134244.330227427@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
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

From: Purva Yeshi <purvayeshi550@gmail.com>

[ Upstream commit 32d495b384a2db7d23c2295e03e6b6edb1c0db8d ]

Fix Smatch-detected issue:

drivers/char/tpm/tpm-buf.c:208 tpm_buf_read_u8() error:
uninitialized symbol 'value'.
drivers/char/tpm/tpm-buf.c:225 tpm_buf_read_u16() error:
uninitialized symbol 'value'.
drivers/char/tpm/tpm-buf.c:242 tpm_buf_read_u32() error:
uninitialized symbol 'value'.

Zero-initialize the return values in tpm_buf_read_u8(), tpm_buf_read_u16(),
and tpm_buf_read_u32() to guard against uninitialized data in case of a
boundary overflow.

Add defensive initialization ensures the return values are always defined,
preventing undefined behavior if the unexpected happens.

Signed-off-by: Purva Yeshi <purvayeshi550@gmail.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm-buf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm-buf.c b/drivers/char/tpm/tpm-buf.c
index e49a19fea3bdf..dc882fc9fa9ef 100644
--- a/drivers/char/tpm/tpm-buf.c
+++ b/drivers/char/tpm/tpm-buf.c
@@ -201,7 +201,7 @@ static void tpm_buf_read(struct tpm_buf *buf, off_t *offset, size_t count, void
  */
 u8 tpm_buf_read_u8(struct tpm_buf *buf, off_t *offset)
 {
-	u8 value;
+	u8 value = 0;
 
 	tpm_buf_read(buf, offset, sizeof(value), &value);
 
@@ -218,7 +218,7 @@ EXPORT_SYMBOL_GPL(tpm_buf_read_u8);
  */
 u16 tpm_buf_read_u16(struct tpm_buf *buf, off_t *offset)
 {
-	u16 value;
+	u16 value = 0;
 
 	tpm_buf_read(buf, offset, sizeof(value), &value);
 
@@ -235,7 +235,7 @@ EXPORT_SYMBOL_GPL(tpm_buf_read_u16);
  */
 u32 tpm_buf_read_u32(struct tpm_buf *buf, off_t *offset)
 {
-	u32 value;
+	u32 value = 0;
 
 	tpm_buf_read(buf, offset, sizeof(value), &value);
 
-- 
2.39.5



