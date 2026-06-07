Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99212AD00;
	Sun,  7 Jun 2026 10:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827330; cv=none; b=HbtUfxr3/76QhZX4nmm7ZdG+YaMaZgY5BsiaOy+s5STvoDBgmkzkCBFYfV99D/lZfC+t3rlRToKYbK+zV3CZoBHFxFa4t2vpMexnxVkmc6gw78vdeei47UdDGm8S7R8JaBC5u2jNF0YOrId7hK0t18reZTEgYyY0PMa7LCbSwC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827330; c=relaxed/simple;
	bh=4qIrHHKgOHhYP5qY4T0bhYiuS2j64CL1yB11HoSI3tY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZqMfbYPEN8J73RQSPQbBifOkafqMm8kvArI1S+z3OyQIX+x1gP8uMIb8+X/LKer32k9qqY0uTsSjtvgQozzq3lmp3l1/zAJb8vtmg2Wq6PCx7ZURuHUeRIyDIAA5ZrK8bdOFSwE/xFau7+Igc32BdHN7irX8ncQ84MF3GVO3Eeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X4JOBWyJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X4JOBWyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3158A1F00893;
	Sun,  7 Jun 2026 10:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827329;
	bh=FZTiQUl5LtfezJdW2qymqcs86DNXGpOeEMzR/bGnvxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X4JOBWyJ+tklzx0qXMMROcW0jc5mS1d8ALLqsOrj1g+f/YiyboUKOypxSGLnYVvVM
	 /T4QGP8km+Z1hBuBn1hhpYM1n1sP4aRWF9N5IwEJtAi/xKrxWX2Z5VAlCPEStQehD9
	 8zfInokjfu88ZvQfeoW3TEr2kCpvg48iImHSV80E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/307] accel/ivpu: prevent uninitialized data bug in debugfs
Date: Sun,  7 Jun 2026 11:57:23 +0200
Message-ID: <20260607095729.399124788@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 44e151be23deb788d9f6124de93823faf6e04e99 ]

The simple_write_to_buffer() will only initialize data starting from
the *pos offset so if it's non-zero then the first part of the buffer
uninitialized.  Really, if *pos is non-zero then this code won't work
so just check for that at the start of the function.

Fixes: 320323d2e545 ("accel/ivpu: Add debugfs interface for setting HWS priority bands")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Link: https://patch.msgid.link/ahP24m6Mii9EDL7Q@stanley.mountain
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/ivpu/ivpu_debugfs.c b/drivers/accel/ivpu/ivpu_debugfs.c
index df89c1c0da6dd7..1da4ce6a99cd9b 100644
--- a/drivers/accel/ivpu/ivpu_debugfs.c
+++ b/drivers/accel/ivpu/ivpu_debugfs.c
@@ -447,7 +447,7 @@ priority_bands_fops_write(struct file *file, const char __user *user_buf, size_t
 	u32 band;
 	int ret;
 
-	if (size >= sizeof(buf))
+	if (*pos != 0 || size >= sizeof(buf))
 		return -EINVAL;
 
 	ret = simple_write_to_buffer(buf, sizeof(buf) - 1, pos, user_buf, size);
-- 
2.53.0



