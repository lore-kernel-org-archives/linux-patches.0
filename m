Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CC0376A0B;
	Tue, 21 Jul 2026 21:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669447; cv=none; b=S+a0T8sFzZsY4oSQALlENLmPXBjl/K27L1vSxMuC1yUNPeCOQr3iPswCHZoau1mU3ZGpCBes0xlhAyfUQnhljWNZpVCt1sYKirXTdP3meOxlL9K5mmoqP700RR8YtSQZDLnYpPflW7lMEee01EWelGpgjGM6AZ1rJitQkAksO3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669447; c=relaxed/simple;
	bh=PbDTwSvC+9HSjd4roEbI1NspVNc0NbSHOpUmGZ9d2nA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aFDcPtDCljeBQn+ZXCBZM8+603OPdOpd/K/UyRb98e9pAvnBhMrrVW6AoWcAS+jHLP84EcPXjXjskpnkUWSVoxO9AoJ+VGD5DlvgT4uQisYB116bmpwkaWhnOIEYv1Ujaw3rCssLGMEVhDnOKl8q3A6I8em3u7p1En8N0Mqz9y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LFWbv0TS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LFWbv0TS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75371F000E9;
	Tue, 21 Jul 2026 21:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669446;
	bh=yBlMHVHWyUqjhdMhZd2/n4kix84umf3dmnUFW5RHtIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LFWbv0TSyQzr3epbks3Hmh3e2HorPgrxsgOfaPXVvsu0siKOcqELiADp2EWRTR2MF
	 YdEwRiNMaDKUKJbM4hWXfGUvR5Aw6ikurqbOrUBVeDIbJ0Sgc1sxyWUCkIWU36PAk9
	 p5sIIEz2ZOFUapGKV5xrsDoco4NOQSfZsQ6OPmEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	=?UTF-8?q?Maxime=20B=C3=A9lair?= <maxime.belair@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0556/1067] apparmor: fix potential UAF in aa_replace_profiles
Date: Tue, 21 Jul 2026 17:19:17 +0200
Message-ID: <20260721152437.044910531@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Bélair <maxime.belair@canonical.com>

[ Upstream commit 7b42f95813dc9ceb6bda35afcf914630909a19f9 ]

The function aa_replace_profiles was accessing udata->size after calling
aa_put_loaddata(udata), causing a potential UAF.

Fixed this by saving the size to a local variable before dropping the
reference.

Fixes: 5ac8c355ae001 ("apparmor: allow introspecting the loaded policy pre internal transform")
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: Maxime Bélair <maxime.belair@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index 030625a53f764a..0ceb2a381f8f37 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1152,13 +1152,15 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
 	mutex_unlock(&ns->lock);
 
 out:
+	ssize_t udata_sz = udata->size;
+
 	aa_put_ns(ns);
 	aa_put_profile_loaddata(udata);
 	kfree(ns_name);
 
 	if (error)
 		return error;
-	return udata->size;
+	return udata_sz;
 
 fail_lock:
 	mutex_unlock(&ns->lock);
-- 
2.53.0



