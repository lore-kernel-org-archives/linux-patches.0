Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7B68F40;
	Sun, 10 Aug 2025 00:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754785296; cv=none; b=IhJYsOsLeCmiw7i7HUhnVziaKf0ndWP/XxEwYmbKP9A/3vjp9I1n0Ud14Yr092wMy03ge0Q3xG5O7T/9kezfMpfLI7/RdtiUB1r2Q96kc9BEEG6KOIVMFrikwzwRA5CKytBJ8vcEJkyEzjaAZI4nPjLGd3DJjL76g24JJBXJSqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754785296; c=relaxed/simple;
	bh=oxbFC8LpeOtA7fHqzIDtkJBaA/dia+1GofAqcvEpL8o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Kk7UHu2pHh1OnUoq/R4S+1HDWU6AewtYbR5gwezMuuZmD37+M/5bISiOHZxnrAdAXmcTlvNMfTDAwBxj6mSnSy4zyqvJ562YEOOZ6hMrvXYyis5w6xQZ6fea3k3i19AIf2bPevbNC5v1aB3PqTaAGH0YRrks4HLoJI410CX/AuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sSez/7yU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sSez/7yU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03514C4CEE7;
	Sun, 10 Aug 2025 00:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754785296;
	bh=oxbFC8LpeOtA7fHqzIDtkJBaA/dia+1GofAqcvEpL8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sSez/7yU8bXOeMwMYXDYpCPguSdYR+krOp0FUnPi2586/vJgTDx3BLsytNczSxfD/
	 hDoRqN26JsKUVdves38CJi+i0SjdyeJ3KiCM6qn/SZUsYANl0H9bxiV56eN6Y5QjYh
	 LoF72yLG6HpOrNAoQP0hbIBVoPHXCV1T921vaxtqTuARA0qsUMD9A+L3UpOjxA5loQ
	 2lhBjGhQOpr1Pdxv47q5O5GNtSf14aEJ2smGESyo6P9UVNNCLzzNp6DgSNkyoH6vla
	 fMsdh+T+zY2k5lOrvVK8toRTIwbo80nRmVZiLNuYW2JEBu2DijTcWZoWchMlgZiDrx
	 8Tx1g9k8GIUDw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Breno Leitao <leitao@debian.org>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>,
	openipmi-developer@lists.sourceforge.net
Subject: [PATCH AUTOSEL 6.16-5.4] ipmi: Use dev_warn_ratelimited() for incorrect message warnings
Date: Sat,  9 Aug 2025 20:21:02 -0400
Message-Id: <20250810002104.1545396-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250810002104.1545396-1-sashal@kernel.org>
References: <20250810002104.1545396-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Breno Leitao <leitao@debian.org>

[ Upstream commit ec50ec378e3fd83bde9b3d622ceac3509a60b6b5 ]

During BMC firmware upgrades on live systems, the ipmi_msghandler
generates excessive "BMC returned incorrect response" warnings
while the BMC is temporarily offline. This can flood system logs
in large deployments.

Replace dev_warn() with dev_warn_ratelimited() to throttle these
warnings and prevent log spam during BMC maintenance operations.

Signed-off-by: Breno Leitao <leitao@debian.org>
Message-ID: <20250710-ipmi_ratelimit-v1-1-6d417015ebe9@debian.org>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit is an excellent candidate for backporting to stable kernel
trees for the following reasons:

1. **Fixes a Real User-Impacting Bug**: The commit addresses log
   flooding during BMC firmware upgrades or when BMC is temporarily
   offline. This is a practical operational issue that affects
   production systems, especially in large deployments where BMC
   maintenance is routine.

2. **Minimal and Safe Change**: The change is trivial - simply replacing
   `dev_warn()` with `dev_warn_ratelimited()`. This is:
   - A single-line change
   - Uses well-established kernel infrastructure (ratelimited logging)
   - Has no functional impact on the IPMI driver's operation
   - Cannot introduce regressions in driver functionality

3. **Clear Problem Statement**: The commit message clearly describes a
   specific scenario (BMC firmware upgrades) where excessive "BMC
   returned incorrect response" warnings flood system logs. This is a
   documented, reproducible issue.

4. **Follows Established Pattern**: The kernel already has precedent for
   this type of fix. Commit ca8c1c53b03b ("ipmi: rate limit ipmi
   smi_event failure message") from kernel v5.15 made similar changes to
   address log flooding in the same subsystem, and that was successfully
   integrated into stable trees.

5. **Low Risk**: The change only affects logging behavior, not the
   actual handling of IPMI messages. The error path (goto
   return_unspecified) remains unchanged, maintaining the same error
   handling logic.

6. **Addresses Operational Concerns**: In production environments with
   many servers, BMC maintenance is common. Without rate limiting, logs
   can grow excessively, potentially:
   - Filling up disk space
   - Making real issues harder to spot
   - Degrading system performance due to excessive logging I/O

7. **Code Context Shows Repeated Condition**: Looking at the code path
   (lines 4604-4615), this warning triggers when the BMC response
   doesn't match the expected NetFN and Command. During BMC firmware
   updates or reboots, this mismatch can occur repeatedly until the BMC
   comes back online, making rate limiting essential.

The change meets all criteria for stable backporting: it fixes a bug
affecting users, is small and contained, has minimal risk of regression,
and addresses a clear operational problem without introducing new
features or architectural changes.

 drivers/char/ipmi/ipmi_msghandler.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 064944ae9fdc..8e9050f99e9e 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -4607,10 +4607,10 @@ static int handle_one_recv_msg(struct ipmi_smi *intf,
 		 * The NetFN and Command in the response is not even
 		 * marginally correct.
 		 */
-		dev_warn(intf->si_dev,
-			 "BMC returned incorrect response, expected netfn %x cmd %x, got netfn %x cmd %x\n",
-			 (msg->data[0] >> 2) | 1, msg->data[1],
-			 msg->rsp[0] >> 2, msg->rsp[1]);
+		dev_warn_ratelimited(intf->si_dev,
+				     "BMC returned incorrect response, expected netfn %x cmd %x, got netfn %x cmd %x\n",
+				     (msg->data[0] >> 2) | 1, msg->data[1],
+				     msg->rsp[0] >> 2, msg->rsp[1]);
 
 		goto return_unspecified;
 	}
-- 
2.39.5

