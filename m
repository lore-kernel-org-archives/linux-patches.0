Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4238A33F59A;
	Sat, 12 Sep 2026 12:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215218; cv=none; b=uZ0I8fi0XI/yJOiAb31Nh1hgr8ahW1QwRm3ThTuzv7LsZJGOy2It2SUR0vn4N8ieZ1zbmP3DAA6rAqe456PpCX7bPFUry/eE7uOEc+sWBX8f+bugPnnEIsKs0WbdFWnJerPzISxVL/eD5hO8aO4wl6rQCNNcIyLxA7Mv/dd7lus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215218; c=relaxed/simple;
	bh=1sF3D4f1nba+V76fOgvsJHcODRFDbYdw3aAK1DG1iKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qYRHivd9pbD92E7SA30RU0gROBrzq+0NY9sw0Dp2FMr62nvJairZ36hpmbA3+O3EwrqrOwIBM7L5YDJdxrwJbvneByzOjbOyimcSTydg5AS5KNNwK+xBuY4XuI0iKDzmdTsW2GZOGkUk4zuv3J/FTOvRhHGSVuMpnp4e/imwJ4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iy7BcH3h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iy7BcH3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A76D1F000FF;
	Sat, 12 Sep 2026 12:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215216;
	bh=xly/8K+JXee5hocIZthOR2swurhRgeRHcciuAlOoNbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iy7BcH3hduR5JSvXHIBnRWr9vRCtt7L82TLEfdLLsiSlrkBneEOdvCVJUL+bkInTF
	 5aAG5eYfNLnyvboUUjYlfLMmwsLZwjQpacZsPzEqd++2wKAXz8VALMJfta1VloIMpt
	 CnbENbKKgVaAnz9yhVQUxCcQatZ2SiEnAn4IuMY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0486/1376] usb: ljca: bound bank_num in ljca_enumerate_gpio()
Date: Sat, 12 Sep 2026 08:48:32 +0200
Message-ID: <20260912065618.369268731@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index d9c21f7830557..e6e3888451fa2 100644
--- a/drivers/usb/misc/usb-ljca.c
+++ b/drivers/usb/misc/usb-ljca.c
@@ -585,6 +585,9 @@ static int ljca_enumerate_gpio(struct ljca_adapter *adap)
 	if (gpio_num > LJCA_MAX_GPIO_NUM)
 		return -EINVAL;
 
+	if (desc->bank_num > ARRAY_SIZE(valid_pin))
+		return -EINVAL;
+
 	/* construct platform data */
 	gpio_info = kzalloc(sizeof *gpio_info, GFP_KERNEL);
 	if (!gpio_info)
-- 
2.53.0



