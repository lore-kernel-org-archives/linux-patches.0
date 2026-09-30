Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337D65111B7;
	Wed, 30 Sep 2026 16:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784303; cv=none; b=chDozUcgwRDadPa3N/R/xbfwSQbIFpAwI7jn5pS2Urdv8xb9El0Dtop7q712JqLv2UZYnVBxJvKty4H1LVNDQMCq22cQ4oL/G69jLBM0vuMp84l1LTRjGIQGMfu0TF7hXW48CoU+lLRVrfFkZB1EPBuU9iOROHXW1UcWREabap4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784303; c=relaxed/simple;
	bh=FFvTWn4S1mht27XRR2RQ+ssng2P+a35NRMtlDMDfDJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QYy+rtu69MrN/pWWrY2ASjIdQ9oHu4i7vlkNzrCf5bjW8Z8QG3c0fwqeDPPBaQu2KXeE3IpVIyXfbsxF94+ztaAzyC5xwCa9ntLBLlVvNCWUosUuoQBu1gXKCG5ttTJLj1m7nhxhqIaTBt1ZOvFj4okvOuEI8tdl2Iiu979HU2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PsSU30dl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PsSU30dl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D9D1F0089B;
	Wed, 30 Sep 2026 16:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784298;
	bh=Hv5MmJT6Qwyl6o7rhItVLD9Jre7HVJ8QKf9NGNdVHO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PsSU30dl4TybdcVB9PXh+GJz0YTbi1xIrKpdqNb7FO1xl54glAqfTcnoZmESuEtv1
	 WwUk6xZQeuh1Jm1KGg1oa6p7z60PDe0glr9Oisy7yMk7mHcNw65Niz2kOrRnyFod57
	 e4TlKq2hDFIHJp7uC52TWo97vXzIuaCmcLal5UWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 105/982] ACPICA: Fix integer overflow in acpi_ex_opcode_3A_1T_1R() (mid_op)
Date: Wed, 30 Sep 2026 17:14:01 +0200
Message-ID: <20260930152419.066729124@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 198da79c0cd48..ecb5bc536feeb 100644
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



