Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8237223E80;
	Thu, 12 Dec 2024 16:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020344; cv=none; b=NITVNWRaaaJbp6lcfxEMSrMyJ2q2fO0kSoEiM4FZtlD/29iOw4uKcRrfedytKVGxnWj2YRpn6VG1Qz/ejVl481BhrP+lT2fee4FgdtldEfwudc4gd4LLUfjMEga6Vbmpzn3OynUFxSgvGSJcfTWzp8MT11C7HcCDdJcfsFVMa7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020344; c=relaxed/simple;
	bh=lEGdgw1M25qSKsRSU4XxQkR997T/UnlItGcDDg3iehE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i0resXVOg2LAEzbriNQ0MnTb244vQh6dcs0ZwwNZHRn+DrJmEbu8aOUjc84xRD3XejzXcJDB50AQXW9FR6MnjjwW/nHbpOi5+Oq79DrlIDUgNHt31gOWTnUx9nd9Myv1nZFkFHfYH6mWLAzKfVsowoI3orOjjbpv4a7sR9nt8qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MX5YJ9gr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MX5YJ9gr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF70C4CECE;
	Thu, 12 Dec 2024 16:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020344;
	bh=lEGdgw1M25qSKsRSU4XxQkR997T/UnlItGcDDg3iehE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MX5YJ9grc9a55HXwIuIHWyb7FyaQOvPixC5mRhtRW8IN/UriSFjSgHUFZjNJ7DBHx
	 Yk1AL3x2fpGqQPvbzJJnQOz8okUlmBMFWipqctCyFpm/mwqEPcEZHcSA5SU1og1AzG
	 kgCdaxgh9h8kiwTYTfOdGdek+0U+EstsHH6ZJqJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 443/772] perf/arm-cmn: Ensure port and device id bits are set properly
Date: Thu, 12 Dec 2024 15:56:28 +0100
Message-ID: <20241212144408.226973705@linuxfoundation.org>
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

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit dfdf714fed559c09021df1d2a4bb64c0ad5f53bc ]

The portid_bits and deviceid_bits were set only for XP type nodes in
the arm_cmn_discover() and it confused other nodes to find XP nodes.
Copy the both bits from the XP nodes directly when it sets up a new
node.

Fixes: e79634b53e39 ("perf/arm-cmn: Refactor node ID handling. Again.")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20241121001334.331334-1-namhyung@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm-cmn.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/arm-cmn.c b/drivers/perf/arm-cmn.c
index b8983f42e749e..4445cae427b2d 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -1951,8 +1951,6 @@ static int arm_cmn_init_dtcs(struct arm_cmn *cmn)
 			continue;
 
 		xp = arm_cmn_node_to_xp(cmn, dn);
-		dn->portid_bits = xp->portid_bits;
-		dn->deviceid_bits = xp->deviceid_bits;
 		dn->dtc = xp->dtc;
 		dn->dtm = xp->dtm;
 		if (cmn->multi_dtm)
@@ -2183,6 +2181,8 @@ static int arm_cmn_discover(struct arm_cmn *cmn, unsigned int rgn_offset)
 			}
 
 			arm_cmn_init_node_info(cmn, reg & CMN_CHILD_NODE_ADDR, dn);
+			dn->portid_bits = xp->portid_bits;
+			dn->deviceid_bits = xp->deviceid_bits;
 
 			switch (dn->type) {
 			case CMN_TYPE_DTC:
-- 
2.43.0



