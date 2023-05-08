Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6916F168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:42:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F2AC433D2;
	Mon,  8 May 2023 10:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542572;
	bh=pWGqKTWrtH0Ev8z5H1AQCu8OlufaMthu4IYWWo2+XvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IhUh+84vSIYjRVO9jPIFTcf683Ck8d5Ywa8KCcwGAiIj6irA2IGcPPGEDzN/U7iG1
	 8k+YK98SHDJTWQE1lDilRza5NSAVk9aNk0aVJUqtxao18dtBtkK8GAaeuC8HgJKVyw
	 VSYhZaar7kSYTSjuQ0psy5Spw1zWWEFiJ/AgN4uY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Gondois <pierre.gondois@arm.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 478/663] cacheinfo: Check sib_leaf in cache_leaves_are_shared()
Date: Mon,  8 May 2023 11:45:04 +0200
Message-Id: <20230508094443.817106737@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
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
index f05acf3c16c6b..88205a240fb2e 100644
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



