Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3983D6664;
	Fri,  4 Sep 2026 05:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499104; cv=none; b=akx5InvIQc9wq58ithqAMMvmGfuoO7TpSLNGJMkdIsFylL5Mp2kRrVE+65bVmGt+CQuiWrN5ZM63oWVZYqhwSGT/nB0Z3dZbPmqmlo9o84No6dH9Dp17ZaxTquJXeW514zr94kdt/NRcavxHGc4K1iZ1Gu6+DkoTNbvAuG0froM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499104; c=relaxed/simple;
	bh=zdF0y8gFUAfac9HQfKh7fgv7Sh6iIrZR5r1Na+sxYe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FaM+VeoVlgrLD7Il+jQMpB6Fpcu7TFEcMk0Bvh/kFaqxYYkfZ6XRDK+FNbBdkWxCRRGDH6gCjeyIjEkf3gjwBqkLsml/LzKlhlJOxkA3x5HDItVU5mxBxPLcTv4+VP0oDnm9a7ewwv7Ah2nxP3SSe/R8KXOP1lbIGEBK/UjnnhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jyUZj4sA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jyUZj4sA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62461F00A3D;
	Fri,  4 Sep 2026 05:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499103;
	bh=WO3Z1rvfKo/Pycjv4EA5lkOe/GR/pDYeuk1kh6Ysoyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jyUZj4sAXo9I2AGBEg6E7y79imc8ec1/MttRhFZs+CBPmvNzJVx9LrKbTeutk20su
	 unqMDkQwBaaKo6+j1hacz/X8MR0QmKdnUvKyqALk7Nqz+ltRel7WvF8C1720aVrMby
	 3nRamKtM21QDGi0x/Lh9mJJ1aCqVbVdBEPPs1eZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TanZheng <tanzheng@kylinos.cn>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.2 298/713] ACPI: APEI: GHES: fix ARM section length accounting after header
Date: Fri,  4 Sep 2026 06:54:26 +0200
Message-ID: <20260904045810.522384693@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: TanZheng <tanzheng@kylinos.cn>

commit 903308ea40adf0577d82eab69882faf8836326ce upstream.

In ghes_handle_arm_hw_error(), after skipping the cper_sec_proc_arm
header with (err + 1), the remaining length was reduced by sizeof(err)
(pointer size) instead of sizeof(*err) (structure size).

That overestimates the bytes left for cper_arm_err_info records and can
let the parser read past the CPER section when err_info_num is large
enough relative to error_data_length.

Use sizeof(*err) so the length accounting matches the pointer advance
and the earlier sizeof(*err) size check.

Fixes: 87880af2d24e ("APEI/GHES: ARM processor Error: don't go past allocated memory")
Cc: stable@vger.kernel.org
Signed-off-by: TanZheng <tanzheng@kylinos.cn>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Link: https://patch.msgid.link/20260806010944.32384-1-kensanya@163.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/apei/ghes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -576,7 +576,7 @@ static bool ghes_handle_arm_hw_error(str
 		return false;
 
 	p = (char *)(err + 1);
-	length -= sizeof(err);
+	length -= sizeof(*err);
 
 	for (i = 0; i < err->err_info_num; i++) {
 		struct cper_arm_err_info *err_info;


