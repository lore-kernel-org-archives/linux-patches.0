Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C272576E;
	Sat, 12 Sep 2026 07:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199912; cv=none; b=AWmOdB/jL8czFIdBsWUO4QaahqZEDI4UD+zald7cBylMMpg94SaWvuMUPsV4VM203Oztqt+FgXhSxTpOD0xFXJnvERCCu3Z2aV3QIce6Gr/dAaYu9M3ko7K8LDLr5GXcLYB2VaIGW42hwuDzomkHKpQ89IqU/dKjBBIwGtJpBHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199912; c=relaxed/simple;
	bh=ehJ+Lgi1wROYXINIChdqOm8dGwqLu7mCuY3QBuEOL3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ln+z188QkEFZaI8MD1zkN++t2jvdUuwmmWVZcLuNn0nx3cDZpKNYEW341uHlTXYmWUbCwum6et5oHowhFFMBgiPEZUbO5WVQ1KayHxe11jaMnCnSVZy3eCihmTpbVgnKLE2u0NYGSMqf+JxBujbbSEgNPY1g1mWyz54JGGp3CqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VaLii8nZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VaLii8nZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8E91F000FF;
	Sat, 12 Sep 2026 07:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199911;
	bh=acCB28Vcx0h96EYRJQwp3iVgnonUkhVq2o9FQANZCAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VaLii8nZdZW6ONZemYuaI9jIQCufDodbGsmjJl2uAMWwcV+nzdV1u2Ay39FDR7pkh
	 QcKGiim3TrMD4pCFlygw08sMm+WmTb4LOT2ITFKkDaPesxn6mmEM54IPZBgHLQ+x6E
	 8s879YHmYIvv2ebs0zsQCzhBBNzyZhaazpeCCW+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumeet Pawnikar <sumeet4linux@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0680/1815] powercap: intel_rapl_tpmi: Handle PMU registration failure during probe
Date: Sat, 12 Sep 2026 08:40:30 +0200
Message-ID: <20260912065704.850071005@linuxfoundation.org>
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
index 7f41491d9cd11..73f36d9c09b1b 100644
--- a/drivers/powercap/intel_rapl_tpmi.c
+++ b/drivers/powercap/intel_rapl_tpmi.c
@@ -414,7 +414,10 @@ static int intel_rapl_tpmi_probe(struct auxiliary_device *auxdev,
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



