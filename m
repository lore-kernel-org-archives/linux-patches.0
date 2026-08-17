Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB263E2ADD;
	Mon, 17 Aug 2026 13:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974712; cv=none; b=WgdM6BtY2VMZ9WJXRH8ERnnl8vteeUaOEa9kYLuMftdCin8nYS5iQx6cn7wweijKybEGpHyxakVvxL9vjPRSRNVnIlUL/X1Rs+bl6cQk7TPTt+71RCOrIGr31WuK3ZeP1PnSK6IrsyaFKuXmvgWOU9lUdVjDJypSdw7P+CH6UKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974712; c=relaxed/simple;
	bh=L6omE8h/sx4g6Ux+wgklGIuDJhkHL3LdkUyXFs+YKi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jZPdnVx0/RoVq+9FKSynrTdD+F08vDeFSNqY4rZnjvW6ko00qV71mRBT0ItBFe5+cWeRXsBdT8Q59RENxGydvB1pJTyVQa3BOBTA8ZOZg/VKt7poR4PivmgaUYrEWRkRs6EW4Ure/yCHOJeXK0x3VPZb7msCS8LaZoJj4pnsJHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BhZTVxps; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BhZTVxps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507081F00A3A;
	Mon, 17 Aug 2026 13:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974706;
	bh=lYmRMHOMZ8NsWtaMm85WmEMfiYie8UzsREM6ZoEZO9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BhZTVxpsJmcUTStxB9zm2l/L65l49wxD5ZV8tys7joaJiymovBZuH4DUkeZbIwnB1
	 xNKDliR9KxO1fmKnWOeRvRdd+ZPj52rawO70VD63cQYbvuvusQdvjtWFtJ3eqY9w/9
	 XxxLCRIWzTRt84sMlYWJdr/HxhaBlh2ckZ86mSQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 003/250] sched/fair: Separate se->vlag from se->vprot
Date: Mon, 17 Aug 2026 15:29:24 +0200
Message-ID: <20260817132536.604354574@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Ingo Molnar <mingo@kernel.org>

[ Upstream commit 80390ead2080071cbd6f427ff8deb94d10a4a50f ]

There's no real space concerns here and keeping these fields
in a union makes reading (and tracing) the scheduler code harder.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://patch.msgid.link/20251201064647.1851919-4-mingo@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5dea369fcfc96..fa02b2254905c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -587,15 +587,10 @@ struct sched_entity {
 	u64				sum_exec_runtime;
 	u64				prev_sum_exec_runtime;
 	u64				vruntime;
-	union {
-		/*
-		 * When !@on_rq this field is vlag.
-		 * When cfs_rq->curr == se (which implies @on_rq)
-		 * this field is vprot. See protect_slice().
-		 */
-		s64                     vlag;
-		u64                     vprot;
-	};
+	/* Approximated virtual lag: */
+	s64				vlag;
+	/* 'Protected' deadline, to give out minimum quantums: */
+	u64				vprot;
 	u64				slice;
 
 	u64				nr_migrations;
-- 
2.53.0



