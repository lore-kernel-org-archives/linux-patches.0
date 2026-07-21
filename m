Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790764746AB;
	Tue, 21 Jul 2026 21:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667912; cv=none; b=ihN8SxvKjUHtEqUFI11T3387VEgVL0asHRrzVhs/dXt37U0QCVHFCxg3JLIloV6kmQn2Pz3SrLjYS4yAJngtxemeSmkwR+aLfPHE+z0+uaWg6sE1uugL0y98z9x9d3r04G0eqCoSSvqbnOjmzNY1j9i5E18d26TqHN9QjeuGBTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667912; c=relaxed/simple;
	bh=TPrkbRnfTlYyAce/WA8UDi6BFIr7ulNH+XuXVJQwiTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0Pqi40ryTCApHBlua+Ro16LcAFmf8pD1EObV3Jkstq0itgaf0w70krmm+zF58J95/D0tcaJPRqE2S4WBxuL5RapCXTzIWW+AFwewY5vyBmzbXUR+dG3FVRsvUw4CSl2Q7N3God/FWeb9PpTI9PJfKs/n4Rpw31CWTAm3XdOQsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0uWXyTym; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0uWXyTym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E049A1F000E9;
	Tue, 21 Jul 2026 21:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667909;
	bh=sxMH/QC4ZuGAW2Yb/9ukgDiTNzV13JEswVk2tvll34s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0uWXyTymfvqoYVb8AK+wtfNQMMiTBbg8BH+cJuKQsFsSiuLJbWmbuKRzfkkXdh0yQ
	 TQJhui0bGux77IV33r29sIRjttnZnSddD/Mf6ssu5NbMbl/qjMsW1evG9Kf+7DJXyI
	 tyD8jqlL5KSijEeJjAw6g6zaWNSSL165CuG5jH1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1237/1266] regulator: scmi: fix of_node refcount leak in scmi_regulator_probe()
Date: Tue, 21 Jul 2026 17:27:54 +0200
Message-ID: <20260721152509.494787519@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


