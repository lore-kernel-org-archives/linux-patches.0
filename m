Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE2E1E25E1;
	Thu, 17 Apr 2025 18:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913540; cv=none; b=decYPOMtQRZbf6/wmZPrnY5BLGgACgsqu78f0lvO1d5wk/uioMnQyvI3X3vDroTepErgrYJd2/feLiwmIKxhBbxZSA9A6JE7jSnJ74D0LadJyFQ+56GYTrQCRovRCGNXNeY28MHEQA5IJeHWSedj1jBvrFlKOMGFEY394oOdUjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913540; c=relaxed/simple;
	bh=8XvUgDVDu2WgW/yLRxjytCsabjKOlQggTwz0/Wwc3UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JoE7805+6o4bS6eZtvRqJpZ2oqmnzsZWklIhN4iiPLsJcjhyQ6H8na2wDaxfqr5HnMsMhgdqQ/5dWiX4mvXTQMcGlO+qf3zU6XcRugJ0DOGaw5uvOg9juNkA89RPkOTRoVwVzPGF6tKq6c3aRJqVDMFE/d+wjALwYZKpjAK2p54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4ijzCEK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4ijzCEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58673C4CEE4;
	Thu, 17 Apr 2025 18:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913539;
	bh=8XvUgDVDu2WgW/yLRxjytCsabjKOlQggTwz0/Wwc3UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4ijzCEK42X9SNjZ7oQ3aWWrrd8k82heeZ4VIMz45kqlR2LUjYT6Xo1TSRD+DsvoH
	 aq4QYNUEi4lPQn8HGrgMh27C84Z+GXDx1qtmUUolFc7dWvewpHqO6cvz/6XRZiKkbM
	 plZArvE5irl1tG2h4q00kDnEjeBGj7mjD46ykhpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trevor Woerner <twoerner@gmail.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 6.14 373/449] thermal/drivers/rockchip: Add missing rk3328 mapping entry
Date: Thu, 17 Apr 2025 19:51:01 +0200
Message-ID: <20250417175133.270457624@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -386,6 +386,7 @@ static const struct tsadc_table rk3328_c
 	{296, -40000},
 	{304, -35000},
 	{313, -30000},
+	{322, -25000},
 	{331, -20000},
 	{340, -15000},
 	{349, -10000},


