Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4DF4F85B0;
	Tue, 13 Oct 2026 11:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892640; cv=none; b=jM1aAgbjpcfN76kxr4i4v/JELGh1GFPSamqXHyKSwCZYgqJKq5IKnIxUkUT1B7FtMhxzxCSdyaP0DKU5ASJXJ59hrsxvDkiDeEg+yVMx3XC1g0dumx1RhiXp9HkXIXB0epSNe13pdw+R5FWrK4//vLb9rx1O06N0JqmS7xW8cu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892640; c=relaxed/simple;
	bh=ZPtvUJ7eulHfol2zsFMJjGHLmJonePUyyF6q5TDPk9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LtgU8ejAepxjm+EJ/RiJlYIY5U7f5ZoJPj3QZqQOtZHG7YHswCJtQSE07cw/bEaru8C4aXGc6cxd8F9+4JM9yn0fjpX21TJXiz3+7EpTMas+XBKTJBTiwbmaymk+yyR4XILjRJ8ClVOoTT3jepApvHHB6NCeiBkW9SHzL4uJXQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FQDHkOfv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FQDHkOfv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903381F00899;
	Tue, 13 Oct 2026 11:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892639;
	bh=DLTTG0TpqrpCkTdZaf2X+Uu3ggx47C2kGayf+Yhr3QU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FQDHkOfvXilbLvZLsHoB0cq6kwTeQBn+y6C9dqvvNo2D8Id6PMlI6UBBqatjpOTkd
	 X3/mQXOnScuFCGZFTevcdL6PcltIAcNLyJNaZ5aDNk8o+2sMQfuUH9wEyk9Iber4Tw
	 U7+DYw9Wd/ob3Q4YK2lFiTMM50KoX7WozKMWxfjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Mallesh Koujalagi <mallesh.koujalagi@intel.com>,
	Anoop Vijay <anoop.c.vijay@intel.com>,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 240/281] drm/xe/sysctrl: Fix mailbox header handling
Date: Tue, 13 Oct 2026 13:39:16 +0200
Message-ID: <20261013112900.974568467@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Mallesh Koujalagi <mallesh.koujalagi@intel.com>

[ Upstream commit f0a4447789ef28ba1aded2db19543d69c640b5e5 ]

The mailbox header was defined as __le32, which required
cpu_to_le32() and le32_to_cpu() conversions whenever it was
write or read.

These conversions are unnecessary because the header is always
handled as a 32-bit value, not as raw bytes. It is written with
xe_mmio_write32() and read with xe_mmio_read32(), which already
handle any required byte-order conversion through the underlying
writel()/readl() accessors.

As a result, the header value is already in CPU byte order when
used by the driver. Keeping the extra conversions had no effect
on little-endian systems and could cause an incorrect on
big-endian systems.

So use u32 for the mailbox header and remove the unnecessary
endianness conversions.

Fixes: 1f95f618182b ("drm/xe/xe_sysctrl: Add System Controller mailbox communication support")
Suggested-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Signed-off-by: Mallesh Koujalagi <mallesh.koujalagi@intel.com>
Tested-by: Anoop Vijay <anoop.c.vijay@intel.com>
Reviewed-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Signed-off-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Link: https://patch.msgid.link/20260924060900.146167-18-mallesh.koujalagi@intel.com
(cherry picked from commit 5137b391599579371c32f555958d3cf55e19bd88)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_sysctrl_mailbox.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_sysctrl_mailbox.c b/drivers/gpu/drm/xe/xe_sysctrl_mailbox.c
index 72baf1aa4b3ad..a0179e62abaaf 100644
--- a/drivers/gpu/drm/xe/xe_sysctrl_mailbox.c
+++ b/drivers/gpu/drm/xe/xe_sysctrl_mailbox.c
@@ -19,20 +19,20 @@
 #include "xe_sysctrl_mailbox_types.h"
 
 struct xe_sysctrl_mailbox_msg_hdr {
-	__le32 data;
-} __packed;
+	u32 data;
+};
 
 #define XE_SYSCTRL_HDR_GROUP_ID(hdr) \
-	FIELD_GET(SYSCTRL_HDR_GROUP_ID_MASK, le32_to_cpu((hdr)->data))
+	FIELD_GET(SYSCTRL_HDR_GROUP_ID_MASK, (hdr)->data)
 
 #define XE_SYSCTRL_HDR_COMMAND(hdr) \
-	FIELD_GET(SYSCTRL_HDR_COMMAND_MASK, le32_to_cpu((hdr)->data))
+	FIELD_GET(SYSCTRL_HDR_COMMAND_MASK, (hdr)->data)
 
 #define XE_SYSCTRL_HDR_IS_RESPONSE(hdr) \
-	FIELD_GET(SYSCTRL_HDR_IS_RESPONSE, le32_to_cpu((hdr)->data))
+	FIELD_GET(SYSCTRL_HDR_IS_RESPONSE, (hdr)->data)
 
 #define XE_SYSCTRL_HDR_RESULT(hdr) \
-	FIELD_GET(SYSCTRL_HDR_RESULT_MASK, le32_to_cpu((hdr)->data))
+	FIELD_GET(SYSCTRL_HDR_RESULT_MASK, (hdr)->data)
 
 static bool sysctrl_wait_bit_clear(struct xe_sysctrl *sc, u32 bit_mask,
 				   unsigned int timeout_ms)
@@ -126,8 +126,8 @@ static int sysctrl_prepare_command(struct xe_device *xe,
 		return -ENOMEM;
 
 	hdr = (struct xe_sysctrl_mailbox_msg_hdr *)buffer;
-	hdr->data = cpu_to_le32(FIELD_PREP(SYSCTRL_HDR_GROUP_ID_MASK, group_id) |
-				     FIELD_PREP(SYSCTRL_HDR_COMMAND_MASK, command));
+	hdr->data = FIELD_PREP(SYSCTRL_HDR_GROUP_ID_MASK, group_id) |
+		    FIELD_PREP(SYSCTRL_HDR_COMMAND_MASK, command);
 
 	if (data_in && data_in_len)
 		memcpy(buffer + sizeof(*hdr), data_in, data_in_len);
-- 
2.53.0



