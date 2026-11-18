Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061227;
	b=UoxuI9LV6dBWOhyV6sTfnMU/cEJBfFAHlrnrZitizusBVlv11gH4zuQR2+8m1JDYrpDq
	 6OQCKYl2mbA/knmTVS6UOwopYTuL6jvAzPzJuFaCUFT1+4itIADX/XqTNtbO6jOnFC217
	 maq5F+HMpn8pt24v8R91Uu6865HqKRS+l/gIRsVJxDq1iekUR4LpusYASvQJk8mNZA2Ev
	 RW7j+dm92h4McD2pMe2vffUzhFBmZiJBafabyX1NgvhrrmhNeOAOQ082a3tj1hmQ4OvBm
	 VP+WZt8jDjfAM2IDSlbCKBoLwZY9/3jBOZJj6pWU9pR7PHApZuU561uWRLbtZhkltDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R8OF9W4GhB/CmSp0v6CqaVx4i/AQAXBqFl6e3lYFluU=;
	b=QFvyi/XS5gVbvUJK9hoqMiimpWaA/YKPo3v8FW4q64sBF4mU9tYdf0X3ULvjlU2XjSB+
	 6SVNKSi3ijXAZYO1uWFua6Y0tMn3ypfEbIRxrUSBvaZj6p8y9Eq2Lyc7O7he+7XELspZy
	 AZM8mZWM5mZX5mFRCB4aT61x3O2xlskGQENxGCQhF0ZLOFFY44lbI6v0fYh+39ZfHHNl5
	 +w8U1KyVPj+kejeaWezrjOCDBNcoI6DK3ItL5VoNZXL92Vz0fPvWjTtn3tpu64J5l9dk9
	 8ZsBA22ymL378E+M4c0r+qBetmIBGW2Hm7lon7AToCIxozsH4GG9qzvVRI49Ga2kfYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="agyL/kK6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4FD606A325;
	Thu, 19 Nov 2026 04:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=agyL/kK6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F92B1F000C4;
	Thu, 19 Nov 2026 04:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061227;
	bh=R8OF9W4GhB/CmSp0v6CqaVx4i/AQAXBqFl6e3lYFluU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=agyL/kK6eY/La3zvKAC7VYZd8MOswl+nal0ojn79L9Q7xH7bBrgL5DdubYduUiD1Q
	 YThdfh4ihOXOvyvOKyq29U+ENPqJnFs5Bp3POnsMzPIH05Lwa62qqyIU1D+X8HCjx6
	 tusDIankT96j7pQRe9h3yLK+KUnB7VR+Ripd+DaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Denis Efremov (Oracle)" <efremov@linux.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1478/1848] floppy: flush pending work before releasing resources on init failure
Date: Wed, 18 Nov 2026 15:58:36 +0100
Message-ID: <20261118150021.154145452@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 74c2e2eeb7e51cdeb5e3eceaf324cfcf8dcd0d32 ]

do_floppy_init() probes each FDC with user_reset_fdc(), which queues a
redo_fd_request() work item on floppy_wq that may still be pending when
the probe finishes. When no controller is found, the error path calls
floppy_release_irq_and_dma() to free the IRQ and DMA channel, and only
later destroys the workqueue. destroy_workqueue() drains the queued work
last, so it can run after the IRQ and DMA are already gone:

  floppy0: no floppy controllers found
  work still pending

The flush used to be here. Commit 070ad7e793dc ("floppy: convert to
delayed work and single-thread wq") renamed the label out_flush_work to
out_release_dma and dropped it. Restore it so the work drains before the
IRQ and DMA are released, as floppy_module_exit() already does.

Fixes: 070ad7e793dc ("floppy: convert to delayed work and single-thread wq")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260722034435.13432-1-kmehltretter@gmail.com
Signed-off-by: Denis Efremov (Oracle) <efremov@linux.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/floppy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 8e1a881df16b7..c7a8ca9ef6767 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4798,6 +4798,8 @@ static int __init do_floppy_init(void)
 		}
 	}
 out_release_dma:
+	/* Drain the queued redo_fd_request() before releasing IRQ and DMA. */
+	flush_workqueue(floppy_wq);
 	if (atomic_read(&usage_count))
 		floppy_release_irq_and_dma();
 out_unreg_region:
-- 
2.53.0



