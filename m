Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911BD1D0964;
	Wed,  2 Oct 2024 13:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875550; cv=none; b=hPcODFtTow/ww2xrXgpIMO1eNf5FxVlHYpX4yEeRxdc8wuO9CvPh1KwKXmuQK3Rao2nGB1v+JHl/9YrIhneBFjNKPm793h4XcjrCOscqImR9kw1cxn//n80yzAf2ctg9CppoRI1x5am4kYEaTuDZiw3UCUV4bWnkY3OHv1A0asc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875550; c=relaxed/simple;
	bh=PmypqS5L7Zhv3wafuTYJ1mK5F0JZncGqxzC5z/sNqfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WxdmrbCsNAuh0uPVtNXkRZrUusLX8XakZkDRZFSh/YTz/kSTmWDerxKeD+omYtyKEK33Ge3ba8H+6h2zjMm7y3Bg5sRpu/6XvcLsm/V9NzYZTnK9q1JSro8f5mewjtU5REWntON6cNXamZKpHSk/d5l1XHmP4G39OXjtdmKVoAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0MJPh3ks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0MJPh3ks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA05C4CECD;
	Wed,  2 Oct 2024 13:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875550;
	bh=PmypqS5L7Zhv3wafuTYJ1mK5F0JZncGqxzC5z/sNqfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0MJPh3ksKJoZsaC7oQ//iQUwUYi6t44VdfrCMcul9UsG/atFFawQu6Z6DqZY6ZiGU
	 jeSEHurWZ8LUJ0234z84Uqi927QW84Hsdha10zAXcA3Gn6R7R+QiiUNA2Xfp/bQtDq
	 e8MynmT/L31HCZhp9rmr/rwyqbjFDuFo34PpVlLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 139/695] regulator: Return actual error in of_regulator_bulk_get_all()
Date: Wed,  2 Oct 2024 14:52:17 +0200
Message-ID: <20241002125828.034538652@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 03afc160fc72c..86b680adbf01c 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -777,7 +777,7 @@ int of_regulator_bulk_get_all(struct device *dev, struct device_node *np,
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



