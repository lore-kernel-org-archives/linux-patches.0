Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3DD1D07AC;
	Wed,  2 Oct 2024 14:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879416; cv=none; b=QmWYoMA5HpeXvTguO4hzGzkKPK7V+bsCKR8gyTLgewaQ5HWYUjPMf2/ZgTITmpvC1QGwTU4mUjJHDH0CskqPMzCHd09NIojExKc9MnIfdKQV0+8MhA8uCl4DuqVH0mUqRr2zaKVykPJMgEg3OruJmQg/JU5X330mQYt0usvkdsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879416; c=relaxed/simple;
	bh=MPbYbn9j3W+u8z/9LrPk8h5Zt8wcapLb+VZe0EMNm9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQ7UtQSL2BG1o/WhZo6iJ3BmyD6Tbra8gBIY/J6d0buaSaKsx2c1CJFRKZRt78hYQ99fdtFbzTe+zCanczoU5FilMoIFNUFcxZVqBuFrQcBZXu3TUyXG58xuoTJTjqIoFM++F3RTY9eFTtpeJd6FEydwTePFJvH6HMjTYGsQoXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z26g1lL1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z26g1lL1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31176C4CECE;
	Wed,  2 Oct 2024 14:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879416;
	bh=MPbYbn9j3W+u8z/9LrPk8h5Zt8wcapLb+VZe0EMNm9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z26g1lL1CSLiJw2KHERsvryOb14dxW555pv/hURf3joTt2q2EmAMbVqiV1MydW0Dt
	 UICbMTxQM3WLnavjc8uBF0XfEkCPih/SkDzjpbknSifglzetJfpOr2mrExIncUT3v6
	 XoyNx2DZGr49GMv/XqgvxmnrZhPfDUyOBwATc8ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 094/538] regulator: Return actual error in of_regulator_bulk_get_all()
Date: Wed,  2 Oct 2024 14:55:33 +0200
Message-ID: <20241002125755.939436593@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 395a41a1d3e377462f3eea8a205ee72be8885ff6 ]

If regulator_get() in of_regulator_bulk_get_all() returns an error, that
error gets overridden and -EINVAL is always passed out. This masks probe
deferral requests and likely won't work properly in all cases.

Fix this by letting of_regulator_bulk_get_all() return the original
error code.

Fixes: 27b9ecc7a9ba ("regulator: Add of_regulator_bulk_get_all")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://patch.msgid.link/20240822072047.3097740-3-wenst@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/of_regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 1b65e5e4e40ff..59e71fd0db439 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -768,7 +768,7 @@ int of_regulator_bulk_get_all(struct device *dev, struct device_node *np,
 			name[i] = '\0';
 			tmp = regulator_get(dev, name);
 			if (IS_ERR(tmp)) {
-				ret = -EINVAL;
+				ret = PTR_ERR(tmp);
 				goto error;
 			}
 			(*consumers)[n].consumer = tmp;
-- 
2.43.0



