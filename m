Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC5E26B094;
	Thu, 13 Feb 2025 15:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459387; cv=none; b=S7dveBnEgUAFoXj9SWb6DsjItUhT5LcU2dCcLJ+7Fxjn2QMYOL757BLf5so3fzjJciwUHg/pYMYzZcbLTbrgWmkEmqIqHGoMYOtGKj4LP0dqjJKLgJ+RAhUJp0/6r9cPOayE5GAvLGqUPrJbUelYPj3IrN6dRycHH1Mqjc0OzwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459387; c=relaxed/simple;
	bh=1Z0S3Bana4ifBDTTjiHrGdslO/fcrYU6VMonpaTeQVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LdY708IQXrDQXXa2CbKnB3L0runTewzyHoa2tle5BkgUOBV6oAoEHUUNU/CpHoS9XfCg05yhffbTgUcOxDYfRQD7o2I+8272NBxesMt7KAAOT613gO5GkcrSAImW+8VkG+nA3qdaVmfqQw2eSn0cnSjMLJKK6t4TRNn8JWN2vDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EX2v0BSq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EX2v0BSq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09F2C4CED1;
	Thu, 13 Feb 2025 15:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459387;
	bh=1Z0S3Bana4ifBDTTjiHrGdslO/fcrYU6VMonpaTeQVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EX2v0BSq9d8w4RwVaI1iSLVlrhx+8HvuP0KuF7W1ei/hYl7gO5OvNr/M3wN0RhAx2
	 X0MkSr1wRPh2Fxn6aO3R7oJb6Qon4S3Hn7/eYthLOj4+eMuQ+Oy8STDcji+pAsaO5Z
	 CWgxveVotc/hRG+gjp6gKp0nc724XryrMuiOlurg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.13 250/443] ASoC: renesas: rz-ssi: Add a check for negative sample_space
Date: Thu, 13 Feb 2025 15:26:55 +0100
Message-ID: <20250213142450.262617955@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 82a0a3e6f8c02b3236b55e784a083fa4ee07c321 upstream.

My static checker rule complains about this code.  The concern is that
if "sample_space" is negative then the "sample_space >= runtime->channels"
condition will not work as intended because it will be type promoted to a
high unsigned int value.

strm->fifo_sample_size is SSI_FIFO_DEPTH (32).  The SSIFSR_TDC_MASK is
0x3f.  Without any further context it does seem like a reasonable warning
and it can't hurt to add a check for negatives.

Cc: stable@vger.kernel.org
Fixes: 03e786bd4341 ("ASoC: sh: Add RZ/G2L SSIF-2 driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/e07c3dc5-d885-4b04-a742-71f42243f4fd@stanley.mountain
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/renesas/rz-ssi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/renesas/rz-ssi.c
+++ b/sound/soc/renesas/rz-ssi.c
@@ -526,6 +526,8 @@ static int rz_ssi_pio_send(struct rz_ssi
 	sample_space = strm->fifo_sample_size;
 	ssifsr = rz_ssi_reg_readl(ssi, SSIFSR);
 	sample_space -= (ssifsr >> SSIFSR_TDC_SHIFT) & SSIFSR_TDC_MASK;
+	if (sample_space < 0)
+		return -EINVAL;
 
 	/* Only add full frames at a time */
 	while (frames_left && (sample_space >= runtime->channels)) {


