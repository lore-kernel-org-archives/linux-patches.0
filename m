Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CB840C03;
	Tue, 29 Apr 2025 18:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949953; cv=none; b=gU33o8fDo6qepAXbXfkrtfs2Hghm9BkIlKI6gZPbqQQwMCxfUtSDRARD3Kw/ylzxOPz48xSdO51DaPhpaxkO9z0nrh/eRLiQeNvzGE1e3WUDhL1K1VwZZQbybErP7Q8SRjXJYHf5SQ8ApwucyqjS0vDqZlttGrDk5Y5jOBNMA1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949953; c=relaxed/simple;
	bh=3Djvvtp2+QZtAPeMxXz5FYR8v7r2wjNxGet/UIX4Bjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZPFU90fn08DaCjxsoWPN9Hi02q5YrZ11rb46YpImWIcTtZwGEHg8CYwCIdLOwz+1uvm/IqDu2kk6hR8jllu7dEHzmATEqKQDOXWcbtPKjARBJemqbl5XhOpgBh3woRTiYN4fpOBQ8k+MoJRQIqhZTxICCkm3JlP+JAXXRGLclo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idss620X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idss620X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410E2C4CEEE;
	Tue, 29 Apr 2025 18:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949953;
	bh=3Djvvtp2+QZtAPeMxXz5FYR8v7r2wjNxGet/UIX4Bjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=idss620XXeA5ggRcDi49togKRfjunJBuk1LNA8N32goDc2hhuT/+1t9eKV7/sqbiC
	 L7Pph3t0spWzB6jkb7eDkFXvvu/KiAICbSg7xTrJZtdcCBI3r3Zb0sT+KDWYwBh74J
	 tclwYoPoSLtgHAZ2ttLfiB/dKUxx2U+rxSJ9Lo0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Yakovlev <anton.yakovlev@opensynergy.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	virtualization@lists.linux.dev,
	linux-sound@vger.kernel.org,
	kernel-team@android.com,
	Betty Zhou <bettyzhou@google.com>,
	Takashi Iwai <tiwai@suse.de>,
	John Stultz <jstultz@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 109/167] sound/virtio: Fix cancel_sync warnings on uninitialized work_structs
Date: Tue, 29 Apr 2025 18:43:37 +0200
Message-ID: <20250429161056.151017326@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: John Stultz <jstultz@google.com>

[ Upstream commit 3c7df2e27346eb40a0e86230db1ccab195c97cfe ]

Betty reported hitting the following warning:

[    8.709131][  T221] WARNING: CPU: 2 PID: 221 at kernel/workqueue.c:4182
...
[    8.713282][  T221] Call trace:
[    8.713365][  T221]  __flush_work+0x8d0/0x914
[    8.713468][  T221]  __cancel_work_sync+0xac/0xfc
[    8.713570][  T221]  cancel_work_sync+0x24/0x34
[    8.713667][  T221]  virtsnd_remove+0xa8/0xf8 [virtio_snd ab15f34d0dd772f6d11327e08a81d46dc9c36276]
[    8.713868][  T221]  virtsnd_probe+0x48c/0x664 [virtio_snd ab15f34d0dd772f6d11327e08a81d46dc9c36276]
[    8.714035][  T221]  virtio_dev_probe+0x28c/0x390
[    8.714139][  T221]  really_probe+0x1bc/0x4c8
...

It seems we're hitting the error path in virtsnd_probe(), which
triggers a virtsnd_remove() which iterates over the substreams
calling cancel_work_sync() on the elapsed_period work_struct.

Looking at the code, from earlier in:
virtsnd_probe()->virtsnd_build_devs()->virtsnd_pcm_parse_cfg()

We set snd->nsubstreams, allocate the snd->substreams, and if
we then hit an error on the info allocation or something in
virtsnd_ctl_query_info() fails, we will exit without having
initialized the elapsed_period work_struct.

When that error path unwinds we then call virtsnd_remove()
which as long as the substreams array is allocated, will iterate
through calling cancel_work_sync() on the uninitialized work
struct hitting this warning.

Takashi Iwai suggested this fix, which initializes the substreams
structure right after allocation, so that if we hit the error
paths we avoid trying to cleanup uninitialized data.

Note: I have not yet managed to reproduce the issue myself, so
this patch has had limited testing.

Feedback or thoughts would be appreciated!

Cc: Anton Yakovlev <anton.yakovlev@opensynergy.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: virtualization@lists.linux.dev
Cc: linux-sound@vger.kernel.org
Cc: kernel-team@android.com
Reported-by: Betty Zhou <bettyzhou@google.com>
Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: John Stultz <jstultz@google.com>
Message-Id: <20250116194114.3375616-1-jstultz@google.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/virtio/virtio_pcm.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/sound/virtio/virtio_pcm.c b/sound/virtio/virtio_pcm.c
index c10d91fff2fb0..1ddec1f4f05d5 100644
--- a/sound/virtio/virtio_pcm.c
+++ b/sound/virtio/virtio_pcm.c
@@ -337,6 +337,21 @@ int virtsnd_pcm_parse_cfg(struct virtio_snd *snd)
 	if (!snd->substreams)
 		return -ENOMEM;
 
+	/*
+	 * Initialize critical substream fields early in case we hit an
+	 * error path and end up trying to clean up uninitialized structures
+	 * elsewhere.
+	 */
+	for (i = 0; i < snd->nsubstreams; ++i) {
+		struct virtio_pcm_substream *vss = &snd->substreams[i];
+
+		vss->snd = snd;
+		vss->sid = i;
+		INIT_WORK(&vss->elapsed_period, virtsnd_pcm_period_elapsed);
+		init_waitqueue_head(&vss->msg_empty);
+		spin_lock_init(&vss->lock);
+	}
+
 	info = kcalloc(snd->nsubstreams, sizeof(*info), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
@@ -350,12 +365,6 @@ int virtsnd_pcm_parse_cfg(struct virtio_snd *snd)
 		struct virtio_pcm_substream *vss = &snd->substreams[i];
 		struct virtio_pcm *vpcm;
 
-		vss->snd = snd;
-		vss->sid = i;
-		INIT_WORK(&vss->elapsed_period, virtsnd_pcm_period_elapsed);
-		init_waitqueue_head(&vss->msg_empty);
-		spin_lock_init(&vss->lock);
-
 		rc = virtsnd_pcm_build_hw(vss, &info[i]);
 		if (rc)
 			goto on_exit;
-- 
2.39.5



