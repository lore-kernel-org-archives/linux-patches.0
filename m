Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064191;
	b=Ubthpvn/NxS9SJucVh6f97ny5K+GfMK+SllGFv9PGz5pKKMD0I+eL0FaOjLHPqR/c2HB
	 wyLpzluWKC6A+nGeESHeXQ6pDvNBREbgf8MzIrj0eX9DWzBOazcevgstIt+NFlKm+nuZc
	 BhnguxHj2jWImN2WL/AXM6LiraNU1iImDZpi5PtJNNS1pgsb+od1iXvt+U96JuEb5egxu
	 If7wqLBtBieC40mup3F5tUn1JHjXS4hT2r/qnEf9QNek/lo570XRON1Dx6qESDmpyG6zu
	 gV1wQqoi5w7/wxLKP/J2UEA2nH6fuAQtoSqtg9ZFdFF0gURWVxIKuM95jjEIn/s7EVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FA6n+2Jtoo2VthamL+uin0wSv0E6NqCm6HfboVYWI4A=;
	b=4kbjX+gy/fEM4nFz+dplFpv0sJ4IlabetPVOOt/xo5rLiP5gY/+cxBWlZgs+dwOEoGKz
	 4fVcWCrMt7c0bspla1nvVTUSwy92fPi6PvY2+FDjnBxvVKHp++GVd3WufrCuKkAng8qTC
	 TDnUUzk3JexMCjVX29F7BedInp9ZvoYUb8RZUeMdN5tGgERIiT8rQRgA0GuA7ZDnc/AyU
	 zSsq/CxDgAVhBqlEFNkqGd1SmkTQs/+NLYXZolc+6lsRcSC6UOUEpzXEMJY7E2RI3z8yx
	 FTdW5exkW5sZyzBdlECE8cJKh1AMI1lJMDnHqEWl6MHuG9m9scYMzct91Tf3tcckslA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1FvsjFua;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C8D606D829;
	Sat,  7 Nov 2026 15:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1FvsjFua
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F041F0089F;
	Sat,  7 Nov 2026 15:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064191;
	bh=FA6n+2Jtoo2VthamL+uin0wSv0E6NqCm6HfboVYWI4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1FvsjFuajorf6NXanI9zY9SnRmQ6lEpBSnc/M13NN0jr8Wih31DSue++F40dNTMkH
	 ZgwBUudoNe2GTpMnNipXpPBVepkg+Q1A6G2tFgbz+eUPlgtsNxkIafkCtB+8WSyzZH
	 qANt8rGSoK0OLGcAZD/sj24WKILY3olteRU4ibbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0296/1257] regulator: core: Fix coupled regulators reference leak on removal
Date: Sat,  7 Nov 2026 08:43:12 -0500
Message-ID: <20261107134947.638949278@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 811a890b88311..e20f00c364efe 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5909,6 +5909,8 @@ static void regulator_remove_coupling(struct regulator_dev *rdev)
 
 		c_desc->coupled_rdevs[i] = NULL;
 		c_desc->n_resolved--;
+
+		put_device(&c_rdev->dev);
 	}
 
 	if (coupler && coupler->detach_regulator) {
-- 
2.53.0



