Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625749;
	b=YZq970pdZOxdvOq8uBHsViCxJgLV6pgt+kpw5YIueTvwRzr07Ar77dIRKKiSXETNwME3
	 +3Ebhw6dvUaMX/vJ27nmO6ZvKPWViptQsC0+/M8MyFsOCaeUWeoQQNJtf2nQA1aaFf6TK
	 SasKj5HYsCtVwB339PmmK996Wm/ZFStJpvXtd9JHsBapmOQPSfdTRuZservz0l5htOxcq
	 XQ37A/JlBeKJIkNTa8fmsuCwb85vTKY/S39EKSsJUH0ghUz4YPS7T0uelTmRopVWpcbPn
	 BX79krSEmZEvwHb8OEQK+2H7e2EQZ+QNKW34oYsPZ2pE2m9F96i60uLh4LyEEz21f6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625749;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wW9ga8PDNF2LmSrB5w+pQ9nLI00/zc8va/np2izoRG4=;
	b=3lewy0nuj5yQVYLGotDcxVTponl7zQqKryWgrKpHYHmlySEvwez7FYfmHMaQsq1V0Uoz
	 YWDdxHGp6Xk15k2iYR3cKDPgZv31/T44WTfcVZ28AbA2BSfg5E9tuA6SCKNi+8N2M/bR6
	 DuiidWayYVz6+bCxDojqHe6jEj5bWEfUps5zbmiashCf3UdknlniiCtYSl3CxTaNtlMO2
	 RwuS85w+WKKyaKZHoXEXNrx+cOO/pnBo0Utr3HOyWTnAiUWVLGLxri+nzTwE3FvXkW7xS
	 LlXlg9xBYAxFKoUOA/DRLuPWWaiAfZiTLdvu4eZ8InKL7bhOZEqGBuumaGaNjSD1Pfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oxXqdMuj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81AF606A69C;
	Wed, 25 Nov 2026 16:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oxXqdMuj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FBC1F000E0;
	Wed, 25 Nov 2026 16:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625749;
	bh=wW9ga8PDNF2LmSrB5w+pQ9nLI00/zc8va/np2izoRG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oxXqdMuj/wzxPS0IEydcYAo2zqqtS6cVGgUFXkpmeq3Sit/OrzYLpx7as1tGFi+CU
	 J6WCWR/san5tm3niNp1xWxIbzHpK4573Y9Sf4Qc66ZO813lz2NpFoDPYhcuf9uxk9n
	 YJcj0AB3GM3ymVUlGKBep0mdwa/eTZNuxh71dFmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.12 621/816] cpufreq: acpi-cpufreq: fix P-state index mismatch in extract_io()
Date: Wed, 25 Nov 2026 15:36:09 +0100
Message-ID: <20261125143903.557041061@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

commit 6bc092a0fc4d331a4adbbb664078af149c580834 upstream.

When policy->freq_table is built in acpi_cpufreq_cpu_init(), entries
that are not lower in frequency than the previous one are skipped.
For each remaining entry, freq_table[].driver_data stores the
original ACPI P-state index, so the index space of freq_table no
longer matches perf->states[].

extract_io() currently walks perf->states[] with index i and uses the
same i to index policy->freq_table[i]. When duplicate frequencies
exist, this can associate a P-state status with the frequency of a
different P-state. It can also access an invalid or sentinel entry in
freq_table when the number of entries in perf->states[] is greater than
the number of entries remaining in the frequency table.

extract_io() is used on ACPI_ADR_SPACE_SYSTEM_IO platforms by the
frequency verification path, which is enabled by the
acpi_pstate_strict module parameter. With the mismatched lookup,
check_freqs() can fail to match the frequency of the P-state that
drv_write() has already programmed. It then sleeps through all 100
iterations - at least ~1 ms of usleep_range() plus 100 cross-CPU
calls and I/O port reads, all with policy->rwsem held, and
.target_index() returns -EAGAIN, leaving perf->state at its previous
value while the hardware is running at the newly requested P-state.

The cpufreq core consequently keeps policy->cur at the old frequency.
Since __cpufreq_driver_target() returns early when the requested
frequency equals policy->cur, the driver is not called again for that
frequency and the control register is not rewritten. The hardware can
therefore remain at a frequency that differs from the frequency known
to the cpufreq core.

Fix this by iterating over policy->freq_table and using
pos->driver_data as the original ACPI P-state index when accessing
perf->states[], as extract_msr() already does.

Fixes: fe27cb358835 ("[CPUFREQ][2/8] acpi: reorganize code to make MSR support addition easier")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Cc: All applicable <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260910111329.2220-2-lirongqing@baidu.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/acpi-cpufreq.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -200,14 +200,13 @@ static unsigned extract_io(struct cpufre
 {
 	struct acpi_cpufreq_data *data = policy->driver_data;
 	struct acpi_processor_performance *perf;
-	int i;
+	struct cpufreq_frequency_table *pos;
 
 	perf = to_perf_data(data);
 
-	for (i = 0; i < perf->state_count; i++) {
-		if (value == perf->states[i].status)
-			return policy->freq_table[i].frequency;
-	}
+	cpufreq_for_each_entry(pos, policy->freq_table)
+		if (value == perf->states[pos->driver_data].status)
+			return pos->frequency;
 	return 0;
 }
 


