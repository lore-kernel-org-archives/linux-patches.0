Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1C733375D;
	Fri,  9 Jan 2026 12:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960177; cv=none; b=F05ceUSMmE56fEkyvViViuoJTQqRG9K2o0bOM2QQ42mFOL4d87Oo8PK+GANYda9ijjfRQMzzGNCzyAfEeTPXBvQVL3yq1VNdeDncPlxfQjz4zRkz3I6gPWC985a8rS+LMT71+ufGeuztdUlV6pRZmm1qTm1G8fhpm3m9AROkAno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960177; c=relaxed/simple;
	bh=yFN2jDZMfESxOutXYYCbtjNU2Fnxj6hGdJW64fhj6cQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U5RJgEJTgAeq3vBuAvGXxFsHbFxyhNEisqhSATP40CyWZyfKz3DehEKK/uAIkc3UkzArHr05hjkvXvxGoDg4J+oD3YAbQFM7uKqZnII+seHqD3HpLXRNnynMKcjWDzLZ1Vy1TSVf8dMNJxIyzadzr7pIzR1b/rcMWPD0ZgqO7rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PiXUWAd7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PiXUWAd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57BD3C4CEF1;
	Fri,  9 Jan 2026 12:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960177;
	bh=yFN2jDZMfESxOutXYYCbtjNU2Fnxj6hGdJW64fhj6cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PiXUWAd7M11t3TramK5zUyEJMlG6IjlR3OSGXkgDVYeQfgY14yrWw905InUXd969f
	 pC9v0bMYFxGpb6oSBZ3zAhbpzC7z9wZpNK8yiYvQ+eF2vXdFjtOXWSeGnvLYBd/nD3
	 OvLfMv4ZU5ETGEqNUW73YHjZ+CN5hdJOKxwjyQFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Simakov <bigalex934@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 285/737] dm-raid: fix possible NULL dereference with undefined raid type
Date: Fri,  9 Jan 2026 12:37:04 +0100
Message-ID: <20260109112144.733414702@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Alexey Simakov <bigalex934@gmail.com>

[ Upstream commit 2f6cfd6d7cb165a7af8877b838a9f6aab4159324 ]

rs->raid_type is assigned from get_raid_type_by_ll(), which may return
NULL. This NULL value could be dereferenced later in the condition
'if (!(rs_is_raid10(rs) && rt_is_raid0(rs->raid_type)))'.

Add a fail-fast check to return early with an error if raid_type is NULL,
similar to other uses of this function.

Found by Linux Verification Center (linuxtesting.org) with Svace.

Fixes: 33e53f06850f ("dm raid: introduce extended superblock and new raid types to support takeover/reshaping")
Signed-off-by: Alexey Simakov <bigalex934@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-raid.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index f23edd79df45e..0c4ab6865182b 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2259,6 +2259,8 @@ static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
 
 			mddev->reshape_position = le64_to_cpu(sb->reshape_position);
 			rs->raid_type = get_raid_type_by_ll(mddev->level, mddev->layout);
+			if (!rs->raid_type)
+				return -EINVAL;
 		}
 
 	} else {
-- 
2.51.0



