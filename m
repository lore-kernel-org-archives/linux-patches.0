Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E678312BF32;
	Tue, 30 Apr 2024 11:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476603; cv=none; b=WjaiAcRxLmxew1X97Xdi/VyodV5KkAHEE3XzncFhaon45VH2UEVADiGi5sebpf37Blxy39PkCzezeHBJXiZikmua2fZkLcjy36vmeg+iaoPM5r5/IbnGVhC3RAyxtR4VNTtU80bpHA5hq1E1l061iLjxfJkEW/WH0g9pt60YOx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476603; c=relaxed/simple;
	bh=t835IqbI708riW5DU2yxRhwwR+9G4X33J/7LBjeofuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iupqzoS65Lu6ZQ55QBF8pJ9YOBk+PzGzdihRjzd8KUIbdmpBWfQ79MKLFARrp/usTiBybcld7UkF5MYyjO1LYqhG0t4+lhYiM7jKPyn+16uWIacdnW/G2HYtGrYE8QNSNsqeLPO7L/VRqGHtETSuv/LcERGcgXp7VaCWrVV6yu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WEgsgNcY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WEgsgNcY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68BA8C2BBFC;
	Tue, 30 Apr 2024 11:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476602;
	bh=t835IqbI708riW5DU2yxRhwwR+9G4X33J/7LBjeofuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WEgsgNcYJPgj76NlE7cVnBJYlxP0JqQTBW8V+/0V4i5uOPMLTpGnIp0EoEDcxD3V+
	 frths8z6AReZ/epzpd4EzI0TJODZn09RSzL6DbZKvdLRX8JkfJzsmyoeZU4CvYm1D6
	 FITfCjLtYax+krXB+H0PTTfj3WYBtPLwdV+J9KH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarred White <jarredwhite@linux.microsoft.com>,
	Vanshidhar Konda <vanshikonda@os.amperecomputing.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 082/110] ACPI: CPPC: Fix bit_offset shift in MASK_VAL() macro
Date: Tue, 30 Apr 2024 12:40:51 +0200
Message-ID: <20240430103049.987227611@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarred White <jarredwhite@linux.microsoft.com>

commit 05d92ee782eeb7b939bdd0189e6efcab9195bf95 upstream.

Commit 2f4a4d63a193 ("ACPI: CPPC: Use access_width over bit_width for
system memory accesses") neglected to properly wrap the bit_offset shift
when it comes to applying the mask. This may cause incorrect values to be
read and may cause the cpufreq module not be loaded.

[   11.059751] cpu_capacity: CPU0 missing/invalid highest performance.
[   11.066005] cpu_capacity: partial information: fallback to 1024 for all CPUs

Also, corrected the bitmask generation in GENMASK (extra bit being added).

Fixes: 2f4a4d63a193 ("ACPI: CPPC: Use access_width over bit_width for system memory accesses")
Signed-off-by: Jarred White <jarredwhite@linux.microsoft.com>
Cc: 5.15+ <stable@vger.kernel.org> # 5.15+
Reviewed-by: Vanshidhar Konda <vanshikonda@os.amperecomputing.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/cppc_acpi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -167,8 +167,8 @@ show_cppc_data(cppc_get_perf_ctrs, cppc_
 #define GET_BIT_WIDTH(reg) ((reg)->access_width ? (8 << ((reg)->access_width - 1)) : (reg)->bit_width)
 
 /* Shift and apply the mask for CPC reads/writes */
-#define MASK_VAL(reg, val) ((val) >> ((reg)->bit_offset & 			\
-					GENMASK(((reg)->bit_width), 0)))
+#define MASK_VAL(reg, val) (((val) >> (reg)->bit_offset) & 			\
+					GENMASK(((reg)->bit_width) - 1, 0))
 
 static ssize_t show_feedback_ctrs(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)


