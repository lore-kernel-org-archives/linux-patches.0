Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8C93F12CE;
	Tue, 21 Jul 2026 17:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655862; cv=none; b=GDhjbsRhPw6qgJIkKYjSjt8mpZ5z1VzxcKLFSvJ/hyCChu+C0VM6dCX5DUALUTXmDtFy+j/0yg/DBvSNqoM4arUSPo35SvLdmnV16Mc190HPXiavI1z9cfsFGFd9q5bquLa1pAGdkXW7nGHSUUedFisc0f83fmhKzvfBTERNFi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655862; c=relaxed/simple;
	bh=t2LcJ2uRL+qmfmuR6nmaXtX/JccNzuD3F59Pzqnx92c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ke/0VTqvkaDGaPkISXFmxwDIsE4zOOxg1wX2qxjWYIk7gvba9ilicMD/j1tbqi7uLZrHhp18knENEoycG23nbY+Qd10iRauEm8xVgVQEexoWBuXFmqCQWOFsWHPHRDN75Rm9+1/f08dqndngMUyC7G0skEn7y7HyA2UtibLnw2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YHuzSLh1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YHuzSLh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5F81F000E9;
	Tue, 21 Jul 2026 17:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655860;
	bh=nQAjNrlosVt6Tjh67TcjMKaVzYIq7JKSnDp5Lya7+54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YHuzSLh1rjDOOKUvdbt0EhfgamOJ+MfdDQaI3l6HtMxrJWX8dkEXXqekSinuSXd65
	 enXd2aEKsfAZHlTLokslRupsV9Ev+4jx9qiDAc0fH0FkXPeXVqbj0LQSyS5l4zLMQk
	 Z8JlInpJSojxZm84PaqTgPH18g0qHS6S/LLQQjC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0169/1611] media: atomisp: Fix memory leak in atomisp_fixed_pattern_table()
Date: Tue, 21 Jul 2026 17:04:45 +0200
Message-ID: <20260721152518.695429717@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 3a4eb4f6d3be5d..ae9c4dc8a44b42 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_cmd.c
@@ -3367,10 +3367,8 @@ int atomisp_fixed_pattern_table(struct atomisp_sub_device *asd,
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



