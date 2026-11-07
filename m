Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062089;
	b=TsvPgrXp00N9trVb+dYiBj0Z8/t7agHZIEANvk0nJZLXeaRrFUwZYA61cUQjgIHi+Pkk
	 fDRI13xxtuhTIUZRtHX5gtsw0iMVW/84Lhxy8zdvG93rtHCyEj4h6afKt0tZoYhFSJAXv
	 EXGhN70LpHUnF/XsQqJCnIARbJK70yVQIr5W7lKYL8FfhQBwDdjqgYnG37qexMDfZS5co
	 DHI08dWQ1Es4alOisiNoqEKGTmTp34I/30DS5dtRTDFRDRziUFWhusLtSqJS2XNl4+r5Y
	 BSeMaCpiejjNXR4vxzEK+MceuIDG0D8QT3raKHpOuZVjdZNdbPy6YsJG6F4ANPJfZeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062089;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dG+29u5lUcHsQ6GV8nny60Bjd5eVE0a9ybPP8uVu9Eo=;
	b=eVWOKuyWL4YwwLPFQkCrmdBc3vjhmaQGEt3u9mF8hYtxf2T/7jFQLEeLznFVuAedjKSX
	 tPfcTVxYhlYgVl1Qlpm2kr2xgNJFixHReFvu6Qu+Qch3CR9hzt7+SQUhwfgOlbTfkNswg
	 alp0YrpYs/ONahjYx+GMBoBJngu6jPmjJ6al1S1iVcazH1iFd9amOAMuoFV1EH93VXwZc
	 6K4aIa13R/PA9Xm1hrjLcu9mNkhjduzio3aIdpiCXNHHiEafjT/P107XfGY/F+OVXElgh
	 dL11U9pywnmT5M+ISsIjbpVOmBH6wEuQH83jcGts3UgoKc2VU2Vll5EN467Xmu7AjFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XztOSRuV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459AA606EEBF;
	Sat,  7 Nov 2026 14:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XztOSRuV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88651F008AB;
	Sat,  7 Nov 2026 14:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062089;
	bh=dG+29u5lUcHsQ6GV8nny60Bjd5eVE0a9ybPP8uVu9Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XztOSRuV48C+yf2v43iOnjvrzTSNeQGVFi9FrENV8LmXBLbE5nKc9JI6nbsZHe/bJ
	 Tv4MtNiwflTf8GZqTEZtarDZur+RLaHuEeTdVzkDhTN/PZxmoexiiCgfy4uyJb1rjr
	 TDqBHhhpdK/c8l+T+/fcbOmZKUE0qpPfEuLE3lc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1063/1536] regulator: core: Fix coupled regulators reference leak on removal
Date: Sat,  7 Nov 2026 08:51:19 -0500
Message-ID: <20261107135027.540296181@linuxfoundation.org>
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
index 707fa12836471..3361556d1b6ef 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5573,6 +5573,8 @@ static void regulator_remove_coupling(struct regulator_dev *rdev)
 
 		c_desc->coupled_rdevs[i] = NULL;
 		c_desc->n_resolved--;
+
+		put_device(&c_rdev->dev);
 	}
 
 	if (coupler && coupler->detach_regulator) {
-- 
2.53.0



