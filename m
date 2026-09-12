Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE07214A84;
	Sat, 12 Sep 2026 12:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216383; cv=none; b=A9tjWZzO6keibi8PVLG8cdObPFoDJpxO5KmLucZaTENGWxx3Dw2w3Dey33gvWcj5DYna51gIBnATHEotOwjZ+EyMav0yNrXIF+rt7cc19y5q50xS49f9DsainbU9ICLpWspmQaX5xuwDWmg1OH4wlt8G7oJVoI5s1EPln6cHZvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216383; c=relaxed/simple;
	bh=vAW8F2M/ezcdsXmdUlBfsrudpvSV6CIKZC4gpTx7iKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLBY+CkEnl3XWY5tHHjRiI3i6yikncwqj7KV1QUrFh8IEeA6+FnO5nijpWf+7erXpPwmBv3q4AF+Y9V28AkrALDOoN3aAjORWthP/k9sLRoyiCpstBuojrGzVuBWsV5w6qcpZu34SrjYRlf8XGpXLUxJYJObVExLRXk8RIs1D68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TqJ1TQ72; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TqJ1TQ72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6637A1F000FF;
	Sat, 12 Sep 2026 12:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216382;
	bh=Vnq8jCGOYKST6zRbNSOQ8pYWTqrYwHvyG4yV5FWZnIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TqJ1TQ72eZIDIQY8zJeo5IZ6WO3eIeouls+ZJhcWz9HXQZKR6wqk0GAumw5juIonw
	 JFuVn0aA7ntTxU5RESQ942Z9UpgdgaSyP1uGfKGfGsmIGvYqLNxiaZTI5bAiKv6rry
	 e8GBZ+On4d/Th45JT32oYoQiQBkEtv2dxuSUtEbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumeet Pawnikar <sumeet4linux@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0698/1376] powercap: intel_rapl_tpmi: Handle PMU registration failure during probe
Date: Sat, 12 Sep 2026 08:52:04 +0200
Message-ID: <20260912065623.101754319@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Sumeet Pawnikar <sumeet4linux@gmail.com>

[ Upstream commit 9229916d59918ec9d3639e7263e1e97be638e361 ]

intel_rapl_tpmi_probe() invokes rapl_package_add_pmu() but ignores its
return value, so a PMU registration failure would leave the driver
reporting probe success despite the PMU being absent, with no log
trace.

Since PMU registration is an optional auxiliary feature for perf energy
counters, its failure should not break the primary powercap functionality.
Check the return value and log a warning to ensure graceful degradation.

Fixes: 963a9ad3c589 ("powercap: intel_rapl_tpmi: Enable PMU support")
Signed-off-by: Sumeet Pawnikar <sumeet4linux@gmail.com>
[ rjw: Changed the log level of the new message to "info" ]
Link: https://patch.msgid.link/20260723172321.5960-1-sumeet4linux@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/intel_rapl_tpmi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/powercap/intel_rapl_tpmi.c b/drivers/powercap/intel_rapl_tpmi.c
index 1618138c5cac1..1fae66a609298 100644
--- a/drivers/powercap/intel_rapl_tpmi.c
+++ b/drivers/powercap/intel_rapl_tpmi.c
@@ -313,7 +313,10 @@ static int intel_rapl_tpmi_probe(struct auxiliary_device *auxdev,
 		goto err;
 	}
 
-	rapl_package_add_pmu(trp->rp);
+	ret = rapl_package_add_pmu(trp->rp);
+	if (ret)
+		dev_info(&auxdev->dev, "Failed to add RAPL PMU for Package%d, %d\n",
+			info->package_id, ret);
 
 	auxiliary_set_drvdata(auxdev, trp);
 
-- 
2.53.0



