Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4022168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7412AC433EF;
	Mon,  8 May 2023 10:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540615;
	bh=3Kg9bkvKjVFpRgqLrECET1Xq25EDmdbWlu2X5wWnLlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cMW5VitGYJKyXC/cK1JTDGmmEoYdFr1uHOukzRCQqQ1eltW4AQ9yeR4DDZCr7N3A/
	 o5zZirbeq+VkIziIdMGgSMl8ki13Gz1MGuHHZZZF8Zj/3LR6lOJ5ZHBhqmfJ/6amST
	 nRBw0xeEcg37Pz5jBrfYZH8Aa4Q+Ghhfna6t8/Nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Gondois <pierre.gondois@arm.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 433/611] cacheinfo: Check sib_leaf in cache_leaves_are_shared()
Date: Mon,  8 May 2023 11:44:35 +0200
Message-Id: <20230508094436.255366865@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pierre Gondois <pierre.gondois@arm.com>

[ Upstream commit 7a306e3eabf2b2fd8cffa69b87b32dbf814d79ce ]

If there is no ACPI/DT information, it is assumed that L1 caches
are private and L2 (and higher) caches are shared. A cache is
'shared' between two CPUs if it is accessible from these two
CPUs.

Each CPU owns a representation (i.e. has a dedicated cacheinfo struct)
of the caches it has access to. cache_leaves_are_shared() tries to
identify whether two representations are designating the same actual
cache.

In cache_leaves_are_shared(), if 'this_leaf' is a L2 cache (or higher)
and 'sib_leaf' is a L1 cache, the caches are detected as shared as
only this_leaf's cache level is checked.
This is leads to setting sib_leaf as being shared with another CPU,
which is incorrect as this is a L1 cache.

Check 'sib_leaf->level'. Also update the comment as the function is
called when populating 'shared_cpu_map'.

Fixes: f16d1becf96f ("cacheinfo: Use cache identifiers to check if the caches are shared if available")
Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20230414081453.244787-2-pierre.gondois@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/cacheinfo.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/base/cacheinfo.c b/drivers/base/cacheinfo.c
index f30256a524be6..c440d1af197a4 100644
--- a/drivers/base/cacheinfo.c
+++ b/drivers/base/cacheinfo.c
@@ -38,11 +38,10 @@ static inline bool cache_leaves_are_shared(struct cacheinfo *this_leaf,
 {
 	/*
 	 * For non DT/ACPI systems, assume unique level 1 caches,
-	 * system-wide shared caches for all other levels. This will be used
-	 * only if arch specific code has not populated shared_cpu_map
+	 * system-wide shared caches for all other levels.
 	 */
 	if (!(IS_ENABLED(CONFIG_OF) || IS_ENABLED(CONFIG_ACPI)))
-		return !(this_leaf->level == 1);
+		return (this_leaf->level != 1) && (sib_leaf->level != 1);
 
 	if ((sib_leaf->attributes & CACHE_ID) &&
 	    (this_leaf->attributes & CACHE_ID))
-- 
2.39.2



