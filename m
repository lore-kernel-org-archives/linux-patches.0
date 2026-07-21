Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDA347012F;
	Tue, 21 Jul 2026 19:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663931; cv=none; b=KecYu8MUaOZ2SGgFCN6/aEgFwwWmnaZT9BhBorsooBLkUlGRivduP2hE9K1Zaw1ABuYI4UBtAPkb6Vya0pevdKFcqV3NDNABBl8oRh7Hzjhx3iNlmRVSiYgCOmfv3URNf/AGjgqvpwbwWQvd0dXpNWLj4v+ami1A6sEjFvv4hoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663931; c=relaxed/simple;
	bh=k6MYfBIndiIw/7JvDr1h3jRJh5x2nC66ehoRV5azZkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMAfuQjasw/GkW5KynUC2hG5SA0aKxBdgMwnDPEOkKG0igNkPURyhAYMxq/gfjtWdKf+vClBghqhe4KIYFchVd96+UIOZKZA3AwBorXzuQbu8hhYPMPAl0azk8KRFPxoqDYkxVDnwwanBuVrDzDz/RmuxznoAMrsgDVv/j8uFOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tjPld0AH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tjPld0AH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768811F00A3A;
	Tue, 21 Jul 2026 19:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663930;
	bh=wI4OwV8R5noGPKIusaYxZbWq+icYOQNVUpeKFzOVtlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tjPld0AHbUjJmpqeVG8DGA6AFIU9YORsr7DX6rilnKdtAK+MpSTxnIHS6kkbvCWb2
	 ea3WFd2NuQpFiE2hkKdW2KSVa8osrVm492oxNcmRVD1Ev0eVCy/mehJsXrzW+eyHwH
	 GfR2em2NV2+0vTCeThHGER/LkfBLh4Z249w6SfsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 1007/1276] dm-stats: fix merge accounting
Date: Tue, 21 Jul 2026 17:24:10 +0200
Message-ID: <20260721152508.542671839@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit 1917eb2db750ecbdf710f79a8042eaa545a063c7 upstream.

There were wrong parentheses when setting stats_aux->merged, so that
merging was never properly accounted. This commit fixes it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Fixes: fd2ed4d25270 ("dm: add statistics support")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-stats.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -692,10 +692,8 @@ void dm_stats_account_io(struct dm_stats
 		 */
 		last = raw_cpu_ptr(stats->last);
 		stats_aux->merged =
-			(bi_sector == (READ_ONCE(last->last_sector) &&
-				       ((bi_rw == WRITE) ==
-					(READ_ONCE(last->last_rw) == WRITE))
-				       ));
+			bi_sector == READ_ONCE(last->last_sector) &&
+				(bi_rw == WRITE) == (READ_ONCE(last->last_rw) == WRITE);
 		WRITE_ONCE(last->last_sector, end_sector);
 		WRITE_ONCE(last->last_rw, bi_rw);
 	} else


