Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751063C870E;
	Wed, 20 May 2026 17:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296868; cv=none; b=Qwozjs+vK59rv5lh77QCllFJv8MUhfrpU2ihvUAHrKLEpDKPOeXiMWMAItr98yhroz46/Y49ZZFGp+1RQ5oPBXwoXzYkXRJqVJPZoMZVtIN6LviyZ6SdZP53Qs0xmRoUsDE66aK3fYHaVEjliTS6xtUNoNAu5JI4lPJxCu4Glnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296868; c=relaxed/simple;
	bh=yP58a/d1dab6ta4czpIJv85yLx8Oaol2wyoVyDP25Mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i6/gNoW9OnIUOLC16HKLfrXxwKQlt1ExYWBR28wWeIat7Lq9Cat4zzdw/I37qitmbr9D7ucVnGPCXF8aQIjGoex6wB3xGgX+YzQlgH//muRO9Cmf+gaEHLdaJiA2fbg6gySjiL2xo5mF/mAOc97EMyWvoObinKWhd8N2135Cw0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZTtRDsZc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZTtRDsZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6A71F000E9;
	Wed, 20 May 2026 17:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296867;
	bh=Mg5uUUstgMiRGvgBd+Nqnq4deE68WdopRrIDaM9dzrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZTtRDsZcgmSsXbkt/6t3nk/rpDdnF4lG1QCZJv4I8vw9CYnu2caK+XAN2Rrevikrh
	 /UUE+3yxVKjpCuVQ1vRsYtt9dyIiyIusB+qIZg/b3YDM4psBzJmXTct/Ii/zZc4olF
	 yQFk7oETzfSh5794BIRaKha9t5VMDYoDMytp9jb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tom=C3=A1=C5=A1=20Trnka?= <trnka@scm.com>,
	Keith Busch <kbusch@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0955/1146] md/raid1,raid10: dont fail devices for invalid IO errors
Date: Wed, 20 May 2026 18:20:05 +0200
Message-ID: <20260520162209.847325962@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit f7b24c7b41f23b5f9caa8b913afe79cd4c397d39 ]

BLK_STS_INVAL indicates the IO request itself was invalid, not that the
device has failed. When raid1 treats this as a device error, it retries
on alternate mirrors which fail the same way, eventually exceeding the
read error threshold and removing the device from the array.

This happens when stacking configurations bypass bio_split_to_limits()
in the IO path: dm-raid calls md_handle_request() directly without going
through md_submit_bio(), skipping the alignment validation that would
otherwise reject invalid bios early. The invalid bio reaches the
lower block layers, which fail the bio with  BLK_STS_INVAL, and raid1
wrongly interprets this as a device failure.

Add BLK_STS_INVAL to raid1_should_handle_error() so that invalid IO
errors are propagated back to the caller rather than triggering device
removal. This is consistent with the previous kernel behavior when
alignment checks were done earlier in the direct-io path.

Fixes: 5ff3f74e145adc7 ("block: simplify direct io validity check")

Reported-by: Tomáš Trnka <trnka@scm.com>
Closes: https://lore.kernel.org/linux-block/2982107.4sosBPzcNG@electra/
Signed-off-by: Keith Busch <kbusch@kernel.org>
Tested-by: Tomáš Trnka <trnka@scm.com>
Link: https://lore.kernel.org/r/20260416140345.3872265-1-kbusch@meta.com
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1-10.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index c33099925f230..56a56a4da4f83 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -293,8 +293,13 @@ static inline bool raid1_should_read_first(struct mddev *mddev,
  * bio with REQ_RAHEAD or REQ_NOWAIT can fail at anytime, before such IO is
  * submitted to the underlying disks, hence don't record badblocks or retry
  * in this case.
+ *
+ * BLK_STS_INVAL means the bio was not valid for the underlying device. This
+ * is a user error, not a device failure, so retrying or recording bad blocks
+ * would be wrong.
  */
 static inline bool raid1_should_handle_error(struct bio *bio)
 {
-	return !(bio->bi_opf & (REQ_RAHEAD | REQ_NOWAIT));
+	return !(bio->bi_opf & (REQ_RAHEAD | REQ_NOWAIT)) &&
+		bio->bi_status != BLK_STS_INVAL;
 }
-- 
2.53.0



