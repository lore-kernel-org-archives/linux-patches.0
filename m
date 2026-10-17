Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856FD3A0B2E;
	Sat, 17 Oct 2026 17:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256746; cv=none; b=T1ANf8q1ne862C2AEy0KngEJpXE3Ha2rhPEHRhgEPM1AKGC9TK/aMK3VU/w4ZX6HQKNIbFygI4ZveksdB65RX2gezYTt0TVp6hwmoegXQJ+sSEGx38drUOPR/U5WIOE0uVxGJdV//wGpuhdkGtx6Enmz+cKeeNvCVtyF1FeI3ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256746; c=relaxed/simple;
	bh=Uh1mOX6ycXVIQQT3y33Ijyk8QDl49iYL6mfw5XOxYqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7V81U9EDpmCpTquTG4p7xO3Zpq8hQyu+0wX8LvTB0NPsgq4TA+SHgnU8FrudTUipSFeBmof7TsjSOAO5aqZWb4NeuXTqMSFU7bKtqYKr2Zj6ELMe5w84W6ABuae+2DrHD7OMu/t9qTgpVmlOB0l5PCyq0PGThQ64QHrBlYhqoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c7S7h9WY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c7S7h9WY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38BB1F000C4;
	Sat, 17 Oct 2026 17:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256745;
	bh=FI6Wxj9JwqOfyEykKa7CnAgHa62XTbJIFWDffhUQH7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c7S7h9WYFQWmgD648ZJnwhBsZ9P44aIYyxqGBpOBlf7X08ud8OFXbII+ixO13ukuK
	 4vtYXEnsqbA7ZjwHTLPm6fqP/DsHIFSWaMP5jyg2MOutEr9BaBuWY7FCOi7UltXy0h
	 BSVryZ5qBTZzvJoA8h9XlHyXCeEpEtTeWNXN6pjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.6 0336/1674] iio: accel: sca3000: fix frequency divider condition check
Date: Sat, 17 Oct 2026 17:43:28 +0200
Message-ID: <20261017160439.751312671@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salah Triki <salah.triki@gmail.com>

commit d380bf5f94a892e546d9a94e8557ad866b043a2a upstream.

When setting the sampling frequency, the check for `base_freq / 2` is
followed by an independent `if` statement for `base_freq / 4`. If `val`
equals `base_freq / 2`, the second check fails and falls through to the
`else if (val != base_freq)` branch, returning `-EINVAL` erroneously.

Fix this by chaining the checks with `else if`.

Fixes: e0f3fc9b47e6 ("iio: accel: sca3000_core: implemented IIO_CHAN_INFO_SAMP_FREQ")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/sca3000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/accel/sca3000.c
+++ b/drivers/iio/accel/sca3000.c
@@ -652,7 +652,7 @@ static int sca3000_write_raw_samp_freq(s
 
 	if (val == base_freq / 2)
 		ctrlval |= SCA3000_REG_OUT_CTRL_BUF_DIV_2;
-	if (val == base_freq / 4)
+	else if (val == base_freq / 4)
 		ctrlval |= SCA3000_REG_OUT_CTRL_BUF_DIV_4;
 	else if (val != base_freq)
 		return -EINVAL;


