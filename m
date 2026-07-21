Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3810446C4A0;
	Tue, 21 Jul 2026 15:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648554; cv=none; b=XxzUstVyPWP9L10GYbj28Qt5NwD5iHWL4SZ8J64ZEVr8JsBYuU9jdExrSSuu8LxWhsXY3nQ5gP4gjGF54pJaTxqmHsy0edU4EmDoTh3IWOy/M+ul2VeS85inGNnE310iKNt9v3/9yIMkX3OMxQ0IHe6AHOrNZtfRT/1YyJSNMjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648554; c=relaxed/simple;
	bh=FRCpQCyhrRk/8tdPauPiJcwqeWcpLkka6PBbJfMe4lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5hfr9oVPOsOwtrsksjHNhNqt5hmFFdxrMmqoqpM2ExBqmzyLHjv0WR2iHDqLKkdz1qOfn9euTJozsvnZxNDCUj+7KssMsSAeVdIw1kEGysQzEB8+YGFCZRwUamnCBhDshVxXbS0sPuTzdYsCxvhPuiIxGPc95wCUYCisPIyQaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qF4+AoX/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qF4+AoX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B281F000E9;
	Tue, 21 Jul 2026 15:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648552;
	bh=Dt6pphQzwlAXnWM2VRFqbs1b2FAiYLdZ7kmeUXF8fak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qF4+AoX/zF0JOmuWkf97MQMWEhVY1CCJrpkOcDHdfiUhgbvK8qib1+G3b1sPMCdfO
	 krM3Qb86LuzSfqAOw/raTLdoySchkGzV/Xhmp5JKKA0wfKO5PbzQQE4LUqtCKSEzz6
	 dGF+kEg7guxC/Jj4fPGMZoDVE+z5pJC4QcWWiPK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0243/2077] media: atomisp: Fix memory leak in atomisp_fixed_pattern_table()
Date: Tue, 21 Jul 2026 16:58:36 +0200
Message-ID: <20260721152558.408410745@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index fec369575d883b..d58aa4d5945774 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_cmd.c
@@ -3364,10 +3364,8 @@ int atomisp_fixed_pattern_table(struct atomisp_sub_device *asd,
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



