Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEE434252D;
	Sat, 12 Sep 2026 07:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198598; cv=none; b=cQooCLW4x91QAHOUTevP1knKkxOAXBrdXSSSX7E9ae6egbpkCSlSVX+zy8sUPy3lhYENi837Hu4I0DpJXfDow+tTY5AyDqdgLPGAnPYSunf1iaP2pI7Pi4jluU5SgHhz5O+w7a4rpnAv4u+qfAcIjkmq8iRO058ju7EIjSBujcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198598; c=relaxed/simple;
	bh=uVTUxgcVGabZFMKkvsb7+QDn/4/IIa5T0jrXZfWNM58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NosvhN3XZbTlCSKZxUfGZ6M+DAzIMBPwfD/0lwulOccao9G4yiWQ/S1KqqK1+D8H3hwLYdnoXCZgFmlwW6stSXJf6WnxF6UWvhgTmQJow22Rr+ObLpiKTd/oSnh/ataMelWl9HLD0zeIOXtF6QpCRRARuSLVC8EN4P6i30mky28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V9y5SJnF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V9y5SJnF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F8B1F000FF;
	Sat, 12 Sep 2026 07:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198596;
	bh=AG5mBwIo9uxJokMDXSmbY+fkEtJM9DbIxITzJm5ItVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V9y5SJnFZHUw3R5R+i/Om0JRh8fDzwDktDa2beJPfMii6oyK0AheR0/lRarxth3mi
	 HrZ7kbOt2O/E3omLYCNMFbn503jfh3MiBwtaNe22ep31CjrNNfqjtgeNRb4Fpv9KT0
	 MLDec45lKaoAGpDMtvG871j0UuTHG6Lc4npMOjx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0370/1815] media: v4l2-async: Unregister sub-device if asc_list is empty
Date: Sat, 12 Sep 2026 08:35:20 +0200
Message-ID: <20260912065657.589737078@linuxfoundation.org>
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

From: Hans Verkuil <hverkuil+cisco@kernel.org>

[ Upstream commit 4e72f13d58c4245c177a9d5f54579345554f354d ]

When my em28xx USB device that uses the i2c tvp5150 driver is
disconnected, it crashes.

The cause is that the tvp5150 i2c module uses v4l2_async, but
the em28xx driver does not since it predates v4l2_async.

In that corner case sd->asc_list is empty, so
v4l2_async_unregister_subdev() never calls v4l2_device_unregister_subdev().

Modify the code so that, if sd->asc_list is empty,
v4l2_device_unregister_subdev() is still called.

Fixes: 28a1295795d8 ("media: v4l: async: Allow multiple connections between entities")
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-async.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 0aa4265a67829..460bf3dbbb882 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -897,9 +897,18 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
 	sd->subdev_notifier = NULL;
 
 	if (sd->asc_list.next) {
-		list_for_each_entry_safe(asc, asc_tmp, &sd->asc_list,
-					 asc_subdev_entry) {
-			v4l2_async_unbind_subdev_one(asc->notifier, asc);
+		if (list_empty(&sd->asc_list)) {
+			/*
+			 * If the sub-device was registered through other means
+			 * than v4l2-async, there are no async connections but
+			 * the sub-device may still well be registered.
+			 * Unregister it now.
+			 */
+			v4l2_device_unregister_subdev(sd);
+		} else {
+			list_for_each_entry_safe(asc, asc_tmp, &sd->asc_list,
+						 asc_subdev_entry)
+				v4l2_async_unbind_subdev_one(asc->notifier, asc);
 		}
 	}
 
-- 
2.53.0



