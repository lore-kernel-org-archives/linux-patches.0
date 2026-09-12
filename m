Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334B737204A;
	Sat, 12 Sep 2026 07:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197141; cv=none; b=lMxK2epVmpv0/95JeMP2CohFvMZwOpTG4G5+/IxHIKj1FyfDnhmUB2KBjs3+SB+isKCvGLCNguH7PF9BWhu5MnjezngZccVfK2DMUG1GCDT2nhTuq0tgcpGvNb5RBSjm7oYaF0cr6guLe/XFZKyBnDHzTzizsobKqt894Cs1c1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197141; c=relaxed/simple;
	bh=MsMxqVWb1QqDBWoGWSvPIlDHku2AMXI67uxuZuhhekM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l59PyvT/CAWZD4mJde7gqTXqgfQz/G44aY80QC8a9YYHIlokIdriRpkH0yqsibuV+sAxT5UyxXx7ZAr1Ow1pDoImMUHfm2BW5iEmNa+7NZJAJUN1Ll4Eq2v1bgMmqYqdz2AhKGDPXijk/Shlr/byYi2b09i3g8DzpijQYeG/KMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qzkPnGp6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qzkPnGp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6E71F000FF;
	Sat, 12 Sep 2026 07:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197140;
	bh=qBIqP6B6bEBc4FtVpeLJzSlvYqI0C0ghiDeNSXHnroc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qzkPnGp61Tp3z5vQ+am68COzDJ1FVERMb/Q8OncAAOWLDxp/PnBeDSB/AJfwQKK4c
	 voskgESE/6YDRRffaY4SjIeoTDLXw0OF3CoEaeqq+h4BEl+avaJN7hDxgFI502xbTn
	 vRHu5Q1Q2oYtqXnyHSDOOlVf+t2JbcicGV9ID790=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0109/1815] pinctrl: imx1: fix device_node leak in dt_is_flat_functions()
Date: Sat, 12 Sep 2026 08:30:59 +0200
Message-ID: <20260912065651.565008111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 7b1272d02e65d2d4aeffb0d85b290a8753d24c12 ]

for_each_child_of_node() holds a reference on the iterator node that
must be released on early return. imx1_pinctrl_dt_is_flat_functions()
has two early return paths inside the loop that skip this cleanup.

Replace both loops with the scoped variant so that the reference is
automatically dropped when the iterator goes out of scope.

Fixes: 63d2059cd665 ("pinctrl: imx1: Allow parsing DT without function nodes")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/freescale/pinctrl-imx1-core.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/freescale/pinctrl-imx1-core.c b/drivers/pinctrl/freescale/pinctrl-imx1-core.c
index b7bd4ef9c0db5..4a6bdaefa42f2 100644
--- a/drivers/pinctrl/freescale/pinctrl-imx1-core.c
+++ b/drivers/pinctrl/freescale/pinctrl-imx1-core.c
@@ -547,14 +547,11 @@ static int imx1_pinctrl_parse_functions(struct device_node *np,
  */
 static bool imx1_pinctrl_dt_is_flat_functions(struct device_node *np)
 {
-	struct device_node *function_np;
-	struct device_node *pinctrl_np;
-
-	for_each_child_of_node(np, function_np) {
+	for_each_child_of_node_scoped(np, function_np) {
 		if (of_property_present(function_np, "fsl,pins"))
 			return true;
 
-		for_each_child_of_node(function_np, pinctrl_np) {
+		for_each_child_of_node_scoped(function_np, pinctrl_np) {
 			if (of_property_present(pinctrl_np, "fsl,pins"))
 				return false;
 		}
-- 
2.53.0



