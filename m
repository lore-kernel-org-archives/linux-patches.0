Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF091BD00C;
	Tue, 11 Mar 2025 15:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706398; cv=none; b=Golla/CRs9ftsFBlgmDzA5R95wBLquXp2E1Nst+4Kkb09WTcIX7C0fxc3ilsAhOn0hWG8Fcfr7O+4cJRV1mer40+X0FkMelwf6mTn5HFq1+FVnmxoDLtfAp/ItQsz7uoD/SOjP2Y8MAL5OtetN6ZzSqpjmSizSsZMZcp8MvfRjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706398; c=relaxed/simple;
	bh=4rpHAl0W4H5FxAxqSRtVWvRqYLgSMHx41/AyWfhxcK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5MqmBA+HTmzmeAB9iL04GJVfzv9HHM/a2c6q1ZebMPk+3b4XKWC5xFF+KTasGDubU0IUcIYmP1OnXQIONtKcm99PkOY7WXnera+qmf2Ap/Um/3SrE6nFGuEC/Id/EZoCT8jHNCQA+iNLs1mL5PlrKPapg8OYNr8vJSmLx8m6Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xcaYXZxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xcaYXZxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6BE2C4CEE9;
	Tue, 11 Mar 2025 15:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706398;
	bh=4rpHAl0W4H5FxAxqSRtVWvRqYLgSMHx41/AyWfhxcK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xcaYXZxdoTAL8hdTLlZcT8uldFYX73uLvYHIvXBOdxDc7q3EOCVYZBvRz/PF/FrSY
	 9xHbb6XJfon8ji0zqmPBi3CeZcTkxn27N6XnGOv8jw/k/UaJ9ipxQCQbO3SRVk4Xd6
	 Bij+lmpk13HHSn6KQBQMS2J9zNq382jwzQL0T3zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 034/462] regulator: of: Implement the unwind path of of_regulator_match()
Date: Tue, 11 Mar 2025 15:55:00 +0100
Message-ID: <20250311145759.702575379@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5d844697c7b68..d1e69470137cf 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -377,7 +377,7 @@ int of_regulator_match(struct device *dev, struct device_node *node,
 					"failed to parse DT for regulator %pOFn\n",
 					child);
 				of_node_put(child);
-				return -EINVAL;
+				goto err_put;
 			}
 			match->of_node = of_node_get(child);
 			count++;
@@ -386,6 +386,18 @@ int of_regulator_match(struct device *dev, struct device_node *node,
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



