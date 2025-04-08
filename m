Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CCC263C6D;
	Tue,  8 Apr 2025 11:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110488; cv=none; b=GU4/d/7M1UHfqguRZ6X+1smaEkB/ajQAR0ptSVkHasD+UFGWBO2aOBtqXjhoi3DsZPe2eP/qJilOsHWgUkun+8rhFgBHIvXOPs6Sn8U42MJcIE8bhoWC/1k3R21sH2lGwhRXy3lqbLrDDoYZdSUyE+CCW8E+57kNWMF1MssoeYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110488; c=relaxed/simple;
	bh=ZirfOvraMMocGQw8LCU1ZIhQwjaqj7DBvlhwWZDgEeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UJzcqF/eco4qREN2B74V12B9e3vYyrwFoAVuwDeo1exDp2nDYfuthrauUnRuJv+5IrGr0VmlPtbCu0uY3MqVNiW/qsMMmoDsSkLC6uoShhAEHeWVhcMlrPSrdOhe9/AuBB/oHbdB4qd7v2sl8VPL6JTtQGl8m5OO4PckUarLZVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TA/cTPju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TA/cTPju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556F0C4CEEB;
	Tue,  8 Apr 2025 11:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110487;
	bh=ZirfOvraMMocGQw8LCU1ZIhQwjaqj7DBvlhwWZDgEeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TA/cTPjuqDVlL1wc+xao1IpODu112U35sb2QplEJ2g3xs2L7dOE4xdCtzaVwPyz4s
	 G81FZ6lrdapCwtBVK0AyLO+x6vrB1OpHxtFUR3TFK+uQ/VJoN+8QO3Vqq27j7TB8Qw
	 eGcYmyuR9KNY358YX8yROJMe57rJrFyh2Lpwxvls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 080/731] wifi: ath9k: do not submit zero bytes to the entropy pool
Date: Tue,  8 Apr 2025 12:39:37 +0200
Message-ID: <20250408104916.131292623@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 0f2b59a98027a781eee1cbd48c7c8fdf87cb73f6 ]

In 'ath_cmn_process_fft()', it doesn't make too much sense to
add zero bytes in attempt to improve randomness. So swap calls
to 'memset()' and 'add_device_randomness()' to feed the pool
with actual FFT results rather than zeroes. Compile tested only.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Fixes: 2aa56cca3571 ("ath9k: Mix the received FFT bins to the random pool")
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://patch.msgid.link/20250123141058.1696502-1-dmantipov@yandex.ru
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/common-spectral.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index 628eeec4b82fe..300d178830adf 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -628,12 +628,12 @@ int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_h
 				else
 					RX_STAT_INC(sc, rx_spectral_sample_err);
 
-				memset(sample_buf, 0, SPECTRAL_SAMPLE_MAX_LEN);
-
 				/* Mix the received bins to the /dev/random
 				 * pool
 				 */
 				add_device_randomness(sample_buf, num_bins);
+
+				memset(sample_buf, 0, SPECTRAL_SAMPLE_MAX_LEN);
 			}
 
 			/* Process a normal frame */
-- 
2.39.5



