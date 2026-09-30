Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C29351993C;
	Wed, 30 Sep 2026 16:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787164; cv=none; b=XrgLqMcwNG/P2yv8cuO/UgwWusyulxypQNzXIA+Gepgqrc14hS4po4fRjcOCh+HgJ6EC1WoVnAuV5skv2dswF7q5o+DSm/QsEKnwvrz6jFR5Xz8srwiXz/gyYlE7lv/zkIpneVUtT4oQseumiNVLxeKqBBFKZ/JkwtDOywmXuTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787164; c=relaxed/simple;
	bh=mMCdi+YCIZMhmr1JxQfmcIc+X64qaGXZf1RbMhsfVxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1916AzzUQ5VXssLyEhqZWXw0Etguy2V4Bj5tABF/LHOs25xMlileQMvhycZcuIPSnB4CSEfuIUxxDHxOiI3Hy/1zPBozwp0/gy36e2vIO4Q/i+kzKKuyKV2X+cYkW0UYXq4TQyuBW1WqehE1zW//W6BWz8WTFn9mLlCHt7EyAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3ap7Fhu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3ap7Fhu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F231F000FF;
	Wed, 30 Sep 2026 16:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787163;
	bh=Mk3NJc9ySqKHSHAA1D2R6WKubkfxrG5Bx+Th4DkDN/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O3ap7FhuJKBdfk5BdJWy1+VLm38Z1tnRoufZqZMvwYXL/hLFZTZ1cgW+pTvj98gE+
	 0OtkJv4cTfGs6jlnkJuj54cOUgNPhQRSYMaPVkk4kqOxL8/tpALiJnOeXrTQ75kN9c
	 U8qmVV+JRtaspGHuZLKonikDECbHJ7LvN6OLfgFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 134/457] dpll: use exact lookup for reference sync pin id
Date: Wed, 30 Sep 2026 17:23:59 +0200
Message-ID: <20260930152348.939287263@linuxfoundation.org>
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

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 7cce782d8327b7291334c4a304cf3fd909a74d9d ]

dpll_pin_ref_sync_state_set() looks up the reference sync pin in the
pin->ref_sync_pins xarray, which is keyed by the sync pin's id (see
dpll_pin_ref_sync_pair_add() using xa_insert() with ref_sync_pin->id).
The pin id to operate on is supplied by userspace via DPLL_A_PIN_ID.

The lookup however used xa_find() with a ULONG_MAX limit, which returns
the first present entry with an index greater than or equal to the
requested id, not the entry stored exactly at that id. If userspace
passes an id that is not paired as a reference sync pin, but another
pin with a higher id is present in the xarray, xa_find() silently
returns that wrong pin and the subsequent ref_sync_set() operates on
it. The request only fails when the given id is larger than every
present key.

Use xa_load() for an exact-key lookup instead, mirroring the deletion
path in dpll_pin_ref_sync_pair_del().

Fixes: 58256a26bfb3 ("dpll: add reference sync get/set")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Link: https://patch.msgid.link/20260917143736.526221-1-ivecera@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/dpll_netlink.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
index 9e55745e33e4f..9f274c6253c66 100644
--- a/drivers/dpll/dpll_netlink.c
+++ b/drivers/dpll/dpll_netlink.c
@@ -1282,8 +1282,7 @@ dpll_pin_ref_sync_state_set(struct dpll_pin *pin,
 	unsigned long i;
 	int ret;
 
-	ref_sync_pin = xa_find(&pin->ref_sync_pins, &ref_sync_pin_idx,
-			       ULONG_MAX, XA_PRESENT);
+	ref_sync_pin = xa_load(&pin->ref_sync_pins, ref_sync_pin_idx);
 	if (!ref_sync_pin) {
 		NL_SET_ERR_MSG(extack, "reference sync pin not found");
 		return -EINVAL;
-- 
2.53.0



