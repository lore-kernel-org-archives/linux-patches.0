Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E73207A04;
	Tue,  3 Dec 2024 15:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240264; cv=none; b=jlMWZtWK8Ff2i4J7cTHDmzeil6wuTUimNG6tcyVcbjhRzG2pa8qowypD+DjBmLVbcgPeWjzfcpWt52R11m5enemuAQO50Vkl95sW9Pf+/qiOOcsMcUV7SlcNQHmA+hB/7N2G2jpE8tVCawibfrGbLJOLJFXJSdDgYqsAE128Q+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240264; c=relaxed/simple;
	bh=gijS9OFBKbXVX1cEPmcIO/cHQzKW9yNYM6m84Y1ToU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbzPqlKDr2xv76GCdIr25tPaAtDIN470J8MN/tYvsWq9ckYzAnEPp9+IJQTrkXXmGSlmHmwZo5Ly9I6I16gmlc7sSWmx4dV93xj5DWdn/+AP9X0HXUrc8bLNVFetc4Y+/4GP88MIRW2XwMytW3NbrqC6iC7aY3sagQmh/FIEEhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RootN3N0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RootN3N0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5FAC4CECF;
	Tue,  3 Dec 2024 15:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240263;
	bh=gijS9OFBKbXVX1cEPmcIO/cHQzKW9yNYM6m84Y1ToU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RootN3N0ltHd+9cYVgh/iM1sXEsAZJx44GF5KpLlWPH+P3o/icpxGw/B5uY/ZqrpP
	 NkNt4WRV14KxCaK9bMfsi5kk/pIqPJ+Koyduu3uTC2ceKn3aFG3F1noQzTbTANWT9D
	 IDaR9fBq8hkPUjIHNO1GRo3Z972Jx/hOCyGLD89U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/826] rcuscale: Do a proper cleanup if kfree_scale_init() fails
Date: Tue,  3 Dec 2024 15:36:47 +0100
Message-ID: <20241203144746.590955039@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uladzislau Rezki (Sony) <urezki@gmail.com>

[ Upstream commit 812a1c3b9f7c36d9255f0d29d0a3d324e2f52321 ]

A static analyzer for C, Smatch, reports and triggers below
warnings:

   kernel/rcu/rcuscale.c:1215 rcu_scale_init()
   warn: inconsistent returns 'global &fullstop_mutex'.

The checker complains about, we do not unlock the "fullstop_mutex"
mutex, in case of hitting below error path:

<snip>
...
    if (WARN_ON_ONCE(jiffies_at_lazy_cb - jif_start < 2 * HZ)) {
        pr_alert("ERROR: call_rcu() CBs are not being lazy as expected!\n");
        WARN_ON_ONCE(1);
        return -1;
        ^^^^^^^^^^
...
<snip>

it happens because "-1" is returned right away instead of
doing a proper unwinding.

Fix it by jumping to "unwind" label instead of returning -1.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Closes: https://lore.kernel.org/rcu/ZxfTrHuEGtgnOYWp@pc636/T/
Fixes: 084e04fff160 ("rcuscale: Add laziness and kfree tests")
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcuscale.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/rcuscale.c b/kernel/rcu/rcuscale.c
index 6d37596deb1f1..d360fa44b234d 100644
--- a/kernel/rcu/rcuscale.c
+++ b/kernel/rcu/rcuscale.c
@@ -890,13 +890,15 @@ kfree_scale_init(void)
 		if (WARN_ON_ONCE(jiffies_at_lazy_cb - jif_start < 2 * HZ)) {
 			pr_alert("ERROR: call_rcu() CBs are not being lazy as expected!\n");
 			WARN_ON_ONCE(1);
-			return -1;
+			firsterr = -1;
+			goto unwind;
 		}
 
 		if (WARN_ON_ONCE(jiffies_at_lazy_cb - jif_start > 3 * HZ)) {
 			pr_alert("ERROR: call_rcu() CBs are being too lazy!\n");
 			WARN_ON_ONCE(1);
-			return -1;
+			firsterr = -1;
+			goto unwind;
 		}
 	}
 
-- 
2.43.0



