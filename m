Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059522;
	b=zI0iGTqvawk8wzPXhAOkl0z6laDuY1G3uKdENR7YKuhY6XfYKM/ovibgATjJign4/Ht5
	 M5t+/KJLqfNT9Yx+TRU3osdSYxV7FeCDAUtokkmKg7BaivlfIDO3PKuYa6ui25RwAgUBY
	 oEZZdKpKI77Z98Qf560aGzfqG+Ya9DhIsGyiACXLcqw897Co3pof9QUUgzEu1AIWYjfcI
	 Jn5Jgs1n/Og30kqjurst2lFciHLuQ2DrQW2ju6+YgU7sBQAqqOGRoG+WPDlnDD1l+JJV4
	 7txK9aYvh/FHVkJKptAnA437g6PHGX9UQWCHmqayURd5CLxMcATXaEXL0R70c+j2xHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059522;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cIPvHfVFTMsoEHif4Tj/bxvu/6eS1YGGMjvhRXCq1js=;
	b=pp5Xx4gSSnUii1e9CIPNlfItNsLaSOzhKTzVJuymS/Sd2S+Hr+UnafnsrGPHf/NjVajL
	 3zsTiNn4NOFXQtJNdpUrL+LsmyxsBXaLqGUOoFsdl8GihwO1fYObYJHsHnqdZULA9xMEb
	 agfsKsT4PsOpEa4gZDzmJAbwaL9NYrvJNTkwfyWwyiZRgYTRqWbu1eefATLXENp/nU2k1
	 y5JKuxtyBgfo2M/XkcZ/3wFtukGkkfp6c34ZR1MRGZdLn11emGz7E6yJFfc+eB4gYlyK7
	 phrWMWKrvR4Sesr/00gf82JuPRI2mMsUWSecUGHv8VgVN1NrsLYXMsSeM1YTUveDdSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dZi3x8Aw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D5D606A320;
	Thu, 19 Nov 2026 03:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dZi3x8Aw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033F51F000C4;
	Thu, 19 Nov 2026 03:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059522;
	bh=cIPvHfVFTMsoEHif4Tj/bxvu/6eS1YGGMjvhRXCq1js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dZi3x8AwPhe3PeeQIj/cawR2vRx6sLz4yIg8qPap4IoaQh2kvkf8SbTK/CVokKjQw
	 uc2tk57OZwyBcnxFic4o1ODwl1EXGfrYBS7AM3X3MPWGXwOBFMh+aLj1dlr+z+OryR
	 mp/Vo//mzqYEdvYQff6GlMVfzCnXF4zqiSAjXRV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0871/1848] media: vpif_capture: Fix i2c adapter reference leak in vpif_probe()
Date: Wed, 18 Nov 2026 15:48:29 +0100
Message-ID: <20261118145952.905828465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted vpif_probe() context to account for the absent v4l2_async_nf_cleanup() call ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/davinci/vpif_capture.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index f90de09c14853..e81c894dc2aed 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1617,7 +1617,7 @@ vpif_capture_get_pdata(struct platform_device *pdev)
 static int vpif_probe(struct platform_device *pdev)
 {
 	struct vpif_subdev_info *subdevdata;
-	struct i2c_adapter *i2c_adap;
+	struct i2c_adapter *i2c_adap = NULL;
 	struct resource *res;
 	int subdev_count;
 	int res_idx = 0;
@@ -1701,9 +1701,12 @@ static int vpif_probe(struct platform_device *pdev)
 		}
 	}
 
+	i2c_put_adapter(i2c_adap);
+
 	return 0;
 
 probe_subdev_out:
+	i2c_put_adapter(i2c_adap);
 	/* free sub devices memory */
 	kfree(vpif_obj.sd);
 vpif_unregister:
-- 
2.53.0



