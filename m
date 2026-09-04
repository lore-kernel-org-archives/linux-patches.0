Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365E9369204;
	Fri,  4 Sep 2026 06:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502275; cv=none; b=aF0uzGRfYS3HVTH8fti7I7WxDMsVbUBibBTBUelGnupgDi0puKNKqtRKnuc3kI2lBoPIvQYDmHhCCF975qsOE1W8nOaEAf/RmI/nFHVdpyyZ87zTGPeXU63D5uPAEpEQA7MRdbevKqNtPKiJ28zF7AjpfclDkWCu1iihEqE77ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502275; c=relaxed/simple;
	bh=hYVPMgmCuUOH767wTl35Qvb/Q7tyioXPN7YYWBYIK8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hMkzs6e/uFYMZROC86vVEnErSuxzwEf1Ydh7ZGzyIiuNWZLgy6dAfec8jGanVCBC41WuycbbbjQzmlERxwU+v7zJFM9jQiSYIiCZsNLoeuNiK/V/SHa/nNpTBM2gzpwZAVbtb/aEvxFii/JoDC8Tv6eInFAM/GMRNdjZGgMUkxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FoBKLJbs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FoBKLJbs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9F01F00A3D;
	Fri,  4 Sep 2026 06:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502274;
	bh=YVevwBWnJEewv4rBe1tW+A2wBUBdajAwKxkOUa1plus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FoBKLJbsq5zmU3+cjiXvQQPJcWsM5F7vDXOj+EptPxTWll8ou0AGsafS0Yd0iloA9
	 pZT9kQWmgMYwUKQYlOrMEUVZv28Q4+ooj7Tj4wN2lct4vnJlFrxoFMwBgsN+1VjnvR
	 D/d4rVu0aktHx2rtjQIKiYEnulS2RD1av9Caf8PA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nirmoy Das <nirmoyd@nvidia.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.12 151/403] ACPI: APEI: Fix ERST timeout unit conversion
Date: Fri,  4 Sep 2026 06:59:14 +0200
Message-ID: <20260904045738.283438665@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Nirmoy Das <nirmoyd@nvidia.com>

commit a685d8eea4a6899dc887e393927c16fa18ff5e9a upstream.

The ACPI specification defines bits 63:32 returned by
GET_EXECUTE_OPERATION_TIMINGS as the maximum execution time in
microseconds. erst_get_timeout() instead multiplies the value by
NSEC_PER_MSEC.

Use NSEC_PER_USEC to express the firmware-provided microsecond timeout
in the nanosecond units expected by erst_timedout().

Fixes: fac475aab70b ("ACPI: APEI: Use ERST timeout for slow devices")
Cc: stable@vger.kernel.org
Signed-off-by: Nirmoy Das <nirmoyd@nvidia.com>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Link: https://patch.msgid.link/20260721182551.2434933-1-nirmoyd@nvidia.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/apei/erst.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -108,7 +108,7 @@ static inline u64 erst_get_timeout(void)
 
 	if (erst_erange.attr & ERST_RANGE_SLOW) {
 		timeout = ((erst_erange.timings & ERST_EXEC_TIMING_MAX_MASK) >>
-			ERST_EXEC_TIMING_MAX_SHIFT) * NSEC_PER_MSEC;
+			ERST_EXEC_TIMING_MAX_SHIFT) * NSEC_PER_USEC;
 		if (timeout < FIRMWARE_TIMEOUT)
 			timeout = FIRMWARE_TIMEOUT;
 	}


