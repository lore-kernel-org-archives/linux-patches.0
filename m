Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27757155308;
	Mon, 24 Feb 2025 14:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408164; cv=none; b=EP8dDv/7uRotzzqFDOGw8U7rz5oQsIzF67KP5YUEAjKQllnHeKxs3+403+H200Ygl6fVqiB7rrOybO94K1no7WGJ9Ygad0HB6oGV7/iRWK1mEE0N5Q8Gz2NSOvPayVY05+8PCDHIfL85piOUe4UmwzsoqV/kA2tUaKxekXARrBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408164; c=relaxed/simple;
	bh=6vzYBVw7TSmImArvpnBRX0D2Yink986C3eoPRD88kPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tn1UdzyZKWDdv4TRkvpDdSEu9FQ0Y094QNw5/jCVANfGMHLNNOShajaOneAYhxB+NR5WKf+O8sKVSRwqbsd9HijSBaJZaVM5ag2AX9WQHceIco4LCtzffg/IuRKWiFINSv1qeR5bw851LWL49Jsf3a17MeIopzXxFZUyzhVouuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=snR6nccw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="snR6nccw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F676C4CEE6;
	Mon, 24 Feb 2025 14:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408163;
	bh=6vzYBVw7TSmImArvpnBRX0D2Yink986C3eoPRD88kPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=snR6nccw8kn1EhY9devJ6cJqozEwMLznYb86f6szeciYPiFeOHjl+/yxJtdoksDT2
	 PTK/lP3D5A0LS3yaYA36/rwFgk9znEvFsf4vr4L7J8b7FbQgVtEGJyl0/8esuk0dxB
	 GPjfcPi+gN/M2MGiY1hdLRNXUgRGMUr+vxk1f5MM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 118/140] ASoC: fsl_micfil: Enable default case in micfil_set_quality()
Date: Mon, 24 Feb 2025 15:35:17 +0100
Message-ID: <20250224142607.654579378@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -156,6 +156,8 @@ static int micfil_set_quality(struct fsl
 	case QUALITY_VLOW2:
 		qsel = MICFIL_QSEL_VLOW2_QUALITY;
 		break;
+	default:
+		return -EINVAL;
 	}
 
 	return regmap_update_bits(micfil->regmap, REG_MICFIL_CTRL2,


