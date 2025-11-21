Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24EFD283CA3;
	Fri, 21 Nov 2025 13:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731968; cv=none; b=cZUlYs/5BCE3MyimgM9vaydBm0ySfT1Tma2YHlxcc5jh6D0g2+gtQ5ONFbHQR42ZUYmLFrd+s/J7OBBsx/OD5hlE3DWPzdK876fWgiBEjFxNKQHrTVCu/fQIiW3BxqjwHk0K9Gk7fv8JhldpG7jzBWRxdrUVxtDc7XUXuyEn3RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731968; c=relaxed/simple;
	bh=b6rtrOXfPlJuwTmIQFmB8lo02o1ZCFXjxFyUXUWo5f0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcrUNkqJQPDxqGTff5RIWccQ31au44uI4pE7RkfiYYvulb/7sXJ8XkDT9aad6SawkqvkrhkzDajd97Zwdd2PrX5Y1/IRQiY98ZUr3QZDOL8i8sBAUOgfiBrjzwIzMmBs3cLuBM4YT3boojRluMMwkScluhtIhbGr2GZIMpzxa8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A46DPM5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A46DPM5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42200C4CEF1;
	Fri, 21 Nov 2025 13:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731967;
	bh=b6rtrOXfPlJuwTmIQFmB8lo02o1ZCFXjxFyUXUWo5f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A46DPM5Ser5U4Mpi1565AUvCiBfsIvCAYL1XmHEszb78LnaJK9wXNEClUD7EFGyzY
	 HQ8zQLLzRXpyoRr6NTqIChC6YV6KcMzIaehMe+smFFlll+CPW02zaxwkyMdmWGfQa8
	 DKRFapUydNxGsxBcjQfcmdF9Hee0lA1mIhRRPjwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Askar Safin <safinaskar@gmail.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.12 143/185] PM: hibernate: Use atomic64_t for compressed_size variable
Date: Fri, 21 Nov 2025 14:12:50 +0100
Message-ID: <20251121130149.036184276@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Mario Limonciello (AMD) <superm1@kernel.org>

commit 66ededc694f1d06a71ca35a3c8e3689e9b85b3ce upstream.

`compressed_size` can overflow, showing nonsensical values.

Change from `atomic_t` to `atomic64_t` to prevent overflow.

Fixes: a06c6f5d3cc9 ("PM: hibernate: Move to crypto APIs for LZO compression")
Reported-by: Askar Safin <safinaskar@gmail.com>
Closes: https://lore.kernel.org/linux-pm/20251105180506.137448-1-safinaskar@gmail.com/
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Tested-by: Askar Safin <safinaskar@gmail.com>
Cc: 6.9+ <stable@vger.kernel.org> # 6.9+
Link: https://patch.msgid.link/20251106045158.3198061-3-superm1@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/power/swap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -648,7 +648,7 @@ struct cmp_data {
 };
 
 /* Indicates the image size after compression */
-static atomic_t compressed_size = ATOMIC_INIT(0);
+static atomic64_t compressed_size = ATOMIC_INIT(0);
 
 /*
  * Compression function that runs in its own thread.
@@ -676,7 +676,7 @@ static int compress_threadfn(void *data)
 					      &cmp_len);
 		d->cmp_len = cmp_len;
 
-		atomic_set(&compressed_size, atomic_read(&compressed_size) + d->cmp_len);
+		atomic64_add(d->cmp_len, &compressed_size);
 		atomic_set_release(&d->stop, 1);
 		wake_up(&d->done);
 	}
@@ -708,7 +708,7 @@ static int save_compressed_image(struct
 
 	hib_init_batch(&hb);
 
-	atomic_set(&compressed_size, 0);
+	atomic64_set(&compressed_size, 0);
 
 	/*
 	 * We'll limit the number of threads for compression to limit memory
@@ -884,8 +884,8 @@ out_finish:
 		ret = err2;
 	if (!ret) {
 		swsusp_show_speed(start, stop, nr_to_write, "Wrote");
-		pr_info("Image size after compression: %d kbytes\n",
-			(atomic_read(&compressed_size) / 1024));
+		pr_info("Image size after compression: %lld kbytes\n",
+			(atomic64_read(&compressed_size) / 1024));
 		pr_info("Image saving done\n");
 	} else {
 		pr_err("Image saving failed: %d\n", ret);


