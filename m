Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4893002BA;
	Tue,  6 Jan 2026 17:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721401; cv=none; b=sVg2aekguOEfv9eMYv4B3/30ZjJP8bYd89mboR8VBQIR2ozFhpgK1dKeGTnIp03pynOrIZ9aceJF/s+8oLqrmKQkYpmmCizFvZfygG97AgUOvy9lN9canEX7KS/idpo5mvKRMPHLRroYkWnhZRfJaB9XJ4tUFbhAnczV5g4XY0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721401; c=relaxed/simple;
	bh=ROTcuEA1lQm6nTzvfJlh67lCiSbBD5wT6Xrxk6zWZgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+SF19+vt/KU4/31WDTeo5xUohCn98Ze36FDvupgeIlmtq1PVRwHLNqvQ/ttnx50Mu4j9TyHN0AnsFCgeXYDHbyBx64XcuXcCyb0hYO8e06V6xgaJ2T/NldrGe/nrhcssQCEC41rdsx71hRASQIqAtVB8g1ehfq7wSe5BKsQgdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Sm0jmxj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Sm0jmxj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76FFFC116C6;
	Tue,  6 Jan 2026 17:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721400;
	bh=ROTcuEA1lQm6nTzvfJlh67lCiSbBD5wT6Xrxk6zWZgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Sm0jmxjW3ymm58a1tqP370/vpDwG7H93G1StIPe8UeWqutJmsZUbkvDMxrGn675Z
	 8AyRG84ekq/VHCIuRglManRE2TomQ+zWAkEWLSgg/mRa8U9R6NJT6UFrrHbrwaIuSa
	 +y2GeOfSHNJFz1MqCbzbg+VbpWlbMGr4qL7/p/hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Ni <xni@redhat.com>,
	Coly Li <colyli@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.12 524/567] md/raid10: wait barrier before returning discard request with REQ_NOWAIT
Date: Tue,  6 Jan 2026 18:05:06 +0100
Message-ID: <20260106170510.774551670@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Xiao Ni <xni@redhat.com>

[ Upstream commit 3db4404435397a345431b45f57876a3df133f3b4 ]

raid10_handle_discard should wait barrier before returning a discard bio
which has REQ_NOWAIT. And there is no need to print warning calltrace
if a discard bio has REQ_NOWAIT flag. Quality engineer usually checks
dmesg and reports error if dmesg has warning/error calltrace.

Fixes: c9aa889b035f ("md: raid10 add nowait support")
Signed-off-by: Xiao Ni <xni@redhat.com>
Acked-by: Coly Li <colyli@kernel.org>
Link: https://lore.kernel.org/linux-raid/20250306094938.48952-1-xni@redhat.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
[Harshit: Clean backport to 6.12.y]
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid10.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1626,11 +1626,10 @@ static int raid10_handle_discard(struct
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
 		return -EAGAIN;
 
-	if (WARN_ON_ONCE(bio->bi_opf & REQ_NOWAIT)) {
+	if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT)) {
 		bio_wouldblock_error(bio);
 		return 0;
 	}
-	wait_barrier(conf, false);
 
 	/*
 	 * Check reshape again to avoid reshape happens after checking


