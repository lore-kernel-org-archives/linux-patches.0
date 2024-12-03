Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD23E1F4709;
	Tue,  3 Dec 2024 14:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237988; cv=none; b=QfXS0gR2MgD6InpH+yoLUQqWV+ZL2p2sWPQzS8cpioFqrKEApBlUqUFMfW5M1mZxoE2lUFmr3ZnnV8pl6RdTvx+JCNnzE8AhTiYF4x6jf4fluEOeZc9GAcUeSZLeNElqSX3bRGjbzzxULxlIlfPmOObCYy3pHerk24Inu2bps8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237988; c=relaxed/simple;
	bh=S3/emaXOh+uOEN66c2+Kvnl8uP849VdBxs23oE5FpiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXE3+ThqJJLqnoCcz/MRf9pJHqcX8M1ZbSeOHLASs/Yr6+cdZHOq+qiRJASTwtqpyOj2nZV8L2M1hmAYMIeKVGhgBbqk3ndAO64NLWFre3c7pjyvtCH8xG9yVD9D9W6PRi3JnMVP2L1lyT2YT4wXZTF78eWvZBA6WMiLEah+52w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPOLJ6vK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPOLJ6vK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD46C4CECF;
	Tue,  3 Dec 2024 14:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237988;
	bh=S3/emaXOh+uOEN66c2+Kvnl8uP849VdBxs23oE5FpiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xPOLJ6vKlB8DBfZj8UvbSZMM4q36nNZYdeyZ4a2tgzQ+M5gJYWB39XxJdqFbGWPqm
	 o/MmMTzEKjcHXI5lwJWiShAQZPGAsYyqH5j8drcsu57n0nH4cPFgRCgWk/MhdM8oGG
	 Ya1IxTE8FvTl0O/bsApZuuGdDCQK+gMLO4YGVNaA=
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
Subject: [PATCH 6.11 126/817] rcuscale: Do a proper cleanup if kfree_scale_init() fails
Date: Tue,  3 Dec 2024 15:34:58 +0100
Message-ID: <20241203144000.634216838@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index f88c75b3cea3b..31d480b533033 100644
--- a/kernel/rcu/rcuscale.c
+++ b/kernel/rcu/rcuscale.c
@@ -781,13 +781,15 @@ kfree_scale_init(void)
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



