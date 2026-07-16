Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A473D42D769;
	Thu, 16 Jul 2026 14:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212372; cv=none; b=KNH/KtVFv+lBL64Lh7C+63f+K8Qs82fnWruwB56JZ67oh2cbywD5UkNKWHapAZci2qBLPzJ1FB3FOSvKoM1vwdMPjkrOGjJTnv5YNyulnCYFdYHuLjXXv8JgRKtFm82jL11n2Zt1Qr5zkePPtEbBq6Eu1c7dZUqq6zqSeUqUC2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212372; c=relaxed/simple;
	bh=UAcFswrjSgtEhJ/wNHLHkZrXBC/wxxvl8lO1dX2TR0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KN1/y4js/snVX9lLGgbRzGfGHlIpmCmSp9GhBgD58lG5kCzaBVYHNX/kwUscaimLTM8eaYh0bgKpBc4aMnikHFV+h+DBQIDEA/jb2I38ovbwnFpSDAq4TWnyQ8bPTcb9coOZA0sRn7b9xb4Z8SRABO0/YrvX5yji+1CyZuFQr44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z94ogiBq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z94ogiBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161871F000E9;
	Thu, 16 Jul 2026 14:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212371;
	bh=7ie+Vxqr3OQ4FN01+6mMBllsKdYUduVZR3L1X9rI3Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z94ogiBqx8kCF1DDVR+DaVYUqbl66cm3nQhOP1L4UiV//tsbvDw13JyZJPJe5SLZc
	 1hsbQXUvsCS7A3P43FoKoAvOv0j9UG7RW6H8Xj/dulbFHpB2/98gXoFawxUhXInEbI
	 sRwN6KpCnOXYq+V0SII72Vfdez+iZRoK67dK1Y0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 302/349] regulator: scmi: fix of_node refcount leak in scmi_regulator_probe()
Date: Thu, 16 Jul 2026 15:33:56 +0200
Message-ID: <20260716133040.080358151@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit fa11039d6cdff84584a3ef8cc1f5e1b56e045da2 upstream.

scmi_regulator_probe() calls of_find_node_by_name() which takes a
reference on the returned device node. On the error path where
process_scmi_regulator_of_node() fails, the function returns without
calling of_node_put() on the child node, leaking the reference.

Add of_node_put(np) on the error path to properly release the
reference.

Cc: stable@vger.kernel.org
Fixes: 0fbeae70ee7c ("regulator: add SCMI driver")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260527104850.872415-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/scmi-regulator.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/regulator/scmi-regulator.c
+++ b/drivers/regulator/scmi-regulator.c
@@ -345,8 +345,10 @@ static int scmi_regulator_probe(struct s
 	for_each_child_of_node_scoped(np, child) {
 		ret = process_scmi_regulator_of_node(sdev, ph, child, rinfo);
 		/* abort on any mem issue */
-		if (ret == -ENOMEM)
+		if (ret == -ENOMEM) {
+			of_node_put(np);
 			return ret;
+		}
 	}
 	of_node_put(np);
 	/*


