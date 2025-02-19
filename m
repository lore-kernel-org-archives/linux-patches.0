Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685C91CAA68;
	Wed, 19 Feb 2025 09:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956112; cv=none; b=R1nnv4aT1SpRt/2UYwliIm4ohmLxfgPlJ/tOpdOGGWnW764obWzwyX4sC0XsQlIRWfkdqlTXH05eOZZgK/FzfBhLZ8hfZTiJkoTOedR5l6qiEi+FOQYMS9Lhm4sblyQifIA9uZjWbF7CstnVhoNIpiUJaV2U49cjqytgO6jXn7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956112; c=relaxed/simple;
	bh=jEMINu276ZWxM7XSUOi77mwBAYmVIGOoR4VRuMPEtdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+hTvKmssP746bBa14kJNORP4EMKz4EEZFSYgZgwecfbNevAKL3Ds7TPLG927JmdnGnUx89A2kNywfzHdzKvRMDX0Hnn764Sb6OG7EqahiJ6sShDOLW+4q2mqHoBS20ER3Jr1GssDMxHxPmSOl8xtPDZk05ia4fptP4Dp6WDIDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FFxw2e+E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FFxw2e+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2584C4CED1;
	Wed, 19 Feb 2025 09:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956112;
	bh=jEMINu276ZWxM7XSUOi77mwBAYmVIGOoR4VRuMPEtdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FFxw2e+EyumpSWX5o27UIrt5PyNHp+9ZVRPTgx1o5K3BwsHjcXvtx4Z3fZTMbmS6b
	 Mh2mYLRI6Aw0Iuy3aSqBPXzrHN8AYDGk/wSavmxbOpGsUNqnnqyASR24MUWfAfuRZS
	 HKuUOypy1e964UL0ALmlyG8ZWbGVE8ycfNUfzgH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/578] regulator: of: Implement the unwind path of of_regulator_match()
Date: Wed, 19 Feb 2025 09:21:12 +0100
Message-ID: <20250219082655.560753636@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit dddca3b2fc676113c58b04aaefe84bfb958ac83e ]

of_regulator_match() does not release the OF node reference in the error
path, resulting in an OF node leak. Therefore, call of_node_put() on the
obtained nodes before returning the EINVAL error.

Since it is possible that some drivers call this function and do not
exit on failure, such as s2mps11_pmic_driver, clear the init_data and
of_node in the error path.

This was reported by an experimental verification tool that I am
developing. As I do not have access to actual devices nor the QEMU board
configuration to test drivers that call this function, no runtime test
was able to be performed.

Fixes: 1c8fa58f4750 ("regulator: Add generic DT parsing for regulators")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Link: https://patch.msgid.link/20250104080453.2153592-1-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/of_regulator.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 59e71fd0db439..f23c12f4ffbfa 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -435,7 +435,7 @@ int of_regulator_match(struct device *dev, struct device_node *node,
 					"failed to parse DT for regulator %pOFn\n",
 					child);
 				of_node_put(child);
-				return -EINVAL;
+				goto err_put;
 			}
 			match->of_node = of_node_get(child);
 			count++;
@@ -444,6 +444,18 @@ int of_regulator_match(struct device *dev, struct device_node *node,
 	}
 
 	return count;
+
+err_put:
+	for (i = 0; i < num_matches; i++) {
+		struct of_regulator_match *match = &matches[i];
+
+		match->init_data = NULL;
+		if (match->of_node) {
+			of_node_put(match->of_node);
+			match->of_node = NULL;
+		}
+	}
+	return -EINVAL;
 }
 EXPORT_SYMBOL_GPL(of_regulator_match);
 
-- 
2.39.5



