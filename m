Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591157;
	b=Zu5wJGNIXQCxXHIrCG2gmCI7KibtuBcbC28zzYbl+AF+NMK5VSIgaS4/bMBfIsuaVhBa
	 3st4ZTLH8JuPkj6qCx+NqN+05OgEvheSVcPeu/bqRQv4BH7OFGhW9YkK5dpTbR9JzQRQd
	 4RbcG2FyJcXqF8pTO41jbN8sH4057f54+1P7hdyLpeB8B98q8uCVONd0k6eUoNvENm6Eg
	 e3djfB/J/fRLDApHrSmgYnDzICwx723yCTYdJHEI49xY4qGTWPUz4b+3EOSIcBzRtqWiq
	 nzMjxXDGdbRqKTzwWcQYRAfTSMHTLGo1CclSd5F5zzK8yB5voF2Gap6W7S2Y34wMj+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NqHo9vkkxYCKmbM0NSS5Za4aMHobVIfRaBnttcOLHYs=;
	b=bUL2AghTjgXrrWatC+AlB7jGtfNP9VVI9zMVJBlh5O0vDLpcG1hZP6iY+qHWfk65LqDE
	 mfnixStiyfUk+TQugQQBLBGhsAoeO+tZC63xYiGqQdFQJ0yQCnBsMcog87DQ+FF+k6I6b
	 kEbRDs9yGDKsRowvye6qYc3JJL8MnSpdHzbNxYH0xCtBxJOgEtF+FTAmb5POctOURV3ey
	 HhxNvEnSYDtPVPyFfW62TuHw7Sh/AUq+qvTSTCoiid684nyup+U6slxOHTTZFVR/tRv2S
	 lqSQrctRANVoSE4Ur+MbdVEjfvsJUaRfsJ+9ix9Z8JgM8VlQz/Q3SWuG12PX1KUS8eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IFXevXCt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC01606BD27;
	Fri, 13 Nov 2026 17:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IFXevXCt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6F71F000C6;
	Fri, 13 Nov 2026 17:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591157;
	bh=NqHo9vkkxYCKmbM0NSS5Za4aMHobVIfRaBnttcOLHYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IFXevXCtFLdUO8KGLzvaCuN9vFBB4atMS5HUbe+CbDIC18V6XPGoedfODkNhxqRFj
	 Xa+hKICvA1IDj04bAUPlTsx8FRW606IkNBKUnqf28b2fSR5qukiay6d9+TMzpQrmKg
	 UH1W9jonqsTSqH/4rhB28IOAchQ1YJGOKzMzodPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 301/670] vdpa/snet: Dont discard the DPU error in snet_send_ctrl_msg()
Date: Fri, 13 Nov 2026 10:47:45 -0500
Message-ID: <20261113153822.121445438@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



