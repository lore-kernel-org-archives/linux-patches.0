Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D91346F488;
	Tue, 21 Jul 2026 18:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658648; cv=none; b=q31YVwSjRiyG5imiUKvyivcRdshUVsq5siIORD1w50hThN6Zrx8+MqIARCjJ0SRyZvU3O4TYONUsSm98ocoGF9WF85lp3ruItgb1sOwQampy9QJRW6+e0by3B2mZw44OlEusnGI59M4aMRhlt126+YdUXooVRwzwwcAyxSndyic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658648; c=relaxed/simple;
	bh=4PdR0+T0DEdIyXsvjSMi3HDbWn+qVP39tBNisyWlxQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltjZLSZ3nW6P2ryOtPZsy0J3XFAbjkD09X5O0tVR5J2y2S5Tp/W21STu+OKZiDSjbmKhClz+o4HJE4+1oUK5vUiNkEUvE1I8leLr/vJKtdobWHFA4DL7IdAfCrID2Ld3V7OvhhkMTd0vf1rxRRkDHxfjva4a5/WDeylObvFmTfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z0+sC7Bz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z0+sC7Bz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2543E1F000E9;
	Tue, 21 Jul 2026 18:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658646;
	bh=q6REQ/7llwbg0rn/KCH/olTd2jmQCl+VGjEoBQ8pWOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z0+sC7Bz8nqBeoC2JLYkYRkwPa6l0F8cYfmCG2iMXVujb5YU5PtfXHcfbNfflSB8j
	 ahZb7X1dF8RdfE0b6jMUxfBI969a+6qnTnq4QKsiZkIVZhRV61dzvaiTd5aifUYERO
	 RYq9E0+GIG26/v5n2QzblIHGmR2K9v1mDvwiJwYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Wasim Nazir <wasim.nazir@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.18 1223/1611] remoteproc: qcom: Fix leak when custom dump_segments addition fails
Date: Tue, 21 Jul 2026 17:22:19 +0200
Message-ID: <20260721152542.944300444@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Wasim Nazir <wasim.nazir@oss.qualcomm.com>

commit ecf9fc18e62c58eae1ceb65dab2bccb8a724de2d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/qcom_common.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/remoteproc/qcom_common.c
+++ b/drivers/remoteproc/qcom_common.c
@@ -110,6 +110,7 @@ static int qcom_add_minidump_segments(st
 	struct minidump_region __iomem *ptr;
 	struct minidump_region region;
 	int seg_cnt, i;
+	int ret = 0;
 	dma_addr_t da;
 	size_t size;
 	char *name;
@@ -130,17 +131,22 @@ static int qcom_add_minidump_segments(st
 		if (le32_to_cpu(region.valid) == MINIDUMP_REGION_VALID) {
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


