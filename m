Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A59A3328FC;
	Sat, 12 Sep 2026 14:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223171; cv=none; b=dk0SyhY7KWhu9N6y12zOydmhtYOLGFqRCzydXLthEg35sdQWBePk7TNUsKqPzufjUR9kIkbEYPy1rJvWYUVn4P12J+0g49rZWn3ZtyXLZuBTRoXbLr1c+inzgFuUR19ZcY+OeypNo6Td/VMmr40q3gkqrzSq9Y1TgA8qF6YegWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223171; c=relaxed/simple;
	bh=XgAVSRcKBLFKVkSa+ftKnWR4Kl1wQsbEIy+eiThUTIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ssG+8si8v0U4WbyUZ47W6KKacRtNNgC37lGSDPtfggS4C6fVLyGI/tYWky2r8pc3DY41UBIx3E90GgdwjrlPJAq1//V+dEe8na1zJ9/nOjapBZdxZPCUwCGYJwuR//RoMDoUuWx3Ogsu3Fp8yvDlzPzXU/d+nBvJIqfqpcs14xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q1tIg0mi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q1tIg0mi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26EB1F000FF;
	Sat, 12 Sep 2026 14:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223169;
	bh=4bAMq2Ks2itj67nrTfYqoRVgZO4rgnauziNrQqGjD+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q1tIg0miCnGpsYXeSlpcDDXZl2oOBmNsLQQKhDVCFj8ITlC6sUAxymwfYWvt5U/rQ
	 eNzCGXGrDxrMF/DSURHXTETdeDBBUmcVs161FXDgjx6Inqr9RRrIyw1ir9sW3IADdA
	 6/2elErsMd3hTRrbG5y7+rEg+XrlVjjy57+4+TQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sre@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0736/1424] media: v4l: async: Drop useless list move operation
Date: Sat, 12 Sep 2026 08:52:48 +0200
Message-ID: <20260912065623.780236812@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Sebastian Reichel <sre@kernel.org>

[ Upstream commit bec3db03911bd85da29c1c8ee556162153002c9a ]

v4l2_async_unbind_subdev_one(), which is called in the line
following the list_move() operation contains list_move_tail()
for the same entry and overrides anything list_move() did.
Thus it can be removed.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: 4e72f13d58c4 ("media: v4l2-async: Unregister sub-device if asc_list is empty")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-async.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 23e4944e2e26c..76fd95c2a4de8 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -895,9 +895,6 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
 	if (sd->asc_list.next) {
 		list_for_each_entry_safe(asc, asc_tmp, &sd->asc_list,
 					 asc_subdev_entry) {
-			list_move(&asc->asc_entry,
-				  &asc->notifier->waiting_list);
-
 			v4l2_async_unbind_subdev_one(asc->notifier, asc);
 		}
 	}
-- 
2.53.0



