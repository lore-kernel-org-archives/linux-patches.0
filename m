Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D5E1D88DB;
	Wed, 19 Feb 2025 09:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957098; cv=none; b=AfK8S/yz2vsSrwlMMhanpsXuHmiwUniDjEzNtdaATNYQFYLaRkyXCnlQ7Sm2TJhGmyep7hEIY2OpqTA1wRcO5ohY366aAF5o7pUTUzVkAr7RKMhZZpLK/d3zKH4bLLzAAWtXCrzCLhHr/zjSrAhZXGMdE18qPoQ/ZHiPBC8VOto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957098; c=relaxed/simple;
	bh=F0isypVfAR661BUBL4TBOWlhsYNipN3JAiEsLW91G7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kRAGMCX6Zr1XLLgdF3X8S6rXcW0EYAkSD9wdvzG9I0Qc57KdWBwV4zWSamSxAcIMn7Mk7Ys/IAX4MOan/dQYDvGkeZ/3o2IAXIDxJA2xh1bbZJnZdjIUAN+SQMPRws853I2un3bsKSfWcEPjqYV231npHdZCMFuyGMf5vKpqfHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fy5Akdrp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fy5Akdrp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8260DC4CED1;
	Wed, 19 Feb 2025 09:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957097;
	bh=F0isypVfAR661BUBL4TBOWlhsYNipN3JAiEsLW91G7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fy5Akdrp4cLYW8TWhOO5Kfjd45ej+tkxjImPgORJZ0l86ILL2yc8Gdhp7S5fB0MaX
	 8bk40CFRf8pnAuMdLKB+YBJVGmV+PgiFBRhYn20xkd3MIqbHqf6D3ftguX7smu1abt
	 mhkBSvBwrWUrhiz9pgzpvKuDvorfeHktbrfkv9wY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.1 407/578] media: ccs: Clean up parsed CCS static data on parse failure
Date: Wed, 19 Feb 2025 09:26:51 +0100
Message-ID: <20250219082709.033475086@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


