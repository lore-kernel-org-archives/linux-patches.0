Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045094;
	b=zp7PWnrc8ZA//WSE5g4S3pfowjjtJBPVyBI7cU/fARh1M/2A/XF/05RtkmtUjveqLEl+
	 X+VShiiFXMMnChim2afFkAAO2weuy6R6pr7ylr3VBNHjd43GIVM39nt/9u/sP84Mkx8sa
	 5TpL+0+vadF1edNpk5IA1qrnVBX6Npp76Xkg0AYnp92KCqvKVwPxO92d8xFu+0bSiuo26
	 3yQ5PDrTMoLPmZ4WWyAS0bqiuHQWV/fdMsEa7aVIXsJK+PzU2HVz6YCjRz/U4REB1Phjj
	 y6e3ORyFRGT1oDqKI3JJcWtIt+dW4SpojJN+J1zLlRQ43Os+tJEdpAdVuCGDTy24ecw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045094;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZolQWTXNRfcEiSS9KNHpr0UDFPsEBZ6QL/sHV0ylRlU=;
	b=TRL7AC/ICGjbAZ7siSMzEXl+DIFWmdSlNGPaO5jDrkDc4CUjPeM1Ld0zO7QqvfFnw4Vt
	 6o76W7zCaCLHryCczvwnTmwnurt+KQqoEUTbWRJe8tdYE8YQC//JfwBeIiEUT6xnY/Sn1
	 I0ER1mDfKoMrYnmbEXPqnLlYGCaYDIFXExWAO8ltflsoDRRcmShQIDBtRDFBtpyw+lJZV
	 PzNVObV2qBklD8tAeQ+g/fORDG44Jiz8FOFwV106fbu1jcg9NMheJCQTppioZYwi4qQ2P
	 +CxleLi51OqHUzfFo+Oeiyr3tBuUWr13+gFVLCk35J7yUallUcgMQ7XaHPZrxGY2Q8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Mk0FagZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB93606A32A;
	Wed, 18 Nov 2026 23:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Mk0FagZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3AB1F000C4;
	Wed, 18 Nov 2026 23:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045094;
	bh=ZolQWTXNRfcEiSS9KNHpr0UDFPsEBZ6QL/sHV0ylRlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Mk0FagZTsnWvZT3q1Qt3DLtDOl20WdOeIdgzH8izuD9LJcVlsACfqe8RxYQ3vbhp
	 w7mxK/jGMchixMTSUpAE9a/3airjTHzJNFJ5ldB0n3rSCqXPh7se4KJchm/oA4Bu14
	 t3wF6zLb5mHBbIGCigsO+PmMzSQGRtK9lrQkQ6+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0784/2857] regulator: core: Fix c_rdev reference leak in regulator_resolve_coupling()
Date: Wed, 18 Nov 2026 15:30:18 +0100
Message-ID: <20261118150229.796879240@linuxfoundation.org>
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
index 52fb31ed59e48..44ae5fb8dad36 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5405,6 +5405,7 @@ static void regulator_resolve_coupling(struct regulator_dev *rdev)
 		if (c_rdev->coupling_desc.coupler != coupler) {
 			rdev_err(rdev, "coupler mismatch with %s\n",
 				 rdev_get_name(c_rdev));
+			put_device(&c_rdev->dev);
 			return;
 		}
 
-- 
2.53.0



