Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983D92DB79F;
	Thu, 17 Sep 2026 15:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659527; cv=none; b=df58mvNp0IRggP7AzdLTx6DqGoYk2v6LsS/f9uYob51qSTuAwIUwBgSSrBn1Jbv+xmLX9OO3FyyrvrMbgUhOFlFJDp18WaMVzJG34cdZ++TrcBAW0TIFObsrmZua6h2F698BvlwDBk+torReAexJ+2Hwr8GmHsOTrP2Bp/LHg2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659527; c=relaxed/simple;
	bh=21yO8ymX/Ff6Le3wE6Au14+R1Wf5ZqE7hXkPBTK1t6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AElcWgpVIlueVVfnRloRCrgCGzKDDVsTvnmnLfdQa/f2pgl3tswa/4SpZAMSUhUfJRcuE3J/mSY/UU6876HYv1vCO21ez7tP+YWkURsfimTkW9Nn6Pl+QGhRvxiJfCXZAR5l0pdiMa+urnG8KnqMNeWTm1D04EJQX7XNADdPAUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AGHmAE6A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGHmAE6A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18BCF1F000FF;
	Thu, 17 Sep 2026 15:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659516;
	bh=XBVTlbviubwA+uVzYjdjQ5Qq1M1UVggmmdJXiKotOPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AGHmAE6AkWxGSNWutxIWlkkKpnbSZpLR3OFSTG6SHkNKdvyvXpnawaKAaCMMMGUpj
	 9KSWC7y7SDuv/7YLHsTRO6wc8EBxzB4mpU2GmA1ycBzaRN4WMDlDl6lNVVLtmlof/R
	 75VFuGYm5QcmZ+c/EMpzAMlCRWSfc2w9JES8lI6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 282/733] dibs: Unregister dibs_class after error
Date: Thu, 17 Sep 2026 16:09:50 +0100
Message-ID: <20260917151358.405146252@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 2b53a9d277dca..20c50997a7cf2 100644
--- a/drivers/dibs/dibs_main.c
+++ b/drivers/dibs/dibs_main.c
@@ -251,13 +251,19 @@ static int __init dibs_init(void)
 
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



