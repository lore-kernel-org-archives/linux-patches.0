Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6105541F5D5;
	Sat, 12 Sep 2026 13:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221350; cv=none; b=Xdx0N2PZadyCOTpd5Lp+CYxdojPTMETKE5vM+PGU4rx72+yjNueu8uCN2YSeUVSFhGOvbYnBon7WI1ONJoF8lqafs4J9Jhkd21QIwCWrdWopTDKZdCkEDH+QSyliZN5frgA22t4tdImTwEPpQrlP1KjAcICFpiigOjvd+52727I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221350; c=relaxed/simple;
	bh=oKPpDdUgreTxRj46mH6IgCL4u0mFr1RzWZc0Erse6yM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QTMFTyUPxrRI88Vs1gB6tIYp08JVYltyyFh5Lhl4HCfH9e6PVlkkq9HvqasTOzB0OfJk3B+d2kPDs+HtPBbX0l8bkal+VhiW/jKPrrSYK27UvFoadUlaBd3T09P91tWSMzWg74Q3QtbORoFgJkLYQlZUWS7TV/Nd0AU9MaxCkjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BEp9FPpH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BEp9FPpH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47EF1F00893;
	Sat, 12 Sep 2026 13:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221342;
	bh=EytY4CNp8DrVV1AhxfI94InmsmYpKxj6ikncYiJRg8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BEp9FPpHBn0iyoianvcw92B4uOS8E6zCsX4F1q3TWvm4qGTDpy44I6x+uORX+wefN
	 KR2qaDhhfCVtnEq1z44MFH6PGMeo54j/LGJpDBKvv/JRRiRJyEesVEPfSSjjr+jjCw
	 atWJFnkq0vOkmrRnRNFjYA7KYs+7e3jt/PdQglJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 0346/1424] mm/damon/sysfs-schemes: kobject_del() scheme region dirs
Date: Sat, 12 Sep 2026 08:46:18 +0200
Message-ID: <20260912065615.038470869@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

commit f3ec3271210781c255e737498b84d5790e8176b4 upstream.

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts.  Fix
those issues for scheme region directories by adding kobject_del() calls.

This issue was discovered [1] by Sashiko, though its analysis was
partially incorrect.

Link: https://lore.kernel.org/20260628220121.97360-5-sj@kernel.org
Link: https://lore.kernel.org/20260517205828.6204-1-sj@kernel.org [1]
Fixes: 9277d0367ba1 ("mm/damon/sysfs-schemes: implement scheme region directory")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.2.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs-schemes.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -151,6 +151,7 @@ static void damon_sysfs_scheme_regions_r
 
 	list_for_each_entry_safe(r, next, &regions->regions_list, list) {
 		list_del(&r->list);
+		kobject_del(&r->kobj);
 		kobject_put(&r->kobj);
 		regions->nr_regions--;
 	}


