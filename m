Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226AC183CA6;
	Mon, 12 Aug 2024 16:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479582; cv=none; b=jXVvhmMm9Dqiulb+AdFxU6rJlJ+wBc154fAp7tnLuan+oqJSkvabSS9j33ecuvQqkYz6Fu8a+FAIkO0enFsIWDFoknPRlwz1kJwuuOqajSobVBw0oV/PoZzbCEPZBlvoX1nAEFCZeH+vy5dWsauEJ8/ersEA283gHJjYDq0WDAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479582; c=relaxed/simple;
	bh=p43FZDDpJjvHda9TBsVy8xqAZeQisl3OX2/Q3KePGTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CCl4aJvmC27a0VhgQe6lsm2ohJSj8jEOI9BpHH/uzz5nL65E+qPpFyTmJO9CM5AT8KnHKrR+OTwVDgUfpIPi71YTb/6qINRI8rO0RnGGVYkM0fajklZ22p8e0cM0+/WXzXQeIPkgaiPib6maNec06ShlQyzsEzG1qGHbNZ9KxEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFFQ/jz2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFFQ/jz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86740C32782;
	Mon, 12 Aug 2024 16:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479582;
	bh=p43FZDDpJjvHda9TBsVy8xqAZeQisl3OX2/Q3KePGTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFFQ/jz2UYRv9uTwgziSNUiYF+Ns18g0sTzrKTBadCIRciN+vUx1n3oPKTxAxXY4R
	 XKTk4cI1ljLzs9VkhLJGs2jZcrxIMb526z2MhygnsRF0S7BZpYqRsIrMn3kJRr8kET
	 oNbkbELudWOWtFyCJjXTvrPf2NAyEQRthAFnMQ1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 100/189] i2c: qcom-geni: Add missing clk_disable_unprepare in geni_i2c_runtime_resume
Date: Mon, 12 Aug 2024 18:02:36 +0200
Message-ID: <20240812160135.992451065@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit b93d16bee557302d4e588375ececd833cc048acc ]

Add the missing clk_disable_unprepare() before return in
geni_i2c_runtime_resume().

Fixes: 14d02fbadb5d ("i2c: qcom-geni: add desc struct to prepare support for I2C Master Hub variant")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qcom-geni.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-qcom-geni.c b/drivers/i2c/busses/i2c-qcom-geni.c
index 5cc32a465f12e..5ed61cecd8d0e 100644
--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -991,8 +991,10 @@ static int __maybe_unused geni_i2c_runtime_resume(struct device *dev)
 		return ret;
 
 	ret = geni_se_resources_on(&gi2c->se);
-	if (ret)
+	if (ret) {
+		clk_disable_unprepare(gi2c->core_clk);
 		return ret;
+	}
 
 	enable_irq(gi2c->irq);
 	gi2c->suspended = 0;
-- 
2.43.0



