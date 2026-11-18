Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058216;
	b=nGTyrTKJNe5lKNcdGe3EenQm05cUkjuwjvYB7LNm3n+wZnvUF6ojVM/06GQcBGjTCQbv
	 WW7flnneIbvUVtCMLbowZf+rwYi3c0SqHQ4tJ8mhz7XemsxsE+e/qWJgU/dmFm1EL3O4k
	 LuTiODy0x3PpyGOA9AcGaviRlXeQMbPH1mLVxwGB4w0g6KwYICDQ2q4fBPU/KeYyxzFLd
	 9PjwaT5xqhvnL0hcmH2lgUjx0Va9YuoAorTW+MqtKrcoIzn8SNawbJSwfubpuyGp+6tLn
	 njm6k5OVHjub0KJ993uepTEmEVFea69ecKB5VkSbGP3LiSHaXThgtc3EuFwUysKfkUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=027jESiXzzgbzXlS+C8ws6hlSeqBxIrKxIszIoYJHNQ=;
	b=IZHfSy1/nf0WS6hJlp6+Fz9x9qqmPEsW8OPvHFzpYXOQjprkf+8Yh2Z3RXN8Y/WnwU1C
	 U3+UjMY+KbPhBT9w1DeUTzkL4Gml1y9/0hobnh5+R+J4H1PUkcFh8yTg9idhtSHLjocWF
	 1mQflxJ0IlpWzYK7kx59XW2W9sTLXwapuMThtrawbVdv3BDsL/s0U2JN8pvteQ/LAlPzF
	 j5X2ZvGk1+8rGEK8U39s6iOFNxdYs7pmFi00Pkj9GHd/uBwBEDD9/mJ35gyj0n191RNw1
	 RfvFBFh4QvqV0cfygfecQxpp2R+f1uAoNi11z4PYVpLDwrsprDX8nkE8w/NJ22P4e4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=srrjzHFP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D810B606A31C;
	Thu, 19 Nov 2026 03:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=srrjzHFP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2AC1F000C6;
	Thu, 19 Nov 2026 03:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058216;
	bh=027jESiXzzgbzXlS+C8ws6hlSeqBxIrKxIszIoYJHNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=srrjzHFPWlSiayPmrNi50fy7/zD4s2g9oJ/nj6akv4u0dnzTpjohFRCh7EehcLowJ
	 fd0UF+VQ3SYzV6rOHEWqliysMSXDjf38JavebPlZF4FZsD0KImZaCnhCEeZWDLfNnN
	 3YIbWB0AKALSIcGHlWalOG5MIT7r0v4ywtl31Vi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0408/1848] regulator: core: Fix c_rdev reference leak in regulator_resolve_coupling()
Date: Wed, 18 Nov 2026 15:40:46 +0100
Message-ID: <20261118145930.959779631@linuxfoundation.org>
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

[ Upstream commit c41b69e9f76fd9632662714c1d37860468e8d773 ]

of_parse_coupled_regulator() returns the coupled regulator with its
device reference incremented, but regulator_resolve_coupling() returns
without dropping it when the coupled regulator belongs to a different
coupler, leaking the reference.

Fixes: d8ca7d184b33 ("regulator: core: Introduce API for regulators coupling customization")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917142535.2156720-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 0cdb81a1ba316..6547776bebbfc 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5166,6 +5166,7 @@ static void regulator_resolve_coupling(struct regulator_dev *rdev)
 		if (c_rdev->coupling_desc.coupler != coupler) {
 			rdev_err(rdev, "coupler mismatch with %s\n",
 				 rdev_get_name(c_rdev));
+			put_device(&c_rdev->dev);
 			return;
 		}
 
-- 
2.53.0



