Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56A447AF75;
	Thu, 20 Aug 2026 16:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243467; cv=none; b=ILIBaG6c1pof9VTK6BckMTprMboepWlE6tjRcEMdYbMby4Nec/nyW0HorKSJq4HJIv1noY4yRfQyvhRgg/Au+SfmNx9McsmaeQvqINkmoErX74Kja6LNHVogVNSEAAjifLodwLMsz4De4n48bsWq7oHdS4gxzLcfaceepS9xqlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243467; c=relaxed/simple;
	bh=2WThl9mngQZuA/U+Kwx7L9ykUjbnY9rZ5jJCPGmSg7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4VFy0lt/8bp0bJKq+q4ZdXUFYR8akRSyOc69jNYb9h9c2C3Pcpnbp+r/ha5wigEmGGN8wOWs63uyhOK7qCK3fgBU9gn7at1gtPU+DmtUpr6p0Z37rp9CFjrqm1ZxrDwvMW94lAuQ0G2xM6B79RHg9R/NF6QZ567G/OcXBaxBFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oa5wxRtk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oa5wxRtk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14EEC1F000E9;
	Thu, 20 Aug 2026 16:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243465;
	bh=ZFBHq9m73iBxW3AtM/9YNUSTTJe0k+DCR63Nadhb30I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oa5wxRtkkv2ACuhib5opf2+XUeJyEa4KcULHS0roflok1tT2/htKcRwpFxOpiLzOc
	 Xa7/4KJy7sQAj4EGdrEk92S6bbd9d1pxdTbpPJ2IxLMDnPfQR6O79z/lQGzmiwWGRH
	 ACiuul4GiRK02J92NUnoITpPerOJH9/ZdEQvv4jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Wasim Nazir <wasim.nazir@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/272] remoteproc: qcom: Fix leak when custom dump_segments addition fails
Date: Thu, 20 Aug 2026 16:54:47 +0200
Message-ID: <20260820145234.359544802@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wasim Nazir <wasim.nazir@oss.qualcomm.com>

[ Upstream commit ecf9fc18e62c58eae1ceb65dab2bccb8a724de2d ]

Free allocated minidump_region 'name' in qcom_add_minidump_segments()
when failing before adding the region to 'dump_segments'. Otherwise,
the 'name' is not tracked and is never freed by qcom_minidump_cleanup().

Return error when adding to 'dump_segments' fails.

Cc: stable@vger.kernel.org # v5.11
Fixes: 8ed8485c4f05 ("remoteproc: qcom: Add capability to collect minidumps")
Reviewed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Signed-off-by: Wasim Nazir <wasim.nazir@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260318-rproc-memleak-v2-1-ade70ab858f2@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/qcom_common.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/remoteproc/qcom_common.c
+++ b/drivers/remoteproc/qcom_common.c
@@ -108,6 +108,7 @@ static int qcom_add_minidump_segments(st
 	struct minidump_region __iomem *ptr;
 	struct minidump_region region;
 	int seg_cnt, i;
+	int ret = 0;
 	dma_addr_t da;
 	size_t size;
 	char *name;
@@ -128,17 +129,22 @@ static int qcom_add_minidump_segments(st
 		if (le32_to_cpu(region.valid) == MD_REGION_VALID) {
 			name = kstrndup(region.name, MAX_REGION_NAME_LENGTH - 1, GFP_KERNEL);
 			if (!name) {
-				iounmap(ptr);
-				return -ENOMEM;
+				ret = -ENOMEM;
+				break;
 			}
 			da = le64_to_cpu(region.address);
 			size = le64_to_cpu(region.size);
-			rproc_coredump_add_custom_segment(rproc, da, size, rproc_dumpfn_t, name);
+			ret = rproc_coredump_add_custom_segment(rproc, da, size, rproc_dumpfn_t,
+								name);
+			if (ret) {
+				kfree(name);
+				break;
+			}
 		}
 	}
 
 	iounmap(ptr);
-	return 0;
+	return ret;
 }
 
 void qcom_minidump(struct rproc *rproc, unsigned int minidump_id,


