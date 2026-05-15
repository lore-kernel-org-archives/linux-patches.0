Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A99F3F928E;
	Fri, 15 May 2026 16:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861751; cv=none; b=RwSTDE0KFytocMasoys6eDJg96SYYeSFzG7hMKTVz8ilwhvvlDQsAtDPJHrUkPfZRCI5nASXQm+DKLOjJP30pJoj10XYG72C0mUM/oNp1NvlggxU82lMkpRiaD6hqyvYtD8fw3z2qd1EQPo5KV830tpSPzcP4AD2Alg4JcKjnU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861751; c=relaxed/simple;
	bh=rZJHoS9Olc9EVLDP+cW26mB7i2CfCpW1X1V8PSOJGrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bw1oiz+575VvrvvKw1s2toFrU6+5obsgmW6h1R3F8mAzYf/oDOL4vpRgg/pAXOHW0anl2ktb0wXsM0IX8bSpWAhgFxgiVkc0xL48X5bszj6VRIiTE+Q8Sf1MoilImojpt7NtvpcV1ah0aL7Fg9wEbjXaeMdQ4U+p38wDBXAg558=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U0V3xKab; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U0V3xKab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BDA3C2BCFC;
	Fri, 15 May 2026 16:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861750;
	bh=rZJHoS9Olc9EVLDP+cW26mB7i2CfCpW1X1V8PSOJGrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U0V3xKabD3u+utt9QmNXnJFVkD36F6rq+XLERAr7NiXayEsl3U8rdI7tnO7sCZnCz
	 DXfmmITAujc/rnLbEiYP+ZEzWPpKbqJmAE+v3pCNjAD4Or9fgl1pUzQmDqIkMICIrt
	 KOcUIrObD+WlpCCJZpQKI3iHIB5S+5uyj51fKado=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 449/474] mm/damon/core: implement damon_kdamond_pid()
Date: Fri, 15 May 2026 17:49:18 +0200
Message-ID: <20260515154724.806452549@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: SeongJae Park <sj@kernel.org>

commit 4262c53236977de3ceaa3bf2aefdf772c9b874dd upstream.

Patch series "mm/damon: hide kdamond and kdamond_lock from API callers".

'kdamond' and 'kdamond_lock' fields initially exposed to DAMON API callers
for flexible synchronization and use cases.  As DAMON API became somewhat
complicated compared to the early days, Keeping those exposed could only
encourage the API callers to invent more creative but complicated and
difficult-to-debug use cases.

Fortunately DAMON API callers didn't invent that many creative use cases.
There exist only two use cases of 'kdamond' and 'kdamond_lock'.  Finding
whether the kdamond is actively running, and getting the pid of the
kdamond.  For the first use case, a dedicated API function, namely
'damon_is_running()' is provided, and all DAMON API callers are using the
function for the use case.  Hence only the second use case is where the
fields are directly being used by DAMON API callers.

To prevent future invention of complicated and erroneous use cases of the
fields, hide the fields from the API callers.  For that, provide new
dedicated DAMON API functions for the remaining use case, namely
damon_kdamond_pid(), migrate DAMON API callers to use the new function,
and mark the fields as private fields.


This patch (of 5):

'kdamond' and 'kdamond_lock' are directly being used by DAMON API callers
for getting the pid of the corresponding kdamond.  To discourage invention
of creative but complicated and erroneous new usages of the fields that
require careful synchronization, implement a new API function that can
simply be used without the manual synchronizations.

Link: https://lkml.kernel.org/r/20260115152047.68415-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20260115152047.68415-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/damon.h |    1 +
 mm/damon/core.c       |   17 +++++++++++++++++
 2 files changed, 18 insertions(+)

--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -677,6 +677,7 @@ static inline unsigned int damon_max_nr_
 
 int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive);
 int damon_stop(struct damon_ctx **ctxs, int nr_ctxs);
+int damon_kdamond_pid(struct damon_ctx *ctx);
 
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 				unsigned long *start, unsigned long *end);
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -762,6 +762,23 @@ int damon_stop(struct damon_ctx **ctxs,
 	return err;
 }
 
+/**
+ * damon_kdamond_pid() - Return pid of a given DAMON context's worker thread.
+ * @ctx:	The DAMON context of the question.
+ *
+ * Return: pid if @ctx is running, negative error code otherwise.
+ */
+int damon_kdamond_pid(struct damon_ctx *ctx)
+{
+	int pid = -EINVAL;
+
+	mutex_lock(&ctx->kdamond_lock);
+	if (ctx->kdamond)
+		pid = ctx->kdamond->pid;
+	mutex_unlock(&ctx->kdamond_lock);
+	return pid;
+}
+
 /*
  * Reset the aggregated monitoring results ('nr_accesses' of each region).
  */


