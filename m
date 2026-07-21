Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257FB44AB7F;
	Tue, 21 Jul 2026 21:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668810; cv=none; b=pFpnVJyQGXKZ1OmoHX5al5SZkG6YuCt1K5ww/hVaU4b3PZGU2sTgUAA9S0vh9UqEsPe3AdayxOMzALkKIYna5bcJrRBH6xwLWH24KcTYjApGeei8UsLOU/0yqB37MDBK5pNg2sDMgNHGG3GGA9VL++2JI9qAd2zZYEFhkhJ+QQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668810; c=relaxed/simple;
	bh=T7fDJagqoVXHhfNjk1nETPcgxuWSvUiXTtOajhPqgo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SvX1u30hyDEgXzcorfOp3IeeV17zvakvjJ82jhL8o4gzeyydzXU1b9p2f520053PaxsE/HK/qT9VeCs2oiNOVCWVGiERn5GiNl8YjkgAM/I2d+azGrJ+fSWfIMkPVNnY3Ig7QK/heFFe7b1QJGBmah6sW6MtKtPhsqfPPxL1n/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=moNowqH0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="moNowqH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860311F000E9;
	Tue, 21 Jul 2026 21:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668808;
	bh=ziCNCsPWZyTUyfS+KLBsOZPqrNtc/hj9wUzSqCcoIJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=moNowqH06d9L5ocGYT25jDAJ4ddtA2WDAyqMttRDF/ZaaDD+wvlTUlXtATACdopyc
	 0u5/YNsM/8maI+3xYXcbbUOSoI/LhhNoUztNgaRM2qBKonBoXQP880lEVf8OIv8KF7
	 YHKI6HXpmqdK2zxZJbWdyTNxdsRq3D4kqi2XeeMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0315/1067] media: atomisp: Fix memory leak in atomisp_fixed_pattern_table()
Date: Tue, 21 Jul 2026 17:15:16 +0200
Message-ID: <20260721152431.638893153@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 4e8156bd9517fa18c3613ea39c222c7035f0221e ]

atomisp_v4l2_framebuffer_to_css_frame() allocates memory for
temporary variable raw_black_frame, which must be released via
ia_css_frame_free() before the function returns. However, if
sh_css_set_black_frame() fails, the function returns immediately without
performing this cleanup, leading to a memory leak.

Fix this by assigning the return value of sh_css_set_black_frame() to
ret. This ensures that the error code is propagated while allowing the
execution to fall through to the ia_css_frame_free() cleanup call.

The bug was originally detected on v6.13-rc1 using an experimental
static analysis tool we are developing, and we have verified that the
issue persists in the latest mainline kernel. The tool is based on the
LLVM framework and is specifically designed to detect memory management
issues. It is currently under active development and not yet publicly
available.

We performed build testing on x86_64 with allyesconfig. Since triggering
this error path in atomisp requires specific Intel Atom ISP hardware and
firmware, we were unable to perform runtime testing and instead verified
the fix according to the code logic.

Fixes: 85b606e02ad7 ("media: atomisp: get rid of a bunch of other wrappers")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/atomisp_cmd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp_cmd.c
index c72d0e34467104..57d66f2c620769 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_cmd.c
@@ -4234,10 +4234,8 @@ int atomisp_fixed_pattern_table(struct atomisp_sub_device *asd,
 	if (ret)
 		return ret;
 
-	if (sh_css_set_black_frame(asd->stream_env[ATOMISP_INPUT_STREAM_GENERAL].stream,
-				   raw_black_frame) != 0)
-		return -ENOMEM;
-
+	ret = sh_css_set_black_frame(asd->stream_env[ATOMISP_INPUT_STREAM_GENERAL].stream,
+				     raw_black_frame);
 	ia_css_frame_free(raw_black_frame);
 	return ret;
 }
-- 
2.53.0



