Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279E738F255;
	Sat, 12 Sep 2026 19:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242793; cv=none; b=ZeRrBoB2F8zN0GmFb3mE3IjYKFVKzMY18WZvSyqihvpm0hN+gVRfQCpJOrIn9XGjZaI4CIaiSox5R8g7wxvddUaI6VNgeudwrxoiL/YYu0jK6fqWoG9pm/9WOnOdrJhKDTvzQyWvOyEv2UEyLSVzkqkdpqd/pfN4kY8U4BUp860=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242793; c=relaxed/simple;
	bh=+Uwa6i61D+wxrxtGKZIP41EytD+bno4dwgYaqdSECW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1MK83GU0af5QswkDsfrxB+hk0k4PyxI14ka23qgg0SsT4IPYtcY68+VZUkSZLCQEj1RkJET60Ljh/+1cj0gyGf+L2hYopJsgIbiLrW0PubYWj91LSopDn+gQ107d5BTwLvdCmSKTS+ofiqZWb9nDbzJEpLz7I1SjV8tHdS+NyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UsFAMoU4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UsFAMoU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830021F00893;
	Sat, 12 Sep 2026 19:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242791;
	bh=SHmYKnnwVN/yb9u+u5t0CZJ6LLX9+BmDCWpU+mTBYY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UsFAMoU4lViiGpZwddBJckG5CaV47zlq6PVF6nG/+7zHjIaIx8gAzH0CVfoBtwJCz
	 BOQkVwxmuRDVYd+1e3iDF9WMlPLXfiIp6UfcmesrAiqmwnVFpOr8q6na8fuPVyKupH
	 vu2PqmmB1ALbCkrgrqU+xkXxUppxXQjeKcAi9R10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Peng Fan <peng.fan@nxp.com>,
	Arnaud Pouliquen <arnaud.pouliquen@st.com>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 521/798] remoteproc: Add new RPROC_ATTACHED state
Date: Sat, 12 Sep 2026 09:02:29 +0200
Message-ID: <20260912065529.075254236@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathieu Poirier <mathieu.poirier@linaro.org>

[ Upstream commit 4196d18903f94090f0a223d65de25e3bf50a3d13 ]

Add a new RPROC_ATTACHED state to take into account scenarios
where the remoteproc core needs to attach to a remote processor
that is booted by another entity.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Arnaud Pouliquen <arnaud.pouliquen@st.com>
Link: https://lore.kernel.org/r/20210312162453.1234145-4-mathieu.poirier@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Stable-dep-of: 74ee3b2f5767 ("remoteproc: Prevent crash handling to race with rproc_del()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_sysfs.c | 1 +
 include/linux/remoteproc.h            | 7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_sysfs.c b/drivers/remoteproc/remoteproc_sysfs.c
index d1cf7bf277c44..1167adcf87413 100644
--- a/drivers/remoteproc/remoteproc_sysfs.c
+++ b/drivers/remoteproc/remoteproc_sysfs.c
@@ -201,6 +201,7 @@ static const char * const rproc_state_string[] = {
 	[RPROC_RUNNING]		= "running",
 	[RPROC_CRASHED]		= "crashed",
 	[RPROC_DELETED]		= "deleted",
+	[RPROC_ATTACHED]	= "attached",
 	[RPROC_DETACHED]	= "detached",
 	[RPROC_LAST]		= "invalid",
 };
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index 2546758f13eb0..34e684e6c9459 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -407,6 +407,8 @@ struct rproc_ops {
  * @RPROC_RUNNING:	device is up and running
  * @RPROC_CRASHED:	device has crashed; need to start recovery
  * @RPROC_DELETED:	device is deleted
+ * @RPROC_ATTACHED:	device has been booted by another entity and the core
+ *			has attached to it
  * @RPROC_DETACHED:	device has been booted by another entity and waiting
  *			for the core to attach to it
  * @RPROC_LAST:		just keep this one at the end
@@ -423,8 +425,9 @@ enum rproc_state {
 	RPROC_RUNNING	= 2,
 	RPROC_CRASHED	= 3,
 	RPROC_DELETED	= 4,
-	RPROC_DETACHED	= 5,
-	RPROC_LAST	= 6,
+	RPROC_ATTACHED	= 5,
+	RPROC_DETACHED	= 6,
+	RPROC_LAST	= 7,
 };
 
 /**
-- 
2.53.0



