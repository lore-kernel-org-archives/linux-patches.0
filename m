Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3886D34A3D3;
	Tue, 11 Nov 2025 01:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825334; cv=none; b=Tha1q92my8s6EFh2NVuS9YL8lDcatHZrqsPU1t04WqoN4fyWZxm9uHPX8oGIj2fKudhZIZqe2YnuUQ0KNzSrtyw/PhPr5AZIUgbUPttNPAsbW4/p0VG6BptF612dZ87hLcbsK2gnZadSXm9hyB5CH3ZiIzJHOHsVV5DyQvAa8nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825334; c=relaxed/simple;
	bh=C9rcMefQ4SWHLT0+zH207qN9ptFbNwpFrVwLltKEJhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQ9BzaCp3ltEDr7pgAEJHjX4Gu931R9xGZ16ZzjLJa2rt+aUIG2OyAqhG0W68IlGZn6tI3kQpqFKBakvXVByoFUJjJy+XrgDg83S83MyqXZH66K591G8G/6yMFIjNoHLnIEhyF0TAsR98KPf2SvVwc41RkNt+Rd4db7X30nqY64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PVvZUKP7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PVvZUKP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C05C2BCB1;
	Tue, 11 Nov 2025 01:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825333;
	bh=C9rcMefQ4SWHLT0+zH207qN9ptFbNwpFrVwLltKEJhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PVvZUKP7UUAqUSqZFBoW80WDhvjlQyIhLlkPXtfJr8T431SSV7jsroU+B9qAiscGu
	 dx2UGlJM/t5kmR/tVSce5KG9Y9qN8MKxl3J3bfgI5kUdFoXvF/o+iAQm1QJq/RtxF/
	 mjDJM6zQC/z91rxYYkg5V6uxCnmMMB7+TwEhUH+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Randall P. Embry" <rpembry@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 715/849] 9p: sysfs_init: dont hardcode error to ENOMEM
Date: Tue, 11 Nov 2025 09:44:45 +0900
Message-ID: <20251111004553.719125449@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 714cfe76ee651..a59c26cc3c7d9 100644
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



