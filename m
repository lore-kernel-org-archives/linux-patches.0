Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8A7223708;
	Tue, 21 Jul 2026 17:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654832; cv=none; b=CN+wTCwwRurnah9O4xiLeyCGuQ3D9qrFFVaJDJbV0HtT7wQdAJMLHCxY+s04CMBAmNzObEUgn4xAy/+XQ3XqiAI8kbi010p5+4xXMa1jQF3Avk6RqF2xSFjIO8xAa+KiqPwpkZXMl540exV39y/EKx46j9GeF+4/0jEMjHhnxgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654832; c=relaxed/simple;
	bh=cuX2gREko0v2O3k0aovxaXqOlPi422RtEEzwAVIcieg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PiXeJ9yWCKFA3PETpr9h9rYLaBN5itZWlRpZdDI8p9BWPbuRGOlflkRC7tBrnc41IuHlSuKSUUntGobvSVkMwyOsaytdTTFASs2BXI0Lu2cTrVSmntO2m4li+bpeHUclfkvpY/DdYsHhx1q5/jczFE9P+wnkQRI2+dB+JhcZla4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AskY+ZC3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AskY+ZC3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2F01F000E9;
	Tue, 21 Jul 2026 17:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654831;
	bh=7MudAlhAbqXJqJ3nSLucv82GeumEAD3w97GA5n39wd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AskY+ZC3+u+1h2hDo8cRM72xRdWBqhYc9wlgf+Fxd1ZU0RTvmHZ9oBjgCuOR7Ng/P
	 Df04faah5yHwAkceaebQaZfHhf6YopIc5b/rKt+JuV00p/XQp0QcslraIPIIFs2F6R
	 cekVXayy1GjELD3S+3E9PLAAJI/pSWhSIcgyG+Uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.1 1855/2077] dm-integrity: fix a bug if the bio is out of limits
Date: Tue, 21 Jul 2026 17:25:28 +0200
Message-ID: <20260721152636.487071204@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 5a266764fadaff8b5c1fe37a186ebf9b09cb953e upstream.

If dm_integrity_check_limits fails, the code would exit with
DM_MAPIO_KILL. However, the range would be already locked at this point,
and it wouldn't be unlocked, resulting in a deadlock. Let's move the
limit check up, so that when it exits, no resources are leaked.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Fixes: fb0987682c62 ("dm-integrity: introduce the Inline mode")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2523,6 +2523,9 @@ static int dm_integrity_map_inline(struc
 	if (unlikely((bio->bi_opf & REQ_PREFLUSH) != 0))
 		return DM_MAPIO_REMAPPED;
 
+	if (unlikely(!dm_integrity_check_limits(ic, bio->bi_iter.bi_sector, bio)))
+		return DM_MAPIO_KILL;
+
 retry:
 	if (!dio->integrity_payload) {
 		unsigned digest_size, extra_size;
@@ -2587,10 +2590,6 @@ skip_spinlock:
 
 	dio->bio_details.bi_iter = bio->bi_iter;
 
-	if (unlikely(!dm_integrity_check_limits(ic, bio->bi_iter.bi_sector, bio))) {
-		return DM_MAPIO_KILL;
-	}
-
 	bio->bi_iter.bi_sector += ic->start + SB_SECTORS;
 
 	bip = bio_integrity_alloc(bio, GFP_NOIO, 1);


