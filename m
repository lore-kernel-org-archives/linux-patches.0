Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062014;
	b=Sv7eVUbFXVQ5OhQBmhsAFvN2oWyNY5x+FiEQHDLqdPfgReeWF64Fsfy5DIbK3b/zO8iG
	 SYvKOdm097ELpWibXcarJl8+js+DD0Vu2UAvIUneqxr1pmt2xxo0wTUvzRzsmXDSJyqHV
	 LDiybvzElaXhLeb1Y0kGVNgG0FtTnDVeuC9K5ekyK+RZ6NCb7iFvU1DTk+d1FP9xVORYb
	 qP8qqfQkj534cNU2tqGbiNSj7ImZ3XQPByyr0NYmyeVTfSLV7LJ84bMgKJp+Xinr2Bjkx
	 647nyJ1I+nMulmMnvUTnu6J00GO+DkesqK6InHFECX/Cudk1pCoDO4FM42t3L2dsNhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062014;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2x5Rc3gkZ0xKd2CuWaAkMQy9E8ngdeHoD6kI/stS6z0=;
	b=rcZDPB8RIIZKPupDKjSDyZeF/TLTQ43g2u39u+SrNGSATZ4ZBDHOh/UY6cVVicnjjQJG
	 kamCWU9wrZmLJhmhEButTcD2srT5izQmxxjtl6iEkSjGNUjAqLmaQ1JyiyLsUK4SbYIJA
	 f2GOExh+sGy1BuojJSeCWD6R7iGzD12+ffkWa6cFm2ejcdBealPEtOqHBYpyNSMe5cUJO
	 o7Cx/seyZKYVCNn+TKl5CTELOL+tQqhdEgSpNQDw8OrCFbcCPhuqmNzHuFiRYZOezorYc
	 sDqjcgJcsgj0juDNkg3dIKWcE/4H0kXjGphwqtUCnFGkbq9cBpY0MSuS1YdDj73xYJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sjzfGQKu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4924A606A332;
	Sat,  7 Nov 2026 14:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sjzfGQKu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8131F0089F;
	Sat,  7 Nov 2026 14:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062014;
	bh=2x5Rc3gkZ0xKd2CuWaAkMQy9E8ngdeHoD6kI/stS6z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sjzfGQKutRiTuCjPxAILj7eg8tbOAs1u+y/LuJ/w0+TodyZImZUX+mlNaQ8ZYdGiZ
	 anwHl/IT0YmEN8wjPYdT5uXCdqtKxmvfljCv4iJaRxvlv/q/oqF4U3u1FBfQXnd9Tx
	 +sPQW7cQtsqVSrDbOOu+ZCsO3MlTMPDq3W0RTbdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1003/1536] regulator: core: Fix c_rdev reference leak in regulator_resolve_coupling()
Date: Sat,  7 Nov 2026 08:50:19 -0500
Message-ID: <20261107135025.840126377@linuxfoundation.org>
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
index 0462b4726a64d..41dd9b2a41b76 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5525,6 +5525,7 @@ static void regulator_resolve_coupling(struct regulator_dev *rdev)
 		if (c_rdev->coupling_desc.coupler != coupler) {
 			rdev_err(rdev, "coupler mismatch with %s\n",
 				 rdev_get_name(c_rdev));
+			put_device(&c_rdev->dev);
 			return;
 		}
 
-- 
2.53.0



