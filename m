Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B084E430B;
	Thu, 17 Sep 2026 16:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664047; cv=none; b=jfrkVf+vcpXY/huNMobDw6uwRmLgtzivT27J4ZZioJ3WrMVmT7xrNkUErSe86JV30jaTniF3jNlI6wMZN5VUiZUemTxqKzQ1YLG13FBef70NX+p5LiIugBScoFBzNUZoWuuwRj0NM4gZkAihinitYXwmVpmH7wrC6Pm3ZbFhg3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664047; c=relaxed/simple;
	bh=MgEU60+e3rp96/1HNbEHqlI/q62bgkWsmW7J4Cn/aBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRI7XmDXIafgWUyZy0ckiE5/AQTH4bwVnn0btqF7n2E01rEEPilStLSgj/+C1MVPbM/i0n/xKJfwNhFLIu4pweFISY0tyli9hqJCjgTa6cE+rNFrS5ebTTOKte3/f8taB8lN3XO2sXJpJaSVLSd3iUD2h8nRhJKX98u/SKgULaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fX8u/yjw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fX8u/yjw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4271F000FF;
	Thu, 17 Sep 2026 16:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664046;
	bh=fEt3Je/cRvng1uAeU9KAqcAvaNwKADI26WGYLaroJic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fX8u/yjwz3OQ3mI4KmkKpp31Y+7eKPXrjXGuX1SR71TbfSsIaC4cF+TOYheJ6Ckb9
	 BCa6HF6CIQ7jIFPs4bliXBE/8q6HOoRPyYqYXL19rw4NHu16P4siLw8qmTYORKxeKo
	 xuGwx/ereDqnD6FkexALIp8ri7ev+Q/qcSSYBmU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0240/1250] ACPICA: Fix integer overflow in acpi_ex_opcode_3A_1T_1R() (mid_op)
Date: Thu, 17 Sep 2026 16:00:35 +0100
Message-ID: <20260917151558.647581671@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c8c8c4e49563e..df770f36b4d08 100644
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



