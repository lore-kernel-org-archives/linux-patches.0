Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498CB4FE2F2;
	Wed, 30 Sep 2026 16:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786865; cv=none; b=p7yr/3yPYaRy4l7pgELP4VHTmYS+5gknSVPugyAwcAtsCwfFohYFGDmbA8rA86+HlgK/PAnB/LDOFdCpuxUQZkwFwTGUzdfOPlr114vfbHAJ5lRxXjbOULAXS/uC11GA3yEvOOHVZJjino2vOfbFaxuHj1FfGZ9XkYCkjeHkgGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786865; c=relaxed/simple;
	bh=wPQnbyBZmuuEJGeFdBVIhjbzsEZ521GA31blD7pEzgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2b9EpovvANWyYOOAuw/b41fdJHlbgwsfE9hlwYEi4zCLcKhfD7BHfeaBdDxmUSoFlBmVmmq2hKA7ID5QtQzAL2ANHV9YBp7HTsr4t4HC/gOwDE6eQyu0rMkZvs4klb8ZUK2oBUIgmbmD9UpHGRVdQvml5ZapSd/MKkhpGx19tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qeSeylRv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qeSeylRv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41351F000FF;
	Wed, 30 Sep 2026 16:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786864;
	bh=gaJzHnh/YhKHauU+1GR+zldO8zapfbcW92bTBIkCCDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qeSeylRvazBPWP/DXvUtqeKirwLMfNMs2HH61mrTCU+QZXJi2c55+WXbGsxqoZVDi
	 lHUxbfuCWZLMo/hnEARAZxXwwqlwE1WDN81MnZA7i8JrY6qVzqyRWCnqgoJChtXQ92
	 zEZ6u4YAlOCuI1ylPGN+L9oy8BVJvQgMlReO8yP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 012/457] KVM: s390: Fix race in _destroy_pages_crste()
Date: Wed, 30 Sep 2026 17:21:57 +0200
Message-ID: <20260930152346.296599661@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit 4ca00a9154f998116fba9a32cce5bd938d228065 ]

Use READ_ONCE() in _destroy_pages_crste() to read the crste, avoid
dereferencing the pointer multiple times.

Fixes: a2c17f9270cc ("KVM: s390: New gmap code")
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260828115439.145885-9-imbrenda@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/gmap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
index 8abb4f55b306b..f11d4ecaef7be 100644
--- a/arch/s390/kvm/gmap.c
+++ b/arch/s390/kvm/gmap.c
@@ -991,11 +991,13 @@ static long _destroy_pages_pte(union pte *ptep, gfn_t gfn, gfn_t next, struct da
 static long _destroy_pages_crste(union crste *crstep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
 {
 	phys_addr_t origin, cur, end;
+	union crste crste;
 
-	if (!crstep->h.fc || !crstep->s.fc1.pr)
+	crste = READ_ONCE(*crstep);
+	if (!crste.h.fc || !crste.s.fc1.pr)
 		return 0;
 
-	origin = crste_origin_large(*crstep);
+	origin = crste_origin_large(crste);
 	cur = ((max(gfn, walk->start) - gfn) << PAGE_SHIFT) + origin;
 	end = ((min(next, walk->end) - gfn) << PAGE_SHIFT) + origin;
 	for ( ; cur < end; cur += PAGE_SIZE)
-- 
2.53.0



