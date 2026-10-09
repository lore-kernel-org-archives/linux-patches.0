Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A08045A2AC;
	Fri,  9 Oct 2026 14:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555470; cv=none; b=gCRp50lE4oxQrwsD1jDZthSWmIztgtppv26d9VkeTBYkCJ0qm9DE2EachOhARr/Z0QierGCggxNbHCZOolPZUeI0zIYeDvB0n/Ibwyy15E1dXUHwQBCmnuRwUYc3lYysqRdei2+3sjD3HQqy5vXbhMAsWPfCATHT/nOqJz9hFIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555470; c=relaxed/simple;
	bh=NelsH7vfsKryDqhPRs0cw13QteC5YUa0Zb5rZnUbbNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+g3Xd4Ldqi0/Vb14owQ6dsgvhMgWRglFwIcETwOL3CkHRQcgIRclXK5NPFiMgeUzCffh/gBSBRRWdAF8XIwAaa/Mym6VCYb1fWnD8T3j2tgLoNRIuggP/milJO9KVgXYITd+kGX+JZqmnnX6wPZ88+LAMmdeSm9PT6mzxOt5/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vX4sQzri; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vX4sQzri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24FAF1F00893;
	Fri,  9 Oct 2026 14:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555468;
	bh=3alw7/u/Qyu6VExZ0wv+kHQI8z2G8qOxWMnFHrd5uN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vX4sQzriVwc8OBk1/F2QWlj0hkIViU6r2n8pNwSuw3gdI77NEjhapVD/GuQuyMxPF
	 NWgs5E+KNHmXrx+c7gdcChsrnp2Zx9H+G+3fb4ZE0unLRDRxjqE3yEFAzZOAnF+z80
	 c29lNYiaTKjGuQUpOGVopaAYemv7xQjp+BoSGmj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI <sashiko-bot@kernel.org>,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 063/403] of/overlay: dont leak fragment references when changeset init fails
Date: Fri,  9 Oct 2026 16:07:04 +0200
Message-ID: <20261009140953.571460813@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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
index 1364b8ae6cac7..8e5b5e5d2bc4e 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -854,6 +854,10 @@ static int init_overlay_changeset(struct overlay_changeset *ovcs,
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



