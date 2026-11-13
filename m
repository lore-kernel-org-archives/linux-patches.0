Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585653;
	b=Qk4MmWbGn3kLiNBAeBorcWW0cnnswEapsCBiUx83+uVg4Je2idF8/IEGdY/0FMgWOL+R
	 Eq8+k98LY+hAWRXkFn+nZOX6kM9A1A7+KyokROmy+Rl15zX0hvIKCxxbh2WXHTHNYBjwR
	 2ktGwtNqDNpssGisB3a7xw6+fVsH6YqluYSLxp56X3CN45eBPGwF5M3ZV6Mr2yomXXAL+
	 RRISh7NNiyryUokGaM1rJ6svlxZ+a21DrS8DxWDNRXjPfTUafaPeegi7svugbVUGtD3Dq
	 O0WVCRkMNY0HACKeVi64rLyqYkWC3XPRC4VAkYS0vw7GJRxVoX69Pz3D2IzbZqXjmAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585653;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UsI+E4Ait0pmC6dOYnzSNgQa/i1RN/k3q6E9iHzR0I0=;
	b=ows2E1lYqaHQwtS140+LoHFnunC0xn1nd8CmE8dXqT/hEc02TMlpsuEI9YQB5cDex/+o
	 K2USnxYD0wwTeFGowkP13FV8IGe+1Tsw7Y0A/OdC0AIHStn12bLYnfH8DkLpxN7Q96m6O
	 zZyNwd3FSMiPRohXW5JTw0xwcPhMZYL55JZQllzG3XyxjGrR0KVaivf4yvEKkQFbhiDbV
	 5SbwKcm14XlRmJi8OmmfdzkZ+olLOFmhfyEwxwBYEydM11iCbmIzic6hjIiWGeQC4nfMA
	 rSClyqsLUzgKDpk2X6QU0QCKdRrqELisYVJ+jW2l215OxfuN5eHcWMNxIvI+qaXtmgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FwhVQdsu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24ADE606B2DF;
	Fri, 13 Nov 2026 16:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FwhVQdsu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41D71F000C4;
	Fri, 13 Nov 2026 16:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585653;
	bh=UsI+E4Ait0pmC6dOYnzSNgQa/i1RN/k3q6E9iHzR0I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FwhVQdsuMiDugMo91sF+sqKBT3rXhFNrti/X+Km5EXTKQcw+U4FwqvNpVvGmonQL2
	 ApC5uqTkI9/tqGUig8g06r0q1OroML276xD9Iq8bNxfhqVrNxDNNZjnf5yDOK8QNHp
	 5FEevRK1497rk36v8SMU9f2IuqWb8qC4uoLxCnlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 268/507] vdpa/snet: Dont discard the DPU error in snet_send_ctrl_msg()
Date: Fri, 13 Nov 2026 10:49:32 -0500
Message-ID: <20261113153803.716518894@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index e284c3a06717c..09afa0487fd6a 100644
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



