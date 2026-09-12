Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5604C2F617C;
	Sat, 12 Sep 2026 12:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215592; cv=none; b=eyNLSLIDPOxVhWI89krD8eWP8G+MHYUL39BkI6zsdA+Q2uv5I3fXLske0Q35KzRAWbej0kHAQ7EluODh1VX+aiDVF4XTkEnnz792rBnwecKMqxBTYZIOU4FIygHRt26nanZozDo83tW/0yaD2vYU4e0a4mt51z9550EQUed8TK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215592; c=relaxed/simple;
	bh=kX+SFMsBw3DbgmRrvVK7J3A3Ldhhh7u707QezTlKEiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YoCfyCs0UYhbsz+ahP1SOU46f10JnqS4REu0FCJWvZrdtqcsWBQHEeKMR1ibDrKCq5fnh23fyihbZTnNJH/8rQ2oHLQfM4kVTYEVyQnnxTDzbzfOh1M0NvQgKXSTTYGQkWiAmMRruxA862Dgg6vfQH1LLWH4zWdew3Ecy4GCNbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TyQuJhq5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TyQuJhq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A6F1F000FF;
	Sat, 12 Sep 2026 12:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215591;
	bh=sgbHL/mGI4pqOFMn9tgdU7Ww7Qmf3aFKVWGyoRf6lQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TyQuJhq5sfYZJLmzs6Tk3t5yCjHKULArMclcc6ALPvK74rLfSWoKnWA2Awy49bbD9
	 9GH7CmjOo7pkH7pmCY1qc7qbQA9cxCwtSPhsAYnk8y2mgtx2nM941tcm7qWY0wWxJ8
	 Bq5ivqa656kSk5LwY58famgIwj/tNPXTky/jNWpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0520/1376] media: v4l2-async: Unregister sub-device if asc_list is empty
Date: Sat, 12 Sep 2026 08:49:06 +0200
Message-ID: <20260912065619.126532390@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 70284f50e1f93..5f6685e34d90f 100644
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



