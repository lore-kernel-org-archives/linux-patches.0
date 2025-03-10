Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDD3227EA0;
	Mon, 10 Mar 2025 17:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629467; cv=none; b=BcQeRB7wre1QuYR2NKoqE5zuEUzN741D7gsNPb6/RRjEFuy53xQdjeMwwaU/7nnI1N6k6eK4eHH7VbE59I6dexCl3qJ9cNXpKgsQ61ao+wVanJ4bpKd8+lbkpxETpuf0tSmQhhVW8XPUcH7CZaGkTloP4y+kKlGgpD/f+NSEzrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629467; c=relaxed/simple;
	bh=U39IgqMr8udSGQ9KFt4C4NjK9qwr99oL6sogTiuwHKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=czQpi/WyZ7y7SE3YhTmi+iM6wiBuZJPy5nrfmfJZUi9zzrYA30WnWz+bclc7Dd0+jMfRNf+8Zh0ekHQjpz8eCN47AcLUKNm4WnlmYsvqRbvYvYXAJmZht9jj+qwf/K9XRMLWTtRfHJpktNcOX7J+2J2rkAl6kvBlJY7cqzW+0Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VS0aR4ra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VS0aR4ra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099A9C4CEE5;
	Mon, 10 Mar 2025 17:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629467;
	bh=U39IgqMr8udSGQ9KFt4C4NjK9qwr99oL6sogTiuwHKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VS0aR4raXNUUvIckOzD5BGuoXBqIvr+euw7UkZkFhmUDRk82DftKecPMd+J6RKT2a
	 uXmJcGri0Xa/rdBFQOxSN9sIhvSXoIGAbRAWoVykSTnJ6yxN2PsTgq9Fu49gB+lQah
	 NoBeSIOXq52kBLYKbaOfiK6QQW6/G00ZIUnJj+zI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.15 304/620] media: ccs: Clean up parsed CCS static data on parse failure
Date: Mon, 10 Mar 2025 18:02:30 +0100
Message-ID: <20250310170557.620720869@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


