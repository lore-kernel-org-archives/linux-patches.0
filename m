Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6F344AB7B;
	Tue, 21 Jul 2026 22:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671507; cv=none; b=V5W/VlyVkFgEG0E3HWo96xUdg6ukK7bVLFiSMC7MW0ui6T7lgXzHSI21dXmrHJVr76Sc4uLJ9mP/tzq3CJuY82jf837eaROHlvbfGgdlSG/j4TOR8p/8DYDfkgDyGvHoBeAHZAfcZthrAlEFff0WJ8K5mlyTnZHL3biM8YSI5po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671507; c=relaxed/simple;
	bh=uNigZV1GJMhIplIuh3VgG8GzRBiDbmxXF+4ybpbJbVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=md71gtSmiC+rbl6D1wXbbCILlJg5WtobfY4w/eGkCAt4Qk4vFcnpjsBJkMbblBSEkCRjn2sGm6cg588ZTSCPm6fgwRApw+u8fAFdZX5D0s92i+5qIxesHDCNGRJXn6a/Q3nvvG8uK8pNfYY6pVceF9Ft7pckE2IFr1azSQ6830E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/xuDH6k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/xuDH6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C691F000E9;
	Tue, 21 Jul 2026 22:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671506;
	bh=Imf7HmHcWZd4qWqNle7fxA3oVyWor4EOiHpryG9niRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0/xuDH6kcGp4OGInLefT8G4R7MUQujM2crDz6cGNBP8IJ53jJN0fYHJLOLVn4gHrn
	 mPYUQCKdlXZZQRR3MyB0Pl6GQwPGbIlYKJBotXTl4vI+CdWLmoaGGyZhkLFUwdhH+G
	 tJDiWwNzpNoaD+VYx2orsEVzT5N8gJ7Cw/YWYrGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>,
	Ben Cheatham <benjamin.cheatham@amd.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 273/843] dax/kmem: account for partial discontiguous resource upon removal
Date: Tue, 21 Jul 2026 17:18:28 +0200
Message-ID: <20260721152412.165968994@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Davidlohr Bueso <dave@stgolabs.net>

[ Upstream commit 8aa442cfce79e2d69e72fc8e0c0864ac2971149d ]

When dev_dax_kmem_probe() partially succeeds (at least one range is
mapped) but a subsequent range fails request_mem_region() or
add_memory_driver_managed(), the probe silently continues, ultimately
returning success, but with the corresponding range resource NULL'ed out.

dev_dax_kmem_remove() iterates over all dax_device ranges regardless of if
the underlying resource exists.  When remove_memory() is called later, it
returns 0 because the memory was never added which causes
dev_dax_kmem_remove() to incorrectly assume the (nonexistent) resource can
be removed and attempts cleanup on a NULL pointer.

Fix this by skipping these ranges altogether, noting that these cases are
considered success, such that the cleanup is still reached when all
actually-added ranges are successfully removed.

Link: https://lore.kernel.org/20260223201516.1517657-1-dave@stgolabs.net
Fixes: 60e93dc097f7 ("device-dax: add dis-contiguous resource support")
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Ben Cheatham <benjamin.cheatham@amd.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dax/kmem.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 97723ee15bc689..354aea5f290a56 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -179,6 +179,12 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 		if (rc)
 			continue;
 
+		/* range was never added during probe */
+		if (!data->res[i]) {
+			success++;
+			continue;
+		}
+
 		rc = remove_memory(range.start, range_len(&range));
 		if (rc == 0) {
 			remove_resource(data->res[i]);
-- 
2.53.0



