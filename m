Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFE249D587;
	Thu, 17 Sep 2026 17:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665728; cv=none; b=luuDonfWH/vJ8ZbXcTCMs4VriRFSX6r3TcG/97pOGZcMcc3OGvJWxfxyNDvsOJnSh+QRTC2fAJ3RJ8PsvgkMQa7QCIhWAmEJQugYZldEs74RioxHo1yT58NOwJcJXzsEEBsueNU/vAWYdMMK8EUeMqkQVQ0VbZ8HemXXeCkwgoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665728; c=relaxed/simple;
	bh=aGoDNJvsB0PJ1ZfKkbPBvKD3fQ7O1yMxTpw3yPOX/jA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oqmjfs7a/XVCNBEbUCAYg7a05bTuBwPsPD0CXKJMm5zjYYvYfZA/UBVa3Jl7AcLOQ9nYKaTl+FyJ8ZGCYHJforHEtF7w3r1tTZTA86CNWBD5qRU/BHLTfZ4MTYhxnI4A68wbMc1NuvuN9dt+kUNqh3sCto9F11+rsKCjitJ+pt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eb8HklUt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eb8HklUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2ED21F000FF;
	Thu, 17 Sep 2026 17:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665726;
	bh=se52znPLY0UybU2x6x9NRc77ZDk4wEaYW/TQNE0EQHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eb8HklUtzlBQPLk+AUB8cLNLe03TknDj1iX7RBNnrOc3e4xHDx9krvBw01S8Sn9pL
	 RvoVjaclq+HMFFFGfaGaBlB0ng1pyzsKSK/5CGUr31HryKavOGysExaOUXe+/SegQi
	 aLMdTEccgAChNKHAn5+0fCQDuhGAOcq4A1DJ+Fac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0800/1250] dibs: Unregister dibs_class after error
Date: Thu, 17 Sep 2026 16:09:55 +0100
Message-ID: <20260917151613.590766934@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Alexandra Winter <wintera@linux.ibm.com>

[ Upstream commit 1668a31e3b1ad358d981ddb6dbd3db1fe0533621 ]

In case dibs_loopback_init() fails, e.g. because of -ENOMEM, dibs_init()
must unregister dibs_class. Otherwise dibs_class and /sys/class/dibs exist
even though the functionality is not available. A retry to load the module
fails with -EEXIST.

Unregister dibs_class in the error path of dibs_init.

Note that before
commit ad3dfa80be76 ("dibs: change dibs_class to a const struct")
class_destroy(dibs_class) is required instead of
class_unregister(&dibs_class).

Fixes: 804737349813 ("dibs: Create class dibs")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Link: https://patch.msgid.link/20260902143438.426664-1-wintera@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dibs/dibs_main.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/dibs/dibs_main.c b/drivers/dibs/dibs_main.c
index c3ec36e8c10fc..e05041841f139 100644
--- a/drivers/dibs/dibs_main.c
+++ b/drivers/dibs/dibs_main.c
@@ -252,13 +252,19 @@ static int __init dibs_init(void)
 
 	rc = class_register(&dibs_class);
 	if (rc)
-		return rc;
+		goto err;
 
 	rc = dibs_loopback_init();
 	if (rc)
-		pr_err("%s fails with %d\n", __func__, rc);
+		goto err_unregister;
 
 	return rc;
+
+err_unregister:
+	class_unregister(&dibs_class);
+err:
+	pr_err("%s fails with %d\n", __func__, rc);
+	return rc;
 }
 
 static void __exit dibs_exit(void)
-- 
2.53.0



