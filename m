Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D2F49D58C;
	Thu, 17 Sep 2026 18:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668539; cv=none; b=i1pC1YHg3gzh/w74C//PS2Bo5dQ6y6OGEPhZJNOhzDNwVe16/D7hGs9UCodxol5LzmlNsoOCG71KuWl5v3SbKjI+ZPlnnHPtcBhlgK0+LArG4SHIEVhLfCGCtVp/gB7MEP2NRXrRhYgNUQe187HRnZvzI655+oHG186tE635Ctc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668539; c=relaxed/simple;
	bh=A5tB87SMcm8xhMdSW+XCjkZdXzrxJDOIH7leI7OjOrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YcZ0eTPtrMCzf2m7a3aHOcM1H6MIQ1/JPrTyLRzMl/0jcWGlZ4wh8qqYWfK3YTDJf2hraDiKdNEWwSFjmL4qEv68hHEK21r9/vuguwjFXcwq74+hF8D2+zSIO24rmqhNAHcHe6zJjZtZdUarv+mwo6MbTqpwrSpNNc7wY4KOxJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gESE5vN7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gESE5vN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067A61F000FF;
	Thu, 17 Sep 2026 18:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668537;
	bh=0xZqpIOKCDoQZcXmarkVEkHnB67slQ3gMTf5R829GCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gESE5vN7kJ+sGhKxvkijigoHQ2Sty3yiHbSjMpK4du/eSS2Hwi5kEYr/zBH6b+dz2
	 bjlSLbL0UZ5gKeYZSpgSJgnUhLBNGi6BG1pMoX16L0W6dzMolwmzE892E1q1+WzFgj
	 EFoy8nziKsxgkz+mVHMe48V4QHiUknlmbPisXPyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0456/1102] vhost-scsi: flush backend after device ioctls
Date: Thu, 17 Sep 2026 16:06:39 +0100
Message-ID: <20260917151551.135208189@linuxfoundation.org>
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
index 88f213d1106f9..fa0d407442914 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -2158,9 +2158,10 @@ vhost_scsi_ioctl(struct file *f,
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



