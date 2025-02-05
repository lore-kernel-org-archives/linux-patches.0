Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FD9149C53;
	Wed,  5 Feb 2025 14:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764538; cv=none; b=ri88jS73LBMLfnRe2HH2njQGsAEsaDc+oi4AQR8CWU8evESJ29Bsr2tickFA1ZbHngjrDw7wRBobT/PKuuUzX+TmWvebCthVHQbfDhx/7NFlzYF9ve7nRHGjqgLqT1yi9eDxJfUvGj73pjlgB2BTbdaXXfseHhpfayuGIowfnuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764538; c=relaxed/simple;
	bh=81OwuTKgF+vb7Gxw+n7ay7WoBqUB0iV0y3RGwphP/z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCF+qxjr68M07nVOBdwaOhBOOwyPwgxeKGST6hNdXR25xXuigKBXSW6I3omrVUZSvd0Obm++Sp/pP8hvLFUg8UrQyjvJcbOABYy8oS9kJbl8DCPdD0/2q5qrVmf0cGm3YrwXde5XGSWExybVfIrEnlShCj1eYl+6LLz50ah644U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2b9Ecj/g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2b9Ecj/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598EDC4CED6;
	Wed,  5 Feb 2025 14:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764538;
	bh=81OwuTKgF+vb7Gxw+n7ay7WoBqUB0iV0y3RGwphP/z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2b9Ecj/g5sCr5W/miscxvWv0aivR+RlBD8GCz8w7NRsH6XwqsNxI89D/mMvY4E00G
	 eBGBTnWmJ9LOFoCP3LVZ73yCX8qwAxswFeCug29K02pEaGUQfpwF3E6DDi4xMu7ZAi
	 jOstIovJCQRd1vAKt3QguNJzd3fGgawI9nA+qtMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 136/590] OPP: OF: Fix an OF node leak in _opp_add_static_v2()
Date: Wed,  5 Feb 2025 14:38:11 +0100
Message-ID: <20250205134500.472140933@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit 1d38eb7f7b26261a0b642f6e0923269c7c000a97 ]

_opp_add_static_v2() leaks the obtained OF node reference when
_of_opp_alloc_required_opps() fails. Add an of_node_put() call in the
error path.

Fixes: 3466ea2cd6b6 ("OPP: Don't drop opp->np reference while it is still in use")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/of.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/opp/of.c b/drivers/opp/of.c
index 55c8cfef97d48..dcab0e7ace106 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -959,7 +959,7 @@ static struct dev_pm_opp *_opp_add_static_v2(struct opp_table *opp_table,
 
 	ret = _of_opp_alloc_required_opps(opp_table, new_opp);
 	if (ret)
-		goto free_opp;
+		goto put_node;
 
 	if (!of_property_read_u32(np, "clock-latency-ns", &val))
 		new_opp->clock_latency_ns = val;
@@ -1009,6 +1009,8 @@ static struct dev_pm_opp *_opp_add_static_v2(struct opp_table *opp_table,
 
 free_required_opps:
 	_of_opp_free_required_opps(opp_table, new_opp);
+put_node:
+	of_node_put(np);
 free_opp:
 	_opp_free(new_opp);
 
-- 
2.39.5



