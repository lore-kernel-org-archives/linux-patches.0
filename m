Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0887250E5A7;
	Thu, 17 Sep 2026 17:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665113; cv=none; b=A7xYZd82c9slNh7J7pSzDBMw5ADdDlwN19yekfmchypCHqAMC0gm/x/A6KWe2ATo6yNrwj4CkvprxYgeRmHRPsyqFck02elpqFWdaQ64i0anrDQfVoSbb8eQBvNzFYIp4gmHYEhJStzIXo7NIaHzBoRJfOUCGMdMnp2/LHKZCgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665113; c=relaxed/simple;
	bh=y3L3XuU3Qk055EFc2tuetZ+9cSuMdZIKem4AGABz4Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qorhvO61wr4mf/smASBNCD9Ug7/AvfaMBvEEwtM8cLM0mWJPNViNMujMfFcXADriBIUe9GTe/5orsDQI4Zw9jzmwNnbTmKZBXvGzkrmtxakGaexg0MAOo2Dv9Y+4iUH3fYsQPXxtqTuolmw2XYT+SPgzqKW5XloL3lcPz3ZQCh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EtZdO76I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EtZdO76I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5951F000FF;
	Thu, 17 Sep 2026 17:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665111;
	bh=olyuG0jenuC/i/rkufbDRLbWOfdMDbVTJ35wO42/TaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EtZdO76I1mqmMsR5HpERBBrD5kV021vA46KvHDbwVjBAnfvwOx5auyf8bKIGhVD1p
	 kYPxGyPKbPazVGfQB6wxL3fTjbuAs37quiomUO1ZSCmDtmLSeqeV/jFdNkvsqH1+gr
	 P/bM8110EjoCwG7wjvfl9mdzuM+ogkkksTV0vOok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0559/1250] vhost-scsi: flush backend after device ioctls
Date: Thu, 17 Sep 2026 16:05:54 +0100
Message-ID: <20260917151607.082567058@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 29716ce714554..deb4c8bfd3d57 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -2448,9 +2448,10 @@ vhost_scsi_ioctl(struct file *f,
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



