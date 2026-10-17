Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0131738654F;
	Sat, 17 Oct 2026 16:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256301; cv=none; b=s1pOQDn9o0NXaB+oGdVi/qF/DHXuYp8BCyGh2WsK1y+LbXWmANl7c6nKA21VSsOgo4bPnCFMX62hi49BwoluYMjXdZ02TixyRvmjievlxiT7thJzg6L6FomhjKIr4fOao3GmiGkktEsUdjXayiSolc3/Mq4bESR8e4BG5Knk0nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256301; c=relaxed/simple;
	bh=dcuyiuvMGnpJ4WqngEhTd8EWHQYWk2SnmjTzRIV560g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u28rvVmSuIHHruakUmd7KcruoOwsyheOr81mRtLtqcGk2io5fk9KXFK7iP2AYsAAdALgexiQQVy1NdXAnemi81vFxiunJNw29tXZWWzrCWBuahRE74a4BWp9zmi5tZsF3FoFk1Vyhu6UmSSQl37zbXLRSTrxvt7jojx2MMItcB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eKj/f3rw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eKj/f3rw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5764E1F000C4;
	Sat, 17 Oct 2026 16:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256300;
	bh=cUVnt8z7dHUPpYC+38ioH9kZeBKGb1UdVXAu3UYtd/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eKj/f3rwgiu2wLOyaYFjl9S+IgOTOTMi8X/HNM92mn0dEsFtnXktbz5a2/pnhaEit
	 XWpEgnZS4XQZtZR+AgdO2WaeyFD15jYUveZ2rOkp5TDbBxSULFvFb/UR7JAmPxK27D
	 chYpj5dFLHOiBdSo0/yp6+tbYIrs1zTeKfkJai4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI <sashiko-bot@kernel.org>,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0190/1674] of/overlay: dont leak fragment references when changeset init fails
Date: Sat, 17 Oct 2026 17:41:02 +0200
Message-ID: <20261017160436.030586579@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

[ Upstream commit 1d62f0f2bc7edb12ed09f71203df0e47fa4efca4 ]

init_overlay_changeset() stores the number of initialized fragments
in ovcs->count only on full success. When find_target() or the
__symbols__ lookup fails partway through, the target and overlay
references taken for the fragments initialized so far are never
dropped: free_overlay_changeset() bounds its cleanup loop by
ovcs->count, which is still 0.

Store the running count on the error path so free_overlay_changeset()
puts whatever was set up. The store is guarded by ovcs->fragments
because on the allocation-failure path cnt still holds the counting
pass total while there is no fragments array; everywhere else cnt
only counts fully-initialized fragments.

Reported-by: Sashiko AI <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/20260805204009.CF3891F000E9@smtp.kernel.org
Fixes: 61b4de4e0b38 ("of: overlay: minor restructuring")
Assisted-by: Claude:claude-opus-4-8 [Claude Code]
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Link: https://patch.msgid.link/20260831-nh-of-alias-overlay-v7-6-02754604805a@nexthop.ai
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/overlay.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
index 1c3efa0bbf496..d3ac45080a7b5 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -851,6 +851,10 @@ static int init_overlay_changeset(struct overlay_changeset *ovcs,
 err_out:
 	pr_err("%s() failed, ret = %d\n", __func__, ret);
 
+	/* let free_overlay_changeset() put the fragments set up so far */
+	if (ovcs->fragments)
+		ovcs->count = cnt;
+
 	return ret;
 }
 
-- 
2.53.0



