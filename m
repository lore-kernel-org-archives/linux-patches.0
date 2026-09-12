Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B6E235358;
	Sat, 12 Sep 2026 07:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198375; cv=none; b=qzAVHxzlHEawHp/glns00y6CWB8T8FGyp2N5kG/VMWR+pZ9DvX/PMjeIxBRIplAaz7Y3CMFBV8GcFilr6m+BzzZZ13iF/5SclWcMPYNk9+RtyduFbUNIvnvDtOWk9MyaeRSU1Cw57KP4xeZ3R+riJDF3Tiz77tNwUaP6TPjznbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198375; c=relaxed/simple;
	bh=4aAZAbjCcmAe3yNcmMgYoqqxX1emyuTsMxirp14M4GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9ZhNj0qu9HkD/lN9jL5sxBozSuH+YCwu/+ICe0QunGqGcZc/foKk/rr0GncYLDtQkFOlmlNb9So1hHLsNypn2DFftcycYt4rHtIuQwM0jNLzRW2bpTAB5eRNWS0EHlGp5nYZzQUZKdi+Lc68MUOiPwBce92F/lj0oCo62PB+gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1YL6zDSA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1YL6zDSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226E11F000FF;
	Sat, 12 Sep 2026 07:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198374;
	bh=HpR9VmOKYr4M9TzerJLv6KKxdvP8TrC7J0U5EYTxKt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1YL6zDSAWG5ELnDy389rWw5OV4AlsLLrprj8pAb+uv1dHOnWTEu7qj+EeH0OQCt4B
	 mNpAJLnTj4zcm7HSK1e8vUpblj3lIRIuwg1NuwmEgSISYL3zs8tRVpsLw8DWRDIlXc
	 jx8uqJI+mp9SwwHYuERs7YcFa55ciUgr+fvaiWTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0324/1815] usb: ljca: bound bank_num in ljca_enumerate_gpio()
Date: Sat, 12 Sep 2026 08:34:34 +0200
Message-ID: <20260912065656.539385488@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maoyi Xie <maoyixie.tju@gmail.com>

[ Upstream commit dd9483726d0f16c1a56879c3edb65128259a4e2b ]

ljca_enumerate_gpio() reads desc->bank_num from the device and loops
valid_pin[i] = get_unaligned_le32(...) for i < bank_num. valid_pin[]
holds only LJCA_MAX_GPIO_NUM / 32 = 2 entries.

Two checks run before the loop. The reply length must match
struct_size(desc, bank_desc, bank_num). The product
pins_per_bank * bank_num must not exceed LJCA_MAX_GPIO_NUM. Neither one
bounds bank_num against the size of valid_pin[]. The reply is capped at
LJCA_MAX_PAYLOAD_SIZE (60) bytes, so the struct_size check limits
bank_num to 9. A device that reports bank_num 9 with pins_per_bank 7
still passes both checks. gpio_num is 63 and the reply is 56 bytes. The
loop then writes nine u32 into the two entry array and overruns
valid_pin[] on the stack.

A broken or malicious LJCA device can therefore overflow the stack.
Reject a bank_num that does not fit valid_pin[].

Fixes: acd6199f195d ("usb: Add support for Intel LJCA device")
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Link: https://patch.msgid.link/178176358875.3352358.6059116660356914900@maoyixie.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/misc/usb-ljca.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/misc/usb-ljca.c b/drivers/usb/misc/usb-ljca.c
index 78e94dd89da55..fcb627b49eac6 100644
--- a/drivers/usb/misc/usb-ljca.c
+++ b/drivers/usb/misc/usb-ljca.c
@@ -595,6 +595,9 @@ static int ljca_enumerate_gpio(struct ljca_adapter *adap)
 	if (gpio_num > LJCA_MAX_GPIO_NUM)
 		return -EINVAL;
 
+	if (desc->bank_num > ARRAY_SIZE(valid_pin))
+		return -EINVAL;
+
 	/* construct platform data */
 	gpio_info = kzalloc_obj(*gpio_info);
 	if (!gpio_info)
-- 
2.53.0



