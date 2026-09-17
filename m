Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279804EF13D;
	Thu, 17 Sep 2026 17:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667665; cv=none; b=MqXQdId3gqo9kZJW/Uq5bmjd/+lQ4hnUn5O+GYz5dtF/MGGSm78U4pvNFERkZqKfsRehhmcwxP/1QSkHfCOEvimIORrJe2CMHPMO8vB4TMPaX7c4VlsWawtK85Ys1E4rx0KOTmvsDSo9k+W3s4sLSBqn4mMMwm45LbphaXMKH40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667665; c=relaxed/simple;
	bh=mxGlRyXyLM6ZITlplCBexCCKekEo/alse887Txm7GME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dc1AdQG5gWnBMYHzQgvjy2kPnvuCWu/oXum/kV8ukE8eewp2vyqZq92p7yMm+3BJiZXaB+5LkAXpCQQmXKe8V3Hz0p2RZWRSx/Duy4/TOnqDNSAN6J/LwbxHJpE9m3HPaLyHb3J3f9NUV4XqNlcoqnouPkEqf7jLMz7Xj0sBC+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHiOvcps; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHiOvcps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E701F000FF;
	Thu, 17 Sep 2026 17:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667664;
	bh=btGrGrBmA6ctoU2yPRLQo08PBzapa8W0oJlXmEGB/rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aHiOvcpsN0xGqGlhIzY6y/puYTMXeseknqIeIVs1twpfceCzfyOL1joMcp+8hwO1b
	 dkaSwOE0YyKcAbK+dD8vIAaLjxAYFC5Dj1PsN9NKSbIWiT/TQ1O4ceMiVR4DHxK3rE
	 yK2qtvzA9Oo+CZa3rBvs4klpwV3hlICp5mw4nAYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0166/1102] ACPICA: Fix integer overflow in acpi_ex_opcode_3A_1T_1R() (mid_op)
Date: Thu, 17 Sep 2026 16:01:49 +0100
Message-ID: <20260917151543.706924173@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: ikaros <void0red@gmail.com>

[ Upstream commit 0e2021f49e64b3c8a9aa880d0c62a218bfe147ce ]

Add overflow check for Index + Length to prevent integer overflow
when calculating the truncation length. This prevents negative
size parameter being passed to memcpy().

Link: https://github.com/acpica/acpica/commit/d281ec1ac84e
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/3760974.R56niFO833@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/exoparg3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/exoparg3.c b/drivers/acpi/acpica/exoparg3.c
index 41758343657dd..4d2a04226392b 100644
--- a/drivers/acpi/acpica/exoparg3.c
+++ b/drivers/acpi/acpica/exoparg3.c
@@ -152,7 +152,7 @@ acpi_status acpi_ex_opcode_3A_1T_1R(struct acpi_walk_state *walk_state)
 
 		/* Truncate request if larger than the actual String/Buffer */
 
-		else if ((index + length) > operand[0]->string.length) {
+		else if ((index + length) > operand[0]->string.length || (index + length) < index) {	/* Check for overflow */
 			length =
 			    (acpi_size)operand[0]->string.length -
 			    (acpi_size)index;
-- 
2.53.0



