Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D4B1519BE;
	Wed,  5 Feb 2025 14:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765053; cv=none; b=WGvLcLocOJb+M2st0ZwyImCzZmwSDqUvgRhTLTj9w0+IE5Ig/oN2Mc8Yxm4HkGUSxkwf9BPyvxJWHMKyLi6ixtvyXIhHza8r9ztB3AreG+mQOZ9FoG1/JwJ2Wtx8LAEiDK5oQbhGaShzfdUElLtVRs6BQPMzI5CuZ7jHdB1o8Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765053; c=relaxed/simple;
	bh=CzGHGsPIDjicm7GIDRwR5WhOO1YgDToGoFRnPnX5NdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCcDM6CMeUqZmfmwYczPjvBs8kJlR0r8N4t9gnT07aun1/5MyZ2sU36XUukKE3B60wr7vbltd2l5QWgJ+7gXpbbmasnxYaJfpm8wPk5Dj7J+ACQUAUAcwo6xtP5JSmg2L2mSXfg8rRBtrtFohmcdqD58d+9h3fGBO9fi2fMAS6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bnw1iFjk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bnw1iFjk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC20DC4CED1;
	Wed,  5 Feb 2025 14:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765053;
	bh=CzGHGsPIDjicm7GIDRwR5WhOO1YgDToGoFRnPnX5NdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bnw1iFjkId8zmf3GkQK3ao7oQi6H1yYZKa12c59Q87HZN6lLAzSrA5SjHiMACTkiu
	 hmyPg9LXP5mBM3LGvC34kUyuX0Bw2SasziPCb7/KcYqUC6L95OjycJ1CjdFUr5fhkk
	 lNXOAvCZork7h3EzrBM+TpZW/KaXtzQEpohj75mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 139/623] regulator: of: Implement the unwind path of of_regulator_match()
Date: Wed,  5 Feb 2025 14:38:01 +0100
Message-ID: <20250205134501.551483090@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index e5b4b93c07e3f..6af8411679c76 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -446,7 +446,7 @@ int of_regulator_match(struct device *dev, struct device_node *node,
 					"failed to parse DT for regulator %pOFn\n",
 					child);
 				of_node_put(child);
-				return -EINVAL;
+				goto err_put;
 			}
 			match->of_node = of_node_get(child);
 			count++;
@@ -455,6 +455,18 @@ int of_regulator_match(struct device *dev, struct device_node *node,
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



