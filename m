Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76151EA65;
	Mon,  2 Jun 2025 14:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873230; cv=none; b=jGQTcgihjCOG+pyR6ktzybqvI5QnrsnH4ycYeJ/eNloBhy/treua35SDYRzvqvdrBRmPM1Z3BNcO9ZrRdNh94K2+gdN3824qKpHleHNakui9abZge+n+Sqlex6a3Jhq2UjE6xR0pjDiyTurJ2AiqaBSYh/lAANrPGQYZ4LZP0VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873230; c=relaxed/simple;
	bh=Z3Ol0iwhc7ICnFKbGc+Ulh8O/bb/mwYh3EqXopAHbzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SativOhArIVMrhPSA2YmjzP6N1JutIpw9PsPg/9VgPWtBF3mqSPK32u0ExIe4TdTzIbFPrlDP0L9RmFDBxk3WcngDrA2lR2xgaRzlZkgauZ6uzBTBVlTaeqsUnAlvqKylF1jqKMR54B+gppbYFgu59rPLo8j3Se//1B2YJT0OtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yj+jjsnC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yj+jjsnC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35894C4CEEB;
	Mon,  2 Jun 2025 14:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873230;
	bh=Z3Ol0iwhc7ICnFKbGc+Ulh8O/bb/mwYh3EqXopAHbzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yj+jjsnCIMIiDS6JQKYciiPblvt8rxQSvOKpu+KQ9rrXOVqTb+LZejUHSMIJJU5u5
	 iXLsyxzhJ7B+dlpwkflk8rj9MsY84zwAbDynLuGus9exE3GheVfvrwD9cl2Ve+AniQ
	 D5CbEcmt/BTXVDaPVu2zxazjkri7VDx+a8U2DDbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/444] mailbox: use error ret code of of_parse_phandle_with_args()
Date: Mon,  2 Jun 2025 15:41:51 +0200
Message-ID: <20250602134342.838739474@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Tudor Ambarus <tudor.ambarus@linaro.org>

[ Upstream commit 24fdd5074b205cfb0ef4cd0751a2d03031455929 ]

In case of error, of_parse_phandle_with_args() returns -EINVAL when the
passed index is negative, or -ENOENT when the index is for an empty
phandle. The mailbox core overwrote the error return code with a less
precise -ENODEV. Use the error returned code from
of_parse_phandle_with_args().

Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index ebff3baf30451..f13d705f7861a 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -415,11 +415,12 @@ struct mbox_chan *mbox_request_channel(struct mbox_client *cl, int index)
 
 	mutex_lock(&con_mutex);
 
-	if (of_parse_phandle_with_args(dev->of_node, "mboxes",
-				       "#mbox-cells", index, &spec)) {
+	ret = of_parse_phandle_with_args(dev->of_node, "mboxes", "#mbox-cells",
+					 index, &spec);
+	if (ret) {
 		dev_dbg(dev, "%s: can't parse \"mboxes\" property\n", __func__);
 		mutex_unlock(&con_mutex);
-		return ERR_PTR(-ENODEV);
+		return ERR_PTR(ret);
 	}
 
 	chan = ERR_PTR(-EPROBE_DEFER);
-- 
2.39.5



