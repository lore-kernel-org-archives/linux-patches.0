Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6F438C42F;
	Wed, 30 Sep 2026 18:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794186; cv=none; b=KDbVldfuDY9uMb5tO8IbGoNDqqY7nnoHYrcKSU4884Z43cdifkod1UM/Kt7YcSOtDSKlvjbglDXKqINoeQ+eewVTIBEbTgPN0IsG45Itz3NzXqzNVv08LOgpLhZkqw/JZ7ozjH/cKtM5A/95xmVs3qjq8HBGOuNrpSuZpp+qIyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794186; c=relaxed/simple;
	bh=tdQ+qRQMKQ1YTtYQeMJt5DcmIYyhETOREFG0hMNp+VE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtqpUzOiSfbQvEbnCoTpnm3HUbiv4zGZ/xkGh18fUWfLsDr/rW62K4CR8vtJD3IDchY0ir2q7G+CS3IF9dxBm05MbvVKlpH6k4attbyQnHZv2aMHRETge8OWpmlZJjMuQpDGZjpESuRGpu8fGhNRTIll1jYw7ZVei5D6Jvup8cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MyWizou+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MyWizou+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071CA1F000FF;
	Wed, 30 Sep 2026 18:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794185;
	bh=GqTcNHxsAApPeV5rfpk6q2i7iZN3iqBQK0NP4dWHORQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MyWizou+j9tRHmrrcLCj+iHsJhtt7pF7RIGFSCDr0oMgoctibnu2mqOWQ0vlvja/K
	 Xt82I4l22TtC0Iz0SGOQxgtmgpCALVxL4ju/HpuB70oYgY8rZ4KGefUsTui4uRs1UZ
	 BhaFH4hij91BtmqgnZRSsNC2+VvYesTtmB+HhZyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0122/1193] ACPICA: Fix integer overflow in acpi_ex_opcode_3A_1T_1R() (mid_op)
Date: Wed, 30 Sep 2026 17:13:26 +0200
Message-ID: <20260930152436.932639947@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



