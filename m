Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2831E8836;
	Fri,  9 Jan 2026 12:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962095; cv=none; b=byAPH4WqorkSDJNjxNO3A1NG7oCqeOXO7hkMvTEdW3YGqxdLeY93BNJSrRMynhuQDh+wkzsIWuLMKnLJBwjnqhGOiDArgODPPs7CsZvAjloU04HQx5BI/1zpsJva40zpSAxk4PZSzK2z+6PDaeKvEULsNm/v5i3PqSVcIfsOMiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962095; c=relaxed/simple;
	bh=g5FZ5qnPNypIMd5cLRlndhj72L1DP5VCXk6Klrl5jIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gS/ai8joWn4zKOr6KpDdXdV8D2TmBjbByFMEP+1S4l7i/RH7lfC8V38k9wB6nPwbH+wYohmTvnJfTPCVSJcbxqy3le5SI2hIQkjt6L4ur1lj171uK/026oMXqZc8LsBKpQjhM1FeO8c1j3tbyduf+i0pdxN5qsWWiD8buF0rP8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Hli6Ns0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Hli6Ns0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9D8C4CEF1;
	Fri,  9 Jan 2026 12:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962095;
	bh=g5FZ5qnPNypIMd5cLRlndhj72L1DP5VCXk6Klrl5jIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Hli6Ns0QDmLOA8DdJwvjBHsWUe/xqTuXrqYukKBRRXegbda0jl1xrkIcD/50xaDM
	 aI5/U99pwQ4XFxXLrQ/Xmoh7byETUStoJcCZqTdotjiebh+W25X7Wln/cSGMnaASsB
	 08fzWmoGj0HTxaNW+Bku9SHHvSWN11fjQKHOqFrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Simakov <bigalex934@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 212/634] dm-raid: fix possible NULL dereference with undefined raid type
Date: Fri,  9 Jan 2026 12:38:10 +0100
Message-ID: <20260109112125.413605580@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Simakov <bigalex934@gmail.com>

[ Upstream commit 2f6cfd6d7cb165a7af8877b838a9f6aab4159324 ]

rs->raid_type is assigned from get_raid_type_by_ll(), which may return
NULL. This NULL value could be dereferenced later in the condition
'if (!(rs_is_raid10(rs) && rt_is_raid0(rs->raid_type)))'.

Add a fail-fast check to return early with an error if raid_type is NULL,
similar to other uses of this function.

Found by Linux Verification Center (linuxtesting.org) with Svace.

Fixes: 33e53f06850f ("dm raid: introduce extended superblock and new raid types to support takeover/reshaping")
Signed-off-by: Alexey Simakov <bigalex934@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-raid.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 21a1586c69a7f..3d9be184d4606 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2259,6 +2259,8 @@ static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
 
 			mddev->reshape_position = le64_to_cpu(sb->reshape_position);
 			rs->raid_type = get_raid_type_by_ll(mddev->level, mddev->layout);
+			if (!rs->raid_type)
+				return -EINVAL;
 		}
 
 	} else {
-- 
2.51.0



