Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827156;
	b=qLW/REIt9XY67IOlE2yW/y/Ix+g/PMv9o9ZUH88w++hiolMusERLVY9XEqC4gDmpdw5Q
	 Ra9VQAEgb85cF9s0RwJIM8QT5KFoHvzio4yQ5plDorrUqDM4ZCLpn4Q2GqaJJmRejxmH+
	 GNJ9bTHDrlWkdWJJeEPI5CGbNHlA3H+6i1AowHINRtXjlotKeFlmWFKbjejixZfeAQnL0
	 Zkdx2r5KYMcO5O+IX7p7mfeUxjtdmUYyPSvqwy3bWk1le1aHregzkVl8PKauh0RHfccnz
	 hdJFvn8CWtKB2NduUHnUlcDqZYiFsfKME/G+L5O1ioozzXPCWHzpeaKmr/tRAkZu6pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827156;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JXB1hdUd//ehSPemGzO0Rud3J7oFQb0unhRA7+4YV1U=;
	b=Sqbmm+68Ky3e6POh7S6bQNioMgMs0u0HLHfK+AYAJQfFoZevQ/0AicmG/X0Hv5PAILPT
	 Z+easZWJaV9v5L55CBbRJVEP4F/ASDplP853vvP1Ij5isSj8caMG8lG6ukuuec712Y7pc
	 RkfeXn17c6KrXYuI7c80H8BNLIWlOx663TjYojDzbFk2YWS/Gwf9xSQh/A/+CSUMiKjeA
	 +7kwsBtGdBrTqkGIowOoTQhCR8XAv1Er6oEUbRfYEiilDUcQUhMvu3SbejBNzkk9kjRsc
	 PsRa9UFWDTIVx4JE/mJnphK32iEODM3xyD5k5m9laoohKSrdwKrHrbqHKLdqjay6chQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZmLGkLvK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CB4606A86E;
	Wed,  4 Nov 2026 21:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZmLGkLvK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BF41F00A15;
	Wed,  4 Nov 2026 21:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827155;
	bh=JXB1hdUd//ehSPemGzO0Rud3J7oFQb0unhRA7+4YV1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZmLGkLvK1tt79hDyYhqZGHR8Miy1z7fRl+TM+4xJk3wya2jITW2m03RW9R0vBAzB8
	 fn6Jv2looPMU0gqB7VBlYyciCvpQ+8UBsc+847eWfJ6XTNUxXh8Y5htj1pWt+YFiKU
	 dCUoJuFuqvWoGZLVHd0TAQPpFRdPnjbASUFBUdbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.3 229/547] media: microchip-csi2dc: fix async notifier leak on probe error path
Date: Wed,  4 Nov 2026 16:06:53 -0500
Message-ID: <20261104211044.665977876@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Nguyen <congnt264@gmail.com>

commit c7528789244ce7329ca883170fb9315d739ae985 upstream.

csi2dc_of_parse() ends up calling csi2dc_prepare_notifier(), which
registers the V4L2 async notifier with v4l2_async_nf_register(). The
probe error label csi2dc_probe_cleanup_notifier is reached after
csi2dc_of_parse() has already succeeded (e.g. when media entity init,
csi2dc_power() or v4l2_async_register_subdev() fail), but it calls only
v4l2_async_nf_cleanup() and never v4l2_async_nf_unregister().

The notifier therefore stays chained in the global notifier_list while
the enclosing struct csi2dc_device is freed, leading to list corruption
and a use-after-free when the list is next walked.

Unregister the notifier before cleaning it up on the error path,
matching the teardown already done in csi2dc_remove().

Fixes: 2de0b3c0f678 ("media: atmel: introduce microchip csi2dc driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Reviewed-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/microchip/microchip-csi2dc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/microchip/microchip-csi2dc.c
+++ b/drivers/media/platform/microchip/microchip-csi2dc.c
@@ -735,6 +735,7 @@ static int csi2dc_probe(struct platform_
 	return 0;
 
 csi2dc_probe_cleanup_notifier:
+	v4l2_async_nf_unregister(&csi2dc->notifier);
 	v4l2_async_nf_cleanup(&csi2dc->notifier);
 csi2dc_probe_cleanup_entity:
 	media_entity_cleanup(&csi2dc->csi2dc_sd.entity);


