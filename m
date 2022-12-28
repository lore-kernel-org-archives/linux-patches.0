Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7BD1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6286C433D2;
	Wed, 28 Dec 2022 16:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243896;
	bh=dJgZaAXz44OcIoZ8lj2GbfgRiJ7+2jo3eYjnptDEBUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j+rTi37Rw7h9A3HH9df81v4tpf8kMejpob3q30rnnBekyQsW9pkeHMv5sMAXIK0VL
	 D0R4/FKD8NQHs3AetVOzsZhiGLrqQXKmR4jOexCzESUmYJKsB75aRC3DfGv3rmxxnG
	 /ptkapQ5kXBFxRI/+KAVy26kdHQV0GU5kVbexYY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0574/1146] apparmor: Fix regression in stacking due to label flags
Date: Wed, 28 Dec 2022 15:35:13 +0100
Message-Id: <20221228144345.763098284@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 1f939c6bd1512d0b39b470396740added3cb403f ]

The unconfined label flag is not being computed correctly. It
should only be set if all the profiles in the vector are set, which
is different than what is required for the debug and stale flag
that are set if any on the profile flags are set.

Fixes: c1ed5da19765 ("apparmor: allow label to carry debug flags")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/label.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/security/apparmor/label.c b/security/apparmor/label.c
index 0f36ee907438..a67c5897ee25 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -197,15 +197,18 @@ static bool vec_is_stale(struct aa_profile **vec, int n)
 	return false;
 }
 
-static long union_vec_flags(struct aa_profile **vec, int n, long mask)
+static long accum_vec_flags(struct aa_profile **vec, int n)
 {
-	long u = 0;
+	long u = FLAG_UNCONFINED;
 	int i;
 
 	AA_BUG(!vec);
 
 	for (i = 0; i < n; i++) {
-		u |= vec[i]->label.flags & mask;
+		u |= vec[i]->label.flags & (FLAG_DEBUG1 | FLAG_DEBUG2 |
+					    FLAG_STALE);
+		if (!(u & vec[i]->label.flags & FLAG_UNCONFINED))
+			u &= ~FLAG_UNCONFINED;
 	}
 
 	return u;
@@ -1097,8 +1100,7 @@ static struct aa_label *label_merge_insert(struct aa_label *new,
 		else if (k == b->size)
 			return aa_get_label(b);
 	}
-	new->flags |= union_vec_flags(new->vec, new->size, FLAG_UNCONFINED |
-					      FLAG_DEBUG1 | FLAG_DEBUG2);
+	new->flags |= accum_vec_flags(new->vec, new->size);
 	ls = labels_set(new);
 	write_lock_irqsave(&ls->lock, flags);
 	label = __label_insert(labels_set(new), new, false);
-- 
2.35.1



