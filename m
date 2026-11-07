Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062071;
	b=k+y5ag/DMXMvT3tEWF17yueROAjMFEPIfJQXLCGdb42u/HUBeuqxYnWeOu0qT6t0HlBx
	 zHmo+yWQnMgtP5+mAoYSMpzrCv1G+330DexPy45j4AQeS+2yYK1Eou7Lj4gb6pfNVA3Nw
	 qR3ADRsRm33sE05PVLPvBwB43+6WxFy8Gh4WZJ62Ouofsp0r0JMrUH91muIedRWUrUjrg
	 Z7fukMOWxHrY/3wFrzOvF6JcsVG9KnyNFZ4GHRL8Rfc4KKIHgC2r58ms8Z/7SP3oR0IVr
	 6kLpkijmyBdOya20LFlnCAvp3sqJUiAJLRhwo6y1z3awOjEih4WKcXplZnLEQPTY77g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062071;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D2f08JhEYZ7uv305QF+lv6IUt/1ftBGfuH6oY+rFHE8=;
	b=t+htXxzqVyDEb5+wAHo5ADVsYE+uAaGDCX82h1Ht2F9eyYwRyFwyjmj0NG0RRDwNY8s1
	 f/e2H+4I8aaOFgMKbKaHWkmFFcXbRLxUpnu9abHFL+BCsT0ZA+V7F8xT0hnFplnIohart
	 5Trt9gQ83vCRNu3QGpskMcpWK9mZF3mWkmuw7J4eqxV8NaoSAITnoGMVQpQvq/mU49fDG
	 TDH4px85sweHwH2BJsRQKbz3g5i6p3ukq4cEaA+hLhA1w2WgHWkxvFmk+0sWgK4v6b0N0
	 PKBVp5WfBXA25Mo/gMxfMtOa3juuF2g4DLyzwSVACDGzmfrBPcsDOyGgNMwg3FSauMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1BfZp5Gl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D582606D80C;
	Sat,  7 Nov 2026 14:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1BfZp5Gl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0B81F0089F;
	Sat,  7 Nov 2026 14:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062071;
	bh=D2f08JhEYZ7uv305QF+lv6IUt/1ftBGfuH6oY+rFHE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1BfZp5GlgfhsBhj8mUSV5K10aVq5OjTUXB7/btbLJEztMVV4+xNEwiayIpwj71wTQ
	 Nd6k1k4CiTFzXeVVcP9j8aHa4ghNSgrXtZM2U/7yaa4vWnNKzwVySA7i3fZSa41RcM
	 iC0n+VaOoj3OSHommiY6cPjUzEdh+0LI7PQABFvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1049/1536] media: vpif_display: Fix i2c adapter reference leak in vpif_probe()
Date: Sat,  7 Nov 2026 08:51:05 -0500
Message-ID: <20261107135027.142567563@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 1fe05a02a6e78..7983a692d77fc 100644
--- a/drivers/media/platform/ti/davinci/vpif_display.c
+++ b/drivers/media/platform/ti/davinci/vpif_display.c
@@ -1291,9 +1291,12 @@ static int vpif_probe(struct platform_device *pdev)
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



