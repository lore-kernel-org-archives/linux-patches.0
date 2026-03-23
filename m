Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9873B19D4;
	Mon, 23 Mar 2026 14:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274574; cv=none; b=ueXe7FWnrAK2IDH6McOjjIU9dXYF742tuTPfx2EnU1r8aJ2JoEAwykVkj3h8wUigJBOQTkx2Y4duyk+9ZB14r9wXa/5fz1VypO6uPolG9kpRSw0Olcgo9c/9uaFshtarQJQTVhOV1yDQ6E351QA1gloTkUOkXlwlzvOqO9zIpbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274574; c=relaxed/simple;
	bh=Ne64Oc6tDwdgrN7H511pU7OlPi3HVb7Q2PoxZZoNFP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NcTf2GeKEr/l37Tyo27NyGcFo5rjSwXHG1LzQjP7sgCfM/ZNDHq+35DyOKPfUrELrazTng3yUuTr8TJxThpFSTrqgrEGTpljM2cYRh1//dLfGiB5LD9Gfxy0XC0M0sOye4Oi5OeCDUyn4wIzQdTsTjQ1d5AHtfyUjjb6TYjgkN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mcXbTihT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mcXbTihT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D94C4CEF7;
	Mon, 23 Mar 2026 14:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274574;
	bh=Ne64Oc6tDwdgrN7H511pU7OlPi3HVb7Q2PoxZZoNFP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mcXbTihTeFwy3qXZlRu+4X1Sxru1eBZwaWzhvIiSy/XiZ4x/rBI7CxxsaPW2kVaeh
	 pYDy1eJO/EgJ8NgLRzEp6SAXuvzvl3s+EZtCjxW6kmJfEjWk1mf6/C5BQLsmurD1yB
	 EQ9+9PXT7ijs8/y9id9RtGtaQu5Vo2WxvXq/Zxes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 033/212] netconsole: fix sysdata_release_enabled_show checking wrong flag
Date: Mon, 23 Mar 2026 14:44:14 +0100
Message-ID: <20260323134504.812985536@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 5af6e8b54927f7a8d3c7fd02b1bdc09e93d5c079 ]

sysdata_release_enabled_show() checks SYSDATA_TASKNAME instead of
SYSDATA_RELEASE, causing the configfs release_enabled attribute to
reflect the taskname feature state rather than the release feature
state. This is a copy-paste error from the adjacent
sysdata_taskname_enabled_show() function.

The corresponding _store function already uses the correct
SYSDATA_RELEASE flag.

Fixes: 343f90227070 ("netconsole: implement configfs for release_enabled")
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260302-sysdata_release_fix-v1-1-e5090f677c7c@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/netconsole.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -503,7 +503,7 @@ static ssize_t sysdata_release_enabled_s
 	bool release_enabled;
 
 	mutex_lock(&dynamic_netconsole_mutex);
-	release_enabled = !!(nt->sysdata_fields & SYSDATA_TASKNAME);
+	release_enabled = !!(nt->sysdata_fields & SYSDATA_RELEASE);
 	mutex_unlock(&dynamic_netconsole_mutex);
 
 	return sysfs_emit(buf, "%d\n", release_enabled);


