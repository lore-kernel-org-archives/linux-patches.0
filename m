Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA171281349;
	Thu, 13 Feb 2025 14:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457782; cv=none; b=VuTX18gKgSsU3iJYz5S4fVTHPRfJ6jEKyRqTxpGjeYxmyOBUpkC1LKs76qVqInJIqP2Lb57vRae0ukeVQQHPTunBXJFHmRYCtOrrk2wMy+pdlURX5wgiy/C0lU0prlkHSca1GExAughqgdkbfPLX/7xeshBsO1MrrXWwhkyuk1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457782; c=relaxed/simple;
	bh=yN2i9JgXpEGY3uDlwSZmGgqhrLlikBx7nkybcxlQPQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rtwinz3yRb7+B4ACQ4z5tX9ncHhKnn5gF0sYQFRhoqfdI08nyCRO/suqHR0gEQP0H9ebFe8ylGgXDcdlG+FHRzaFboWQl64XrpR+BjlAF3nJUj+02xgfI5ecj7FVCHbiQk9KmV4029qsmrbGf53JvzfOWXXr3ub008GUVCCdIQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HwyxHAkN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HwyxHAkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00720C4CED1;
	Thu, 13 Feb 2025 14:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457782;
	bh=yN2i9JgXpEGY3uDlwSZmGgqhrLlikBx7nkybcxlQPQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HwyxHAkNy8+nzC6nbI71EGiz3V3pXsc90zTgsKaeUXsZk7XuvCp7bQy7wJ0dEvCZl
	 egxvOZw0tFlS6igb/UoQ2Wj548D2KCkXWoTjuK94FzHP0wLgHE+hjUxfzNnfHPxthE
	 5Cc3VZVVy4e/0keYZlePLooI8kuj/xvUnD3Hm6ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basharath Hussain Khaja <basharath@couthit.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.12 195/422] of: address: Fix empty resource handling in __of_address_resource_bounds()
Date: Thu, 13 Feb 2025 15:25:44 +0100
Message-ID: <20250213142444.069792737@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit 15e2f65f2ecfeb8e39315522e2b5cfdc5651fc10 upstream.

"resource->end" needs to always be equal to "resource->start + size - 1".
The previous version of the function did not perform the "- 1" in case
of an empty resource.

Also make sure to allow an empty resource at address 0.

Reported-by: Basharath Hussain Khaja <basharath@couthit.com>
Closes: https://lore.kernel.org/lkml/20250108140414.13530-1-basharath@couthit.com/
Fixes: 1a52a094c2f0 ("of: address: Unify resource bounds overflow checking")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://lore.kernel.org/r/20250120-of-address-overflow-v1-1-dd68dbf47bce@linutronix.de
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/address.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -200,17 +200,15 @@ static u64 of_bus_pci_map(__be32 *addr,
 
 static int __of_address_resource_bounds(struct resource *r, u64 start, u64 size)
 {
-	u64 end = start;
-
 	if (overflows_type(start, r->start))
 		return -EOVERFLOW;
-	if (size && check_add_overflow(end, size - 1, &end))
-		return -EOVERFLOW;
-	if (overflows_type(end, r->end))
-		return -EOVERFLOW;
 
 	r->start = start;
-	r->end = end;
+
+	if (!size)
+		r->end = wrapping_sub(typeof(r->end), r->start, 1);
+	else if (size && check_add_overflow(r->start, size - 1, &r->end))
+		return -EOVERFLOW;
 
 	return 0;
 }


