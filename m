Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062951;
	b=5RNuOnGAhBjY4lz6eFBY8mKEGsYohF9vaBg+amX1NqxaRQZ+nfEU9u7/C89uAOEyW2Mm
	 K3XV36+K+O287wHhgisD+t2NT7Xjz44GK4pDfCqIQfmggP/yqb1L8/MXcMFYu6Yc/CeQK
	 pWzDX5+oWdv0Y3s5P4hemeLlhRFGsA/WRH+Z+XOY/o6GbI2h+qXR31I3cQMEo0yWhgZMt
	 KXxQj1D5OOMoTyJOkJJ2JmW6numLkkAp6BsdPqmYXG5ucvRzFvVXRDtXpRY9gVZYZsQ7C
	 t36GQ50Z+i5zwIyY6zk5LMljD3wSMPM148kTJTDR6Nz8A/XFHRkt9jZVlW0dL1vohxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062951;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=26hR4L9FsXLXlyEme5tEY/+dsdLp/T4jOY/jPZTk6aA=;
	b=oeqBXlSSdvVUp8yJin+liVnAMAzxY6rKSHwrxf3dyefh0cFOVFgUgMHh3EeCfyWEZhXE
	 85FStcxzalsLw9lYjLXQwZ74+jnx9w+Sr9nDnsa3+rsxTNJeTcyrq0fjFg5hwg/4unCVM
	 hsb8EB1O9g7r5YaYIiWDwiIxeHOwUTNkVfS8QgTyuhr5Hk4/0BKNkr276uv4PyyHeksTO
	 DCsiB7Z6sLLtnHoH/mStzn/9MWOMzrveVqEXzWuOzJJUP2jyDnmDyIibAadZjvlIzU8a1
	 1hTdixZKvWqWK/hRs3NXOYUk6d/9+0wk56VMDdus4T7RJgiTGGzbT21FMqRPw3FC51w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pUQ3UMYh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAD3606A32C;
	Sat,  7 Nov 2026 14:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pUQ3UMYh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4461F0089F;
	Sat,  7 Nov 2026 14:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062951;
	bh=26hR4L9FsXLXlyEme5tEY/+dsdLp/T4jOY/jPZTk6aA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pUQ3UMYhg2wunSiyYKQl7W5aLONYz2v+PXIiYqvXe8fTVlYzvfCQc1i46sTRBHfxW
	 aqySr3ifBSrLb/3fQBl13Va+EkngS2SqdBx5PBHsPzNSHEpf3ibXWTBdhcng6+gYJu
	 /1GH6f7VGWQjBd370h64fNU9QIt/nBy+k/Kj1KB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 216/869] media: vpif_capture: Fix i2c adapter reference leak in vpif_probe()
Date: Sat,  7 Nov 2026 08:48:18 -0500
Message-ID: <20261107134859.257399516@linuxfoundation.org>
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

[ Upstream commit b00fbdad64d4ea7d594bc67988c1722fe5b3be50 ]

vpif_probe() takes a reference to the i2c adapter with
i2c_get_adapter() and passes it to v4l2_i2c_new_subdev_board(),
which does not consume it, but the reference is never released, so
it is leaked both when the probe succeeds and when it fails after
the adapter has been acquired.

Release the reference with i2c_put_adapter() on the success path
and in the probe_subdev_out cleanup, and initialise i2c_adap so
that the cleanup is a no-op when the adapter was never acquired.

Fixes: 6ffefff5a9e7 ("V4L/DVB (12906c): V4L : vpif capture driver for DM6467")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/ti/davinci/vpif_capture.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/ti/davinci/vpif_capture.c b/drivers/media/platform/ti/davinci/vpif_capture.c
index 9fbef24025744..5158417fe603e 100644
--- a/drivers/media/platform/ti/davinci/vpif_capture.c
+++ b/drivers/media/platform/ti/davinci/vpif_capture.c
@@ -1603,7 +1603,7 @@ vpif_capture_get_pdata(struct platform_device *pdev,
 static int vpif_probe(struct platform_device *pdev)
 {
 	struct vpif_subdev_info *subdevdata;
-	struct i2c_adapter *i2c_adap;
+	struct i2c_adapter *i2c_adap = NULL;
 	int subdev_count;
 	int res_idx = 0;
 	int i, err;
@@ -1693,9 +1693,12 @@ static int vpif_probe(struct platform_device *pdev)
 		}
 	}
 
+	i2c_put_adapter(i2c_adap);
+
 	return 0;
 
 probe_subdev_out:
+	i2c_put_adapter(i2c_adap);
 	v4l2_async_nf_cleanup(&vpif_obj.notifier);
 	/* free sub devices memory */
 	kfree(vpif_obj.sd);
-- 
2.53.0



