Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD63132103;
	Tue, 29 Apr 2025 17:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948755; cv=none; b=haNvgsollhx95maVm9i0qYNMIcF43/CiUwAew2MqKJC48aCeHGg5q2gb8u3UX6mwn+M9HG7tRLZbqCbGCUUQGLrcbFqztytQ0XiC47tvyL5znLuOCY6ZYFld22DJhQ93qMBjK2ttk4PKbNct1Tu6HLrYbILiG5XfIqM+6xl0/Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948755; c=relaxed/simple;
	bh=dQ3fc9TNheTvg+wHkWc6EcnMrt30HjlmYI/Owcolhyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hEOlOTPwV5ihKQGz6sHJM0XkEr2qFhzF62MFsjJ51+leUQrb8MymItPBbabKDnMA+ISPAo/QLeqAby9NmsH79ubazpCtlb3qsedJZ2XkIbT5+Qtnv+RQj8UFgh4nm0pg0TbwTk5urErX68EcgjhJKnjjTlTEhBPDGxn3oBZzsHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a0IrDW2l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a0IrDW2l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55236C4CEE3;
	Tue, 29 Apr 2025 17:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948755;
	bh=dQ3fc9TNheTvg+wHkWc6EcnMrt30HjlmYI/Owcolhyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a0IrDW2l9x45mWoF3WYg1nzizd4iyjDVP9YqJsjoGWsvNedvOxxFn98eX65qPDICC
	 P9XNZ/bPrSXuQBI0drUg09qv14aTDYZsCzb8nMMPCHVSqvgEJRkZxi+JUigGLcNEG3
	 EHEpC5rQCOj4MYCOPhWMWpdtxnjtD3cCKogLGGeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trevor Woerner <twoerner@gmail.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.15 103/373] thermal/drivers/rockchip: Add missing rk3328 mapping entry
Date: Tue, 29 Apr 2025 18:39:40 +0200
Message-ID: <20250429161127.392958948@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trevor Woerner <twoerner@gmail.com>

commit ee022e5cae052e0c67ca7c5fec0f2e7bc897c70e upstream.

The mapping table for the rk3328 is missing the entry for -25C which is
found in the TRM section 9.5.2 "Temperature-to-code mapping".

NOTE: the kernel uses the tsadc_q_sel=1'b1 mode which is defined as:
      4096-<code in table>. Whereas the table in the TRM gives the code
      "3774" for -25C, the kernel uses 4096-3774=322.

[Dragan Simic] : "After going through the RK3308 and RK3328 TRMs, as
  well as through the downstream kernel code, it seems we may have
  some troubles at our hands.  Let me explain, please.

  To sum it up, part 1 of the RK3308 TRM v1.1 says on page 538 that
  the equation for the output when tsadc_q_sel equals 1 is (4096 -
  tsadc_q), while part 1 of the RK3328 TRM v1.2 says that the output
  equation is (1024 - tsadc_q) in that case.

  The downstream kernel code, however, treats the RK3308 and RK3328
  tables and their values as being the same.  It even mentions 1024 as
  the "offset" value in a comment block for the rk_tsadcv3_control()
  function, just like the upstream code does, which is obviously wrong
  "offset" value when correlated with the table on page 544 of part 1
  of the RK3308 TRM v1.1.

  With all this in mind, it's obvious that more work is needed to make
  it clear where's the actual mistake (it could be that the TRM is
  wrong), which I'll volunteer for as part of the SoC binning project.
  In the meantime, this patch looks fine as-is to me, by offering
  what's a clear improvement to the current state of the upstream
  code"

Link: https://opensource.rock-chips.com/images/9/97/Rockchip_RK3328TRM_V1.1-Part1-20170321.pdf
Cc: stable@vger.kernel.org
Fixes: eda519d5f73e ("thermal: rockchip: Support the RK3328 SOC in thermal driver")
Signed-off-by: Trevor Woerner <twoerner@gmail.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Link: https://lore.kernel.org/r/20250207175048.35959-1-twoerner@gmail.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/rockchip_thermal.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/thermal/rockchip_thermal.c
+++ b/drivers/thermal/rockchip_thermal.c
@@ -373,6 +373,7 @@ static const struct tsadc_table rk3328_c
 	{296, -40000},
 	{304, -35000},
 	{313, -30000},
+	{322, -25000},
 	{331, -20000},
 	{340, -15000},
 	{349, -10000},


