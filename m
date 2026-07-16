Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17849425896;
	Thu, 16 Jul 2026 14:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211332; cv=none; b=WpRAUF4jVJo016nadWUxAJAxnvCMm1gaR6Z9dMHS8G4EjtwQ+RQx1ytnTmwQYjRqnXjfrRWOTOJh+VbsaO69O8ReY4SpJ5fJAtB/bP9cdroE0V1OUtI5JLePRGIpj8xobyhBOId3stQqoS11c1NIzoP92QbijEyDknjp56soFVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211332; c=relaxed/simple;
	bh=SnPF0yRErsY1mEQlupRU+s9MZhnG5pgPx6inuAg9b6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pj7zew6XnbpyNwudkHHUipDtP8Z90cyVJ7jJ6PC1YG/clXxZXEwikuJofj1FQD7fj4o4EbBfPToG17cziW0Oj8dzf4qKcUTX2vWasJJPmoNCukMwdXqQPjg1T1ayOtgtnNo3Wo6nGeBqJQRHYdEYB1VSL/AWdLbiiYH0UYzPxwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B7xPa3Uz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B7xPa3Uz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36FE01F00A3A;
	Thu, 16 Jul 2026 14:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211330;
	bh=inxXUoluVgykymKU++ADPurbESwzlGHnPyw1qIsTsWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B7xPa3Uzrtk4t9559ic2MW6Nd51Pzdg1kRjZ3VT5+YoNv+XEf72K2CIR6jVHGewDu
	 g+jVoKviusS+HJmUZ73yT8QX+MIHicNkbb5pYx8Aju4lvWaDzsjEAXZwcpBzXd51ve
	 X/MMIlkh9KDkYPJeEjZZijM/pnZKb7n30AfNI2tA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 388/480] regulator: scmi: fix of_node refcount leak in scmi_regulator_probe()
Date: Thu, 16 Jul 2026 15:32:15 +0200
Message-ID: <20260716133053.193572979@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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


