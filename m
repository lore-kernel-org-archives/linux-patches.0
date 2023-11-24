Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CA839FD9;
	Fri, 24 Nov 2023 18:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h2NWME2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC2FC433C9;
	Fri, 24 Nov 2023 18:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849691;
	bh=58UqEq8+jzkUpj8Q8bS7jYuqzuGNmkG56d7unxTn+yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h2NWME2YhUuBl0EhdDM1nrl0+6spv4nANuk5BdwS/+mdM0o5uLZji9agu4i0TN3p3
	 Ivfu0B1njKWMbhfUgMcqffkkg7q4hfvMvunGxWSC3fvDDga73eqNmCs6ik1SaF+i/K
	 odsmzMot17TBeyWOEIw+oiGKevHk0yUAzJsJfsCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Jakub Acs <acsjakub@amazon.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 282/530] mm/damon/core: avoid divide-by-zero during monitoring results update
Date: Fri, 24 Nov 2023 17:47:28 +0000
Message-ID: <20231124172036.624850463@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit d35963bfb05877455228ecec6b194f624489f96a upstream.

When monitoring attributes are changed, DAMON updates access rate of the
monitoring results accordingly.  For that, it divides some values by the
maximum nr_accesses.  However, due to the type of the related variables,
simple division-based calculation of the divisor can return zero.  As a
result, divide-by-zero is possible.  Fix it by using
damon_max_nr_accesses(), which handles the case.

Link: https://lkml.kernel.org/r/20231019194924.100347-3-sj@kernel.org
Fixes: 2f5bef5a590b ("mm/damon/core: update monitoring results for new monitoring attributes")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Jakub Acs <acsjakub@amazon.de>
Cc: <stable@vger.kernel.org>	[6.3+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -476,20 +476,14 @@ static unsigned int damon_age_for_new_at
 static unsigned int damon_accesses_bp_to_nr_accesses(
 		unsigned int accesses_bp, struct damon_attrs *attrs)
 {
-	unsigned int max_nr_accesses =
-		attrs->aggr_interval / attrs->sample_interval;
-
-	return accesses_bp * max_nr_accesses / 10000;
+	return accesses_bp * damon_max_nr_accesses(attrs) / 10000;
 }
 
 /* convert nr_accesses to access ratio in bp (per 10,000) */
 static unsigned int damon_nr_accesses_to_accesses_bp(
 		unsigned int nr_accesses, struct damon_attrs *attrs)
 {
-	unsigned int max_nr_accesses =
-		attrs->aggr_interval / attrs->sample_interval;
-
-	return nr_accesses * 10000 / max_nr_accesses;
+	return nr_accesses * 10000 / damon_max_nr_accesses(attrs);
 }
 
 static unsigned int damon_nr_accesses_for_new_attrs(unsigned int nr_accesses,


