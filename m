Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBF837E5D1;
	Sat, 12 Sep 2026 12:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217205; cv=none; b=KauhS4Ax6tH0v7xn+rWCbhS6PlzQr69HzHmgaRQz8OCgvmljNwJZapWdO1NaXPwT8FUrwdVeLG1SKFWHA+XIdwPgPCuoQE7U3lswT0zrIRONtV0NQhG6heD5nQ44IAaQqJdNCReY8Asfdf/jQBzKkAPPIAP20aXbP3bUgT91muM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217205; c=relaxed/simple;
	bh=8iXocjepwDQecCnaPbzq1ffvqL6rmJuzdsx/n8rrf8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOgKUqJNCabU2SXs9hLbfEgdH7KtZBGfgBkNEz17GM/0J4RcWYOVbcU2mbFO57IKVWH7vTjermXu0yQXINCNmML9pA8uSj/80Q4MXS6/647+p3Crbf9yVZo1KccNBPxuwyhAFePZYFlMW+6ynVlmhFA6sZb88c02nm1i6p4e5Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ezXjmdQS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ezXjmdQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69451F000FF;
	Sat, 12 Sep 2026 12:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217203;
	bh=jQv114zSHNpd3cn9kFh3YMxpWChzzmQLQC0P3ghHVWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ezXjmdQS819+Q7I2ms0dv5kxw4OAU5u/a1dWttoe6NcHOJ7SzRSv26I0icNSZI7cp
	 PJnxaG7EAKSj33DSfxiz7KOhGeYmYKYrI2o+0oLOKICWByeYK+2+xwRvK142OJwH8I
	 MOV6a7rre5Ma5L3dXjZRK3LcH1xqw5UfjwO7d/s0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0894/1376] remoteproc: fix OOB read via signed offset in rsc_table_for_each_entry()
Date: Sat, 12 Sep 2026 08:55:20 +0200
Message-ID: <20260912065627.488968141@linuxfoundation.org>
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

From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>

[ Upstream commit bb840ea69347aff7bde5a208e7b5b180669a7656 ]

table->offset[i] is a u32 from firmware, but was stored into a signed
int.  A crafted offset like 0xFFFFFFF0 becomes -16, placing hdr 16 bytes
before the table buffer.  The subsequent avail check was bypassed
because the negative int was promoted to a large size_t in the
expression "table_sz - offset - sizeof(*hdr)", yielding a large positive
avail and letting the out-of-bounds hdr->type read proceed undetected.

Store the offset as u32 and validate it with unsigned comparisons before
any pointer arithmetic.

Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Fixes: fd2c15ec1dd3 ("remoteproc: resource table overhaul")
Link: https://lore.kernel.org/r/20260803114331.3277263-6-mukesh.ojha@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rsc_table.h | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/linux/rsc_table.h b/include/linux/rsc_table.h
index c6d6d553d8f11..4cef11a2e3a2c 100644
--- a/include/linux/rsc_table.h
+++ b/include/linux/rsc_table.h
@@ -337,17 +337,22 @@ static inline int rsc_table_for_each_entry(struct resource_table *table,
 	int i, ret;
 
 	for (i = 0; i < table->num; i++) {
-		int offset = table->offset[i];
-		struct fw_rsc_hdr *hdr = (void *)table + offset;
-		int avail = table_sz - offset - sizeof(*hdr);
-		int rsc_offset = offset + sizeof(*hdr);
-		void *rsc = (void *)hdr + sizeof(*hdr);
+		u32 offset = table->offset[i];
+		struct fw_rsc_hdr *hdr;
+		int avail, rsc_offset;
+		void *rsc;
 
-		if (avail < 0) {
+		if (offset < sizeof(*table) || offset >= table_sz ||
+		    table_sz - offset < sizeof(*hdr)) {
 			dev_err(dev, "rsc table is truncated\n");
 			return -EINVAL;
 		}
 
+		hdr = (void *)table + offset;
+		avail = table_sz - offset - sizeof(*hdr);
+		rsc_offset = offset + sizeof(*hdr);
+		rsc = (void *)hdr + sizeof(*hdr);
+
 		ret = cb(hdr->type, rsc, rsc_offset, avail, data);
 		if (ret)
 			return ret;
-- 
2.53.0



