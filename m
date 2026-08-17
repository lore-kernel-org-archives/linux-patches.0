Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C14739733E;
	Mon, 17 Aug 2026 14:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975437; cv=none; b=IYHYtZ7zTfT5LQIBNA2LXcR+vzDOCQapgC6kngJzYHf+0Ln9Kirh2+95I2aMEQk/pzvxOA3SpgnPeJNlP3twuEwOIMCPxE+dgmVJ04GN5Xfmi1ZIf0KFeOiKZNiAY/Anc2qyL1N4wQC3BD3NdAiZo9dP+ATFFlxuDwbDP/ahbXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975437; c=relaxed/simple;
	bh=sD5iDU+hivCaydg8s8Jo/1ub9AWR93uoRAfQE8ipkBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwyA6qsl8faLUy6u+nylfkuDZ1f23TSBkJD1G5S6ePAj89d4DCsFUBBnsJ2+gtbWksx8CjFikKY4ryGKfv6tnyaACV9XR67cIwwcn5t6q8awyqFV3fLkVzPkWBGnDZUobCGc6VduwoFuN6VR+lO6QkcaGGbHiACi5XMUq387Xdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YzNWqjYm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YzNWqjYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA211F000E9;
	Mon, 17 Aug 2026 14:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975436;
	bh=h6PZmdfHfL5R3vUNLRIpQTAoHxy9MWJRDemgE895fso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YzNWqjYmdC7/bR/T+N6ReGe2RYwf4MuNkltsm8l7vXAqDsDxGHupkmaamAIm8+KuC
	 WVHLRnz47Q6L4Z8+ad5+Jdv5TE/IgGyLlRoBRaRuIbwWMm4RCsF6+GVv2EN76BzLn4
	 tusVnbfyyJBZDgp8BA4+pPXP/mfXobiqAoDymBdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanghoon Choi <csh0052@gmail.com>,
	Seungjin Bae <eeodqql09@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/389] Input: ims-pcu - fix heap-buffer-overflow in ims_pcu_process_data()
Date: Mon, 17 Aug 2026 15:27:27 +0200
Message-ID: <20260817132539.162171929@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seungjin Bae <eeodqql09@gmail.com>

[ Upstream commit 875115b82c295277b81b6dfee7debc725f44e854 ]

The `ims_pcu_process_data()` processes incoming URB data byte by byte.
However, it fails to check if the `read_pos` index exceeds
IMS_PCU_BUF_SIZE.

If a malicious USB device sends a packet larger than IMS_PCU_BUF_SIZE,
`read_pos` will increment indefinitely. Moreover, since `read_pos` is
located immediately after `read_buf`, the attacker can overwrite
`read_pos` itself to arbitrarily control the index.

This manipulated `read_pos` is subsequently used in
`ims_pcu_handle_response()` to copy data into `cmd_buf`, leading to a
heap buffer overflow.

Specifically, an attacker can overwrite the `cmd_done.wait.head` located
at offset 136 relative to `cmd_buf` in the `ims_pcu_handle_response()`.
Consequently, when the driver calls `complete(&pcu->cmd_done)`, it
triggers a control flow hijack by using the manipulated pointer.

Fix this by adding a bounds check for `read_pos` before writing to
`read_buf`. If the packet is too long, discard it, log a warning,
and reset the parser state.

Fixes: 628329d524743 ("Input: add IMS Passenger Control Unit driver")
Co-developed-by: Sanghoon Choi <csh0052@gmail.com>
Signed-off-by: Sanghoon Choi <csh0052@gmail.com>
Signed-off-by: Seungjin Bae <eeodqql09@gmail.com>
Link: https://patch.msgid.link/20251221211442.841549-2-eeodqql09@gmail.com
[dtor: factor out resetting packet state, reset checksum as well]
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/ims-pcu.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/input/misc/ims-pcu.c b/drivers/input/misc/ims-pcu.c
index 55d4fffda41bf2..71d96e7d842dab 100644
--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -448,6 +448,14 @@ static void ims_pcu_handle_response(struct ims_pcu *pcu)
 	}
 }
 
+static void ims_pcu_reset_packet(struct ims_pcu *pcu)
+{
+	pcu->have_stx = true;
+	pcu->have_dle = false;
+	pcu->read_pos = 0;
+	pcu->check_sum = 0;
+}
+
 static void ims_pcu_process_data(struct ims_pcu *pcu, struct urb *urb)
 {
 	int i;
@@ -460,6 +468,14 @@ static void ims_pcu_process_data(struct ims_pcu *pcu, struct urb *urb)
 			continue;
 
 		if (pcu->have_dle) {
+			if (pcu->read_pos >= IMS_PCU_BUF_SIZE) {
+				dev_warn(pcu->dev,
+					 "Packet too long (%d bytes), discarding\n",
+					 pcu->read_pos);
+				ims_pcu_reset_packet(pcu);
+				continue;
+			}
+
 			pcu->have_dle = false;
 			pcu->read_buf[pcu->read_pos++] = data;
 			pcu->check_sum += data;
@@ -472,10 +488,8 @@ static void ims_pcu_process_data(struct ims_pcu *pcu, struct urb *urb)
 				dev_warn(pcu->dev,
 					 "Unexpected STX at byte %d, discarding old data\n",
 					 pcu->read_pos);
+			ims_pcu_reset_packet(pcu);
 			pcu->have_stx = true;
-			pcu->have_dle = false;
-			pcu->read_pos = 0;
-			pcu->check_sum = 0;
 			break;
 
 		case IMS_PCU_PROTOCOL_DLE:
@@ -495,12 +509,18 @@ static void ims_pcu_process_data(struct ims_pcu *pcu, struct urb *urb)
 				ims_pcu_handle_response(pcu);
 			}
 
-			pcu->have_stx = false;
-			pcu->have_dle = false;
-			pcu->read_pos = 0;
+			ims_pcu_reset_packet(pcu);
 			break;
 
 		default:
+			if (pcu->read_pos >= IMS_PCU_BUF_SIZE) {
+				dev_warn(pcu->dev,
+					 "Packet too long (%d bytes), discarding\n",
+					 pcu->read_pos);
+				ims_pcu_reset_packet(pcu);
+				continue;
+			}
+
 			pcu->read_buf[pcu->read_pos++] = data;
 			pcu->check_sum += data;
 			break;
-- 
2.53.0



