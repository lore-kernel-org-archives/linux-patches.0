Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2A53B71A2;
	Tue, 21 Jul 2026 20:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665841; cv=none; b=OYx364hd9uA/xYeyZGWc4xx7Pa3Wf1ykVOXOFjhKHkWwGVssU4K4Adg7kZk1kIWxvbetg75ZIDaEvQZMCUatRR7W8bZaYPv9tSJdTLM0Zx6SqeQRSfgjs8Iz/AZ9AmOALbOTRRqhuzNOdnEEVNEuSm/oK5jgOxzYpG2LEaP7WrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665841; c=relaxed/simple;
	bh=88BGE/LDEhnZ55wsHz5bqiyo2q7AbUhi024XJF0sjDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8/qtG9VqITyTGkTHF0jp6D3hiGeZfcf2jdzKm8WO2SlJoNfPTMjF7S8HGBJ1fAwdOgD6EoC7fV82pW+oFQHXzPF/lE1nVoodzv1AS09GgqCnF2GlulW1vp8MeeyH1QVE4/+/RpROvhMY3/LEm23nnv3IGUvG822SIE/nvXe7qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wB5luRTO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wB5luRTO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFA81F000E9;
	Tue, 21 Jul 2026 20:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665840;
	bh=SR72d8gnOYeNlwScV9XMkqW5FLovCn1JeDeOvMaToWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wB5luRTORt7Dp8Rpl8UEeHO9sV6du3udiaUjreij50jJbqrOng1HeH+9CjU3zftY7
	 /Juqihmf9ZeEnYlg1RXoHk80wy+A7I18LLacZ9vvosbqdebMGOLT5eYTCaE1xJzFw8
	 wTuPJPk9TRGbRrqs/zcnH6i+0DnMIRmvSYgrLs8I=
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
Subject: [PATCH 6.6 0454/1266] dax/kmem: account for partial discontiguous resource upon removal
Date: Tue, 21 Jul 2026 17:14:51 +0200
Message-ID: <20260721152451.996091551@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c57acb73e3db2a..60d8bb7acf519a 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -193,6 +193,12 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
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



