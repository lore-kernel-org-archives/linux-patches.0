Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73DB51DDF3;
	Wed, 30 Sep 2026 18:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793669; cv=none; b=q7oRhPqBoaKrC6JZiYKEysDwsDXEQ8Yhap5LNCybJ7X2m4Na6MgGsR2o8/zoJ5Z4nUsTWod8JLhALNXfQ2c70SctxmCa9m0V3oTtdnFDFDigg3UV5G10o7L0UaFT/nCp9bZF4tYzJS55zzN9I+9Erxri+uwJ5iDB6tBeBSZWs64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793669; c=relaxed/simple;
	bh=EIcvln5WJWSNRsCjafH6N5RDmhbOlZdTh2hY5B/rpFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6KpkDe4WpsRcGpFD++AEvkBT9cVse61Eaz3iTCw73q1qB1AvIk923g5WMFm8u2rQSecdiMN2dzXS9NL2OBV/cIzkF4z35kQvId0XcDLMAnlhyX4dTG+OQ3/PoyfPn+VkJyN9MHia54KcjvvT5FsFGFIL1/rokOyrTknseVy71Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cd5Pe+BZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cd5Pe+BZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DCCE1F000FF;
	Wed, 30 Sep 2026 18:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793667;
	bh=LMBV5MLyctPwcGzhkMABQIl7mstmQw1v5RgAm6e/vfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cd5Pe+BZTpD3LtZdbQIW0YMN5Mzb5Oz+zSHTPro9ZlgQalLdmNhI5KwyiGZU9ezT9
	 WDJ92DRYNh3z1d8fAKURAmB9PP1ZFyW+OcrCIWmKh+rcNXcPUGmd7TCV57iZAZj1yT
	 iu7E8/Dtmkgpo6GCJx2WW8nLF//nuT0ZZygCnuV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 336/395] xfs: use correct jiffies comparison function in xchk_maybe_relax
Date: Wed, 30 Sep 2026 17:29:58 +0200
Message-ID: <20260930152347.955980577@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 984aab2d905a8557fafb27cd9e8713d6d12b3437 upstream.

LOLLM points out that we're supposed to use time_after_eq, not a raw >=
operation here, or else jiffies wraps can go unnoticed.  Fix this.

Cc: stable@vger.kernel.org # v6.10
Fixes: 271557de7cbfde ("xfs: reduce the rate of cond_resched calls inside scrub")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/scrub.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -40,7 +40,7 @@ static inline int xchk_maybe_relax(struc
 		return 0;
 	widget->resched_nr = 0;
 
-	if (unlikely(widget->next_resched <= jiffies)) {
+	if (unlikely(time_after_eq(jiffies, widget->next_resched))) {
 		cond_resched();
 		widget->next_resched = XCHK_RELAX_NEXT;
 	}


