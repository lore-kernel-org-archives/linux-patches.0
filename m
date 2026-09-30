Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDAA51CF5D;
	Wed, 30 Sep 2026 18:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791350; cv=none; b=ufHfywHEykk/fh189Yi4IEi3xs5nRbCAYpSP86N+Qf3UADVaYql99CYT56i3pxEgvbpzL75/s0KD9ltwb4Gk8xTfMIpPgU0rUas9aqVPBJ1pdiAQgjx+1pnnYZVVGwJa34vvS8A4I0+sGWgg9IUt/WEk21KOCaaPj+dHkNLb/Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791350; c=relaxed/simple;
	bh=tN3PjrsS4cbH+uoZiOc10ooLqfrnSawz+yjtjSciueM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jpK1lr0GKBoFUfs2uTESsrGLyD1tVe98r5H6RfNw8bY39w+KjoawdrhWvFQJj9PizmFtA6pqRFrD2UKkNX4fOKq5DKs9Ctf9G603GIYJV9zATUOQUrXElEi80goT5pIbxgbOSIXNSYaFGHvR1TlRCFXjAhTUSRlelgNhtpamNF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IjsDpKLH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IjsDpKLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B119E1F00898;
	Wed, 30 Sep 2026 18:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791349;
	bh=OzZ3KZkrUkThLuzKk5dHHKdTOumNqSdsmD7YaikW8jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IjsDpKLH73x/rOZ7+z/lFG9+EmNswNiTFK99l2y58FXJamWmrpd8aC7cMhamZXifr
	 Yna5rK1T+bMsP346KFbPX8yis1Z71dtnIJw5IM7DuQTZ+w8xZEZ/p8tpqAJGg9Q4Wp
	 GvejXIPN8Uh+QGBOKMGxEakfZ2IUhq74LbmZJ9Bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 226/752] vhost-scsi: flush backend after device ioctls
Date: Wed, 30 Sep 2026 17:21:36 +0200
Message-ID: <20260930152403.148523741@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jia Jia <physicalmtea@gmail.com>

[ Upstream commit 22598f55a4c2b510b3df5e69e563387a963222ae ]

vhost-scsi translates guest response descriptors into userspace iovecs
when commands are submitted.  Target-core completes those commands
asynchronously, so VHOST_SET_MEM_TABLE can replace the memory table while
an in-flight command still retains response iovecs translated through the
old table.

If the old mapping is reused after VHOST_SET_MEM_TABLE returns, command
completion can write the response to an unrelated userspace object.

Flush the vhost-scsi backend after vhost_dev_ioctl() handles a device
ioctl.  This waits for in-flight commands that can still use the old
response iovecs before the ioctl returns.

Signed-off-by: Jia Jia <physicalmtea@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260724060919.1569170-1-physicalmtea@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index ff430b6d2e1f3..fde8e61c236ec 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1900,9 +1900,10 @@ vhost_scsi_ioctl(struct file *f,
 	default:
 		mutex_lock(&vs->dev.mutex);
 		r = vhost_dev_ioctl(&vs->dev, ioctl, argp);
-		/* TODO: flush backend after dev ioctl. */
 		if (r == -ENOIOCTLCMD)
 			r = vhost_vring_ioctl(&vs->dev, ioctl, argp);
+		else
+			vhost_scsi_flush(vs);
 		mutex_unlock(&vs->dev.mutex);
 		return r;
 	}
-- 
2.53.0



