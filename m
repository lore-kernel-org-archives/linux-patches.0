Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590368;
	b=CbYKuLC5QBDzk0dVIWpiLkyq6ZWpAO0pT06mgn1oHEy+L8QTrgOEZWBpOwk6Cg+exH09
	 8gtbYgF4+gnjSrZVmsU+eNvwULemtqe4ke5BW1V2liUucxdRevZlKGVbNiomyGoBgwNBM
	 gUlFC0ZkwXfJdA0k6a1i02FYFRv1RP0SKTwb9XKoI9YF4rgqot2qlxQj2gD5Nh2yL+ODQ
	 Shkl8/QKexb5FN3ul8JXGA+WAyp32EwlhtbgE39B9DSeRqwwuMiwPjzewi6mI30kgSVn4
	 eIwYxUt9A5Yabf8BmJO8W3viBPFHLaCxomz4CW/i2E/h4Biig97YtPvhXurGXPLn2Ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590368;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L8z6jX4EwcKMtkJYRzlQBPXlP6l6WxllGvKI/dx4tb0=;
	b=XUmoimnq2KEPmVf3Uw1anzEcAhYZZ+6nR/zawgtMq3MwIZHAYY+th/wcK44ufXDZOtf7
	 LkgwIDEOYfSon2cfdcMHuQo++byqq7hCopkAXOa//B9G6tsRj/FEmARz6W+jquhE1c+lM
	 7Q121pO+qF++OiUHjjU0TPiLy/wJTz5Qmva2S70Hfr6CUvpukeJE2/oqm+csckKONIaOc
	 uCNPYW43RaIaEQv1uA4aurybmh0J3sp1GIExblxnGZux8Urq17p2IsDHgVNofiVieStRN
	 ZSDf/xoKCElXLabaXvf31lq/sUvblC5wyGeEmOFXxXKamdhY8tBDWSSJ8rUBA/h+DJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xiFV+V4y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CB8606E640;
	Fri, 13 Nov 2026 17:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xiFV+V4y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301C61F000CB;
	Fri, 13 Nov 2026 17:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590368;
	bh=L8z6jX4EwcKMtkJYRzlQBPXlP6l6WxllGvKI/dx4tb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xiFV+V4yekqIJadGdRK+wHPUguhisfXp5awkpyDKqG2vnuricP0NI3DnYEsF247tg
	 6fU3OsERWVR7uD/jUu/xt8xNua1OGL09Eean/yY1efKlqvmWDT3jgmvDVHSqrG6w33
	 pdQY4JW4pr2+7DNwOr62OadTseDd/XGa6QNFBM94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 342/686] vdpa/snet: Dont discard the DPU error in snet_send_ctrl_msg()
Date: Fri, 13 Nov 2026 10:47:55 -0500
Message-ID: <20261113153832.521789242@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <oss.patchbox@gmail.com>

[ Upstream commit f41f153d49b4c18172ec61b69ba934c36e1be745 ]

snet_send_ctrl_msg() reads the error code the DPU reports when it ACKs
a control message, but then overwrites it with the return value of
snet_wait_for_dpu_completion(). As a result, a DESTROY, SUSPEND or
RESUME that the DPU rejects is reported to the caller as a success as
long as the DPU clears the opcode register in time.

For SUSPEND this means vhost-vdpa marks the device as suspended and
lets userspace reprogram the vrings while the DPU is still running
them; for DESTROY, snet_reset_dev() never even sees that the device
failed to stop.

Return the error from the saved ACK value once the completion wait
itself has succeeded.

Fixes: 3f3a1675b731 ("vdpa/snet: support getting and setting VQ state")
Cc: stable@vger.kernel.org
Signed-off-by: Yuho Choi <oss.patchbox@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20261005044915.264532-1-oss.patchbox@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/solidrun/snet_ctrl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/solidrun/snet_ctrl.c b/drivers/vdpa/solidrun/snet_ctrl.c
index 3cef2571d15d3..1c3b5f2e44990 100644
--- a/drivers/vdpa/solidrun/snet_ctrl.c
+++ b/drivers/vdpa/solidrun/snet_ctrl.c
@@ -291,7 +291,6 @@ static int snet_send_ctrl_msg(struct snet *snet, u16 opcode, u16 vq_idx)
 
 	/* Check for errors */
 	val = snet_read_ctrl(regs);
-	ret = SNET_VAL_TO_ERR(val);
 
 	/* Clear the chunk ready bit */
 	val &= ~SNET_CTRL_CHUNK_RDY_MASK;
@@ -301,6 +300,8 @@ static int snet_send_ctrl_msg(struct snet *snet, u16 opcode, u16 vq_idx)
 	if (ret)
 		SNET_WARN(pdev, "Timeout waiting for DPU to complete a control command, err %d\n",
 			  ret);
+	else
+		ret = SNET_VAL_TO_ERR(val);
 
 exit:
 	mutex_unlock(&snet->ctrl_lock);
-- 
2.53.0



