Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B4436CE00;
	Wed,  3 Dec 2025 16:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779552; cv=none; b=nAsxfAcFfbF0UqPj1MzXsulticoTThb9mu5tOzFVDHYJPfrLO0m41SA6JvjCvfMZzyut/FIAJdY6YCfapqygfQqfF2X6fZ0f0RXkg1JivkokLMkOrTsHYSfFXiU5SUQjKQ6kFcGEEvvbeiixZgjrVlzxeUC/RaJ+kV5FS2WCrOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779552; c=relaxed/simple;
	bh=OJ/3Ji125RETJksezsz+faTYedLisI6NvZoau8bG1Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Txpt8IB7zox2q/fp2mW7sq9R6qA28TjJ+c0EzXInNYa1txa08l8oNnCWRSJuSXoBH3PW2QPuVSu9/6Asm1odW7D7czHkQgQqyzdNaoLPdTMbUz1iqnfwyS5JtNyPs18ZKBaqwkk9J0FP2JIgIJ0XRbWyGC6vUsCMiRAqJVseuQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SLxG3Gch; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SLxG3Gch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24EEC4CEF5;
	Wed,  3 Dec 2025 16:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779552;
	bh=OJ/3Ji125RETJksezsz+faTYedLisI6NvZoau8bG1Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLxG3GchodbxjD2HgQW4gYRVNvEwNn4r6d/6pjPFGN0s7k4p6V/lkNy9NCl5W/s0m
	 BGOQz9AQB71v3gBWok+vb7djt3DEpkNi73viV+8sxRsnT2Pdm8lmKfI9k9r3JjUqzm
	 M/fyR35ePyNWE3qurp72kP1da5q0pPQRArplWATU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Randall P. Embry" <rpembry@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 292/568] 9p: sysfs_init: dont hardcode error to ENOMEM
Date: Wed,  3 Dec 2025 16:24:54 +0100
Message-ID: <20251203152451.397967432@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Randall P. Embry <rpembry@gmail.com>

[ Upstream commit 528f218b31aac4bbfc58914d43766a22ab545d48 ]

v9fs_sysfs_init() always returned -ENOMEM on failure;
return the actual sysfs_create_group() error instead.

Signed-off-by: Randall P. Embry <rpembry@gmail.com>
Message-ID: <20250926-v9fs_misc-v1-3-a8b3907fc04d@codewreck.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/v9fs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index fc3dadbd2e11c..2a6988db807b3 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -597,13 +597,16 @@ static const struct attribute_group v9fs_attr_group = {
 
 static int __init v9fs_sysfs_init(void)
 {
+	int ret;
+
 	v9fs_kobj = kobject_create_and_add("9p", fs_kobj);
 	if (!v9fs_kobj)
 		return -ENOMEM;
 
-	if (sysfs_create_group(v9fs_kobj, &v9fs_attr_group)) {
+	ret = sysfs_create_group(v9fs_kobj, &v9fs_attr_group);
+	if (ret) {
 		kobject_put(v9fs_kobj);
-		return -ENOMEM;
+		return ret;
 	}
 
 	return 0;
-- 
2.51.0



