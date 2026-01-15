Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388582F619D;
	Thu, 15 Jan 2026 17:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497212; cv=none; b=SfCrgesLfZroHw/MjoPLfMNrh3oDLQdQV+x/ag5Cv+wL7TmKfzhFpdd7gPe633AID9O/kmZU3c3loWz+Z9DmlDWUjtwJ/NFZNV8qxEvnZ/N8pl4TpdNT13h2tG4XKz3+vy7pkCwcBLy+eaA9YgglI+cQ9zEHZzDUB8R8UPLrxRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497212; c=relaxed/simple;
	bh=XOhfUfPwTjrqjjyxaQQ9Fb7Sq0uWsFAmMJlXFP0N+t0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3UF4+fSFjkcVJCJRqJooqe47wTjaViLNaVwfpcVF6qvUq5Cb0OMkR6zUApzugNbnp4zE0caUqXhydTkPLCZj95t1lEh+d9hT1MrLGfFgqQQrpkf1izmioy+gvVnEwRsPLF18JbY2o+NVZIUpExK0lUDN0RForpNpiBdRO5mEtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6HAQByv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6HAQByv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B728FC16AAE;
	Thu, 15 Jan 2026 17:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497212;
	bh=XOhfUfPwTjrqjjyxaQQ9Fb7Sq0uWsFAmMJlXFP0N+t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v6HAQByvC0iLrPQ3nAqJD8ahLC9md9kMXwMBOjqt9NEE8kfKzFzwU8Hk4ksBe3Tk2
	 uhDqqbnrwiwNQKCo00kam0HchIIK/FpbWisABxPpgcL58uUZfcLpNqpH1Jo3PBM6LS
	 TPJ37+UOBfEJ8Sa/iT2kRpAJ7wKWHeCVB+D82Et4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 56/72] ALSA: ac97: fix a double free in snd_ac97_controller_register()
Date: Thu, 15 Jan 2026 17:49:06 +0100
Message-ID: <20260115164145.528359848@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit 830988b6cf197e6dcffdfe2008c5738e6c6c3c0f ]

If ac97_add_adapter() fails, put_device() is the correct way to drop
the device reference. kfree() is not required.
Add kfree() if idr_alloc() fails and in ac97_adapter_release() to do
the cleanup.

Found by code review.

Fixes: 74426fbff66e ("ALSA: ac97: add an ac97 bus")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Link: https://patch.msgid.link/20251219162845.657525-1-lihaoxiang@isrc.iscas.ac.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/ac97/bus.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/sound/ac97/bus.c
+++ b/sound/ac97/bus.c
@@ -299,6 +299,7 @@ static void ac97_adapter_release(struct
 	idr_remove(&ac97_adapter_idr, ac97_ctrl->nr);
 	dev_dbg(&ac97_ctrl->adap, "adapter unregistered by %s\n",
 		dev_name(ac97_ctrl->parent));
+	kfree(ac97_ctrl);
 }
 
 static const struct device_type ac97_adapter_type = {
@@ -320,7 +321,9 @@ static int ac97_add_adapter(struct ac97_
 		ret = device_register(&ac97_ctrl->adap);
 		if (ret)
 			put_device(&ac97_ctrl->adap);
-	}
+	} else
+		kfree(ac97_ctrl);
+
 	if (!ret) {
 		list_add(&ac97_ctrl->controllers, &ac97_controllers);
 		dev_dbg(&ac97_ctrl->adap, "adapter registered by %s\n",
@@ -361,14 +364,11 @@ struct ac97_controller *snd_ac97_control
 	ret = ac97_add_adapter(ac97_ctrl);
 
 	if (ret)
-		goto err;
+		return ERR_PTR(ret);
 	ac97_bus_reset(ac97_ctrl);
 	ac97_bus_scan(ac97_ctrl);
 
 	return ac97_ctrl;
-err:
-	kfree(ac97_ctrl);
-	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(snd_ac97_controller_register);
 


