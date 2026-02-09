Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9A7125B2;
	Mon,  9 Feb 2026 14:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647767; cv=none; b=QITvdtrO60jY+lnDU2b8PLZWa5Tu5zxLS2TslzOhHUgn65NcedRROgV3wIrdv/F/khqalTMGeqTi9Q+LPn2awftkwmcFZNceXAdB6IjXzycMqt54TfkIVHUlYL3WE3g+A8QflY7J2FLV7dQrX4WxZrysEqE/5n69iaGkPILK13E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647767; c=relaxed/simple;
	bh=fbCV7HOeR3O4BpCEcCes4Q5ST6K9Ia1cDYlxfTj51N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0mDE0qDRs30SA//PbhuRvCmrUnlYHFGohjyMsurSbTUHWLPPueGAO4XLEtXf32nUxP92nzjuzG8o/oGPZP2HzfEopTYfheVWKo2/tet1Ep9BdTAxLHBicsAV3U2igh6oX0vMCW1PIxJ2qI4q+OwIPkVVLKkf2ECxW/eWCMn0GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kohKeVsC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kohKeVsC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF06C116C6;
	Mon,  9 Feb 2026 14:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647767;
	bh=fbCV7HOeR3O4BpCEcCes4Q5ST6K9Ia1cDYlxfTj51N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kohKeVsCYe263N4E0yNIElYG8C6tvpOw6mXcEXcZzPmxBhT1/9Nj81lXP18eHZT0b
	 b/FcuAloMNpJPqOWhs/KH4nUYM0KMjxDKc4+kcotrslASyaDqxXRf7jaOPVw4lAFFP
	 zO5jb/GMEQR0MPOiFd43Fr2VGigBZkIoYfV94X5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Todd Brandt <todd.e.brandt@intel.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Len Brown <len.brown@intel.com>,
	Nikolay Kuratov <kniv@yandex-team.ru>
Subject: [PATCH 6.12 022/113] tools/power turbostat: fix GCC9 build regression
Date: Mon,  9 Feb 2026 15:22:51 +0100
Message-ID: <20260209142311.007633179@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

From: Todd Brandt <todd.e.brandt@intel.com>

commit d4a058762f3d931aa1159b64ba94a09a04024f8c upstream.

Fix build regression seen when using old gcc-9 compiler.

Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/power/x86/turbostat/turbostat.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -2798,6 +2798,8 @@ int format_counters(struct thread_data *
 	}
 
 	for (i = 0, ppmt = sys.pmt_tp; ppmt; i++, ppmt = ppmt->next) {
+		const unsigned long value_raw = t->pmt_counter[i];
+		const double value_converted = 100.0 * value_raw / crystal_hz / interval_float;
 		switch (ppmt->type) {
 		case PMT_TYPE_RAW:
 			if (pmt_counter_get_width(ppmt) <= 32)
@@ -2809,9 +2811,6 @@ int format_counters(struct thread_data *
 			break;
 
 		case PMT_TYPE_XTAL_TIME:
-			const unsigned long value_raw = t->pmt_counter[i];
-			const double value_converted = 100.0 * value_raw / crystal_hz / interval_float;
-
 			outp += sprintf(outp, "%s%.2f", (printed++ ? delim : ""), value_converted);
 			break;
 		}
@@ -2879,6 +2878,8 @@ int format_counters(struct thread_data *
 	}
 
 	for (i = 0, ppmt = sys.pmt_cp; ppmt; i++, ppmt = ppmt->next) {
+		const unsigned long value_raw = c->pmt_counter[i];
+		const double value_converted = 100.0 * value_raw / crystal_hz / interval_float;
 		switch (ppmt->type) {
 		case PMT_TYPE_RAW:
 			if (pmt_counter_get_width(ppmt) <= 32)
@@ -2890,9 +2891,6 @@ int format_counters(struct thread_data *
 			break;
 
 		case PMT_TYPE_XTAL_TIME:
-			const unsigned long value_raw = c->pmt_counter[i];
-			const double value_converted = 100.0 * value_raw / crystal_hz / interval_float;
-
 			outp += sprintf(outp, "%s%.2f", (printed++ ? delim : ""), value_converted);
 			break;
 		}
@@ -3078,6 +3076,8 @@ int format_counters(struct thread_data *
 	}
 
 	for (i = 0, ppmt = sys.pmt_pp; ppmt; i++, ppmt = ppmt->next) {
+		const unsigned long value_raw = p->pmt_counter[i];
+		const double value_converted = 100.0 * value_raw / crystal_hz / interval_float;
 		switch (ppmt->type) {
 		case PMT_TYPE_RAW:
 			if (pmt_counter_get_width(ppmt) <= 32)
@@ -3089,9 +3089,6 @@ int format_counters(struct thread_data *
 			break;
 
 		case PMT_TYPE_XTAL_TIME:
-			const unsigned long value_raw = p->pmt_counter[i];
-			const double value_converted = 100.0 * value_raw / crystal_hz / interval_float;
-
 			outp += sprintf(outp, "%s%.2f", (printed++ ? delim : ""), value_converted);
 			break;
 		}


