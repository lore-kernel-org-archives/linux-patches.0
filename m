Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F034F3913;
	Thu, 17 Sep 2026 15:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659810; cv=none; b=er41beqtNmwaOWlVrLXo2J/hEHD+/376uF7si2uvo884pI8PPgjY9hZ86ZZDLKlMccMQuYmAkSXWW44UTv8Vn2Aif/7Cymdu32uSDlAOzYuVBt8uw02JzKZq11sGW4HdZ/wHPbvGwI7j6G1UD0bSF649AIygDhnlknJNMX4jZ9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659810; c=relaxed/simple;
	bh=FJkAtpEvLEEC5EIJKfodl/IZwXzDBl52JqdkCXYLEtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=looEmRXSjH9fQfYYdjGfvWDSYWUJJ+UH82inMBBaxopxpzwVxQg6UlshlsjcsugRjJIlsPYGP+0x0W8MO/8tb8ISuOzTiUJoRgTw2mZL9K0m3KEHaK4ewmXIRo62g/6ZvjASHd5gN35bbGiFZZgd2KxjtDknk/JVwizEqqtCU24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=umgeUORt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="umgeUORt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8063C1F000FF;
	Thu, 17 Sep 2026 15:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659794;
	bh=XrxMeD9nxqzzCGyR396NXQmTlTkOSedXVEpQrj3WrEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=umgeUORtoOOtocT+HTBZ3wdwLM76Osmrko0m46GBszPP2pZRWjg7G7qgmYY0nm3si
	 oKVtgY4bGss/eDQ5ysDjl+EP+qBG/3d0XohB5K8vtLeaTfhC+8m56l6xUjC4ArFRzD
	 3wXfGm5yDk2iPr/EcePXV9AOq+xm7tQ7h0PMrr2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 369/733] s390/debug: Fix NULL pointer dereference in debug_set_level()
Date: Thu, 17 Sep 2026 16:11:17 +0100
Message-ID: <20260917151400.829085919@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Zaslonko <zaslonko@linux.ibm.com>

[ Upstream commit b1eb31d533cdfcae1011ed53850d52f36afe5774 ]

Commit a2cec6863709 ("s390/debug: Add s390dbf kernel parameter")
incorrectly removed a null-id check from debug_set_level(), introducing
a possible NULL pointer dereference for debug-API users that put
debug_register() results unchecked into debug_set_level().

Fix this by moving the check from the internal _debug_set_level()
variant back to the external debug_set_level() wrapper.

Fixes: a2cec6863709 ("s390/debug: Add s390dbf kernel parameter")

Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index 14d2b58ad0930..e06abf1dbc218 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -1074,9 +1074,6 @@ static void _debug_set_level(debug_info_t *id, int new_level)
 {
 	unsigned long flags;
 
-	if (!id)
-		return;
-
 	if (new_level == DEBUG_OFF_LEVEL) {
 		pr_info("%s: switched off\n", id->name);
 	} else if ((new_level > DEBUG_MAX_LEVEL) || (new_level < 0)) {
@@ -1101,6 +1098,9 @@ static void _debug_set_level(debug_info_t *id, int new_level)
  */
 void debug_set_level(debug_info_t *id, int new_level)
 {
+	if (!id)
+		return;
+
 	/* Level specified via kernel parameter takes precedence */
 	debug_get_param(id->name, &new_level, NULL);
 
-- 
2.53.0



