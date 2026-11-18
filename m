Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056283;
	b=iINa0/YCf6+x2ZtwtVXrx4EkR1NxDD4XuxOly87J1wRLv7wowrXeRTObD6zQWJPKdyeu
	 wM1e6NbIJk1jdgMPgJxvhntGMEAv7/Y5tTQcOsnl0dxAO/rp9Y7LrPxFjlgrT6Eg4KaBJ
	 Syz8Fk+cy9+PhycPFSc78ncRlnnCjeKbBgIfNUs0v5Idyx1CpYAoJ6tQ7xKF3iQcY7xks
	 eNACkELCY+kR4owL8EfxcVApTLnjP09ekZT6wfSjLH3EsduZeddVD99l0cJMgEkRRsckt
	 Did5nc92ipfI8hGuHX1V3ZMf4tSR6K73XN0mim2B41ZNNxcojLu7GcLKJmKb5/aSDBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zYQ4HRO95PGZ9Dck1v/lA394My+7amxPYJzuy0fpcm4=;
	b=IGzFw+sjOT5gFvGUv3n7jDNxjENEgaTo6D9p7dSWANCYZPPT2oLyjTvzHI7upGffcwEn
	 jM1IAmpcaCyr5Y4OKct0asPePhW892C7qjoioHGKkjAMs0A6u9OPLKFPw702nQ1CYRFRi
	 oBpvTBAzITKeSI/m/zzhAnVIYr3UWCO2VjmH0aiz9gAEEBCb383hYhhONAdM1rC7o8743
	 psaBXzkDBkOd4WIo8nMYKopru/KSEXzO1mkquPpoPU687kztk23bSLjTWRs2s6O34CwCR
	 RO/2yTFHC57m7X8CwHaU4+4+CsM24j1tgSX7A3bV1ciymz7J9sCAmpfFE84VCtSvdgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Aw1jCKeF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC861606A325;
	Thu, 19 Nov 2026 02:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Aw1jCKeF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5FE1F000C4;
	Thu, 19 Nov 2026 02:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056282;
	bh=zYQ4HRO95PGZ9Dck1v/lA394My+7amxPYJzuy0fpcm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Aw1jCKeFi0d2iz6HLSmqotjmMxNVbRSWVYnOlJfvo0MFz0LfFFR8Fr969ndh3GF2U
	 mcVFxVjYXvBTh+uuZUHbays7spEs4wQtsY5gZ/2lKNQzFVr+tBUMRZ2voxCr29IpJ8
	 9q4kT2/NrmuwSCa6kZMKiPDTJi3gP/gexWUzjc08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atul Akella <atul.akella@gmail.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1931/2214] rpmsg: virtio: fix error handling in TX buffer wait
Date: Wed, 18 Nov 2026 16:00:07 +0100
Message-ID: <20261118150128.258883021@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Atul Akella <atul.akella@gmail.com>

[ Upstream commit 7dd4cffdf4c2a496ccf783303a03d687a2127baf ]

The TX buffer wait loop in rpmsg_send_offchannel_raw() ignores the
possibility of wait_event_interruptible_timeout() returning a
negative value, which happens when the wait is interrupted by a
signal. In that case the loop spins back around and re-arms the
wait instead of propagating the signal, which can stall a task
that is trying to be killed.

Separately, on a genuine timeout (return value 0) the function
returns -ERESTARTSYS, which is reserved for signal-interrupted
syscalls that the kernel may restart. A timeout is not a signal
and should not be treated as restartable; return -ETIMEDOUT
instead.

Handle both cases explicitly: return err directly when negative,
and return -ETIMEDOUT on timeout.

Fixes: bcabbccabffe ("rpmsg: add virtio-based remote processor messaging bus")
Signed-off-by: Atul Akella <atul.akella@gmail.com>
Link: https://lore.kernel.org/r/20261013160055.1362-1-atul.akella@gmail.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/virtio_rpmsg_bus.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index e9bdaf8d6ad8e..8b7a79906d12d 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -537,10 +537,13 @@ static int rpmsg_send_offchannel_raw(struct rpmsg_device *rpdev,
 					(msg = get_a_tx_buf(vrp)),
 					msecs_to_jiffies(15000));
 
+		if (err < 0)
+			return err;
+
 		/* timeout ? */
 		if (!err) {
 			dev_err(dev, "timeout waiting for a tx buffer\n");
-			return -ERESTARTSYS;
+			return -ETIMEDOUT;
 		}
 	}
 
-- 
2.53.0



