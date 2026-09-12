Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC241E5B9F;
	Sat, 12 Sep 2026 11:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211751; cv=none; b=F5xRdW52dU4OBwQ1FG27XIA0YywRzACbMVm6kvmkQ7K9dfBd0x3SVcQValrbPb9qemyV7T6WUMnX83zC9spaMVhmOI0OY+W+wNbCl6d0q410xvh2nJX0HlqYO9l/keQ2kkcYraYDulXVVRH5fVua9a+W8fER16gHIgECdb7dOKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211751; c=relaxed/simple;
	bh=WR3OU8hbNh9rf4lMmsS9Y1RQ7ivO0ITK0u4KYMsPRaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CjMEYrwnF5Q2B9EXARGYqwwNKUpub7Ff5bruleQqqPw6PPxHh5EtGBDkgf3mGPLSjUdC8+P3kganozb6q+TgbeBGlAWGZU98zYC8tJvvNUmhEaCk2GJeVPQMcNitXotjIj+2AarGCf1RainJ3FD2//3m2WCNQ1t0r/iSKTGalTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4ko2RL8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4ko2RL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69DD31F000FF;
	Sat, 12 Sep 2026 11:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211750;
	bh=v5iSFI2K/5caEul6eklPYeilKJvxzdeSTzCQENLXGDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z4ko2RL8lNvWrJIuQtrk3Cz+FCSF3OfGLLWBqjIAPhl/wRls9wzgBD5eTihJ2HMUh
	 X8O23YDEoOEUXrzGmfA0Fo/aLtvZHea52I/Y4EXg7fpfY0r3K/NWY+SuSVSop8Jvs+
	 TTnTT4Jl9WrZZzcnl2Dd8OtwJXGnqpfsrCfugg3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yufeng Wang <wangyufeng@kylinos.cn>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1296/1518] vhost/net: fix clear_user start address in VHOST_GET_FEATURES_ARRAY
Date: Sat, 12 Sep 2026 08:57:45 +0200
Message-ID: <20260912065652.833909475@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yufeng Wang <wangyufeng@kylinos.cn>

[ Upstream commit 92a7b138f2453bf067628de0c5ec563cc8ad16d5 ]

The clear_user() call in VHOST_GET_FEATURES_ARRAY incorrectly starts
at argp, which is the beginning of the features array, overwriting the
data just written by copy_to_user(). It should start after the copied
elements at argp + copied * sizeof(u64) to only zero the trailing
unused space.

Use size_mul() for both the offset and length calculations so the
arithmetic stays consistent with the surrounding code and remains
overflow-safe.

Fixes: 333c515d1896 ("vhost-net: allow configuring extended features")
Signed-off-by: Yufeng Wang <wangyufeng@kylinos.cn>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260626070438.59149-1-r4o5m6e8o@163.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/net.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 89d5438ba7af9..72bd44f2f1428 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1778,7 +1778,8 @@ static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
 			return -EFAULT;
 
 		/* Zero the trailing space provided by user-space, if any */
-		if (clear_user(argp, size_mul(count - copied, sizeof(u64))))
+		if (clear_user(argp + size_mul(copied, sizeof(u64)),
+			       size_mul(count - copied, sizeof(u64))))
 			return -EFAULT;
 		return 0;
 	case VHOST_SET_FEATURES_ARRAY:
-- 
2.53.0



