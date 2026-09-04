Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C381A3242BD;
	Fri,  4 Sep 2026 05:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501006; cv=none; b=S3tcmNUSW9rjayKoIGNZH6QSE0K4ghGUzvIFJlkv2POR9BCgXz1y2AhJqdL0BXiWLojoyv/J2jUS2Rovh0qR2oYWboc7y8/uXmYbbahJMCgygZfbnY0SPqfc/7tcvbYEWKFhq7zFPurCURq+MNK4rMsYCfbNX/R7MnfkHjQRjD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501006; c=relaxed/simple;
	bh=izoX2NVv7k5Pxkd34btypsk+GFGA50bAyLHbx/lyOtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmG9ublLqMxbhdjtRzOpJduetqJuN55pzFMLiqyC39hX9NOlfaiU2fz1gY43t9lJ8Wf7t2tNrDfR74xPDxbzus24YZgmnnAIIL4i66F3Mxt5LTEuXCvWC8Tv6WAS+O+NbThEV1A/14mjfbP1IpzC5sSZ7FIlxOlkr7YtUbI08y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J9TK3wvN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J9TK3wvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224181F00A3D;
	Fri,  4 Sep 2026 05:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501005;
	bh=MY0laex5qlrH4vHDGo0RtSJdWlA7614wTn1w0qVu+tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J9TK3wvNgY42wVZ8vqj3p22Yspb2wIPvNd9C7rUnj0aBF67OrtGgr480u7YQ+8A16
	 Re4+iainZZIqRCJ7yOgEKcgAhPjpxyZN5A726NudiwtN7l4b2lSGFRw4ONrHPBMDPz
	 84C3808J74V44bgC+ZsgPMasmNlbcsmh/13cXzfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nirmoy Das <nirmoyd@nvidia.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.18 214/552] ACPI: APEI: Fix ERST timeout unit conversion
Date: Fri,  4 Sep 2026 06:56:11 +0200
Message-ID: <20260904045754.285533047@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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


