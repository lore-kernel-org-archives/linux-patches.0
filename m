Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A00F3803E8;
	Thu, 20 Aug 2026 15:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239044; cv=none; b=bo4eAnlymLxn6DTBQwUoMvacESi87vtJnE168ixvgCXE1EKtnThJTddGhJzbi4VW9hpuCN9wEMvc9Je3gQuIFBIO40mT0cIfrawJ9FhUdwheQ/qjj6mmxH305qyzGoElEIeaVMXlLloYil1Vbh7n536SAzkXQn9zeLS1YyqPEEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239044; c=relaxed/simple;
	bh=c5CH8xqsqkSs2AjNcW8GzJCaE55uZqmP1bRXNHuDErw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a4YLt6BnY66qaZnp7DghyFkLLliV3n6J9iSbBsNl6qIgOJh9Uttfq7hKRqZwuSy6j45Nn2fpKHXofFMhJCqqJ3nTpLlmHU0nMKcH4gkIoVpBqk0jB4PnhjWSQjcVh62mUWvRzcft7jK1s0Pmk6kIWb5T8SHFpEcxEPkKdDQqzG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rPtI7bP3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rPtI7bP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 948211F000E9;
	Thu, 20 Aug 2026 15:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239043;
	bh=L491gM2n9Yn2MvXKMkJ8I6MD4hCVa03ahPJgNd+D5s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rPtI7bP3UZkILG8ZjyQKdD+vSMb2lTgSqVxSNeLua+9CONHHBR6wFkPt5SEeM8T4u
	 mAxtX2oQMVda3tP8EO2tAKk1ajR7FMV33r+xdnY0n1jUTqEO0b+MRZhD1viJOSMXPq
	 a9kIwgmBKRevtOxWj/vh8aLWv+OVd15OTWdRc7Ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 131/217] libceph: Amend checking to fix `make W=1` build breakage
Date: Thu, 20 Aug 2026 16:54:59 +0200
Message-ID: <20260820145241.684045584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 04d8712b079327409b09dee628378f9583e2e035 ]

In a few cases the code compares 32-bit value to a SIZE_MAX derived
constant which is much higher than that value on 64-bit platforms,
Clang, in particular, is not happy about this

net/ceph/osdmap.c:1441:10: error: result of comparison of constant 4611686018427387891 with expression of type 'u32' (aka 'unsigned int') is always false [-Werror,-Wtautological-constant-out-of-range-compare]
 1441 |         if (len > (SIZE_MAX - sizeof(*pg)) / sizeof(u32))
      |             ~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
net/ceph/osdmap.c:1624:10: error: result of comparison of constant 2305843009213693945 with expression of type 'u32' (aka 'unsigned int') is always false [-Werror,-Wtautological-constant-out-of-range-compare]
 1624 |         if (len > (SIZE_MAX - sizeof(*pg)) / (2 * sizeof(u32)))
      |             ~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fix this by casting to size_t. Note, that possible replacement of SIZE_MAX
by U32_MAX may lead to the behaviour changes on the corner cases.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Stable-dep-of: 9f00f9cf2be2 ("libceph: bound pg_{temp,upmap,upmap_items} length to CEPH_PG_MAX_SIZE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osdmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -1440,7 +1440,7 @@ static struct ceph_pg_mapping *__decode_
 	ceph_decode_32_safe(p, end, len, e_inval);
 	if (len == 0 && incremental)
 		return NULL;	/* new_pg_temp: [] to remove */
-	if (len > (SIZE_MAX - sizeof(*pg)) / sizeof(u32))
+	if ((size_t)len > (SIZE_MAX - sizeof(*pg)) / sizeof(u32))
 		return ERR_PTR(-EINVAL);
 
 	ceph_decode_need(p, end, len * sizeof(u32), e_inval);
@@ -1621,7 +1621,7 @@ static struct ceph_pg_mapping *__decode_
 	u32 len, i;
 
 	ceph_decode_32_safe(p, end, len, e_inval);
-	if (len > (SIZE_MAX - sizeof(*pg)) / (2 * sizeof(u32)))
+	if ((size_t)len > (SIZE_MAX - sizeof(*pg)) / (2 * sizeof(u32)))
 		return ERR_PTR(-EINVAL);
 
 	ceph_decode_need(p, end, 2 * len * sizeof(u32), e_inval);


