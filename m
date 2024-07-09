Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A142155389;
	Tue,  9 Jul 2024 11:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523503; cv=none; b=Zf5ZDtlydZ9pW5p7ndn4c+arAzW2I9ViJqrRwwFwwBRbUbII5TRJgVixZ12iYflUOiz7jypLpku78faSUShBKYrV3/LPmDU1FtVXUv97G/eX5gtWa8wrhdS8sKraElvNW9Te9zPJzNdd+sBvakYcNn0VfQjA1SDPPuzf4C9lO9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523503; c=relaxed/simple;
	bh=3n5AkLKhaTM5BpHQLepN2HojnhyrlZ/jExBcKRJ1hIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PuLiLpJB1SE/UhQ3XmaFP6HElgC0d63pba4iiBdSByiwoHNlvwkiKs5qiiCUM/5eL3ycGSj6bkB4oob47+xhCvJtr1F10B0wduRq/9EvJyyapCcTVWw/ui0SaayVrnnHfqoF9LA5YxD1At5irRGDjB6l6lL3EY+FpkGbJ66eJn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wsyE07iO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wsyE07iO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F01BC4AF0A;
	Tue,  9 Jul 2024 11:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523503;
	bh=3n5AkLKhaTM5BpHQLepN2HojnhyrlZ/jExBcKRJ1hIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wsyE07iOnXi3LjkIPUofvOD3wncf4CskuBzB4RsIWJL/JNDrCnQ/XK5WifT8ZG7Xg
	 TBV3/oCpvUncqdwlSldmFvifGjR7uq/2M2LvSX9VCB+22Cnn+6aPfWYm/owC8z++4N
	 pl+INeGrFY4Un+veDHMs8Av1Iv35Ctj27rD9SYF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/139] media: dvb: as102-fe: Fix as10x_register_addr packing
Date: Tue,  9 Jul 2024 13:08:26 +0200
Message-ID: <20240709110658.397334600@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 309422d280748c74f57f471559980268ac27732a ]

This structure is embedded in multiple other structures that are packed,
which conflicts with it being aligned.

drivers/media/usb/as102/as10x_cmd.h:379:30: warning: field reg_addr within 'struct as10x_dump_memory::(unnamed at drivers/media/usb/as102/as10x_cmd.h:373:2)' is less aligned than 'struct as10x_register_addr' and is usually due to 'struct as10x_dump_memory::(unnamed at drivers/media/usb/as102/as10x_cmd.h:373:2)' being packed, which can lead to unaligned accesses [-Wunaligned-access]

Mark it as being packed.

Marking the inner struct as 'packed' does not change the layout, since the
whole struct is already packed, it just silences the clang warning. See
also this llvm discussion:

https://github.com/llvm/llvm-project/issues/55520

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/as102_fe_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/as102_fe_types.h b/drivers/media/dvb-frontends/as102_fe_types.h
index 297f9520ebf9d..8a4e392c88965 100644
--- a/drivers/media/dvb-frontends/as102_fe_types.h
+++ b/drivers/media/dvb-frontends/as102_fe_types.h
@@ -174,6 +174,6 @@ struct as10x_register_addr {
 	uint32_t addr;
 	/* register mode access */
 	uint8_t mode;
-};
+} __packed;
 
 #endif
-- 
2.43.0



