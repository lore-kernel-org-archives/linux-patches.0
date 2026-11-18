Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036086;
	b=g4lFFjfJb2PHfDTqgLEtu4Lob0o5jlXrLIV78z81US/cPy0CsJr/AXY1vOk3XIkAtloD
	 4RXSReBjHRxkhmk8WF3vd4S+h4hC7bdRHuULWzNJuY5PSFJDWoB1o9fq+4dM9+1e9xxmT
	 7nwOx6+5HjjSsz7rh15PHxTXyPs3T+wrPT2UmZSdROd/O4qHScXuAU3YFNO/qw9pyUn6K
	 u74FIoL377nXCyuUYcZwRpuG718Ruk1oaLpIXBmbbq2Wz72O+QeiD9b/qcynuaLlKFw9q
	 80HVk5ZYXV3NYB+W1i3w8+A1T2KIBmLp3AENDK5tXOgKoYyBZIHH4PlLIe+XzZ4tP7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036086;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EYeynIiBeMRoHrQSjnVAHz8+0ykRxuMcXgU/okxHIjQ=;
	b=EAgAO+voetgwlJ77BHpYSycZgrYMfrztBs7YhCHfeTHH3H/Yyx15vLUfTVWmmwDILXot
	 VKU86rAmDvlSyzqWudtYZlG1ovr6i8Fwxkp9vmuvTAPah4wd/MDaTkuIj3kY1iVNicuK4
	 wKL1xAXPbHW9OqvZ6bsrk/BafyjMHVlw7K7aUXXd8evwhjckozog8GAdIO789kqdViI1F
	 xhjErfJaRknvG9YkZo3+nD2eIRlv11EFfyyt03hVGLT7mid6+UhHYrD5SRK44C42rAOUF
	 aXRu3CGiMI0AbzpgifYZfcu2G+VqMUoufl455k1nwa6G4vYdqHRteBwPWq5LLSCQq6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BgGoCmx4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6420606A31C;
	Wed, 18 Nov 2026 21:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BgGoCmx4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB721F000C4;
	Wed, 18 Nov 2026 21:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036086;
	bh=EYeynIiBeMRoHrQSjnVAHz8+0ykRxuMcXgU/okxHIjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BgGoCmx4UvJ4F9NJlhOR7NFFDuzKuXpRdCJE9WOQl6VU4ZmPrStDngUfJqtIEeC2d
	 8El1St6yjpbyig6bBSFSlPRyUXzmNpljBskh7mwwi6tXId0gfRdqJEbXb5QwMxI5A9
	 sA3Z5GJ6fzXEMh0wy13q8AKZiouFt6mxalKjFv7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0935/3318] regulator: core: Fix coupled regulators reference leak on removal
Date: Wed, 18 Nov 2026 15:25:57 +0100
Message-ID: <20261118150347.608774069@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8690166428a75..372208ce19fcf 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5459,6 +5459,8 @@ static void regulator_remove_coupling(struct regulator_dev *rdev)
 
 		c_desc->coupled_rdevs[i] = NULL;
 		c_desc->n_resolved--;
+
+		put_device(&c_rdev->dev);
 	}
 
 	if (coupler && coupler->detach_regulator) {
-- 
2.53.0



