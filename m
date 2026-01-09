Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2ACF31E107;
	Fri,  9 Jan 2026 12:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961924; cv=none; b=g+SgGe577hrJGuYoITaLD+kqXG7E0cIfm0dlmweMNmRGnBYXT8bKDmyfSJot/7yeMRqDMDNObgks08s5Ik6zZLGDqmUFih9CVsTDrW3yx4rXL5EXKncYzRLjaY5qIov1zOTCQ7OjYfk5UeNbpm2lFFKAC9xKJwjsvfVffqjxvBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961924; c=relaxed/simple;
	bh=9Ms++ED5PMM1Lj191fgAoM3Ik0mKegbehxLIa+rGy3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfjtalV03VU0FCYSEL7iDF3rc3g0MXcGdUIEn8YFbH3DupZYfP/t7Mvav+ZrBBv4dZp4XA+BITSQjMkYIKIowoOI84y1kwNqfEKgBPrhlkaqMaj0GZqVSEAI2HpQWweSc0HiAjDMmdy8U1VaiL96CA2axAsohuzoofIM6MZ7vJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zfb0jyYj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zfb0jyYj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458D2C4CEF1;
	Fri,  9 Jan 2026 12:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961924;
	bh=9Ms++ED5PMM1Lj191fgAoM3Ik0mKegbehxLIa+rGy3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zfb0jyYjdSXd4y1wHghQLdRISKd4oqHbwnYLPXdvcZOV9BneRUXcMU5JWvbpcKTFv
	 OVlORSIdUlZhvpWj/7ipnoAN2J6Nuwi2VHqHyaD+fVDApSE++UNMvN6FPqB3KrmZB7
	 d724O9WAvafb055bq0lOVYPeu2B9u8iMP14CFTtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 185/634] pinctrl: single: Fix incorrect type for error return variable
Date: Fri,  9 Jan 2026 12:37:43 +0100
Message-ID: <20260109112124.401593899@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 61d1bb53547d42c6bdaec9da4496beb3a1a05264 ]

pcs_pinconf_get() and pcs_pinconf_set() declare ret as unsigned int,
but assign it the return values of pcs_get_function() that may return
negative error codes. This causes negative error codes to be
converted to large positive values.

Change ret from unsigned int to int in both functions.

Fixes: 9dddb4df90d1 ("pinctrl: single: support generic pinconf")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-single.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index b81297084f097..0659cd3aa3a5a 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -490,7 +490,8 @@ static int pcs_pinconf_get(struct pinctrl_dev *pctldev,
 	struct pcs_device *pcs = pinctrl_dev_get_drvdata(pctldev);
 	struct pcs_function *func;
 	enum pin_config_param param;
-	unsigned offset = 0, data = 0, i, j, ret;
+	unsigned offset = 0, data = 0, i, j;
+	int ret;
 
 	ret = pcs_get_function(pctldev, pin, &func);
 	if (ret)
@@ -554,9 +555,9 @@ static int pcs_pinconf_set(struct pinctrl_dev *pctldev,
 {
 	struct pcs_device *pcs = pinctrl_dev_get_drvdata(pctldev);
 	struct pcs_function *func;
-	unsigned offset = 0, shift = 0, i, data, ret;
+	unsigned offset = 0, shift = 0, i, data;
 	u32 arg;
-	int j;
+	int j, ret;
 	enum pin_config_param param;
 
 	ret = pcs_get_function(pctldev, pin, &func);
-- 
2.51.0



