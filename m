Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2FD1A704B;
	Sun,  7 Sep 2025 20:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277391; cv=none; b=CH+dHcHhGA16LOI5ccXrf1BD+536z92JuMdYBuJasEG17dC4oIW+mm2t5vXM0/WePC/+TIaAdiZSTL8JC6bhkhd7OxCbNER8rKvZKJxfS+cs649tQspg+ZmdHYjfyC+yNgYnZxz/ZqkCuukmdE7ZUNMfhCQy1D/Hi9cTpzPbFFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277391; c=relaxed/simple;
	bh=1SIJQvmJgXOvvbiXg+DPgCJKiMSig8EGX5aNvXNbdyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCOY++70iTbE6VOoYTeed7YcOtOasRwfJLEfUXTunMutrhjVZ5uxI931+/bk64p6K/+lY89q/FIYy5a1V5FKBrTXLW4X0IM2pvNMRgRkwYp7q4jmRn8f/vv70y0/ytRFgoxN8zUYuGO7DlmGF6oYHgixc/mDEc76LU8u+PO06C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QzIRj3V1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QzIRj3V1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32AC6C4CEF0;
	Sun,  7 Sep 2025 20:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277391;
	bh=1SIJQvmJgXOvvbiXg+DPgCJKiMSig8EGX5aNvXNbdyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QzIRj3V1Mz1jEf7wwpKZaXy4oV44z/QmOXheKORwHc8EygnlI/JAnewDmNsDjP23d
	 K3P/BRvmzgHH79iCDy/Q/tIScSIMslr5ytbtnSOFfIWnfsbSCw/n7s/d4tI6vlR/N6
	 2ZC/nNc224GYceGQJz88PI68Ae9uOEn+HSO0EjAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Li Nan <linan122@huawei.com>,
	Sasha Levin <sashal@kernel.org>,
	Ian Dall <ian@beware.dropbear.id.au>
Subject: [PATCH 6.12 174/175] md/raid1: fix data lost for writemostly rdev
Date: Sun,  7 Sep 2025 21:59:29 +0200
Message-ID: <20250907195618.978432965@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 93dec51e716db88f32d770dc9ab268964fff320b ]

If writemostly is enabled, alloc_behind_master_bio() will allocate a new
bio for rdev, with bi_opf set to 0. Later, raid1_write_request() will
clone from this bio, hence bi_opf is still 0 for the cloned bio. Submit
this cloned bio will end up to be read, causing write data lost.

Fix this problem by inheriting bi_opf from original bio for
behind_mast_bio.

Fixes: e879a0d9cb08 ("md/raid1,raid10: don't ignore IO flags")
Reported-and-tested-by: Ian Dall <ian@beware.dropbear.id.au>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220507
Link: https://lore.kernel.org/linux-raid/20250903014140.3690499-1-yukuai1@huaweicloud.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Li Nan <linan122@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 772486d707181..faccf7344ef93 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1224,7 +1224,7 @@ static void alloc_behind_master_bio(struct r1bio *r1_bio,
 	int i = 0;
 	struct bio *behind_bio = NULL;
 
-	behind_bio = bio_alloc_bioset(NULL, vcnt, 0, GFP_NOIO,
+	behind_bio = bio_alloc_bioset(NULL, vcnt, bio->bi_opf, GFP_NOIO,
 				      &r1_bio->mddev->bio_set);
 
 	/* discard op, we don't support writezero/writesame yet */
-- 
2.51.0



