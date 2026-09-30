Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2EA50B8A8;
	Wed, 30 Sep 2026 16:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784824; cv=none; b=STSaNWmajaLxFzDdSoWIoPs6qPsNzQGS8U9dbaZPc3aBeYX0/l2lcuZpj8gLuxH7DwsfZ61lwudORyu0KwU49TxzHlD4LpA6+PaugPi0HVdIoK+k4wIX6GaTF1BYf+y4bhDj2klatvkxJe0CDAYuKSnrik9ri8dVfunsMnfWZxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784824; c=relaxed/simple;
	bh=7GOX+Y3/o0lEga/tCr1f1ycr7kLxfruvQi4vGIwcQPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubixo2pRj5p0YqHse43NgrdP9LKRePdYt609G5lvCe0CQMAoTTtDn2jwlSPKS6keAL6WQbpKdkEzdnKr3cFshZzmYsQsyrXh1l8QbyDSkR0VIIBeXJE8y57jHBifVr8VXQYqBn9qTL3nHGkIIa9uOrA+ehw4XcE0mtLK7OZrDB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oShn4Ux6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oShn4Ux6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C6C1F00898;
	Wed, 30 Sep 2026 16:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784819;
	bh=eb9X8HIDryHC+i084An63e3ZowO54YtfwuMB4jNs1pA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oShn4Ux6xdrqlcyG5XWuPYsX9ZrQstonZy9IprWeO52LEBbeKVWypd82r42/yrtJu
	 DZWZ8bXCF8L8GhsM2FyY3LT7qJD1MmjdDwbcq1YACt+fpL/gWHc5yXgVyNTiajicm0
	 Khsj1cQPdLiasbMIlyubZ9dybkzn4qFFd8JQk1EY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 289/982] vhost-scsi: flush backend after device ioctls
Date: Wed, 30 Sep 2026 17:17:05 +0200
Message-ID: <20260930152423.013231338@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index f9ef17c3e5664..ade822a8c1a3d 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1948,9 +1948,10 @@ vhost_scsi_ioctl(struct file *f,
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



