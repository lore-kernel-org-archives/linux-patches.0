Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F007E1F09AC;
	Fri, 21 Nov 2025 13:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731202; cv=none; b=E+fRAVGbhevWC61H822jww+7mTER2y0q384Y6nMR1SlM871ZUkf2E0chq/VvQUKfsemv39lSD0jNIXXVS0llWDPeuhjU2hRaKVKmP5/ii4EBNibfQBe/kzH79YIWUqpgR2JQ8+2Aw6//HfJUgqz7eQkLlUsEyswWSuxt0YwsZCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731202; c=relaxed/simple;
	bh=BK1+JPk/DcDzIFVVYl/CN9OiGJA96Iyg7OYlEBK+rzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZZ9DS/Jyr4GqVZRDmV6ydqg+QbHrIq/GD8YeTyE5FcKgK/mJY4jawmKtxFDf+xOEL4La4x8xHb15JWsNKFG5M9oYGWoWzGnzD9NhwWSwXxEGamTV+ReRzuaqmtp5jEbYSopcqvqLw8mhhAiY2Xk7rWUH3WuGl0ChWbK+IKJQP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mu2kfjpd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mu2kfjpd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B55C4CEF1;
	Fri, 21 Nov 2025 13:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731201;
	bh=BK1+JPk/DcDzIFVVYl/CN9OiGJA96Iyg7OYlEBK+rzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mu2kfjpdooMVE5QiW2/P244hdVptaacUamRE5ELXSnnfGFu/+EH1FRLlt6wGlIGBr
	 Szmvsbh3vijrgGtqmJO8kIV/W3kpT+55qfdfmkiUI+2VZLh6NNcTITGpQ/PvE6hI/m
	 IR8g1jbjRltsU09lfeaRTjHnNk9aYXnsjVapFxYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 126/247] virtio-fs: fix incorrect check for fsvq->kobj
Date: Fri, 21 Nov 2025 14:11:13 +0100
Message-ID: <20251121130159.250192591@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit c014021253d77cd89b2d8788ce522283d83fbd40 ]

In virtio_fs_add_queues_sysfs(), the code incorrectly checks fs->mqs_kobj
after calling kobject_create_and_add(). Change the check to fsvq->kobj
(fs->mqs_kobj -> fsvq->kobj) to ensure the per-queue kobject is
successfully created.

Fixes: 87cbdc396a31 ("virtio_fs: add sysfs entries for queue information")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20251027104658.1668537-1-alok.a.tiwari@oracle.com
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/virtio_fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 1751cd6e3d42b..38051e5fba19b 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -373,7 +373,7 @@ static int virtio_fs_add_queues_sysfs(struct virtio_fs *fs)
 
 		sprintf(buff, "%d", i);
 		fsvq->kobj = kobject_create_and_add(buff, fs->mqs_kobj);
-		if (!fs->mqs_kobj) {
+		if (!fsvq->kobj) {
 			ret = -ENOMEM;
 			goto out_del;
 		}
-- 
2.51.0



