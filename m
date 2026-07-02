Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7C433F59D;
	Thu,  2 Jul 2026 16:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010160; cv=none; b=sCIn2o0pwh9P7kzpBuWGErOXlz5il39BLG1NjUeIrIgjI1MTiV7xINluHT7fT+XYlWeAJRRgxakwhGk47IsU2CTV5QLQIp3IhIlN+EiN+eMyhgN9ipJ1cC9LAYoiZJLDLP+yNMRvZdUVVoX+le+AlugLmP9VZHcJeTwCLl/vZgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010160; c=relaxed/simple;
	bh=E5s/p/pwYQy+5lz1Jk+Qlc3AlueTebrXbeKnKXCWsFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSIlih9dsz0GsfiuYsy4FwQYicFB9J0B/QA0IDv3yhlOzTZaAUqkyYFOl82c+G3zhZ/WrUWsk+2wi6d68aYI6YHLYduAgvAMy+bIjNx93euOH+Zw44RhWZdhOiFcLToY64myTvagmLL8E2RWDrUy74ACkPZH2ANCeiT60rW4vAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rq0SKOyh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rq0SKOyh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25BF1F000E9;
	Thu,  2 Jul 2026 16:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010159;
	bh=OT8puXY6sJwbk1Izj+Fs/7gYnPpWu4WLZFTScvKk4Jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rq0SKOyheoFnQo4dcK7M+AhK2ymT22mc1Wyng57HTlhj78jsERtd9/4DNX/JjLgtS
	 UHBtQY5IHCtELcz39NTWR5lzI4Zl7HyR6ezdZmkw/HBZTF1q12ivmQCMjMAeTXZLNm
	 grvYd1xukaSrCuS/pmhI3N7GK8Zjqd4UCvc+6z+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deepak Kumar Singh <quic_deesin@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Wen Yang <wen.yang@linux.dev>
Subject: [PATCH 6.1 111/129] rpmsg: char: Add lock to avoid race when rpmsg device is released
Date: Thu,  2 Jul 2026 18:20:30 +0200
Message-ID: <20260702155114.440361596@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepak Kumar Singh <quic_deesin@quicinc.com>

commit 17b88a2050e9d1f89a53562f2adb709a8959e763 upstream.

When remote host goes down glink char device channel is freed and
associated rpdev is destroyed through rpmsg_chrdev_eptdev_destroy(),
At the same time user space apps can still try to open/poll rpmsg
char device which will result in calling rpmsg_create_ept()/rpmsg_poll().
These functions will try to reference rpdev which has already been freed
through rpmsg_chrdev_eptdev_destroy().

File operation functions and device removal function must be protected
with lock. This patch adds existing ept lock in remove function as well.

Signed-off-by: Deepak Kumar Singh <quic_deesin@quicinc.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/1663584840-15762-2-git-send-email-quic_deesin@quicinc.com
Signed-off-by: Wen Yang <wen.yang@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rpmsg/rpmsg_char.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/rpmsg/rpmsg_char.c
+++ b/drivers/rpmsg/rpmsg_char.c
@@ -75,6 +75,7 @@ int rpmsg_chrdev_eptdev_destroy(struct d
 	struct rpmsg_eptdev *eptdev = dev_to_eptdev(dev);
 
 	mutex_lock(&eptdev->ept_lock);
+	eptdev->rpdev = NULL;
 	if (eptdev->ept) {
 		/* The default endpoint is released by the rpmsg core */
 		if (!eptdev->default_ept)
@@ -128,6 +129,11 @@ static int rpmsg_eptdev_open(struct inod
 		return -EBUSY;
 	}
 
+	if (!eptdev->rpdev) {
+		mutex_unlock(&eptdev->ept_lock);
+		return -ENETRESET;
+	}
+
 	get_device(dev);
 
 	/*
@@ -279,7 +285,9 @@ static __poll_t rpmsg_eptdev_poll(struct
 	if (!skb_queue_empty(&eptdev->queue))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
+	mutex_lock(&eptdev->ept_lock);
 	mask |= rpmsg_poll(eptdev->ept, filp, wait);
+	mutex_unlock(&eptdev->ept_lock);
 
 	return mask;
 }


