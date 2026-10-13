Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA654F93D5;
	Tue, 13 Oct 2026 12:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894770; cv=none; b=CxXQvD0Nwezf2cCcDPKrnjdihwmEQA6c3IGtWVHsSF+ZbjCLdKXL8wKc4eqrHJS5dzS54nwswYg5f7F3mcDAErry7OkeuwJiz2QcJuPHBwfXiRC8tkvDzoWyMXoSgh57Ec7aPRa/Zmz919QeLgfmF7kbaR/K+dBcCIlLAhI9MpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894770; c=relaxed/simple;
	bh=gQVn8BW7Ie9akYNLwJhzORP7n9A1xWN3m69l/TbxYsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uS+RrVJBRTAKhCibqDQccCWIQv4dWS4bo8TJojic02WkSSvvsYe8+qsf70UsSkQQw/4v72fPaWfy5BuCCxS8cRqAu8PdbLWrgflBtS3Ahcj9xt3ESqDQtQHI6yt2+1CGu2m8PI9EFx5I7BhFDie+xq7Z+LyNuXm0DVh5O1yM464=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vX/RF1nT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vX/RF1nT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AFD81F000FF;
	Tue, 13 Oct 2026 12:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894768;
	bh=+zhsTC5h87NrqpOciVAgS22P5odFxM0BW5T+NnZYQC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vX/RF1nTZMmm4UX2LrWeUPYZboB3VfskVggNWbqIKNp7lmZjVtUU2SaRZ45eZPoOv
	 dpED0tuhrd+jYHPql5A4CkuM3BTlXTP0AUCxhfAMjul8DTWI6wc6VdTZKK6c7PM6Cn
	 j12DLh3dae3f6c1DYj4bZF8aJYmXOb2AZZxy7z6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI <sashiko-bot@kernel.org>,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/497] of/overlay: dont leak fragment references when changeset init fails
Date: Tue, 13 Oct 2026 13:33:38 +0200
Message-ID: <20261013112909.099380537@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
index 2118f11718d39..c4a8e925754d4 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -849,6 +849,10 @@ static int init_overlay_changeset(struct overlay_changeset *ovcs,
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



