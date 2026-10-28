Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212922;
	b=EKDy34M0KEzi3F99VOdZ5IG0tHR4WcVoFXeTBz/XaKZVOOT/ZbcY/IMONeF9OFhCE7mz
	 N1Ofl8/+rv7YiN2WS1RZL+gtKvCCnFBGjUM5R4YuSwWSyPUhH+vkjoBp41ydz3+Vj0YVy
	 ZXNWgtaCyL5uwN81M9pqFlA4u8q6/VvdIJYETD+hZjldPfh5uzmHfHCAl/CRcV6NPeqyP
	 2nfMXjkx/zcClPkLHQy31uMGDlm3sS+I+aJRbBCkSzBmv57Pigfa+6dC4fBVzUBzmWknX
	 eEZmKNj36i/KjhZ+0aWxWk5Hwtv0SCzRaoydccUuSaMjEEXXfzK5R5SxfJIYoIsgyHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FoxO96WKAmuyrEAuVRmXWAAdiY3miSK4tGWrnLVH8aU=;
	b=sUlo9TEMdzm4fBn1muxRIu1uruIestnY/AjT0kB7BiPx8eBWA/0s0vjWXnQGgVQVnU3H
	 HrN9kY4NpG2vi5VR5Snw28RicKyFJr1PsE2qzB1VFmsfL+dhJ7d2/8NLmzK2uYMEjKuji
	 eYhoxGlR2i7J+V1zHTNLE5DSWb7I5akXQERnzgkkgD/TlNI0cMOA4f1eUYcCD94QSmEjY
	 jejpEayEp4+qbRBvoUQsJA5tVHkLjxIh8PKxHT4JOrAqVIAsFW2WTfO7E4Ml9Gd2e1bpz
	 AsUsboETqXwBcVp+w2RSwxt3pXFxGcpov5OoS6lDKIabjiSbq0HBnAnUasWh5+PEhxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=heFchLQD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C66606A31E;
	Wed, 28 Oct 2026 18:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=heFchLQD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F09B1F01825;
	Wed, 28 Oct 2026 18:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212922;
	bh=FoxO96WKAmuyrEAuVRmXWAAdiY3miSK4tGWrnLVH8aU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=heFchLQDzEhOCiwnArfpZ0RqqV5HcWBJEMrbQ1M8AdCbqF3cYkJbOfphOWSHXBSqz
	 h3BWlsPvCVwA9fVgrN46OHNW8LCslGEqPZ6R4QfNTtQ1iwZyw1T4r50BvTEoL350/A
	 N2aoxwg7xC6lvbt74essGpgBty3odzw9x833YhV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>
Subject: [PATCH 6.1 0297/1887] serial: vt8500: Fix clock reference leak in vt8500_serial_probe()
Date: Wed, 28 Oct 2026 17:39:53 +0100
Message-ID: <20261028170505.988225351@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

commit 9d8955281d9229a899e2041659a59b389027b711 upstream.

of_clk_get() returns a clock with a reference that has to be released
with clk_put(). If clk_prepare_enable() fails the function returns
without doing so, leaking the reference.

Add the missing clk_put() on that error path.

Fixes: 12faa35ae5cb ("serial: vt8500: UART uses gated clock rather than 24Mhz reference")
Cc: stable@kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917155834.2161361-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/vt8500_serial.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/vt8500_serial.c
+++ b/drivers/tty/serial/vt8500_serial.c
@@ -682,6 +682,7 @@ static int vt8500_serial_probe(struct pl
 	ret = clk_prepare_enable(vt8500_port->clk);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to enable clock\n");
+		clk_put(vt8500_port->clk);
 		return ret;
 	}
 


