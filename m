Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CB547A0B2;
	Tue, 16 Jun 2026 17:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630887; cv=none; b=RRyqIawDDqLWhBIMgU0LP2S7VBBaHNJgz2M2uHtK4yBvJ1fpPbApO/b/xhrw6hyZdd18Zoj+JP0ezcq4T4oa+QAeK9mTvA1AvWJghZSC2zE2G2RhDeXWBixVpnJWn1AF4uqTlaDHnOn/EKdzZN4t1Du3voWbF6863FrIvr/9Oac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630887; c=relaxed/simple;
	bh=l1ULJjmkoledB2zRwnisTh79XM1KXMUuGqWPTBZOULw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRr40Z4/1UOOGcOfe4gqHITCv0qLltwXS4RfZn27FC+OEgq5qZcZQM+cTKOxn7bTmedfow+dO1esmOekZPTwZM/XMR2lWpLQ4bphq+Lo+APK9WowTgQoRpG1XfsJBE5yMiWWG2+l/e1PhMhCzNzGVUSdMNSL/nBXdiRcTsu9ric=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IsxvkZW0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IsxvkZW0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE031F000E9;
	Tue, 16 Jun 2026 17:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630884;
	bh=S04bXo0h5ywkvhRWIFVbjRDeKCUC690s6/Qx0wxvI5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IsxvkZW0i83Abbx4d1QF/YbtwbianlgdsBvNNhcevclGXhTyJxFSVUqDwvCJE3i+9
	 Ho6ZZ2sJLnpjgcRnN4V87efSKtzufGyrN+G1Sk2Ng9zda+K4fGqT6W5GnCkA9AVPv+
	 3ChumDVx9IkQP2eEghSVaNjkgbGA6nP+EIeqwgXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	sashiko-bot <sashiko-bot@kernel.org>,
	Peter Chen <peter.chen@cixtech.com>
Subject: [PATCH 6.1 116/522] usb: cdns3: plat: fix unbalanced pm_runtime_forbid() call permanently leaks the runtime PM usage counter across bind/unbind cycles
Date: Tue, 16 Jun 2026 20:24:23 +0530
Message-ID: <20260616145131.396154942@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Peter Chen <peter.chen@cixtech.com>

commit ae6f3b82324e4f39ad8443c9020787e6fc889637 upstream.

Call pm_runtime_allow(dev) conditionally at cdns3_plat_remove.

Fixes: f738957277ba ("usb: cdns3: Split core.c into cdns3-plat and core.c file")
Cc: stable <stable@kernel.org>
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-devicetree/agKaEePSFknhDBg2@nchen-desktop/T/#m21e1d9c1574eb127ce03c0c2a1a49002ce435b52
Signed-off-by: Peter Chen <peter.chen@cixtech.com>
Link: https://patch.msgid.link/20260513085310.2217547-3-peter.chen@cixtech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-plat.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/cdns3/cdns3-plat.c
+++ b/drivers/usb/cdns3/cdns3-plat.c
@@ -181,6 +181,9 @@ static int cdns3_plat_remove(struct plat
 	struct device *dev = cdns->dev;
 
 	pm_runtime_get_sync(dev);
+	if (!(cdns->pdata && (cdns->pdata->quirks & CDNS3_DEFAULT_PM_RUNTIME_ALLOW)))
+		pm_runtime_allow(dev);
+
 	pm_runtime_disable(dev);
 	pm_runtime_put_noidle(dev);
 	cdns_remove(cdns);


