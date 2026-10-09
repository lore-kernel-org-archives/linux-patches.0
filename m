Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285E52BE7CD;
	Fri,  9 Oct 2026 14:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555815; cv=none; b=s4QHxB32xTATBJlxHC1nYnY8aYjMETsLcsR1nbmC/Ly2J+0GKkoGu0b8aPq6ogX1dSbxNhqfQ7z82SF/UB1qcaMJIiRu/CktdT5g36qCa/n6aVO/bZHvhHves5vHUCRmdfykD6A8lcGwfoEdSE/0s29UzCcZ9qdDlOUQ7j7hWrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555815; c=relaxed/simple;
	bh=VuH0Je94ka4dgY+wwCXQBR/EeZ33hvdraxomH0DJqZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I05oAt1Gpdtk76t7rlR1N0RvHQlppVTbP2fHfFHCWcXghjN/9s5638u4ZEkg9OEarCip5dvg2Z8GDH102ZTZEhzINs7HYmDKd9Flomgn/dj/5IElEkYf5taVCFtlhtryaRNPHcPMzc2q7h9IBtja61jGy/Ad944Zn4rofs4Kn08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RD92Rtj4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RD92Rtj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D0E01F00899;
	Fri,  9 Oct 2026 14:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555814;
	bh=EqcMf39gpTP7fWVGye3kfzaOIMxaTP0BFioaCFBGGEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RD92Rtj4UyEDSiyVSGZ4jsSN4qD5KBzlfJ1y9lwVkXlqflTQD0DliWBs9z7Q+bVxf
	 2NFVu/lbvyLxg8UnMh5igrcReU6QDChfZ16skx1+Uy+QVwdJUdCQMUzPYg7ygRwygc
	 DBPzBg3z8V48CZ4oapFATPE/IxtljL8UV1EFLulY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI <sashiko-bot@kernel.org>,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 074/428] of/overlay: dont leak fragment references when changeset init fails
Date: Fri,  9 Oct 2026 16:06:51 +0200
Message-ID: <20261009140947.786358813@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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
index 0cc08567c300e..276870291656b 100644
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



