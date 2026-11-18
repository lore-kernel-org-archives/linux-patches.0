Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045147;
	b=y2/lxwq7ot5keuPzftaRNsVm3dxh8nG9XzCq7+1qx6XQ/yA5iKue1Zf8UGyoR+F84Wne
	 icAIpOLAdEUp8azG/eqaIlIY0HIXYtiR2eAxXvONxXhPQ4HW1c/ureBCVbZGiiO5QWqN+
	 cVqmNZj9SobrfS6uxPCRA73P7//v7iH2tCrp1gkbrZOuB79RPXab1B1qg07FHo4Zm7fz4
	 ppI0lEbfyhMg3qtEym+4WaQY6TvoySV5i8RiZ5W23L5k0G6PedGNpHnopckKGEJDdENGU
	 Fw1quHujJC3h0D32E3Xkt/KlfxqSZpyZD2k9i+XVXJX2nZQR5ufXArkVfROQ2SonYDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045147;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=njI8fPJeDLWXfzCKnLgY47WonRjHI7Jwm2B/H5EuQ94=;
	b=2iepoMkOghXsfdUv1cZmZRvSz3WhDMW12pTz6aof9ygtIJZf0mGewPJ81mHOMi/8ScPO
	 dO/FG6xww3B5ytDN0T4mAjQNUHJGNxXgpJ8alFr2B6KdCuHFUcF2TfiQX+biGGQggC0CV
	 rj/0vF6i2zFQsoDrmFiABWmc5GSemab7PJI/SVr/PPSdpRbClMK+3x3uNo+rvXJ3UGjuN
	 m+kvJXIPeszwf2wU3c8Q34DwwajbEp0z4x0f89QgbxnV4ygqBgUrY4i1HNVcnyWpka4ks
	 /fV8NR0ZqcwvGiqxrdNrOWrnSy4/H7O7/w4WLGa+vjSZHruInLSs0m4D+jNu5kXBqiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dtUzpbEh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590B7606A325;
	Wed, 18 Nov 2026 23:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dtUzpbEh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D151F000C4;
	Wed, 18 Nov 2026 23:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045147;
	bh=njI8fPJeDLWXfzCKnLgY47WonRjHI7Jwm2B/H5EuQ94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dtUzpbEh3AJrHiL7m8/R/4SB7RqxWejitUtMP0glBqWPZqRR5LqFKnjDKTSf9xeRr
	 87Togawp3K4Vt26vdTSd9G0xLHKCUTA9BE2jXpY0SNgqPfvcluV6ovHZor8A/J9ngQ
	 nxYyYDv3ycFf55xKo5xzNXU9OOzM2cpx79V7f07E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0819/2857] regulator: core: Fix coupled regulators reference leak on removal
Date: Wed, 18 Nov 2026 15:30:53 +0100
Message-ID: <20261118150231.066155853@linuxfoundation.org>
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

[ Upstream commit b9205f0837ca91a0bbe6aa9002207656840c1406 ]

of_parse_coupled_regulator() returns the coupled regulator with its
device reference incremented and regulator_resolve_coupling() stores it
in coupling_desc.coupled_rdevs[]. regulator_remove_coupling() clears
those pointers without dropping the references, so they are leaked when
the couple is torn down.

Release the reference of each coupled regulator while removing the
coupling.

Fixes: d3d64537c339 ("regulator: core: Resolve coupled regulators")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917143052.2156903-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 4c0d8cd5bcbf3..94b092da4ef03 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5453,6 +5453,8 @@ static void regulator_remove_coupling(struct regulator_dev *rdev)
 
 		c_desc->coupled_rdevs[i] = NULL;
 		c_desc->n_resolved--;
+
+		put_device(&c_rdev->dev);
 	}
 
 	if (coupler && coupler->detach_regulator) {
-- 
2.53.0



