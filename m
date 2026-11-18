Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053783;
	b=Bdi5eMCy83XlhNCMNKwf6fEpQ3dAa7cqZMorlilVv8vnT4dZO8efKuoUOJ3hFiuYDX0f
	 MlfyeKaWES5b35md0ltiidSjw4VJ5rdv2qs5hrzq/mxtrahi7pJx4dZ/smswMqc1QoJyt
	 OvjOWO5f5SQDJojytwO659wwF4mybjGTUgBzU9EaQW2buFxx0MAAzHFrqI7VIoIkeUOZK
	 +J+nuX7slHxlDAQhRwG9iq3B3FY+1WUxQ6cXhqb3RWUXsAWGqsFtSGhrC6pmkGNdd8jjz
	 hAAwK7BsyK9tElJEBcp/ciTGFpxGBBUf10LWNqGkEUSkXp1FS8p/qQ3SRm2PUZj/DyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yxIohHkAYcqn6v6rjb4+KkOafoe2XuKrwowlcW1uB5s=;
	b=TUZw/5lU5TVJO811swKz8GRmmfj2pdk/Ha5Exe1GFuLK7l5QNp4rdoxB0vxlgeXXWevW
	 GZCaBgCHub1GuGVAZNqS5Q3X0uv6mT/Xio4Y/XdaM7oe+Gi7hp3uNxrEo4KlD3baZYnk8
	 tMzl9Xc7IxtwWz5+n8rrhtKJaG6fYX2YVwUBi6pTCzrHfj1Pc1qcEr+uqiLP8Rjlbtlu4
	 /R3OW4IbLm2Y8S0xU+yxZQWDUv87OQyZKCkqDDlir8NVH5nwP0prWo/jDrHHJqpJ5qxZ3
	 Ht66N57B7rUEjObWG8EsKL83qeAoKrGLP2y1Wgf7QmMEePsLtnSHpUkJgTLRbXW3EYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KjFImfwO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C608606A32C;
	Thu, 19 Nov 2026 02:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KjFImfwO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17CC1F000C4;
	Thu, 19 Nov 2026 02:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053783;
	bh=yxIohHkAYcqn6v6rjb4+KkOafoe2XuKrwowlcW1uB5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KjFImfwOOA91pKDCQUNe0K7Eh0gnfpFB3iOqeeBZgcHEerrqzpOnzLEnoTb9aDbXa
	 Id8TWXO6ZWai18tkTMfih1DfYDlX254BxipyWPeoXEdUEvFgDgmG6YmD7uE9Yqm4G3
	 WZINMC7sthR9GJwsos4kdtk8cAg/dQQ1Q5jxcnJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1041/2214] media: vpif_capture: Fix i2c adapter reference leak in vpif_probe()
Date: Wed, 18 Nov 2026 15:45:17 +0100
Message-ID: <20261118150053.990344736@linuxfoundation.org>
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
[ sashal: Adjusted patch context to retain the existing resource declaration and older notifier cleanup sequence. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/davinci/vpif_capture.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 164d287c293ed..619952ac1a6b6 100644
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



