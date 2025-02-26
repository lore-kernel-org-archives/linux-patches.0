Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E234327004B;
	Wed, 26 Feb 2025 23:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740614050; cv=none; b=Owa2GtCij+a3ntIU3KymqNO1x6yn0NyYAWshy1SfPmUtjSaR2S0Lcm452tcSp/d+qse0kgPYzq2/3MLDQ/fUd9tiC5kZEVMENJCcw6TRLxYS/vO7oPf9BWSRuQEJvYMIacyJhwbhzX6nsz7KnA+IPymasF7SPLX6dONiWg3LzoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740614050; c=relaxed/simple;
	bh=jD7Egp07f6gfVmAR4BHuiJ5BbwvTOiAt4ojlMd6cO0s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dlzh3N74TzAFbMjxvVrl+OrGg4o5ONfOjAI4D4fliloeopyqy0JTZpErtZzVyrIvYy/BTHIkDrIQgHFf4Nq2o+TdyRNW4fGIUbS1JCY48IjYFS6fXKDUgqUBEmIk+VsrRpKIqM1kDOqrLDO1/JbW1sjii/9HlUYvAZR3F1PVeaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dkn+UrTV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dkn+UrTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F40C4CED6;
	Wed, 26 Feb 2025 23:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740614049;
	bh=jD7Egp07f6gfVmAR4BHuiJ5BbwvTOiAt4ojlMd6cO0s=;
	h=From:To:Cc:Subject:Date:From;
	b=Dkn+UrTVK3hyBc8RIZFfjdh7VK3/c4/eAlGuSsLCCAuCylSpxQeaK+3CtSkMJkqb7
	 OOhZDnRwlsAFUkVt8hnh0BR2S4WMM5UVMSzhxjPicwgIew7zBMZeLi0ZaPT7EpHz0U
	 hqofYN3QJv+oZ9ouYVNK2HWA7JmGplpkgXM21cWn3zgNkbGj9Q8e0F30XnpBH07wWJ
	 9QI3D33b38pJmh4FufTfWTpFbcNmgu/T4ru9cL6UrAzUj+AM1xEKsFFLaCtdjkmCzK
	 nPjIVffIJoIlgdaou3PdXJQlt60IEswZj4TEc/394l2U9sDVmkX9iddidGgOQnQ2hh
	 NzpHI1B87RNBQ==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] clk: Print an error when clk registration fails
Date: Wed, 26 Feb 2025 15:54:07 -0800
Message-ID: <20250226235408.1339266-1-sboyd@kernel.org>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We have a lot of driver code that prints an error message when
registering a clk fails. Do that in the core function instead to
consolidate code. This also helps drivers avoid the anti-pattern of
accessing the struct clk_hw::init pointer after registration.

Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/clk/clk.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index cf7720b9172f..466521248a34 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -4397,6 +4397,13 @@ __clk_register(struct device *dev, struct device_node *np, struct clk_hw *hw)
 fail_name:
 	kref_put(&core->ref, __clk_release);
 fail_out:
+	if (dev) {
+		dev_err_probe(dev, ret, "failed to register clk '%s' (%pS)\n",
+			      init->name, hw);
+	} else {
+		pr_err("%pOF: error %pe: failed to register clk '%s' (%pS)\n",
+		       np, ERR_PTR(ret), init->name, hw);
+	}
 	return ERR_PTR(ret);
 }
 

base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

