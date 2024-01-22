Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DED67E81;
	Tue, 23 Jan 2024 02:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975313; cv=none; b=Lw18f0Qm4s7NQ0jiyCdRs8PY1wE+yVsThIGw7wslf4UfOQrbZ1iA2F1wbk+Uy6wPp9M9pc91UlF/SFBOw8CLEXeFPBnz8HkP4TT2tVaEAhw1p3mT4snfTVljxB0WEPwuzq/fNEXl9YpDTERNkgzpoPc96r/XGCAfBu3bG7REuNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975313; c=relaxed/simple;
	bh=6faO5ETKWNj6CLGa0Gv1OkNfGp2rSghOy4EFU6E5Ip4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djJ42k50WuXIeW4NFWpSRi5lRRa5nxtlHNzcO5xq2F6aAsY7Jweg5tBC1kTECKk3q+1PXVVSe2k5JejJ/q5JlEc4DwljSsTM/O1HnwFDJda96Oi9y+CuZ+uLBU4Mm4oFU3+WmRIbQVrEf8xv25AHh7di43Il8FwLC0Q6sBDqedI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BSs8slJV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSs8slJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D353C433C7;
	Tue, 23 Jan 2024 02:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975313;
	bh=6faO5ETKWNj6CLGa0Gv1OkNfGp2rSghOy4EFU6E5Ip4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BSs8slJVoGT+8oUV4O4rgDEbmv2Gm2J20fyFXFa9QUySvk1wk//5oxxejZkYr87sa
	 65ZyBP8gkkNLL/3ji+HGpDPIJbY20oFs/+1OyxGjdqqgSBHhy0YNLarAZBC2btzQRa
	 p6tCaG+2qZQykd3r2cU/vM+UmDib/F44zkfMIcBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sre@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 254/583] media: v4l: async: Fix duplicated list deletion
Date: Mon, 22 Jan 2024 15:55:05 -0800
Message-ID: <20240122235819.773721006@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Reichel <sre@kernel.org>

[ Upstream commit 3de6ee94aae701fa949cd3b5df6b6a440ddfb8f2 ]

The list deletion call dropped here is already called from the
helper function in the line before. Having a second list_del()
call results in either a warning (with CONFIG_DEBUG_LIST=y):

list_del corruption, c46c8198->next is LIST_POISON1 (00000100)

If CONFIG_DEBUG_LIST is disabled the operation results in a
kernel error due to NULL pointer dereference.

Fixes: 28a1295795d8 ("media: v4l: async: Allow multiple connections between entities")
Signed-off-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-async.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 091e8cf4114b..8cfd593d293d 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -880,7 +880,6 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
 				  &asc->notifier->waiting_list);
 
 			v4l2_async_unbind_subdev_one(asc->notifier, asc);
-			list_del(&asc->asc_subdev_entry);
 		}
 	}
 
-- 
2.43.0



