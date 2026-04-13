Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2722765FF;
	Mon, 13 Apr 2026 16:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096620; cv=none; b=dFP3likp0MDLpLwvDMwdEdl1LAA6cdupQxC4GjKDp3y52Ac/bcwFmJlcE48LLPschUriRJLjpJiqRBws/MXy77hpcgFgDoUOZpl7Znr5RdWWhyFhiRa4KAN8LCxolPnr5HcstFRXbyM/DwTIiphOnv96K0AxF6QawhSRU8+b8C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096620; c=relaxed/simple;
	bh=U9Yp+E07+t+XxMDIv2XhbLsGch/iN22U2iJDBfPsK5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YsxJuqh0Dq6gZ/Zi6xwYcRtQ2mxaS6DDechyAO2uMAXDt5FWmePMAe67jC971Om2CZHv0omZ1UEnMHNVImd795OqjYnB066ttzI0HMRFtMiAMkR3Kvg2BAmvehbiwbBy0Kfx6jzjiTexELeIAkxwlUcVGyev5YKrqtK1HtkFlYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DRmeaUHL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DRmeaUHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B706C2BCAF;
	Mon, 13 Apr 2026 16:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096619;
	bh=U9Yp+E07+t+XxMDIv2XhbLsGch/iN22U2iJDBfPsK5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DRmeaUHLt/nuyt61kC9keWpXEPHbkbeK9IBj8pfWN85p7KckZRbOU98B4vxD71+vh
	 Q8802RofESlVgyfxF04qlWM2tRxNr4jr1OgDLJIz6BqYB8Hmc2Y9g4Jl+4r668OTb4
	 9GrYZOJ9OBrijo3kE2nDo2uqGI1y9UX3GAugk6zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 49/83] mm/damon/sysfs: dealloc repeat_call_control if damon_call() fails
Date: Mon, 13 Apr 2026 18:00:17 +0200
Message-ID: <20260413155732.847053727@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

From: SeongJae Park <sj@kernel.org>

commit 0199390a6b92fc21860e1b858abf525c7e73b956 upstream.

damon_call() for repeat_call_control of DAMON_SYSFS could fail if somehow
the kdamond is stopped before the damon_call().  It could happen, for
example, when te damon context was made for monitroing of a virtual
address processes, and the process is terminated immediately, before the
damon_call() invocation.  In the case, the dyanmically allocated
repeat_call_control is not deallocated and leaked.

Fix the leak by deallocating the repeat_call_control under the
damon_call() failure.

This issue is discovered by sashiko [1].

Link: https://lkml.kernel.org/r/20260327003224.55752-1-sj@kernel.org
Link: https://lore.kernel.org/20260320020630.962-1-sj@kernel.org [1]
Fixes: 04a06b139ec0 ("mm/damon/sysfs: use dynamically allocated repeat mode damon_call_control")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1623,7 +1623,8 @@ static int damon_sysfs_turn_damon_on(str
 	repeat_call_control->data = kdamond;
 	repeat_call_control->repeat = true;
 	repeat_call_control->dealloc_on_cancel = true;
-	damon_call(ctx, repeat_call_control);
+	if (damon_call(ctx, repeat_call_control))
+		kfree(repeat_call_control);
 	return err;
 }
 


