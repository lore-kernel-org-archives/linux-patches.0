Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6188C36CE11;
	Tue, 16 Dec 2025 12:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888009; cv=none; b=I1Zetnb+Ck/vJrK3vU8GEfJCVVSJDTBQu0CI+13FkvZteSinDAlNECvjlXW4STKrO4MShSqaD0eHJmO9/AMpOeVexZFlx57E+Tfmu8Yp+2q12S54rqefuZl2xrYWRKf2Uz9HNU+0SU7WBNi8eb+U2gbTNKSslOnPQftY7/hboOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888009; c=relaxed/simple;
	bh=ne8G44BwdBCyrGSVXIfuWljBDLtcNqPdCiAV8LNrWIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dsTn4JjTRcZhLZX6UwocPmmu/5n68Z5+AX/otiIQnxclrCoLxojkyK/1UmAXeXSuLfdTp3ptosqekKrYWJ2MMycNpT+FN6huBFKPlZiqgWOh5h7dhze/7lyKiHU0jbCkJZHziSdEcWYlKI4lLH7xFawZRI0vqzR2aOgvPq5gpVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zxV2kLhn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zxV2kLhn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6A0C4CEF1;
	Tue, 16 Dec 2025 12:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888009;
	bh=ne8G44BwdBCyrGSVXIfuWljBDLtcNqPdCiAV8LNrWIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zxV2kLhnGTGWm+YskHMsEyCx3oDkkeCKHvntrrcNos5z1m43AnM8zS5+4HEg9IegG
	 Q4KgqxSl0InkpTeGDyziTsxNzSSYliGuvBiMZ0dVXrCRhNpTNLeTRUi/OAm3qIQnfp
	 ame5T/QAmvjjj0zfle+bp5dDZXJHuHc2Hg1EvwfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianglei Nie <niejianglei2021@163.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 404/614] staging: fbtft: core: fix potential memory leak in fbtft_probe_common()
Date: Tue, 16 Dec 2025 12:12:51 +0100
Message-ID: <20251216111416.013193615@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Jianglei Nie <niejianglei2021@163.com>

[ Upstream commit 47d3949a9b04cbcb0e10abae30c2b53e98706e11 ]

fbtft_probe_common() allocates a memory chunk for "info" with
fbtft_framebuffer_alloc(). When "display->buswidth == 0" is true, the
function returns without releasing the "info", which will lead to a
memory leak.

Fix it by calling fbtft_framebuffer_release() when "display->buswidth
== 0" is true.

Fixes: c296d5f9957c ("staging: fbtft: core support")
Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Abdun Nihaal <abdun.nihaal@gmail.com>
Link: https://patch.msgid.link/20251112192235.2088654-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/fbtft/fbtft-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/fbtft/fbtft-core.c b/drivers/staging/fbtft/fbtft-core.c
index 9e7b84071174c..8a5ccc8ae0a18 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -1171,8 +1171,8 @@ int fbtft_probe_common(struct fbtft_display *display,
 	par->pdev = pdev;
 
 	if (display->buswidth == 0) {
-		dev_err(dev, "buswidth is not set\n");
-		return -EINVAL;
+		ret = dev_err_probe(dev, -EINVAL, "buswidth is not set\n");
+		goto out_release;
 	}
 
 	/* write register functions */
-- 
2.51.0



