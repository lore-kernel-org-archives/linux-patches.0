Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13552D1F40;
	Wed, 25 Feb 2026 06:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002610; cv=none; b=t4U4MMuSjzy263zMIjSTZ6jh8QMNKBDQ5j0slBYNXgbQxTTI8SU92eqsoZBdY3VwvF8rjGVbDUd0vkHDg28I3NFE+VDotrkIyVYDsemKhSi49RN8XYwJxXQsePmAolAlkkql4WZM1HM1gz5YGZstkKaKDF2THTRFnH1g3d4myls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002610; c=relaxed/simple;
	bh=WwZZTC6V27rLvz0gi+mnCDpSgmc221yazIlGTkBmnCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZYIMp3ttb/gYx53a+XPp03YL0erOAEJAWhtfLhkCunD0ADLXmicfx9PS0qUSlHNyABHSmwQT9p0gVf+ZCFDkvQ7Mq76/msr6/95pDWeufHEkURC5g42j+3ReFVwMBAK6LH7DvTdSP9xomIbBBRFbM3Vg+4X/w8m2fY2StlzlLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iyh/xYTG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iyh/xYTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E44C116D0;
	Wed, 25 Feb 2026 06:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002610;
	bh=WwZZTC6V27rLvz0gi+mnCDpSgmc221yazIlGTkBmnCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iyh/xYTG5KgU4G2Vv/EXmQCcgMJ1xHfQI3+I6n7st/Wjbdhk81YKdVaBnKLsmo99m
	 NqYa62JqnjxmHvEiSR1ED5gHzsBXwnAgz1WCMfVTTOYuKvhashskX4Dd+LCcyoootx
	 ycA2xe3Ao/rGR3lbevn0Ms+y7M1j8FgjSjhfCdpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malaya Kumar Rout <mrout@redhat.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 361/641] tools/power/x86/intel-speed-select: Fix file descriptor leak in isolate_cpus()
Date: Tue, 24 Feb 2026 17:21:27 -0800
Message-ID: <20260225012357.367372573@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Malaya Kumar Rout <mrout@redhat.com>

[ Upstream commit 56c17ee151c6e1a73d77e15b82a8e2130cd8dd16 ]

The file descriptor opened in isolate_cpus() when (!level) is true was
not being closed before returning, causing a file descriptor leak in
both the error path and the success path.

When write() fails at line 950, the function returns at line 953 without
closing the file descriptor. Similarly, on success, the function returns
at line 956 without closing the file descriptor.

Add close(fd) calls before both return statements to fix the resource
leak. This follows the same pattern used elsewhere in the same function
where file descriptors are properly closed before returning (see lines
1005 and 1027).

Fixes: 997074df658e ("tools/power/x86/intel-speed-select: Use cgroup v2 isolation")
Signed-off-by: Malaya Kumar Rout <mrout@redhat.com>
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/intel-speed-select/isst-config.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/power/x86/intel-speed-select/isst-config.c b/tools/power/x86/intel-speed-select/isst-config.c
index 0ce251b8d4665..a7d54dfd3c68b 100644
--- a/tools/power/x86/intel-speed-select/isst-config.c
+++ b/tools/power/x86/intel-speed-select/isst-config.c
@@ -950,9 +950,11 @@ int isolate_cpus(struct isst_id *id, int mask_size, cpu_set_t *cpu_mask, int lev
 		ret = write(fd, "member", strlen("member"));
 		if (ret == -1) {
 			printf("Can't update to member\n");
+			close(fd);
 			return ret;
 		}
 
+		close(fd);
 		return 0;
 	}
 
-- 
2.51.0



