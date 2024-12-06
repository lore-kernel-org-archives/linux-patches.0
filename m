Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D3E1F8F13;
	Fri,  6 Dec 2024 14:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496785; cv=none; b=gpyCqmkNLRlNK7BZBVIAbXDR6kD99Jj3F4Vq9ONI5hUATaucwTsTcteZkMA8R8mtUDxOkpi+gK2do58vLsNgstnQhi0B+yS9ar+pVq+ltY71VNXVPfYahqAp2/AL18YSvWdWs3DS2yvDhClxVNET16QqElybGOWFhHpXewlLcIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496785; c=relaxed/simple;
	bh=oihSPhjL3dbZQIU/qxX+sogyP8W+sy81ih0eCg8LFbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hl2Mej9YnmdqT061zbXZEWoGoLyrLM2IhXWaGkc9eFsmQkKBnT/B8caAvNlVjTvyiCseTVWxg9LcgJWXnw3MudRcNM2+KaBuJAjerqPw5rYuYqPrCDUGCf5rAMUJ7DQNDNHZDarzKMei+aah+6gGvio5Rq0yQ8QygJaOI+/B2SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZvi7BYz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZvi7BYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C07C4CED1;
	Fri,  6 Dec 2024 14:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496785;
	bh=oihSPhjL3dbZQIU/qxX+sogyP8W+sy81ih0eCg8LFbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZvi7BYz/lQU54HajHY7kXvEBi2o82mvgiV+OlnSGEHzXqY6Ls5o3/zCL5FtpKYTD
	 qwh+9s1zyuX7Um5NG56fbdadfl5F8mu6mYywWQlfgxYAqgh35lrht8ajjer4OLMF9i
	 rDR6FXfPfXv25v6iu50tQFJXBgBLmtu3eltH6xgY=
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
Subject: [PATCH 6.6 102/676] rcuscale: Do a proper cleanup if kfree_scale_init() fails
Date: Fri,  6 Dec 2024 15:28:41 +0100
Message-ID: <20241206143657.340487079@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index ed46d9e8c0e43..902575db9aec3 100644
--- a/kernel/rcu/rcuscale.c
+++ b/kernel/rcu/rcuscale.c
@@ -780,13 +780,15 @@ kfree_scale_init(void)
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



