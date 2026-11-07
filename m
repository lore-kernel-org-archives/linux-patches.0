Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062953;
	b=XcMmQTzaHw8215RFGi1QfDhkMx+l4Zn5Z6lDAx7/2viub/HoCy5WONqYiVyqoDLk2xVl
	 JKKtUuKGJfzelwpkfW/u641XCuX1bFy92ldEAOLbwZy/uMqjJBVYXd1vs1qedNHL7aPqk
	 ENLSjZRfv0kf7Gi0LAd/Nqv19jWEVn/XLsE76owKyKGi0M3KXBdbEdTxx6DifOm9DxI+e
	 AVOwD10olw3B6TOJgRm/Sd0NUaxc9bfkR01Mj2H37/H085wTqLAY0ncBnx7MFhfxAkxEZ
	 qQlD4lrp6oPpznlwEkMvK2gw8UbhZmAcTme74yJI7BTnlRQ7cdeBPzhJUQxc+K5SOyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062953;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kszl4sxdbyd6u13YlSbdF9YUlX3wgj+tsorSHJzqQ8M=;
	b=hU0uJ45aMPyO8C5pYthKs29H7yl8Q54UxQqSHFPfTV38RJX8mIcW7AMmo3kjlixkd6Yh
	 iih3/zO5fjxLGLEKQmmkMh9rZpBFJwLG4LR0FeF0LPzMMjTxniPVTc20MRQgdoYVxVoR3
	 RneARDgyNUUqTUnf4JpOQbjLZxe4XnJ9JpgevngtTJfx+PdtO90LNFPEh27tadna03j6h
	 VkQCI0eFE6MuQ1nPhBy2RugrX/FeeixN+mWv22FZkCp9aWP+P6vYCSzrSg3lPVZoMymfp
	 HBmRFO0QHTheO3EBXOOdD0fcK8dspecIVicLuahOUZQ8wJo/qLiEzwct8KMGjfQTAyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gWmK+YYN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABE1606A32C;
	Sat,  7 Nov 2026 14:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gWmK+YYN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6711F0089F;
	Sat,  7 Nov 2026 14:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062952;
	bh=Kszl4sxdbyd6u13YlSbdF9YUlX3wgj+tsorSHJzqQ8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gWmK+YYNUmflay0JE2nD4wTPRTFS7E5DxoCPIBM8kY4dwXyUheGN2nsPqXWolXBYS
	 jqKQm+bXeMsVBsj9esW2r6v721KOZ9WUO6eiUTts4z8SZ2poAuaJjGOeN23d2shfiu
	 FwhRHlFqpTPKL7yXNL7ebF7wHiPvDN2MDR6otC70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 217/869] media: vpif_display: Fix i2c adapter reference leak in vpif_probe()
Date: Sat,  7 Nov 2026 08:48:19 -0500
Message-ID: <20261107134859.286701935@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit f5863ea3f99265e5e297e3dcf0f47432fee2b8ac ]

vpif_probe() takes a reference to the i2c adapter with
i2c_get_adapter() and passes it to v4l2_i2c_new_subdev_board(),
which does not consume it, but the reference is never released, so
it is leaked both when the probe succeeds and when it fails after
the adapter has been acquired.

Release the reference with i2c_put_adapter() on the success path and
in the probe_subdev_out cleanup.

Fixes: e7332e3a552f ("V4L/DVB (12176): davinci/vpif_display: Add VPIF display driver")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/ti/davinci/vpif_display.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/ti/davinci/vpif_display.c b/drivers/media/platform/ti/davinci/vpif_display.c
index 1e7815e9f8e07..ba16370b70f98 100644
--- a/drivers/media/platform/ti/davinci/vpif_display.c
+++ b/drivers/media/platform/ti/davinci/vpif_display.c
@@ -1289,9 +1289,12 @@ static int vpif_probe(struct platform_device *pdev)
 	if (err)
 		goto probe_subdev_out;
 
+	i2c_put_adapter(i2c_adap);
+
 	return 0;
 
 probe_subdev_out:
+	i2c_put_adapter(i2c_adap);
 	kfree(vpif_obj.sd);
 vpif_unregister:
 	v4l2_device_unregister(&vpif_obj.v4l2_dev);
-- 
2.53.0



