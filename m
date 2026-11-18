Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052480;
	b=QubA8LVBkmoaAxYmDqGatOSU2ocPvrASFFmQ/lcvhkZVxOHYAmR/oFZytMAt72xvm+zU
	 lrurPrsM8bB+6Hlrgq5V08Oj7OxlpdbX1EmNx6DuZ852L8aRjniziQaz5iZ/mR68MVoTt
	 mYpk2XgYq+EBSjcu/cffdBPWjKklpQQFm6XLNqF+S4/7KKd7COe1CzXrnINGgSJuKFvo8
	 KqGDLi9pkisU94LQS6XRGg2hkynwUfa2+4hHyWy9KTB56gyoMWPFPY2+31wQpfDwclzNX
	 sh5kjF1tmTnpJGb6LLuR/wFTbqqYCJzf2yogA+ORDijTkspcHACnf4+aoVR6Sm5v69w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052480;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UWh3J355NNyWJnzciorVFT4Nl2Hd5JsO0NCikfej92U=;
	b=NO1rUeyopK6feWPuZ4UkvXb+Jt3J9XAigXKp1ZVqbxM3eXzJ4ufLeRCP3PSaRV36dtVn
	 AkSfYi3QMSCF+6N3jwcsSusNWrMS0nlCsLXidYEeTCOPWsagzqPWTZdhGw1VHJg+eAeIE
	 Mw3Ft+ksRMhyowYWgxAWhP1m5U38xoTEGdLt0bplc2Twjweyhn1eRJeqCBy0FtvvF0Jmk
	 rYC3W4rerPf5ab6GAyBnCAY1LfVnROBvi5o/Io2GPLVjZNgscEFiOFvOYwG6efwYmhx+G
	 LOmLmm8YfrCmT3qA2AMfr+TAhtn4xv93yumCJyrwKiU5kszInDm3BWDPu5eIaqe8zxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iYdG9n2x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFBC606A320;
	Thu, 19 Nov 2026 01:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iYdG9n2x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117D51F000C4;
	Thu, 19 Nov 2026 01:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052480;
	bh=UWh3J355NNyWJnzciorVFT4Nl2Hd5JsO0NCikfej92U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iYdG9n2x4TGr37hj5uKBCQK81DgDkNGrIHZKjJrpOZNcHWY0XLTudH/m4GyF+g4bu
	 PPV3fHIv95vMgI4YcWJsWmPeqDw1/lB+K6GG36st3IxCobRFbpTz/N1UvzwBOFeRwO
	 3QNeWbJgprEbZdz9O/Oneirv/PZOvkEp+Hos7kHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0529/2214] media: vpif_display: Fix i2c adapter reference leak in vpif_probe()
Date: Wed, 18 Nov 2026 15:36:45 +0100
Message-ID: <20261118150032.230782225@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/media/platform/davinci/vpif_display.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 59f6b782e1040..7ce7d1f6678d7 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1287,9 +1287,12 @@ static __init int vpif_probe(struct platform_device *pdev)
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



