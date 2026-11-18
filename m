Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049810;
	b=n4lNq/dn9p1ZyL7lZcIgLmBcPN1uAdm/MgTtCW0om1XgdYdlIYOBIhbFkhY/oaAYfgqT
	 zcrFInWl75YMyeu5TkkbFPlwSyIdD0eFVDsJj+4d1Is5wQnROq6HTGpzNmscR1CxNSn+x
	 s0UE2kzuuY5P6LesPT+vE0xRxKNYaGAa2kyrUVrfIICY5BEN55D7qqUAzVb4dzCPm2T8y
	 vUoMFnaqSEhDT7/YnAtW77bLJmzvtEurEf+DbCMrNKS2TrgPdSExOk5/IG9el+Ajdnj3b
	 NxGHwbNCcKmf3/e7fLiku1hOFEr5LyGrgg/3nRNu1yfUIAMQ9/u6rIy7i9Fthlk2b9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049810;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/eHdYcP7RbXa6HrxvFOjY8ATHS7Y1rJ1TH0HN2z1Esw=;
	b=l3FaMUqy5ORzPtuaKVyKot3cU/gEXufTHU7i/vuGF9urIEkLE0aJFq+9VWhrm5yq2k3z
	 zuPCRBBLTdNxSa+VrOo+0lMjd5TMIEKaxrzOQCjMhe2+ijDhkNWSfoyotF5fN1iRJgcmt
	 IB1lkjyEt0q92VKmTD2rq391pzAgYCMobfpQNuqwO7imEHLYXL8w/wS3iwIM1S6ZbJT++
	 Kk/QUwUnTS7xBOQvY1QMGlR/1swDFZg31PVG78kY0s0YHBmh2AA6FXl1d/g8X5l+ug6ms
	 iAYlEVRgjujmhV88SDPSk4kwrFf1DwuLInJucOsuH7MCyGBU4m6UpA/+yW/JaMnq/SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UNBjrteC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8091606A31C;
	Thu, 19 Nov 2026 00:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UNBjrteC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A1E1F000C4;
	Thu, 19 Nov 2026 00:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049809;
	bh=/eHdYcP7RbXa6HrxvFOjY8ATHS7Y1rJ1TH0HN2z1Esw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UNBjrteCLKC/g0iHe7IPl6LKQRfFQtMxZlKPj5Uiukw14JvAHk/s35NeKcxT4YsbH
	 E0vdA2pm6jRcthjQLF/0lMzKGfbnyu8hPhr6f4JEKilXNQlOXeYQW4JcKwG9KplzSw
	 6EIu7Ld/2kmREpAvRU9Q2reQWgZxYgPgrJVpQQOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atul Akella <atul.akella@gmail.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2483/2857] rpmsg: virtio: fix error handling in TX buffer wait
Date: Wed, 18 Nov 2026 15:58:37 +0100
Message-ID: <20261118150330.966281830@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0e6851ca9c598..5bd2f69030062 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -536,10 +536,13 @@ static int rpmsg_send_offchannel_raw(struct rpmsg_device *rpdev,
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



