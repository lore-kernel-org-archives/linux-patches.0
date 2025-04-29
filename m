Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F45D2459EA;
	Tue, 29 Apr 2025 17:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947540; cv=none; b=P0V4oVWbLmtxW2uTw1ahSerePW1X7Wtqbg0QjyOxv8q5dlT6CIubRJgHB0Tcpu+U655vU30L0K9bwzCplLKn1vi8Mq2dO7lIuQpUfLoQ8KJtzRhGZ2mV4zAxXhd/h45SC7Wf0gvpAV3ExN5yxe7kZ/or9Z5v07L0546BuH2iMmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947540; c=relaxed/simple;
	bh=fXHW/yQ+mFvPfHfeWErh3prKFBh6gpKxhWaH3jvb7Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyMLTdXAT55euQKXr7LCEUuNmEoFugTGRwCR+lF6kDTeOKnBOb5LpWXKF85EbHuDymU0THgIA05pOPEPT4DsDUR72fksFRfvlzKdRrIKxIgNTXWNmp4E5sXfYLSrsc7ZL+5FALn2cNpMoirDHcCmwLq1A7RFZaCKxTDKkRwtns0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNQGtugI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNQGtugI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8630CC4CEE3;
	Tue, 29 Apr 2025 17:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947540;
	bh=fXHW/yQ+mFvPfHfeWErh3prKFBh6gpKxhWaH3jvb7Lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zNQGtugITohX0svMCCMoPdDtbzQG22yyB9khLjtxElSyd7MWYQf4gggDwm/i9GsH2
	 p92HbrIGDrsabOVrbtoSZ1NlQ6+9WN1WnDO4+FPbrnBYOGOXO/IHqRqWGKf2UVOrid
	 WIs2PnlnNV4Eyl2uDbmSxeFEbmPDJsjjFICm6Jwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/280] of: resolver: Fix device node refcount leakage in of_resolve_phandles()
Date: Tue, 29 Apr 2025 18:39:27 +0200
Message-ID: <20250429161116.175375301@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit a46a0805635d07de50c2ac71588345323c13b2f9 ]

In of_resolve_phandles(), refcount of device node @local_fixups will be
increased if the for_each_child_of_node() exits early, but nowhere to
decrease the refcount, so cause refcount leakage for the node.

Fix by using __free() on @local_fixups.

Fixes: da56d04c806a ("of/resolver: Switch to new local fixups format.")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250209-of_irq_fix-v2-9-93e3a2659aa7@quicinc.com
[robh: Use __free() instead]
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/resolver.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/of/resolver.c b/drivers/of/resolver.c
index fce8bdac45f3e..7d935908b5431 100644
--- a/drivers/of/resolver.c
+++ b/drivers/of/resolver.c
@@ -249,8 +249,9 @@ static int adjust_local_phandle_references(struct device_node *local_fixups,
  */
 int of_resolve_phandles(struct device_node *overlay)
 {
-	struct device_node *child, *local_fixups, *refnode;
+	struct device_node *child, *refnode;
 	struct device_node *overlay_fixups;
+	struct device_node __free(device_node) *local_fixups = NULL;
 	struct property *prop;
 	const char *refpath;
 	phandle phandle, phandle_delta;
-- 
2.39.5



