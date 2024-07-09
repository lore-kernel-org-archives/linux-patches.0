Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FAC158DCD;
	Tue,  9 Jul 2024 11:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523979; cv=none; b=ZZO+JrdFr1XqvDRgJI+oAA3bB5uFbPuSuJIbyoFTwLJdw+R8lDvdv83Y+wLDHvtcRstLzzpzvPUEo1YAMorzEwgD1UPJJSuy9dqw0rf7XL8IwMqGAmRBsxRU/aOZdyYAuJ6OYcL+EiH2eLIev6dTZqyevTesjHUEGuCoC4uS1Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523979; c=relaxed/simple;
	bh=6hX0/Y+VyZMsghGI4kTCioN0V4yqueLn8HA7qLyk1XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uu1rO6gbMdUoin4fCblO3kIqJBzsxM8oXdIzfl+GBbjlhoP3p8Vf21PxPQvCfGb9a2y4TezQnz2zK8LFkN9Jdq7E6pw3nvO6VkxhwJVM42KRVpydwwUZY1WTj68E1GU6sSjMMqN6juc77iAWMsoZ4gtUrUCFpMQrJ+Buh08EpiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xsw9slb2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xsw9slb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0C9C32786;
	Tue,  9 Jul 2024 11:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523979;
	bh=6hX0/Y+VyZMsghGI4kTCioN0V4yqueLn8HA7qLyk1XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xsw9slb2CMgSRbSvVgLRrp4o+8qqZIOgzb4QmiOnW8Ph89aYnQ9gZRNG1hPeg+Sv6
	 ATNeSdv/dR3IHflIpOt3LHHOKKYcKlc6t124t8Oe+J4FmuJhR4F8W2cdlwTuq6BXtO
	 VV/HxzpCjW+UXa/cIlxTRA1IbmW2Bl1hYQ8lDcXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 008/197] media: dvb: as102-fe: Fix as10x_register_addr packing
Date: Tue,  9 Jul 2024 13:07:42 +0200
Message-ID: <20240709110709.232426821@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



