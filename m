Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1215172CF;
	Wed, 30 Sep 2026 16:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787190; cv=none; b=CcXkmO302NSzB2W3y5eSHN9D1LJCgeE2G4kHPmiNf4csUCstska/6IXrniKDfcSnkAjJ5FupLvHG7XO0cByoHFk52Vlw0TCWj5YrKVpnsE7aHa7/7vyYljT60+l9Ii+dG9JObZAhecQ1oeHN8rfbwA9WyteEKKXbQsNBJ/JCc+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787190; c=relaxed/simple;
	bh=dcVEK8sa5CUOOZwQpKsLjyVU/HN/yiMReHbtWiXDo4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLW/czl+GT1CZZXy3E9F/ZbYcl6gJVNN27kNgXnbuIXJezmpmRxbDT4D/XBgYWSxSkv9OBQwGvg8fY7rgecmVXL3KOI5j8+naMXHErhzXn25gbfW8V3AIpnjRoxo8JWjdO+j8vVB6bdo9u4WCGSCFM5vyXRYS4HzyAWQZufEgiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nncmWJO9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nncmWJO9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522B21F000FF;
	Wed, 30 Sep 2026 16:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787188;
	bh=gNvfw0MqK6nT5rL6zxyaxiBa/ZyS6QvKZm4a7X4b1wA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nncmWJO9F119tqTyagFK2AVRvHcHl4osfOMAxLGYlFoM1u9r70xeqNYDVlV9hlINk
	 0jLHVOd9hxFjIHLOzrCS0bo9X8Fd/sFIpHFDTejq61MfgVCDDM0rZHjMGyUMn+eb2V
	 OfHS3v1VCzwS4twQsh+V/2dfaTaZ7CENHtyntwy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 142/457] s390/debug: Fix NULL pointer dereference in debug_info_copy()
Date: Wed, 30 Sep 2026 17:24:07 +0200
Message-ID: <20260930152349.118058888@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Mikhail Zaslonko <zaslonko@linux.ibm.com>

[ Upstream commit 012bfcd5a51082d5a65f096dfb9ca652b5267965 ]

When debug_register_static() fails, it clears areas, active_pages and
active_entries but leaves the area bounds unchanged. Copying such an
area, either by opening its view file or via debug_dump(), makes
debug_info_copy() dereference the NULL pointers.

Skip the copy loop when the source has no areas.

Closes: https://lore.kernel.org/r/20260903132123.12F271F00A3F@smtp.kernel.org
Fixes: d72541f94512 ("s390/debug: add early tracing support")
Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index d193c6fd1ecc7..71c966f4c5d03 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -432,7 +432,8 @@ static debug_info_t *debug_info_copy(debug_info_t *in, int mode)
 		debug_info_free(rc);
 	} while (1);
 
-	if (mode == NO_AREAS)
+	/* debug_register_static() failure leaves areas NULL, bounds intact */
+	if (mode == NO_AREAS || !in->areas)
 		goto out;
 
 	for (i = 0; i < in->nr_areas; i++) {
-- 
2.53.0



