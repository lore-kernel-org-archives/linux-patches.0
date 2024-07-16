Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1388E19E838;
	Tue, 16 Jul 2024 16:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145997; cv=none; b=kRwUe2HklDYNnQH3mt7Go0e/xnBA8Jlq17ELPi8iSQuYjB9gIrTmeXQ8zj04DebvbAPhxsu5ljoK4FYQohPB9V0Lhc1MqpM0vblIbLQ+qtwsATmn6UwrjSrhDUV3Jzcw6HLL/fS6680GjDc0ifDJR4z6zhGQgqBWjugV1gW4VC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145997; c=relaxed/simple;
	bh=3q+IbUlSeFL0LlCDnWEyKyT+V884tMkrXXGk1q4qkRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cuIMmI8aJli9womMcwdl1qlgH+4dFB6DXxM8M/7c8TdXfMV68XvDfOn90sOU7paUa/Bm0/ztJonC9dsvMwkTMzLBUFh6owCcUwafR7SQ2EE9zMI7kjRtO7sLDyU25sXNFDu4X1iJ7LGeh7UrDi+zvHlxfQmisXMKSHqE8jEsgxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zAhUxvWH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zAhUxvWH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A7EC4AF0B;
	Tue, 16 Jul 2024 16:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145996;
	bh=3q+IbUlSeFL0LlCDnWEyKyT+V884tMkrXXGk1q4qkRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zAhUxvWHkIW86F1WNQ7zx9vOGVQhIrPjanqJ10Jr60DPjdoyVUtMObhNWcgAsrkno
	 JF9zdRgKXC2juvVfmEo8FJaQqzMcr/k9Mb+XR7lQ8clt2ZnuwoHXLsK8cdMPGl1CDd
	 Rp1cZ9PtX+byuOJrBS/RQZlFZc5oBSKteRDtxs8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/144] media: dvb: as102-fe: Fix as10x_register_addr packing
Date: Tue, 16 Jul 2024 17:31:12 +0200
Message-ID: <20240716152752.659453795@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



