Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7494D46AEE1;
	Tue, 16 Jun 2026 18:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636019; cv=none; b=KsEwXTocKRQfswOvkxtVbS6gO5CqZ1MpbAk0osE5P/tSTL6XXOXPwkQGfA4EqbdaGWWE/KumMNCnbia9+JvcqyFUwBfp7RJakoK9jGVzpLX85kBEKuAgg9bL0QwsscHYPTK6UE6c7u578+G4dradh2Y6v/H5T3brDXrGqM3JIKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636019; c=relaxed/simple;
	bh=cgHxm+tfkyzqHO3BY6XW51Ydeg3vFnJv4E9K/hhTzdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HVlSNTyxXKOir9/fvt4JLJktH3f+Vkkw3gGzcDnWFAddUlCGGA9Nme2IatcFdecK7Ef58fEZfWng70MD9OqgV1UuOHQIM4w5CYv1BS0EDcT/AuOfQlqBVDy9YTRFf2By75ngeurbGasmhYtBKVq/XNNWocZi5a8/yhSMC+HDFYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WNGcVaDI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WNGcVaDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0FE1F000E9;
	Tue, 16 Jun 2026 18:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636018;
	bh=0YfDrzxJPb/fFeDOxaNbW+duebOomVxrbtqfMpndDH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WNGcVaDI4IBee+P8Fk1XMySUFoHVB37LyHv0cs1JecFCX6Ur/rD5FzlRnaZNVyahR
	 LdzwYUzwxU/v4ue+i4Dbm4Jpq+ORBMZSIQCVKY1J2Ss+R426RBZHs5ohzad7g1/YOt
	 BhSNmCOCUwgUz/1rXub29d3Uvhzs+wD0Xk0uaWtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.10 126/342] HID: core: Fix size_t specifier in hid_report_raw_event()
Date: Tue, 16 Jun 2026 20:27:02 +0530
Message-ID: <20260616145054.073804480@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 4d3a2a466b8d68d852a1f3bbf11204b718428dc4 ]

When building for 32-bit platforms, for which 'size_t' is
'unsigned int', there are warnings around using the incorrect format
specifier to print bsize in hid_report_raw_event():

  drivers/hid/hid-core.c:2054:29: error: format specifies type 'long' but the argument has type 'size_t' (aka 'unsigned int') [-Werror,-Wformat]
   2053 |                 hid_warn_ratelimited(hid, "Event data for report %d is incorrect (%d vs %ld)\n",
        |                                                                                         ~~~
        |                                                                                         %zu
   2054 |                                      report->id, csize, bsize);
        |                                                         ^~~~~
  drivers/hid/hid-core.c:2076:29: error: format specifies type 'long' but the argument has type 'size_t' (aka 'unsigned int') [-Werror,-Wformat]
   2075 |                 hid_warn_ratelimited(hid, "Event data for report %d was too short (%d vs %ld)\n",
        |                                                                                          ~~~
        |                                                                                          %zu
   2076 |                                      report->id, rsize, bsize);
        |                                                         ^~~~~

Use the proper 'size_t' format specifier, '%zu', to clear up the
warnings.

Cc: stable@vger.kernel.org
Fixes: 2c85c61d1332 ("HID: pass the buffer size to hid_report_raw_event")
Reported-by: Miguel Ojeda <ojeda@kernel.org>
Closes: https://lore.kernel.org/20260516020430.110135-1-ojeda@kernel.org/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
(cherry picked from commit 3ab135238832446399614e7a4bb796d620717806)
Signed-off-by: Lee Jones <lee@kernel.org>
(cherry picked from commit 0f77a993b5426cca1b046c9ab4b2f8355a4d45dc)
Signed-off-by: Lee Jones <lee@kernel.org>
(cherry picked from commit 70333a8f866aad8cbd6956e2ec4ace159fa4243b)
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index c73f4ac16fdf24..918c66d5bc93f6 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1793,7 +1793,7 @@ int hid_report_raw_event(struct hid_device *hid, int type, u8 *data,
 		return 0;
 
 	if (unlikely(bsize < csize)) {
-		hid_warn_ratelimited(hid, "Event data for report %d is incorrect (%d vs %ld)\n",
+		hid_warn_ratelimited(hid, "Event data for report %d is incorrect (%d vs %zu)\n",
 				     report->id, csize, bsize);
 		return -EINVAL;
 	}
@@ -1815,7 +1815,7 @@ int hid_report_raw_event(struct hid_device *hid, int type, u8 *data,
 		rsize = max_buffer_size;
 
 	if (bsize < rsize) {
-		hid_warn_ratelimited(hid, "Event data for report %d was too short (%d vs %ld)\n",
+		hid_warn_ratelimited(hid, "Event data for report %d was too short (%d vs %zu)\n",
 				     report->id, rsize, bsize);
 		return -EINVAL;
 	}
-- 
2.53.0



