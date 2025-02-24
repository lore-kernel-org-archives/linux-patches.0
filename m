Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29C514012;
	Mon, 24 Feb 2025 14:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409167; cv=none; b=fSqBjIIZZW3C0aJnlc8FPE8KH9Vl+cJD1R9rwFx3KCP/TohadyCwZCcnuwvDbGxMZ8YzR+kqT5yHArVKtPMzy9PMVVBJM1Wa5G9KT7ngcNArWViBxtIt/0BWjQMkPlpmKc5KjZJBS+7RdTcogMc6ZWaIuWzy4FMuzLTidIzrWKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409167; c=relaxed/simple;
	bh=PvmGSKhsATCvmp2DkNsUI+xX2vgQHw8/UFIFBr+h9t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JWgs+9nrJ0VSr7pS29NJnCrhckgn2SwnoH+HYKZzVSpPnKy8Y11hQlwnlsvdXJylNmJcjZDnh/MUMMhtyTcQ9A5Th5opSKI2F63VhmPA+AQP5c7oS+an32cbmF1rpnND6CEjLhKdmqNXE6qxY2uvOMjWay/202NJFUdSz1X0uCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1snn5e9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1snn5e9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18713C4CEE8;
	Mon, 24 Feb 2025 14:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409167;
	bh=PvmGSKhsATCvmp2DkNsUI+xX2vgQHw8/UFIFBr+h9t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1snn5e9nWlII3zDX9IYtNS3JC9gwwLi22jE+JlDPenirgact6pQ84wmR4r3Qq6HY
	 g2lFEWyuJQ9yjzNaYh8u79zct31dAZKDQpq8xblsd/xOp/GN+uoSJ9qt5T839lYeqQ
	 1wrCVjA3rKPHW5RaNQdrPosprECGqOdsilAV53zU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.13 116/138] ASoC: fsl_micfil: Enable default case in micfil_set_quality()
Date: Mon, 24 Feb 2025 15:35:46 +0100
Message-ID: <20250224142609.035548972@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

commit a8c9a453387640dbe45761970f41301a6985e7fa upstream.

If 'micfil->quality' received from micfil_quality_set() somehow ends
up with an unpredictable value, switch() operator will fail to
initialize local variable qsel before regmap_update_bits() tries
to utilize it.

While it is unlikely, play it safe and enable a default case that
returns -EINVAL error.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: bea1d61d5892 ("ASoC: fsl_micfil: rework quality setting")
Cc: stable@vger.kernel.org
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Link: https://patch.msgid.link/20250116142436.22389-1-n.zhandarovich@fintech.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/fsl_micfil.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -157,6 +157,8 @@ static int micfil_set_quality(struct fsl
 	case QUALITY_VLOW2:
 		qsel = MICFIL_QSEL_VLOW2_QUALITY;
 		break;
+	default:
+		return -EINVAL;
 	}
 
 	return regmap_update_bits(micfil->regmap, REG_MICFIL_CTRL2,


