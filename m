Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CD7277026;
	Sat, 17 Oct 2026 16:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255330; cv=none; b=UP2QHpvYK6Nn7eQ1FU0K0OUYaObKWlKe7hBq4MvIY81g/xWoZrKWnDDwFCKUFwWlT4EiV03Tk8oH2pVwcHzRtCbV/Ldv7fTBgpsVgKproqEl/BnjekLhDx80BZyk1HKkYRA6PDH06ZFqzLdn4GNk1jUo8xx13bZN3iYz6lYJMJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255330; c=relaxed/simple;
	bh=m2i2K1ZefGP0U0LjVVYDDQheHaRfa2Ws+2bGF9t+MBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fb8sBquxJusVETEVNPvRCQ3BWw34rx7PygDnG20S8uMZUc3atWvDjjHjz1Yp1JeW341xxnbYkRzELKNNwfUW5tDbjIuomLVn+Xf/I90JOBNGir/Eo+dyD1w9niO3YV0PQcDQ7en5XDih8R1RO5ygQPyDGkPjbMRlxBViqLNj7vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NjCJbC1T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NjCJbC1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1056E1F000C4;
	Sat, 17 Oct 2026 16:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255329;
	bh=DmD13/DO7p25XI4D/7d5XrN0U8cU+x+0UdcYM3HIruw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NjCJbC1TqgOzEp0/vjeAHU77VJxl+Y0ECpNP/we1nznYsbjc225lY7Horhlwk2g8y
	 LA7caS4rEx+l42z3dwU1zZYYj0QdEuIPv3vToX1ooT9P2pYfFLPdUUOW8IPPGbA/qy
	 LSqYnkdIfDWn+CMX2bh9xXIre3+O4HIm2tk0R50U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 739/869] PM: sleep: Fix bit masking operation
Date: Sat, 17 Oct 2026 17:59:40 +0200
Message-ID: <20261017160055.891650920@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 3860cbe239639503e56bd4365c6bf4cb957ef04e ]

The mask operation link->flags | DL_FLAG_PM_RUNTIME is always true which
is incorrect. The mask operation should be using the bit-wise &
operator. Fix this.

Fixes: bca84a7b93fd ("PM: sleep: Use DPM_FLAG_SMART_SUSPEND conditionally")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Link: https://patch.msgid.link/20250319114324.791829-1-colin.i.king@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 36d74f17e03f ("driver core: Avoid warning when removing a device while its supplier is unbinding")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index cac90c7480d2b..89f0da18c98fe 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -1817,7 +1817,7 @@ static void device_prepare_smart_suspend(struct device *dev)
 	idx = device_links_read_lock();
 
 	list_for_each_entry_rcu_locked(link, &dev->links.suppliers, c_node) {
-		if (!(link->flags | DL_FLAG_PM_RUNTIME))
+		if (!(link->flags & DL_FLAG_PM_RUNTIME))
 			continue;
 
 		if (!dev_pm_smart_suspend(link->supplier) &&
-- 
2.53.0



