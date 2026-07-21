Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D45434E2C;
	Tue, 21 Jul 2026 15:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648763; cv=none; b=cRcvguqPjNW+kemWpm0PAJXwlO4NjU2VqGFSYaIM+LIDY2+BmCkU3lEnLkvKqjkbOmVpH/idH2kM2T+5XrxT14KzfVb9wyjczbl/gvs9cqYGrBM51E4DRv+6vIvnXH8GUL10UV9akU+BiqqVbiIsy97CAEWTBxTKV/3u+Y2/eQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648763; c=relaxed/simple;
	bh=Enz9ytYH7Kr3hMeaOMf3MJIKQn3KuIfkDl8aj9DJUEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bmnYw12keWbpAUFvpCGqJj0bkQB+FjdawVowDGSJYbAlSR6f59IuUIiiFY0Y2ZTtNa5AvTfwGyFGeOAdw5f7HUkMyd1Zb/SPwZKgsiNhpn9CipsF61MiCWvGEeAdk7/nwk7UKo/PBpYxyBdLu2bljbshaY0l7O1hZd9dNhUa5v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GUFCdb1b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GUFCdb1b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F211F00A3A;
	Tue, 21 Jul 2026 15:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648762;
	bh=5qu3Gr4mT9tYhxIk1rJOA9mvU+t5xBzXroBVLWPtCRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GUFCdb1b7W6Y9+LSWXv0SPPN/9TB5B/IzVBMRNig/6pJFASLXXIVqk/4pTl0KL8gg
	 7JZfXYRALUB0mzShnr+BUyA/5PF3UQSdSBFAuovXQZmd01z2Bd8m5Sy6dPAYZ+rQld
	 2uAerib5dWlLsR/u7nDjnqj0YOU2edAdnPyowrbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0315/2077] driver core: Guard deferred probe timeout extension with delayed_work_pending()
Date: Tue, 21 Jul 2026 16:59:48 +0200
Message-ID: <20260721152600.106767427@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit 557495bc879013c3d5e21d667e987e7ce3a514de ]

mod_delayed_work() unconditionally queues the work even when it wasn't
previously pending, which can fire the timeout prematurely or restart it
after it already fired. Add a delayed_work_pending() guard to restore
the originally intended semantics.

Premature firing calls fw_devlink_drivers_done() before all built-in
drivers have registered, causing fw_devlink to prematurely relax device
links for suppliers whose drivers haven't loaded yet.

Fixes: 1137838865bf ("driver core: Use mod_delayed_work to prevent lost deferred probe work")
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260525012340.3860581-2-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/dd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 6ced7272b97e3c..f64175afefc915 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -323,7 +323,8 @@ void deferred_probe_extend_timeout(void)
 	 * If the work hasn't been queued yet or if the work expired, don't
 	 * start a new one.
 	 */
-	if (mod_delayed_work(system_wq, &deferred_probe_timeout_work,
+	if (delayed_work_pending(&deferred_probe_timeout_work) &&
+	    mod_delayed_work(system_wq, &deferred_probe_timeout_work,
 			     secs_to_jiffies(driver_deferred_probe_timeout)))
 		pr_debug("Extended deferred probe timeout by %d secs\n",
 					driver_deferred_probe_timeout);
-- 
2.53.0



