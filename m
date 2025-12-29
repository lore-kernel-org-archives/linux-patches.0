Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C9D332EA9;
	Mon, 29 Dec 2025 16:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767026002; cv=none; b=a8qMjPRhxKGXCV8ZdUS96YgvJMpDs+4U/Xz771P4yztFyU1v+zbpp5xJeoxanKlTez7DDRNlAosYntHPgTJKYRlG+6lwqjEVqMEYmKW8NCN0Qvfqa0LGZM3qluRxuQDAtgbEZBaeYfqyqnCrQpTJucvFAZXTEBRFV9ZDX0yB6Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767026002; c=relaxed/simple;
	bh=Cvz3wIPZVzZPGPwJ2A26fVt+NSYgyVZuopHGOf+kRyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OF4R1cfmzNKdcjQPACpjhiAEG1p5F/ca8zg/a9k4jqmZiKX6ZETV3yheF+gWobXxCqQUyQOQcLDu6NoZes1jxTCbIAuuui+0ARXU/FSOO327AXFR0XPToW9JO5AvoPPSzWmUIKk6o/i0xuECfGZ+zIu0eMFj5t+ODoRCYEet+sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J66bRleP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J66bRleP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899BCC4CEF7;
	Mon, 29 Dec 2025 16:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767026001;
	bh=Cvz3wIPZVzZPGPwJ2A26fVt+NSYgyVZuopHGOf+kRyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J66bRlePTDGhGAZd11S7JPfRekXvrPz5ZqGxOAkJi/HBhBJIcwpR4cpHY16oJ2SeI
	 rhWe70/Lc5ZvLwxbDmwiqKTJjkSR4Sf5bSDSShvxLqjyZuBP4P6L/gWtWtiIXEVqnF
	 sCKlDtRAhgSDmmz5Sj3QL8WwMK8K4DjBgdacqPKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wander Lairson Costa <wander@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>
Subject: [PATCH 6.18 411/430] rtla/timerlat_bpf: Stop tracing on user latency
Date: Mon, 29 Dec 2025 17:13:33 +0100
Message-ID: <20251229160739.440758319@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Glozar <tglozar@redhat.com>

commit e4240db9336c25826a2d6634adcca86d5ee01bde upstream.

rtla-timerlat allows a *thread* latency threshold to be set via the
-T/--thread option. However, the timerlat tracer calls this *total*
latency (stop_tracing_total_us), and stops tracing also when the
return-to-user latency is over the threshold.

Change the behavior of the timerlat BPF program to reflect what the
timerlat tracer is doing, to avoid discrepancy between stopping
collecting data in the BPF program and stopping tracing in the timerlat
tracer.

Cc: stable@vger.kernel.org
Fixes: e34293ddcebd ("rtla/timerlat: Add BPF skeleton to collect samples")
Reviewed-by: Wander Lairson Costa <wander@redhat.com>
Link: https://lore.kernel.org/r/20251006143100.137255-1-tglozar@redhat.com
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/tracing/rtla/src/timerlat.bpf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/tracing/rtla/src/timerlat.bpf.c b/tools/tracing/rtla/src/timerlat.bpf.c
index 084cd10c21fc..e2265b5d6491 100644
--- a/tools/tracing/rtla/src/timerlat.bpf.c
+++ b/tools/tracing/rtla/src/timerlat.bpf.c
@@ -148,6 +148,9 @@ int handle_timerlat_sample(struct trace_event_raw_timerlat_sample *tp_args)
 	} else {
 		update_main_hist(&hist_user, bucket);
 		update_summary(&summary_user, latency, bucket);
+
+		if (thread_threshold != 0 && latency_us >= thread_threshold)
+			set_stop_tracing();
 	}
 
 	return 0;
-- 
2.52.0



