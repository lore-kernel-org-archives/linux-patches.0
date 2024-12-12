Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A172121577D;
	Thu, 12 Dec 2024 15:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016622; cv=none; b=dp0v5Kgaau2w0t8YsamlxhpYR0kWxmRjdgbdxRrAF0+0Eafgvdo9achxP9TH2PwUU0WlUd1AHuObOpO8T5ZazsZIL4bF7sS43KrUGJ2vAShikMvyOahSMVOWkdvBS184NV0eCXNwq3/FBuNQJBJYp0Y349+WchB+qOL97tqgA28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016622; c=relaxed/simple;
	bh=7T/nTgNkvQRaDDTad6N2deyvrMYodeWNE6dpqSR9FMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k/0d3b3nqHbOVVf+6DEy7o9f4IJHvjgxF0HDavnqpW0YOeM9TkLgiAwvfzU0LZlIKffjgMxrnD5qi1HqdQZOW1Y3qwo6K+8hsyZBG5wVdl+KHNJpJawvEZWP0D9N9+AcZbWLR/OyjBhRIexQlx2mrtLMZ6Nbbq/uqAngJwVgdTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GXyWTz/f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GXyWTz/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E014C4CECE;
	Thu, 12 Dec 2024 15:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016622;
	bh=7T/nTgNkvQRaDDTad6N2deyvrMYodeWNE6dpqSR9FMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GXyWTz/fU18FgrVna55TA2ig+YuLoQBABpYE/n87+hZAEzmH9lk8VkXKUdwiuQzYP
	 GUpnRLEtHnxgG9UwbafdljmIvF757JMbOXffzsbJcRRzDJAsygLYSwqYQ/7CFVDGaq
	 QvyDLsqsU7d/WZHtZAzEQL9y7Tn+KdDPLiW0PtgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinette Chatre <reinette.chatre@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 250/466] selftests/resctrl: Protect against array overflow when reading strings
Date: Thu, 12 Dec 2024 15:56:59 +0100
Message-ID: <20241212144316.663522986@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Reinette Chatre <reinette.chatre@intel.com>

[ Upstream commit 46058430fc5d39c114f7e1b9c6ff14c9f41bd531 ]

resctrl selftests discover system properties via a variety of sysfs files.
The MBM and MBA tests need to discover the event and umask with which to
configure the performance event used to measure read memory bandwidth.
This is done by parsing the contents of
/sys/bus/event_source/devices/uncore_imc_<imc instance>/events/cas_count_read
Similarly, the resctrl selftests discover the cache size via
/sys/bus/cpu/devices/cpu<id>/cache/index<index>/size.

Take care to do bounds checking when using fscanf() to read the
contents of files into a string buffer because by default fscanf() assumes
arbitrarily long strings. If the file contains more bytes than the array
can accommodate then an overflow will occur.

Provide a maximum field width to the conversion specifier to protect
against array overflow. The maximum is one less than the array size because
string input stores a terminating null byte that is not covered by the
maximum field width.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/resctrl/resctrl_val.c | 4 ++--
 tools/testing/selftests/resctrl/resctrlfs.c   | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/resctrl/resctrl_val.c b/tools/testing/selftests/resctrl/resctrl_val.c
index f118f659e8960..e92e4f463f37b 100644
--- a/tools/testing/selftests/resctrl/resctrl_val.c
+++ b/tools/testing/selftests/resctrl/resctrl_val.c
@@ -159,7 +159,7 @@ static int read_from_imc_dir(char *imc_dir, int count)
 
 		return -1;
 	}
-	if (fscanf(fp, "%s", cas_count_cfg) <= 0) {
+	if (fscanf(fp, "%1023s", cas_count_cfg) <= 0) {
 		ksft_perror("Could not get iMC cas count read");
 		fclose(fp);
 
@@ -177,7 +177,7 @@ static int read_from_imc_dir(char *imc_dir, int count)
 
 		return -1;
 	}
-	if  (fscanf(fp, "%s", cas_count_cfg) <= 0) {
+	if  (fscanf(fp, "%1023s", cas_count_cfg) <= 0) {
 		ksft_perror("Could not get iMC cas count write");
 		fclose(fp);
 
diff --git a/tools/testing/selftests/resctrl/resctrlfs.c b/tools/testing/selftests/resctrl/resctrlfs.c
index 250c320349a78..a53cd1cb6e0c6 100644
--- a/tools/testing/selftests/resctrl/resctrlfs.c
+++ b/tools/testing/selftests/resctrl/resctrlfs.c
@@ -182,7 +182,7 @@ int get_cache_size(int cpu_no, const char *cache_type, unsigned long *cache_size
 
 		return -1;
 	}
-	if (fscanf(fp, "%s", cache_str) <= 0) {
+	if (fscanf(fp, "%63s", cache_str) <= 0) {
 		ksft_perror("Could not get cache_size");
 		fclose(fp);
 
-- 
2.43.0



