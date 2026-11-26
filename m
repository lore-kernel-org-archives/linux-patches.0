Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705470;
	b=KxBzw/r93ZWvSmMKnMzXnwgw+waAKQlXV3Ti5Jk/EyZfIAutnwmCu7G2bN44lCIXxn4/
	 9x1Ijp0QZQIJPNRCQuOmRYZX6IqeRVp61DdjBBlatV83bY9WFnQx3tdanPJKzgzK2ou49
	 lfyhwGD+Hah7vIbi7qU4cLo/PFQYmI7NO88afcTqGY4QKnK8RbaqX1/7kemN1Ds+vEw/2
	 7NFNFaffOZhchFY+G+0p+gi+JkqTUWPluRYC/MdwOQ5nlNSaBtimnZZlL0vKzobmVVu6h
	 rBL4TZc2xMDomtOoRrKzuEfo1qIfHCoodZzevn6TNmBLuwfWPfVjHut8pNGPeSPFGVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705470;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SVW5kxkRmFSgRjbkpYxAtTaPO7Z97qwd+fDs354GKYo=;
	b=GJdGWZ7bW/rFDFhWO7cCRTObD+DfZFdsnQ43u3l/0XUJzRTYL0UVWf/OXoDb0tNMs5t4
	 Vb9m15gwxwHHAo6x3+/M7zsNKyTHGQgyZK0pA4od9bPj76AsUlE6TBFEjKAXEx2s1Vo2b
	 3vkiR1zQHkseu4HIJYCJeX1di65K/JOVvB7kweBKb6F5fC4sQpNgtyYVa5rlx56OszeeS
	 z9GW6HHHygbU0ZUkSbFPUCI3CxiN0i2oplMY0OIpM0KiYwm/KtYhD572xg3pvrogiCAnN
	 tFPHAT5PnFhVO0bVd7ZWaFMuTYv8RAnVmfeVVm2y2b1gT7QEcQ/qiz9sOMv+NqTf97g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DT3ldB8K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9914606A31C;
	Thu, 26 Nov 2026 15:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DT3ldB8K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D82C1F000C6;
	Thu, 26 Nov 2026 15:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705470;
	bh=SVW5kxkRmFSgRjbkpYxAtTaPO7Z97qwd+fDs354GKYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DT3ldB8KbxLwdJFz70dTM/YRj9CMQRMdx1PrxLSDikGAuorajwhDP/ybHr1aW94fc
	 0ErR1aqkhiMjEqML+oNLNDaZr+uJ5DAUDH7rhlEKX0o7JpdS69VKOemXhgg2a+lLpE
	 zahpkAi+687DwC698DDKyViJPoZwiG4MtHLcXSZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 208/319] cpufreq: acpi-cpufreq: fix P-state index mismatch in extract_io()
Date: Thu, 26 Nov 2026 15:39:36 +0100
Message-ID: <20261126144011.439319647@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -196,14 +196,13 @@ static unsigned extract_io(struct cpufre
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
 


