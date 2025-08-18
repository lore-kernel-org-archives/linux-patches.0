Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF5B2E2283;
	Mon, 18 Aug 2025 14:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526214; cv=none; b=McpocCtvWgf110GvHAzmTzXxGolI2pTcamIadMmf0L25vWCcZ3CJc9e1lq1Wm4N6B4Qga4cKTvOOAGd3BOWIAAx7FbZvA7lN7HWgR0O0T4a6L1F15vcv2dR6zOnhCQfF2t+g66pnDd1LiSQqbXkwYADbtzRIOa2T/awcmV5CDlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526214; c=relaxed/simple;
	bh=wjtUJVnSd4ZJ2ESCwfowqmWtgCdxo76E1O+sBxrLlfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJzNozy9R99stsn1F4Yao1cmqqtqvo7TK/pImH57Hd9Q4BjksBpdvggm03gjcirzey7lcTZLQC2PDzWlQoFa29l+hzthHoIJ+MqybLoy0qrfVUwfR9CDRdCkVuRqxEqCNf2CkvUFfxTxvI+5TtQUONKpu5LQaC/BGSNV3hSS2Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zkno/5i9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zkno/5i9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09248C4CEEB;
	Mon, 18 Aug 2025 14:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526213;
	bh=wjtUJVnSd4ZJ2ESCwfowqmWtgCdxo76E1O+sBxrLlfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zkno/5i9UyAKCaEsmqUBvy63/6Bxsz19A8bgTIDuJJsje4JP69oCuIuz+hQnCZju8
	 NYrMJp+bJDASvnLdgFfROVe58Sde/9orQpGGHSQK3dy2FxqNcKFcXfjOAHbsdv0hKr
	 5o+hkZlGaFKhq7CrTQxq8XXwdgfteH3d/YkD0aR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bijan Tabatabai <bijantabatab@micron.com>,
	SeongJae Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Ravi Shankar Jonnalagadda <ravis.opensrc@micron.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 491/570] mm/damon/core: commit damos->target_nid
Date: Mon, 18 Aug 2025 14:47:58 +0200
Message-ID: <20250818124524.790146280@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bijan Tabatabai <bijantabatab@micron.com>

commit 579bd5006fe7f4a7abb32da0160d376476cab67d upstream.

When committing new scheme parameters from the sysfs, the target_nid field
of the damos struct would not be copied.  This would result in the
target_nid field to retain its original value, despite being updated in
the sysfs interface.

This patch fixes this issue by copying target_nid in damos_commit().

Link: https://lkml.kernel.org/r/20250709004729.17252-1-bijan311@gmail.com
Fixes: 83dc7bbaecae ("mm/damon/sysfs: use damon_commit_ctx()")
Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ravi Shankar Jonnalagadda <ravis.opensrc@micron.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -993,6 +993,7 @@ static int damos_commit(struct damos *ds
 		return err;
 
 	dst->wmarks = src->wmarks;
+	dst->target_nid = src->target_nid;
 
 	err = damos_commit_filters(dst, src);
 	return err;


