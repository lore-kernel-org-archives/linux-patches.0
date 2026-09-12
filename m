Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84F437AA97;
	Sat, 12 Sep 2026 08:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200711; cv=none; b=r0356S7YrB16O4qCJTxCXGxPtAkTuXXHOFmaYttWNkRj+Gu5j4tA6OxAXU4Xfq2G5OmcSKD49wmV9LEl1DxDw2aZo0Zv7H3cSHriv7GfHsjwtXTR/nr9UdUeACx2MulmvHahar215EQOesN6tzKALXa9txtNwzTN81f2QwWui8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200711; c=relaxed/simple;
	bh=LjdixlOLDnmRBTKXuKnnsE8euPnksDGTDRD8J5cqL8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJOJqddy2LFZydltwJJE0rwdgS98Qhmf37aprvFh/+tlAmYcmv3Upc8A2euUqdQLg7puddPT10pJGEZm0O01aG/SEX2WQzxh0ETVhsAwLJZfWYjh0i4uZtrQG5P51ICjgUknEPK5tIyrigh3SXlElZn2tp8UrbhdZ+ar/qwtKPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VrMbAfrz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VrMbAfrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC1D1F000FF;
	Sat, 12 Sep 2026 08:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200709;
	bh=iqYyVbgrREYpeTZDr6Bt5dgFXPlrQrhPyTMCj1MnIig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VrMbAfrzr1Pkl66LPqcZCCuvfti/6FLfrYiwpxPs/Ta0iDoWGjXjNsJKiwRO7T2aH
	 o9+7+CNuZ35zt505oGSH7etav4dZ/dqK/j8kUi8+D3NkxOrZi046sU3H+9zl3vSwLI
	 vymSkjhzy94LVhT3f7jg7vjUIx2hcPIikvimRxxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Mykola Marzhan <mykola@meshstor.io>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0846/1815] md/raid1: create serial pool adding rdev to array with serialize_policy=1
Date: Sat, 12 Sep 2026 08:43:16 +0200
Message-ID: <20260912065708.779111738@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Martin Wilck <mwilck@suse.com>

[ Upstream commit 140234b2380ffb8ffb0cfc46fee0e822f43adef7 ]

The following bug has been observed with kernel 7.1.3 after adding a new
rdev to an existing RAID1 array with serialize_policy enabled:

  Oops: 0002 [#1]
  CPU: 0 UID: 0 PID: 19639 Comm: ext4lazyinit Not tainted 7.1.3-1-default
  RIP: _raw_spin_lock_irqsave+0x27/0x50
  CR2: 0000000000004960
  Call Trace:
   wait_for_serialization+0xb9/0x260 [raid1]
   raid1_make_request+0x762/0xaff [raid1]
   md_handle_request+0x1c9/0x2e0 [md_mod]

The raid1.c code calls wait_for_serialization() if the MD_SERIALIZE_POLICY
is set, and wait_for_serialization assumes that rdev->serial is
initialized. Normally this will be the case for arrays that have
the serialize_policy sysfs attribute set to 1.

But when a new rdev is added to an existing array in bind_rdev_to_array(),
the condition at mddev_create_serial_pool() causes creation of rdev->serial
to be skipped. Fix it.

Fixes: 69b00b5bb235 ("md: introduce a new struct for IO serialization")
Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Mykola Marzhan <mykola@meshstor.io>
Link: https://patch.msgid.link/20260723112741.1206836-1-mwilck@suse.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a3f5ea17a1b41..17f9d494dc48f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -235,7 +235,8 @@ void mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev)
 	int ret = 0;
 	unsigned int noio_flags;
 
-	if (rdev && !rdev_need_serial(rdev) &&
+	if (!test_bit(MD_SERIALIZE_POLICY, &mddev->flags) &&
+	    rdev && !rdev_need_serial(rdev) &&
 	    !test_bit(CollisionCheck, &rdev->flags))
 		return;
 
-- 
2.53.0



