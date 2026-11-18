Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046855;
	b=Aaj9G+LEpMOop6qrcxiWfrY+UrDA7pcOkdRyRH4SDCy1ZY/cuPtCZMzvQVIBTfCLKUth
	 6zf5wiqT/EBP3DRAgtBfxZQcdlorb8chLO/rj1wBm18JB6ZdzJJ8Tlq3KW+L33QbdLhmW
	 FDm4LUxli3CpEUfs43c9LJwfBWZ7cXN3rcDqRXfTovAGXb7YwASjD/q8+OCcWbr2DTACe
	 pDzArgLTAY+btTtylEHSVkhUHAxti690eXsLJhbcj46x6YSnZcTKCnJEic19aOiBGAfKS
	 hsXP3d9aRKXu4KU+8q3TrM4xKZTEh98mPjVdEDno7zSuuIRcQobiUHTb9B9FKvb9mHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BqZntxLon6H3Q+fgK+VoVgFh9FNT8MdBhvo4Cz9EN64=;
	b=iKL5PFLrf/kpkTAfSe390JWZDnixpRvQP4zRYZkD5FTEokla/e8exxU3y1GiSTEaFr/R
	 9b5aouwL7l0UEy3mnKK7dl2yuKWcZzFb7Pk7ZXlHepaxIGpra0nt5SjeuYiU2sYPH+PY0
	 bngxkUqhjo1UDjXjvWDCTdu2AlBIggB+sKzxLjRG1mytxnF2lvKPDsg/DNIgHj2qKklWN
	 As7I3L0TPQ0tlNHI8b1dMZLH6kObd9S3k+PfRjA0ZNmiXRXfq7zv4zwWGhTLzXkRM6XGR
	 5XM6tKTQQQAKPgJ6IO9zsgbf4ZY/mQlNyjqZQCE3VIvtKZcr2W0izxEeGP6fC6+6Olg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=npkzSgQ+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34991606A31C;
	Thu, 19 Nov 2026 00:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=npkzSgQ+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886C91F000C9;
	Thu, 19 Nov 2026 00:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046855;
	bh=BqZntxLon6H3Q+fgK+VoVgFh9FNT8MdBhvo4Cz9EN64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=npkzSgQ+kfyQEva2C7Ht34viDOdrpmAsnnD5FT69+PPqpdJt4gchv/6dn+uJd8dIK
	 GJysmObwV5EisRF210IrsnFfS9k5oopDLJQGNTauEU1tYxpRDlWLbyZLjDl1oySrIF
	 umLIEwVDfHRS4EDZD7LHjwHoHHoceV0CDBoiwkv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1431/2857] media: vpif_capture: Fix i2c adapter reference leak in vpif_probe()
Date: Wed, 18 Nov 2026 15:41:05 +0100
Message-ID: <20261118150252.835904649@linuxfoundation.org>
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
index 7592216177b50..b32d008586755 100644
--- a/drivers/media/platform/ti/davinci/vpif_capture.c
+++ b/drivers/media/platform/ti/davinci/vpif_capture.c
@@ -1604,7 +1604,7 @@ vpif_capture_get_pdata(struct platform_device *pdev)
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



