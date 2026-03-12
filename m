Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1AD36C9F9;
	Thu, 12 Mar 2026 20:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347004; cv=none; b=SEsS/2SI06a3yhf5x/HpGYwcjPSYBtqBNYPm8cq7kdCARriWpU0sEiyG1bMIqN9hIKd1Rl11zPVQp97C+IxDZeXBtR3+LDU55iUzCiqNB6F5iDLjjLyYhqwtJbpJNNf23ZYNMQhqe28XnVlJmbCbFJ+EXo4IDWclESIm6VLzcvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347004; c=relaxed/simple;
	bh=wJZGpDKLAo0Y3QdsgZp+Yn2VuCM0K0Imj8xaoZSy4CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdVwKBJ/+lxom2GIlFMQLO3UqWnE9f1JaoRJcg3lD2XLfRjHyliVyBdobA3CGpdTKscDkvXzA9Kp7XI3kuCHdaJJ9r6qBiIrvSzTxPiUbcIPlSBoW42t2b9NEH+4wFWyWqhc6tKHAhENfKJEqy8w9h96+4P8mYGx8zrcUEbK5Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FsaAaL8I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FsaAaL8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3BBC4CEF7;
	Thu, 12 Mar 2026 20:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347004;
	bh=wJZGpDKLAo0Y3QdsgZp+Yn2VuCM0K0Imj8xaoZSy4CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FsaAaL8IS9pi89Th2LvGDYSa5prJe7DLpRZ+BxJhDVp+Fne8/u1Ktog62xKH/IGBl
	 nO8Cx7Le9zLRsQRlF3o71UOzUAFB1m0+vUQGCcwRE7/p0Pi6jkOxr/O5W5cZQaRUH1
	 f2M6plmmlsLYSDrbBJV2Oe/5ZiBSrCkRXvXK6OSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 178/265] pinctrl: cirrus: cs42l43: Fix double-put in cs42l43_pin_probe()
Date: Thu, 12 Mar 2026 21:09:25 +0100
Message-ID: <20260312201024.735938976@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit fd5bed798f45eb3a178ad527b43ab92705faaf8a ]

devm_add_action_or_reset() already invokes the action on failure,
so the explicit put causes a double-put.

Fixes: 9b07cdf86a0b ("pinctrl: cirrus: Fix fwnode leak in cs42l43_pin_probe()")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/cirrus/pinctrl-cs42l43.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/cirrus/pinctrl-cs42l43.c b/drivers/pinctrl/cirrus/pinctrl-cs42l43.c
index 8b3f3b945e206..7734dae06a4ac 100644
--- a/drivers/pinctrl/cirrus/pinctrl-cs42l43.c
+++ b/drivers/pinctrl/cirrus/pinctrl-cs42l43.c
@@ -569,10 +569,9 @@ static int cs42l43_pin_probe(struct platform_device *pdev)
 		if (child) {
 			ret = devm_add_action_or_reset(&pdev->dev,
 				cs42l43_fwnode_put, child);
-			if (ret) {
-				fwnode_handle_put(child);
+			if (ret)
 				return ret;
-			}
+
 			if (!child->dev)
 				child->dev = priv->dev;
 			fwnode = child;
-- 
2.51.0



