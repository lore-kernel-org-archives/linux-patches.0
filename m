Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062978;
	b=TDMUouqs6SD7SWNN+5IPkxFZgAdv6rQMiefFg1f1B33OPsAwICXHHg6NlvK0oL1NP28C
	 YN/bdWYGAmqtwyiR7nZKVJE61g08TsATTdTpt3PYrozVKHINyED0R4O+AhhHzQsOfo4w9
	 ufJArCTNlaIB4nHVw/zcXQx9kK5sisWPAMMGHbmSBsXcFTg+3tJIpuwWEXTYHVzbyorIE
	 1SeyaxxZQBv2fbzgYL3cvv+CD1V45RAFrPv69uw8pIgezRhRNuaA4n0PIdnPAqmdmdGIg
	 QQJkYxFA7TourGXdcBZgAh+dWHJUzbOcRQ+CLGY53OY0SHLA2uhEXYHhcgh/T1aYn7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062978;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ybObnUE1a/V8miSq384FrQawPHz7atFM7bV0rVNZVVI=;
	b=lEg6tJWC9hayI3GPXWZSlSPE/7iQJEHez9IujfNZmF3tMF3b+16ZAayRTDItO8PokZ87
	 +/hSUAzBimNvHi4vsecowyEZNi9S+igkOZSzLi7WfLgfpUQ69jR16wWZM8unu2oDz23jC
	 7Qq5NhIyOsSoWZEyQKCtO1BFmuDWxPhRSDrygSdpCJfgL+WCGYE41QAWuytBAbtH9PkZ6
	 wy0faQaFX91lGsLa0wgezuidAqncVgO5gaqiwrflwM1XasuzcyIU+QPO0uJkZNXPR1SEP
	 kEeyrM8c51J9X+Hu5se9mGg2+iZA3UweuAh44Z78zMbF2vYTTzKE9Smpio1vVCFuPEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BgD3e1hM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EAB606A330;
	Sat,  7 Nov 2026 14:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BgD3e1hM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90061F0089F;
	Sat,  7 Nov 2026 14:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062978;
	bh=ybObnUE1a/V8miSq384FrQawPHz7atFM7bV0rVNZVVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BgD3e1hMkPCUkx3mDP/pmJACBBgFnV+uCFrLoXEayCZjZlSqu26M4H6TmuCxS1JN1
	 z1wImfjsCLmhZKKz0C0AKYX/i3UufPnClN+v/MqTL/W207TbPJoEQSxa1s/T4GudBb
	 vWqqrHIomKNxZbkIynR6F1nc0ECr65QxbOuNDA90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 239/869] regulator: core: Fix coupled regulators reference leak on removal
Date: Sat,  7 Nov 2026 08:48:41 -0500
Message-ID: <20261107134859.935895309@linuxfoundation.org>
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
index e2328539b9fdc..bb0b7268b2b58 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5707,6 +5707,8 @@ static void regulator_remove_coupling(struct regulator_dev *rdev)
 
 		c_desc->coupled_rdevs[i] = NULL;
 		c_desc->n_resolved--;
+
+		put_device(&c_rdev->dev);
 	}
 
 	if (coupler && coupler->detach_regulator) {
-- 
2.53.0



