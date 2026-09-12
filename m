Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B4D1FBEA6;
	Sat, 12 Sep 2026 19:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242567; cv=none; b=Ol1RXiayjNh0j93TsJ72awsiyCO90AyYXC/rL8Wy6qwyHS93ajpQoauBC5DhRlFA/SUznT9FdoP8ji9RnAJyOFYG/uuobfMMmlrdRtKXeZSt2gzaZQpvVJdzy3BSXyFnHCtfUhWqG9KqasivlIfOVzi+XnpXQN4bbJIIIxOKH/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242567; c=relaxed/simple;
	bh=c6vdC44LlwMv2RlF4P+95elcduDxqMydTWZEgv5oUpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b7eUGdooCYF1foKv6w/QSqRxDIMrwJukyMgyyZHpEKXl7MUhWR5Rh3euEISnaXmHq/6DEJS7Bktq0m6AiSacb/J8mYekucfLoK+9/fzsZiVd+KLycpGGT3Xe4BGbyGkm4xjnKyjTvLrCa9H6M4aO/yCRmSQsptRJJsemw2IWOZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JpFnW/Tc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JpFnW/Tc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46AF41F000FF;
	Sat, 12 Sep 2026 19:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242566;
	bh=1MX8NSpPmJw6zc3/0LSEIicySdEp5YBSVswWR5QrBgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JpFnW/TcfhCqTeqOm1vqbxjyQ2sbHsz5OOkx6dSDkmJErCWx2MxG3rtALKNnlsdeH
	 XpaaA1JXOjhzNf6cLiiGEmU2/R1DfnP9NUF1KjWaJqxKETwKGNFPR5rw8VEZC69P8w
	 RVf0u+hgdCM2y75Xwd9pm6JLWkr+SOMdiVdxy5gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Khare <udaykhare77@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 449/798] remoteproc: qcom: Fix glink->node reference leak in qcom_add_glink_subdev
Date: Sat, 12 Sep 2026 09:01:17 +0200
Message-ID: <20260912065527.432837456@linuxfoundation.org>
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

From: Uday Khare <udaykhare77@gmail.com>

[ Upstream commit 44f4911ab8e6f4d69afad5f2571bbd2da421c918 ]

In qcom_add_glink_subdev(), the device node reference acquired via
of_get_child_by_name() is stored in glink->node. If the subsequent
kstrdup_const() allocation for glink->ssr_name fails, the function
returns early without calling of_node_put() on glink->node, leaking
the reference count.

Fix this by adding of_node_put(glink->node) on the error path before
returning.

Fixes: cd9fc8f1b35b ("remoteproc: qcom: Pass ssr_name to glink subdevice")
Signed-off-by: Uday Khare <udaykhare77@gmail.com>
Link: https://lore.kernel.org/r/20260618132054.11010-1-udaykhare77@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_common.c b/drivers/remoteproc/qcom_common.c
index 085fd73fa23ae..69d2bb25131e3 100644
--- a/drivers/remoteproc/qcom_common.c
+++ b/drivers/remoteproc/qcom_common.c
@@ -74,8 +74,10 @@ void qcom_add_glink_subdev(struct rproc *rproc, struct qcom_rproc_glink *glink,
 		return;
 
 	glink->ssr_name = kstrdup_const(ssr_name, GFP_KERNEL);
-	if (!glink->ssr_name)
+	if (!glink->ssr_name) {
+		of_node_put(glink->node);
 		return;
+	}
 
 	glink->dev = dev;
 	glink->subdev.start = glink_subdev_start;
-- 
2.53.0



