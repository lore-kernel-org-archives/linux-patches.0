Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D4A28ECC4;
	Wed, 30 Jul 2025 09:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869174; cv=none; b=fvedyfX646fStZwaUlDWCER9Q1K8xklAdHo2wXpXkPqhFvI1VLmdz+0j7onHGHEZjCyycwPJaa8msBURMDhOpxLHrlmjSEJv+QSq6VPi8zAng67yWVtlGwdF+fJu0K/CyafFvNAGTBlzYXXbPjGIuWD9mMVwQio4KvoLnJsGFLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869174; c=relaxed/simple;
	bh=P+DACpmm4LTIvF1NkjICUF1ydZY5IuNNgoGEvro8ebA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uieYA2uAybdcNgDbj1j4PgfK4UzXsVI2xk8ASi0Cvj65QSk+HL3FHBAP5B/iPNyBqlCPxofPXNHJrmIxxz00ZkxQOuRaL9ngUEiehRD55w5lV2bc84x1hdZ8jSX2/sa7plVQrtpiL4YzdXOrZSBqygArtGOxf4l9Gx8203jiByI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=prkpgkkm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="prkpgkkm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F92C4CEF5;
	Wed, 30 Jul 2025 09:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869174;
	bh=P+DACpmm4LTIvF1NkjICUF1ydZY5IuNNgoGEvro8ebA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=prkpgkkmIfqhN8n6y8abOBaS0A2mce7v4jQV71Rb9tNxyuwx+EiGfDgjWLG3ic2Wx
	 V4owaeuj+P/+9/nAlTM2iMyzhzzIy7MXBEb8YCy5WMJt+myoGNaBlDSJUQHJmytlQS
	 blmg4H38VxXXG05a1anHS0cJGy97pFyrQ41QKVPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Markus=20Bl=C3=B6chl?= <markus@blochl.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	John Stultz <jstultz@google.com>
Subject: [PATCH 6.15 55/92] timekeeping: Zero initialize system_counterval when querying time from phc drivers
Date: Wed, 30 Jul 2025 11:36:03 +0200
Message-ID: <20250730093232.878176395@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Blöchl <markus@blochl.de>

commit 67c632b4a7fbd6b76a08b86f4950f0f84de93439 upstream.

Most drivers only populate the fields cycles and cs_id of system_counterval
in their get_time_fn() callback for get_device_system_crosststamp(), unless
they explicitly provide nanosecond values.

When the use_nsecs field was added to struct system_counterval, most
drivers did not care.  Clock sources other than CSID_GENERIC could then get
converted in convert_base_to_cs() based on an uninitialized use_nsecs field,
which usually results in -EINVAL during the following range check.

Pass in a fully zero initialized system_counterval_t to cure that.

Fixes: 6b2e29977518 ("timekeeping: Provide infrastructure for converting to/from a base clock")
Signed-off-by: Markus Blöchl <markus@blochl.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <jstultz@google.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20250720-timekeeping_uninit_crossts-v2-1-f513c885b7c2@blochl.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timekeeping.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1256,7 +1256,7 @@ int get_device_system_crosststamp(int (*
 				  struct system_time_snapshot *history_begin,
 				  struct system_device_crosststamp *xtstamp)
 {
-	struct system_counterval_t system_counterval;
+	struct system_counterval_t system_counterval = {};
 	struct timekeeper *tk = &tk_core.timekeeper;
 	u64 cycles, now, interval_start;
 	unsigned int clock_was_set_seq = 0;


