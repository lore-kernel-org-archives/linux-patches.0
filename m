Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56E6400DE8;
	Fri,  4 Sep 2026 06:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502280; cv=none; b=A9MCizbd6oYnW9tnb2Gzmiie2V62hLP624/iVzr+/ux+GwgnvSLV43Q81X2KrSBnm/Hut0emDVOFWqf4aPmBuGJwNj40bapDyyORENv9Gos9WAC2eHfY9eculqDeLqsbif6B0vu7faVlkdpFm3H7Fgjgv7RHSspvDtba6TpxkhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502280; c=relaxed/simple;
	bh=PdlFsze9yntsEfDIAF9UTpVIWg3p48JmQ6vFNN+laGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CthGwxDBVzSGqc7RFVKbOhq+ovRM3dSJgKUQAdan4mvjK3/fImcN8g42R60jbSr3r8CtJwTKF6dwn9wXDa9XSmoyMJtf76IhtanjD2RYAewVeRrh+sl8tbTefAg9uRvWUCUZD4S8hzjSf6V2+LrzAtAALqvlhI9pPFOr1PTKVYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gyHboP7X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gyHboP7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7361F00A3D;
	Fri,  4 Sep 2026 06:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502279;
	bh=y1l4SL0txYQo7ZmfhwEhVuirbdEh6FlhNnmGjeZYr44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gyHboP7XMSiEtSbsp07kqTUaqHSlKfz2MV7jxjcvMZmmdZpqfcXI3LUpELZ+JRv8a
	 152MfiSKjIZhn/dx++x0rdDdS6L1hcv1jAN/EBqdaStZn29BEmPdIErzhrSqAV6jO8
	 RKDmTSlA7yU2i6YQMQrbs0VpR4ImUyA6UAp2RkAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TanZheng <tanzheng@kylinos.cn>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.12 152/403] ACPI: APEI: GHES: fix ARM section length accounting after header
Date: Fri,  4 Sep 2026 06:59:15 +0200
Message-ID: <20260904045738.305930174@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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
@@ -556,7 +556,7 @@ static bool ghes_handle_arm_hw_error(str
 		return false;
 
 	p = (char *)(err + 1);
-	length -= sizeof(err);
+	length -= sizeof(*err);
 
 	for (i = 0; i < err->err_info_num; i++) {
 		struct cper_arm_err_info *err_info;


