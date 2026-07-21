Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BA6408039;
	Tue, 21 Jul 2026 19:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661811; cv=none; b=MP3OewTPj/SeRz876nxX0m4yWbNeATt1yBw1P5d2kJhkjOWgNGEh6YSlhxqobiQ8BlAky2IQE4u2BAmDIfXKEzXf3/TIRGjUAkPXYuuGRzb+qLzrgkbJ+NvKqxHR8KNhHus8yXYowo2y3KxQwXNtETN1lP3qICVSu7rn12bxiC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661811; c=relaxed/simple;
	bh=7i4TCEWNtpASjqAZ5oxW9wpzdis4yCh0grN5kTbjogI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FgtQUYyYmkSi7tG1G2tDmUAcCv4vfN4p4r/t3/AQPXPPO0VjrBTaaQOITrFya8d5QPF05bWE2N3UsitKXYHy0QGOfg1Iv0kim4hdE3pLb+hCk0hKOJQyA089nnrld3EyinLC6Q4563EbCaXnz4/sM85lgd1pfDW1ZtXTt+ofIYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jey8Lp9Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jey8Lp9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B941F000E9;
	Tue, 21 Jul 2026 19:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661810;
	bh=We5vDQtKY37UkLNmNuc1UMz48QK8IsAQW2H4oZWDLIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jey8Lp9ZdBTcM+QGJcbou8N8RKYSRCtJDYh0GMCygTYmQuGPbzYi/ms9uCRrb76Sr
	 CrHcYyerjU2kcqIX3Gh14kLVRz6LxvZYzpIXrqizgf6DnWT9s6K/0cvxACWraqqoP2
	 PA7oEMdYrtHfOpbZneZD7gq1aDU0koLyU+v4P810=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Cheng <chencheng@fnnas.com>,
	Xiao Ni <xiao@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0207/1276] md/raid10: reset read_slot when reusing r10bio for discard
Date: Tue, 21 Jul 2026 17:10:50 +0200
Message-ID: <20260721152450.720342100@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Chen Cheng <chencheng@fnnas.com>

[ Upstream commit 6b8a26af065ddc93de2aa5c9f0df98dce9723442 ]

put_all_bios() always drops devs[i].bio, but it only drops
devs[i].repl_bio when r10_bio->read_slot < 0. If discard reuses an
r10bio that was previously used for a read, read_slot can still be
non-negative, and discard cleanup can skip bio_put() on repl_bio.

Reset read_slot to -1 when preparing an r10bio for discard so the
replacement bio is always released correctly.

Fixes: d30588b2731f ("md/raid10: improve raid10 discard request")
Signed-off-by: Chen Cheng <chencheng@fnnas.com>
Reviewed-by: Xiao Ni <xiao@kernel.org>
Link: https://patch.msgid.link/20260515093019.3436882-1-chencheng@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5cc827cff9181e..de441867d3bd99 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1730,6 +1730,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	r10_bio->mddev = mddev;
 	r10_bio->state = 0;
 	r10_bio->sectors = 0;
+	r10_bio->read_slot = -1;
 	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * geo->raid_disks);
 	wait_blocked_dev(mddev, r10_bio);
 
-- 
2.53.0



