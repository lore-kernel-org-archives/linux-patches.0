Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEF044AB6E;
	Tue, 21 Jul 2026 21:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670723; cv=none; b=TbHVxFLiCyKhvwax4vo6Cthwn48mtceCA3hyNTU3+yWxoljiIKuZVUIaVVQm7mr0o/+j2/39LfqOiIop31nm0226myKeF/Pqah34XvPbd4x4DYqLLZeUqCXwaFYqjlYp8pPIffV1fqrwyZJRQQi41qUWo3p5i6Np8LQJR9eFp2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670723; c=relaxed/simple;
	bh=loqqROM6jBTog8fWVXyboge1LzxjZjOUejdkD1pWLp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJGBWkHzVkp4WU6UAeJYT71FuKXxmm3+j6YeWAY9Oz758DWc7WamfDa0q2PWJc3IK9LG23hWbjD1g0Potv7c1y1J0XcxosaxhWGNfqCnOZcOwe1pkGNIRa8/N8USBk8o229T0Td88JMcA6V+8vEKURKawXHr0BL4Gaf3DA6C9QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xwWRwNH+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xwWRwNH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2841F000E9;
	Tue, 21 Jul 2026 21:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670722;
	bh=vSWvgvn78+FhTt0Bwgf5RLd1u4aM8BIxype/uC7VrkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xwWRwNH+mODiE43t4oeoPyWRMgTMZ9rYSxwxedB4K6t4meF/9CmVq4yCc95McdC9P
	 IkYEyd5z2L8R0p7TvXhO7VtDd4O10lprwh1nEnuhWqay0twyQkGIGFAV3DA/OuNCA7
	 wvI/n/Ilq+7aCw78+5U+kNQ0w0J3jwEwufkseDa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1041/1067] regulator: scmi: fix of_node refcount leak in scmi_regulator_probe()
Date: Tue, 21 Jul 2026 17:27:22 +0200
Message-ID: <20260721152447.877435662@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit fa11039d6cdff84584a3ef8cc1f5e1b56e045da2 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/scmi-regulator.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/regulator/scmi-regulator.c
+++ b/drivers/regulator/scmi-regulator.c
@@ -349,8 +349,10 @@ static int scmi_regulator_probe(struct s
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


