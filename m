Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212EF8837;
	Mon, 28 Oct 2024 06:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098330; cv=none; b=Bf4zeyDartWTkdEAYmedPH+5Ev8v9tFJhs+JnGrFTmjklVdObT3/19A2h5dMQmk/rLww4wDWAn2t6ZOIzo0BOzpEfexre2xYPAS+Q9s7Xrkoe0d2YH0iJeSuQKHh8vpEyH3BzM7haTcKRHN6R/WJVB7jBO3Rau+OdidGiq19ZVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098330; c=relaxed/simple;
	bh=updfxUtZG2sV3OrBbSkxxoFPzzIC3MRNUa2ufH5QjoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOz8hIbvxeGkoAYNJ1DLwTTfqLbu1+kbBUcEva8q8evi9mW8E7x9SlCjXp/3pCpM1QzLVpGDKhlXtw8hi4ML2RDM7GlKgJlxaPgIhBPrDsqFVwAl3zp8RuXq7rqHRM1gDHWRRp9JZGj40veOUhM6HuxG9LVu9Z4C/i3Vs+Cy04Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGMIVIdy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGMIVIdy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A14C4CEC3;
	Mon, 28 Oct 2024 06:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098330;
	bh=updfxUtZG2sV3OrBbSkxxoFPzzIC3MRNUa2ufH5QjoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lGMIVIdy72MoCChdxXT8GXBQTfBgMeOkPFRlGPrzBh01ooTsDBL9Y3fMPcuaxeNJC
	 jHJkqAblmIQN37igJS1OMFMZ2lVQStgDNq/NUBU0wS32Gj/P1wFxlgrsok8jZdGwzI
	 /5ebPdafH1K9NZ2mxMwWUt9tKnA3Psyqr+oGAByc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cc39f136925517aed571@syzkaller.appspotmail.com,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 143/261] xfrm: validate new SAs prefixlen using SA family when sel.family is unset
Date: Mon, 28 Oct 2024 07:24:45 +0100
Message-ID: <20241028062315.627320638@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 3f0ab59e6537c6a8f9e1b355b48f9c05a76e8563 ]

This expands the validation introduced in commit 07bf7908950a ("xfrm:
Validate address prefix lengths in the xfrm selector.")

syzbot created an SA with
    usersa.sel.family = AF_UNSPEC
    usersa.sel.prefixlen_s = 128
    usersa.family = AF_INET

Because of the AF_UNSPEC selector, verify_newsa_info doesn't put
limits on prefixlen_{s,d}. But then copy_from_user_state sets
x->sel.family to usersa.family (AF_INET). Do the same conversion in
verify_newsa_info before validating prefixlen_{s,d}, since that's how
prefixlen is going to be used later on.

Reported-by: syzbot+cc39f136925517aed571@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 55f039ec3d590..8d06a37adbd95 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -201,6 +201,7 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 {
 	int err;
 	u8 sa_dir = attrs[XFRMA_SA_DIR] ? nla_get_u8(attrs[XFRMA_SA_DIR]) : 0;
+	u16 family = p->sel.family;
 
 	err = -EINVAL;
 	switch (p->family) {
@@ -221,7 +222,10 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 		goto out;
 	}
 
-	switch (p->sel.family) {
+	if (!family && !(p->flags & XFRM_STATE_AF_UNSPEC))
+		family = p->family;
+
+	switch (family) {
 	case AF_UNSPEC:
 		break;
 
-- 
2.43.0



