Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065272;
	b=0QaBHVmm1PesHmlwYR3/7JwPKthNA4kN7xKvEtAnZW+Hkrm5omB1H7JVT5kiqqeUVb6e
	 qPDsZsuMOylN9OTUf2eTqqH6scNA+m8Dq3h5s9UgICHK8GomAWCCYeyPEhPW1x77nt6/G
	 D9rHrE5x0zNRymmSaPAn/yPphAykZk5MRpGgDwRgVSPklUk/G6TPIJPT0zJ9kvMyzy4+4
	 Xb1oc/EI6D6esMXpmQqWCNYt1tSU1L9GS08AqpBNgu1ND5tTkLl5REJp/OSNMaNA+OPH0
	 VSU4mGBRs17myAXhfIiC0R0HzC/nL2Q8butsVyqBkfsg3Uoo7J9PMUllVUeSOwZZuwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065272;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6gyviW/2nf6zpUVFec5ypI4EHX6B3CQeqiQuBBAoAGg=;
	b=IMqqStqQk/gPv5vsShAA/Y+GTGoYsn3SPKU7uxSvpgo2O5QewtVkd+ckDPXj2eRYdLXe
	 Ibz7tfPA2GFgfbg5q3PT3VsyUgKQoDb6Q7eX6iMzfC2vCneVnCjlXTbiMmYPW9uKVHPGy
	 eOVp3EY3whcC4ItoBS57rts1Yxj5PJHP0jFSHaR4vPP4immSd45ve2bNkmBlv4oCcIVSi
	 oAIed0VQV9GqRCJQjI3KS1QQDaUCyqCLU/6FpVAyChrjBSt/FnkU/o1ltN4hCAOoSV6vj
	 4+qX9t0JrwgL6GHUBW9NkVaii4OrYTVP36asjZp0XGsWiGuK+eu+RCQSvwDZpSdR9lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=McU+4UyQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95887606A326;
	Sat,  7 Nov 2026 15:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=McU+4UyQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ACCD1F0089F;
	Sat,  7 Nov 2026 15:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065272;
	bh=6gyviW/2nf6zpUVFec5ypI4EHX6B3CQeqiQuBBAoAGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=McU+4UyQQWIMcSTzfGKNCs7M+o5jwbVxKvaWtXwZWaF/MTHFBPULJa+QXZeQri7MN
	 IbEXcQSdE7XJ5cgI8r/GYZ3jzrhHsZXe6r5gx0cBXh52QWUPargemsqNoSAKO624zW
	 tlge0TfdlpvV9LBQnLncaiEWJVUlMaD2SyFfRGqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Navon John Lukose <navonjohnlukose@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1028/1257] i2c: designware: queue only one read command for block reads
Date: Sat,  7 Nov 2026 08:55:24 -0500
Message-ID: <20261107135007.714094763@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Navon John Lukose <navonjohnlukose@gmail.com>

[ Upstream commit 73dae605cad7921800677d982bfaeb81cc930dec ]

i2c_dw_xfer_msg() pre-queues up to rx_fifo_depth read commands based
on the initial msg.len. For I2C_M_RECV_LEN transfers the real length
is unknown until the first byte arrives and i2c_dw_recv_len() runs.
When a large initial length is passed, the surplus pre-queued reads
leave rx_outstanding non-zero after i2c_dw_recv_len() adjusts
msg.len, so the completion condition is never met and the transfer
times out. In a loop, this repeatedly times out the controller and
disrupts unrelated driver-bound devices on the same adapter.

Queue only one read command while I2C_M_RECV_LEN is pending.
i2c_dw_recv_len() re-enables TX_EMPTY, and the rest are queued once
the device-reported length is known.

Fixes: c3ae106050b9 ("i2c: designware: Implement support for SMBus block read and write")
Signed-off-by: Navon John Lukose <navonjohnlukose@gmail.com>
Cc: <stable@vger.kernel.org> # v4.10+
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-master.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/i2c/busses/i2c-designware-master.c b/drivers/i2c/busses/i2c-designware-master.c
index a1bcc3797e4ff..cd4f57b4e2b52 100644
--- a/drivers/i2c/busses/i2c-designware-master.c
+++ b/drivers/i2c/busses/i2c-designware-master.c
@@ -441,6 +441,14 @@ i2c_dw_xfer_msg(struct dw_i2c_dev *dev)
 				if (dev->rx_outstanding >= dev->rx_fifo_depth)
 					break;
 
+				/*
+				 * For block reads, queue only the length
+				 * byte until i2c_dw_recv_len() runs.
+				 */
+				if ((flags & I2C_M_RECV_LEN) &&
+				    buf_len < msgs[dev->msg_write_idx].len)
+					break;
+
 				regmap_write(dev->map, DW_IC_DATA_CMD,
 					     cmd | 0x100);
 				rx_limit--;
-- 
2.53.0



