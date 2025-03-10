Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E6A230BFA;
	Mon, 10 Mar 2025 17:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628749; cv=none; b=V82d9Pc1L4QiTwvMYUnK9wkcsSPYudH7lps+SwIa/CmYYxWonFVKxZFhZQ6HXRAuHfnjEJFuKiRMXlAkCUUiJWhi6VNRTiCn7e4Xai1K6DiyixTs1cdI0XbnL/bdsMBE+YzWUW5Mh1D4x5+HyARDqAH86dKkAWww1IZ9BwR7T24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628749; c=relaxed/simple;
	bh=t8FRKgjIJFQfsBCM5vfFLaxb2lJ+Q0IkNxZYuj+5FRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uK/5+Qc4MbzsqeQKwbEGNzQzTt+Ck5ygl1a3ze7xLOJe6L4zAEvFpAAlhSKGwFlqdclydW8RbnzZG1inWfgafNOGu+GxIIRJMG9D9lkuZC2jgvyQ+T7Ccjd/xwa6yVTdhUnnzcoFi2Cosozz1iQukWJQNNYzg+kjnURUaITKwJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l1+PmpXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l1+PmpXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A475AC4CEE5;
	Mon, 10 Mar 2025 17:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628749;
	bh=t8FRKgjIJFQfsBCM5vfFLaxb2lJ+Q0IkNxZYuj+5FRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l1+PmpXFZzc8N0Mn67oL+1BIU15xajIrg4rCCq6b0kkMIIkbRvCdg3u9aNii2lUl4
	 FR/UIe7ejq76BYgaEI4InlER8NFed69MLfqjW09ev9xfyFgteftcJEf8CzI4VqgRKG
	 N4wa/DY/p0lG0MwMncsG6acsOxt1Dc3iVVJIK/4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/620] regulator: of: Implement the unwind path of of_regulator_match()
Date: Mon, 10 Mar 2025 17:58:22 +0100
Message-ID: <20250310170547.786911374@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e12b681c72e5e..a08905bab2797 100644
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



