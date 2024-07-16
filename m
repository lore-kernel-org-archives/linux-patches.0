Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B516FF9E8;
	Tue, 16 Jul 2024 15:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144517; cv=none; b=ZyazSxCBSGTOwOr282+iCotv9L7fTpRjwqabL/80HcWZKO9FuIMiePtmD+gqz2Y/poFUWGSBS/KPhdq8UymkdYyn4mYwbWM4VE8fbQKWVzWIbcC3ecIRORrbeRUh+tN1AEFxv1XpdAOA2csbOtO9mm2AeuDq0DlIapLZ7zMThlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144517; c=relaxed/simple;
	bh=AdVlYHUzsYyRGvHjmn2GjUY+vhJm73L0sfpCvIzSqtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JNkt8sLTRHmWlbs+hQ03R//asxdR5F9RS/vBibXvS77nHEQHYWjb/REFRwE92dT776BckyZDBJ9gGuZI2AH0IKK9j99dNiGznkt9p1L1BZNZLEzY7afgmdtrDxQG6nwVFkvIq92lfiQeDs6SOQf97dN9GvVTPeer/NT1Np/XIoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R1GOYGYD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1GOYGYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B479C116B1;
	Tue, 16 Jul 2024 15:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144517;
	bh=AdVlYHUzsYyRGvHjmn2GjUY+vhJm73L0sfpCvIzSqtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R1GOYGYDV4t/1d9MeU5hboKED7eiHYfVBZavRlhhVSCIL+2cFvqbGfR8YDc/fdAwt
	 L3p+9O5BwAlzAA5Cm8PiU31qTEqetHTsmg9nTRKYWA3xc1Tfq+AFXV2IYGYR0F4BGn
	 Q0eWYDpq5OkwxP4SoAP+5Qv3WngVC0mhYXLuVSrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/108] media: dvb: as102-fe: Fix as10x_register_addr packing
Date: Tue, 16 Jul 2024 17:30:17 +0200
Message-ID: <20240716152746.087018943@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



