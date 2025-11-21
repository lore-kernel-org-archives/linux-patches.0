Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7E22737FC;
	Fri, 21 Nov 2025 13:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731451; cv=none; b=h2Jnmyd37u/oo6frMeU1ssvIhYEtBqRdLwoDgTuJOfP1rc8LOlQi0ZZQCAdAS0o/6nEGkduNC5G1BS88eAqY00c9pPFVZwoJ2YM2/CPy98UYMz1IsSaUzU/xLi9MgHc18Wl9nUEkG9wY2NKRWbOjjR6PW6qfRI7GB+Vz6cF3llc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731451; c=relaxed/simple;
	bh=rCK+Lw07UmlPT/CvhrBz0EKCORuh1S7495vxA67gS8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6exBISDbmCBHJfI3/n2ijTJQxkxLEBY3ekrzr8cFVlEErhkQfGB5PgmwNbu1XPmg2Qt9oCVsWko0oodpwvrGwsCQE/mlbE+z7LRd9/uBxK78rJFHPGnRh4uC3bb6NNnp5y0KrqR2B3n64iETG6eObSPW/ooioetARdgN5y6jEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=soWXSm79; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="soWXSm79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806D3C4CEF1;
	Fri, 21 Nov 2025 13:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731450;
	bh=rCK+Lw07UmlPT/CvhrBz0EKCORuh1S7495vxA67gS8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=soWXSm794pEdvL+WykYsaE+jWaCufDgLa/+KJbUTXtT6vv7cR5XWhtwuZ1HWBPV+w
	 tD3H1K36qnvxow20L0ExIOtH2TcxrIC0rrRwKQ02GOC3URs0eu6wHXQRPLGdOKTh5m
	 2p1/BMEI+9F+iieUV19bzTyP0gMm8w0kcno3+GNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Askar Safin <safinaskar@gmail.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.17 212/247] PM: hibernate: Emit an error when image writing fails
Date: Fri, 21 Nov 2025 14:12:39 +0100
Message-ID: <20251121130202.336509718@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello (AMD) <superm1@kernel.org>

commit 62b9ca1706e1bbb60d945a58de7c7b5826f6b2a2 upstream.

If image writing fails, a return code is passed up to the caller, but
none of the callers log anything to the log and so the only record
of it is the return code that userspace gets.

Adjust the logging so that the image size and speed of writing is
only emitted on success and if there is an error, it's saved to the
logs.

Fixes: a06c6f5d3cc9 ("PM: hibernate: Move to crypto APIs for LZO compression")
Reported-by: Askar Safin <safinaskar@gmail.com>
Closes: https://lore.kernel.org/linux-pm/20251105180506.137448-1-safinaskar@gmail.com/
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Tested-by: Askar Safin <safinaskar@gmail.com>
Cc: 6.9+ <stable@vger.kernel.org> # 6.9+
[ rjw: Added missing braces after "else", changelog edits ]
Link: https://patch.msgid.link/20251106045158.3198061-2-superm1@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/power/swap.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -877,11 +877,14 @@ out_finish:
 	stop = ktime_get();
 	if (!ret)
 		ret = err2;
-	if (!ret)
+	if (!ret) {
+		swsusp_show_speed(start, stop, nr_to_write, "Wrote");
+		pr_info("Image size after compression: %d kbytes\n",
+			(atomic_read(&compressed_size) / 1024));
 		pr_info("Image saving done\n");
-	swsusp_show_speed(start, stop, nr_to_write, "Wrote");
-	pr_info("Image size after compression: %d kbytes\n",
-		(atomic_read(&compressed_size) / 1024));
+	} else {
+		pr_err("Image saving failed: %d\n", ret);
+	}
 
 out_clean:
 	hib_finish_batch(&hb);


