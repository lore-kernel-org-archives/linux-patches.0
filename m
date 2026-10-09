Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6FB4582D3;
	Fri,  9 Oct 2026 14:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556830; cv=none; b=Vekklg15lJE4YpIlAU0mOq7gz3x/s9II8T3ch4Jp0vMm0DPE80fM66zr4jOFDn8DbDO6kbg7O29SAatfg+UanLQARvSU/QOn4WfoCTeNmp6tt3WDBq6vyn5EOCWGzmMJKAfWpCreL9WGrdRmNi/A8p6Lf+1Dk+bkEOJqEraJDEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556830; c=relaxed/simple;
	bh=LdCyV/4i3RX2i2wO5iBk/tsaTXLpAAcSGniIXumsBb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Po6vnRhDSyUUXFMVCJiicNwkg6VD2yBDDmFv/cNBm0txtdMntqSqjHdOyCctXJjC0LegRw5MKS4xFj6PUmLVmfmyY8JMxphCC7SShVi3uTqcAhOUjKSiSq5SlJg09r9FifAOC5dfEMovzzYbjUaSC5V4LLby8GSqKkuTOjxkXk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qSFHPekp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qSFHPekp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058EB1F000FF;
	Fri,  9 Oct 2026 14:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556829;
	bh=khl8pAdw8HGrczuDfXmBtBcrSTFRp8QW3ZHiW8HGDSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qSFHPekpFxYsnIAgM81cRIlOzBagj1E42SqgSmRLCJpS0irds647awpIYT7yx78mO
	 24uO3H8jWzgn6m0fzGBkejRMz708oI4usR7IMGcYitaqORxQjo0Natkpnz+ROTydZp
	 n0yv9wSxwK7ZQx6kldBfU51/iFl07ufv4vTYQwqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 300/403] iio: accel: sca3000: fix frequency divider condition check
Date: Fri,  9 Oct 2026 16:11:01 +0200
Message-ID: <20261009140959.225439687@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -647,7 +647,7 @@ static int sca3000_write_raw_samp_freq(s
 
 	if (val == base_freq / 2)
 		ctrlval |= SCA3000_REG_OUT_CTRL_BUF_DIV_2;
-	if (val == base_freq / 4)
+	else if (val == base_freq / 4)
 		ctrlval |= SCA3000_REG_OUT_CTRL_BUF_DIV_4;
 	else if (val != base_freq)
 		return -EINVAL;


