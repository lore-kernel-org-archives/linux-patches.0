Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DDE223313;
	Thu, 12 Dec 2024 16:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020155; cv=none; b=I3XD0MUm6tUFFZBmzW56LzociOS2E9JFjr7kX1vfIaGts0lrNBy7AgHWNjzp1z/+2Aw+D0JvuLuLVyY58QtgYDs6rIgNKJhopEQ8houLxR5jczmEQcmaZe7cfL9TtFlqRKZyvrIHI08dpND9TOZnGu+gU+w+c/L/5qppfZSp2CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020155; c=relaxed/simple;
	bh=aMrfj82atOnST38sGlco06x22xVHx2K1ToA3WMuo9V0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IeW+wSRhYMk2BThaMykb0mmoMNWJlCF95V7IThxaiGbq4BqV9wPCahcv3uKbt8R+kwQJRFzFnAyPFM8NSvtOIQ6q86imp3irJAJK6XJ7s+h86KitlbsgQD7m/NtWOrxGZRcohHWd8OP3/aOyhAuDKJUfZ6pO4/CI6FveWCpb6VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bL/51bk2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bL/51bk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A975FC4CECE;
	Thu, 12 Dec 2024 16:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020155;
	bh=aMrfj82atOnST38sGlco06x22xVHx2K1ToA3WMuo9V0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bL/51bk2Mg/K9xNfCSqZSWW2HKbZJIHhpJUs8op+uvEfejrIhOfBiSn6WIsa+1IUB
	 gWk8xpmgLonR9zecT+ddUFdlZLqDq9z5oJIIll3G6BonDjlcYkgY94ctq9B7CMKxX1
	 Hbe1ukLomcR1XYBUYRp1Oy6ixJ8p9KqQNx1FFFmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manikanta Mylavarapu <quic_mmanikan@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 361/772] soc: qcom: socinfo: fix revision check in qcom_socinfo_probe()
Date: Thu, 12 Dec 2024 15:55:06 +0100
Message-ID: <20241212144404.830969319@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Manikanta Mylavarapu <quic_mmanikan@quicinc.com>

commit 128fdbf36cddc2a901c4889ba1c89fa9f2643f2c upstream.

In success case, the revision holds a non-null pointer. The current
logic incorrectly returns an error for a non-null pointer, whereas
it should return an error for a null pointer.

The socinfo driver for IPQ9574 and IPQ5332 is currently broken,
resulting in the following error message
qcom-socinfo qcom-socinfo: probe with driver qcom-socinfo failed with
error -12

Add a null check for the revision to ensure it returns an error only in
failure case (null pointer).

Fixes: e694d2b5c58b ("soc: qcom: Add check devm_kasprintf() returned value")
Signed-off-by: Manikanta Mylavarapu <quic_mmanikan@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241016144852.2888679-1-quic_mmanikan@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/socinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/soc/qcom/socinfo.c
+++ b/drivers/soc/qcom/socinfo.c
@@ -649,7 +649,7 @@ static int qcom_socinfo_probe(struct pla
 	qs->attr.revision = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%u.%u",
 					   SOCINFO_MAJOR(le32_to_cpu(info->ver)),
 					   SOCINFO_MINOR(le32_to_cpu(info->ver)));
-	if (!qs->attr.soc_id || qs->attr.revision)
+	if (!qs->attr.soc_id || !qs->attr.revision)
 		return -ENOMEM;
 
 	if (offsetof(struct socinfo, serial_num) <= item_size) {


