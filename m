Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5301E2AEEB;
	Wed, 30 Sep 2026 18:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794800; cv=none; b=InS513lZKEhzVIQ9AWuZeAJr8vSonn2wlZ/Z11HzH5EtAbrPJz9MUUxlrDFMvqZ/Eu4K9caz6ry0/dkvf4WKCtAuKk6EQ+27/GOOA4zNSNmGHHGtzHXYhu3Kw0qK2ndAAUN6hUrCMfka/LRtOoHqlrYWw5VhyMMv0Su4fUnneE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794800; c=relaxed/simple;
	bh=ul/sAmcW/+rKM0rzptFT2NsqJt8h4LN7LVdjoT+BcG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OhQOLqWwlY2yTjplFFzHIZkAUdpragk8ENZ0nGfVx3MMpPelxIxAYDWsxWSNuK7ysQwYhX9ruV97hau2lbv8c+NhXq0IXMiCmHaQuHWSB+RsyYPH9j1bcw+U+iT529cghEFzNvrc5kxFeK4G4az24kHbno5fqXXz4yddEpXXUv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zHnPQlZ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zHnPQlZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADADA1F000FF;
	Wed, 30 Sep 2026 18:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794799;
	bh=5XXZknU52oOxqaqG9yKNtctI5At769KQX/HPnKUpGTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zHnPQlZ5smd+U8sn8Mef/yvGNHTxYgUJtte1X0ZJSsqIRgLn7LeME92vYilpp7bXH
	 Il2ekIVa+GEz3rhxN+VWOeYb0Ao2e4MEcqig26GbsgDZHhYa/JESdUKZ5pM8IGcb1t
	 jrG6beOCjpEBp0ELMn9uKt9idaI6rKLyZyJIufPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0339/1193] vhost-scsi: flush backend after device ioctls
Date: Wed, 30 Sep 2026 17:17:03 +0200
Message-ID: <20260930152441.688043013@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 90a3c0fc5ab0a..7603597efe5ef 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -2095,9 +2095,10 @@ vhost_scsi_ioctl(struct file *f,
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



