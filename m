Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D00812C499;
	Tue, 30 Apr 2024 10:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474616; cv=none; b=dOCBly6RgvSnjphcaKwiVNpNBJT0oS+6eoolPnBlkBer4kWrbEuTHlSVZFeBfW7ouQjgCAN7jFnle6KMAMYlSF6WAVtArmoxBuWi1aAbK2Jj4/H3kcvuqWWGBPovZSJhA9P0qkL2kf6OWPFSPDRfF/FgQRSrzfe2UXbcH/NkWbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474616; c=relaxed/simple;
	bh=3LmBwj1A00Us3JgxM3GPDLNrywKJw5PHzpP/zuwTq8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AciuZi1VKv6r+WtLh+l6TJm87i/uB08IH1iXeA9lqIllkj0tdqvZCHUXVid+pprdjiGG8juxLZoH/Ck3iZ3QhZvpPV0jR7tm2XorwVlZY6q8Dba2UxBl4dXd03I6pIKAbWEXMgQlCDkt2y/1gkrq99o6FcQjva2+9X+uXovLAuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YtGqBUjH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YtGqBUjH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B8EC2BBFC;
	Tue, 30 Apr 2024 10:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474615;
	bh=3LmBwj1A00Us3JgxM3GPDLNrywKJw5PHzpP/zuwTq8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YtGqBUjH67cBzyKNEIXNg3NAXdWLzEejANzGU54+b8psbjy4ZO6acfidlOLpLDt85
	 Pr8DOLm5ToWzBdAXghX1t4fpldGUQN9c+xCiy+GqwW1fI3iSS9Zw1WNwEmSZ0vQ5vQ
	 PclXOLdeHHZkOfy5ZNkhmPJDRlqh/7w9v8EiWwQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarred White <jarredwhite@linux.microsoft.com>,
	Vanshidhar Konda <vanshikonda@os.amperecomputing.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.8 183/228] ACPI: CPPC: Fix bit_offset shift in MASK_VAL() macro
Date: Tue, 30 Apr 2024 12:39:21 +0200
Message-ID: <20240430103109.083890570@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -170,8 +170,8 @@ show_cppc_data(cppc_get_perf_ctrs, cppc_
 #define GET_BIT_WIDTH(reg) ((reg)->access_width ? (8 << ((reg)->access_width - 1)) : (reg)->bit_width)
 
 /* Shift and apply the mask for CPC reads/writes */
-#define MASK_VAL(reg, val) ((val) >> ((reg)->bit_offset & 			\
-					GENMASK(((reg)->bit_width), 0)))
+#define MASK_VAL(reg, val) (((val) >> (reg)->bit_offset) & 			\
+					GENMASK(((reg)->bit_width) - 1, 0))
 
 static ssize_t show_feedback_ctrs(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)


