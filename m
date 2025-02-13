Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6919326B086;
	Thu, 13 Feb 2025 14:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458127; cv=none; b=W3vupx+m2Oh3aYzPfe9cVI3FurqW0PbGaeVRMfps72wJ/x3GPOkc50MpHiIxvyZTb99YMxSxiTyvCfT5Kkm8p36W7MRcYTG7DDOG7y4VCVH8nyWAnPzEZinTo79wcQh39WQD7FW/VBGNvKOdPk4fNkBoJ0zZeNx34v45xPzRYq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458127; c=relaxed/simple;
	bh=Ln6CkbaTD5+bTGusBZG34bBKTPwfR1V3NK/52gQogl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIWg5sLdqKG+VeM5P3X+f6gproBS7OPwbQtJsl5pM8mtZG1LHfshsNzQdsz7Sr0Sxu3meYvRaEoQUBm4jH7s2barTX+ILlyNKO8ADwtFb5VaK0PASUO/L+crTU+LlqsPYNFsNS16qOWjp4U4HVFzYQzx2DgTr59un0mtL4wY5zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vrROsQsn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vrROsQsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09F6C4CED1;
	Thu, 13 Feb 2025 14:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458127;
	bh=Ln6CkbaTD5+bTGusBZG34bBKTPwfR1V3NK/52gQogl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vrROsQsnzNfP1yyI7f8NeSN15btOiEKTWAPd0tHK03T0j7SnTRvDVxIyLteuLbe4F
	 WlDPwOqHgY6lY6h1U9vkXaxSqxScdJlmTcb+Ytpe8chU2g0spf+nCggMf//o0uz1fS
	 JT3VnQgx8i4bDVyMeC1dmG0vasfFIq07VVyD4zXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.12 310/422] media: ccs: Clean up parsed CCS static data on parse failure
Date: Thu, 13 Feb 2025 15:27:39 +0100
Message-ID: <20250213142448.506021635@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit da73efa8e675a2b58f1c7ae61201acfe57714bf7 upstream.

ccs_data_parse() releases the allocated in-memory data structure when the
parser fails, but it does not clean up parsed metadata that is there to
help access the actual data. Do that, in order to return the data
structure in a sane state.

Fixes: a6b396f410b1 ("media: ccs: Add CCS static data parser library")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Mehdi Djait <mehdi.djait@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ccs/ccs-data.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/media/i2c/ccs/ccs-data.c
+++ b/drivers/media/i2c/ccs/ccs-data.c
@@ -10,6 +10,7 @@
 #include <linux/limits.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 
 #include "ccs-data-defs.h"
 
@@ -948,15 +949,15 @@ int ccs_data_parse(struct ccs_data_conta
 
 	rval = __ccs_data_parse(&bin, ccsdata, data, len, dev, verbose);
 	if (rval)
-		return rval;
+		goto out_cleanup;
 
 	rval = bin_backing_alloc(&bin);
 	if (rval)
-		return rval;
+		goto out_cleanup;
 
 	rval = __ccs_data_parse(&bin, ccsdata, data, len, dev, false);
 	if (rval)
-		goto out_free;
+		goto out_cleanup;
 
 	if (verbose && ccsdata->version)
 		print_ccs_data_version(dev, ccsdata->version);
@@ -965,15 +966,16 @@ int ccs_data_parse(struct ccs_data_conta
 		rval = -EPROTO;
 		dev_dbg(dev, "parsing mismatch; base %p; now %p; end %p\n",
 			bin.base, bin.now, bin.end);
-		goto out_free;
+		goto out_cleanup;
 	}
 
 	ccsdata->backing = bin.base;
 
 	return 0;
 
-out_free:
+out_cleanup:
 	kvfree(bin.base);
+	memset(ccsdata, 0, sizeof(*ccsdata));
 
 	return rval;
 }


