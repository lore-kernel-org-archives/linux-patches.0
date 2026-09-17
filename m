Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A13B503914;
	Thu, 17 Sep 2026 17:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667388; cv=none; b=o7HNEnUR7p640QJC/hx1QS21RCLGKZMlGf88nbMVZcb18XvwArbY8KoZpuP35XQQUXnh6hFHGCOSJ3irsCsNtMENSQNjE785D7stEnaL3QS2fmXNWLWNjGNPPjKf5cC541n9yE/kc+cL1q1ktfDPWFC96LH25II9qAElgieoVek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667388; c=relaxed/simple;
	bh=GWvhe9eM3lxC9+G/L51ld4rnls3HJsqHkZEEIMcHp3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pD5LIstTmC3qIzYMztyVvKvCO6t27g1wsvrQLvLBZGmzzFFLk5/AU5k357V8Agtx6jiQrakNgb68PeXKlCkFKlOC3OsLP5tYtmNRGacaZlduw4CnvCygrNj9mVXJ+qB3akh8EiqbHSXeC6CpoEZyvjBiGnlsuCg979mbvx/ygO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=doeepDqv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="doeepDqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CB61F000FF;
	Thu, 17 Sep 2026 17:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667387;
	bh=UgUgkRrIlOWHN5Fyw7P2+KMj2uNq8CsEkv5x61JgcbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=doeepDqvd6QjxlwJ37XW126mT5fBdpot+IZXK8NtpAJetwNJoknImSZs+DsYM+RY+
	 IubPEiXuZAiT6cpJ5uVz/gOWgeX5iGcaV+/AmNDawlIgoiKPnBJ+f1EphPjGOCJI8w
	 /rgP34O7WxjxTsAlYt5q1FXX7y6ULdgKjvUlYd18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arash Golgol <arash.golgol@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0075/1102] media: video-i2c: use vb2_video_unregister_device on driver removal
Date: Thu, 17 Sep 2026 16:00:18 +0100
Message-ID: <20260917151541.352265944@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Arash Golgol <arash.golgol@gmail.com>

[ Upstream commit 56384b486b80ce4a2bc93689aae49995f908f90d ]

The driver uses vb2_fop_release() as its file release operation, so
vb2_video_unregister_device() should be used instead of
video_unregister_device() during driver removal.

This ensures that the vb2 queue is properly disconnected before the
video device is unregistered.

Signed-off-by: Arash Golgol <arash.golgol@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/video-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
index e6b932e32ed7d..a091fd6d3e607 100644
--- a/drivers/media/i2c/video-i2c.c
+++ b/drivers/media/i2c/video-i2c.c
@@ -908,7 +908,7 @@ static void video_i2c_remove(struct i2c_client *client)
 	if (data->chip->set_power)
 		data->chip->set_power(data, false);
 
-	video_unregister_device(&data->vdev);
+	vb2_video_unregister_device(&data->vdev);
 }
 
 #ifdef CONFIG_PM
-- 
2.53.0



