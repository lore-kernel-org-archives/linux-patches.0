Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2FB23D7CF;
	Wed, 25 Feb 2026 01:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983334; cv=none; b=k2JImEI9yVd2AZYD3pmTvq35SDERRCaZIc0yKIt7I8RyvjPhidihj+GBUYW+Ii2mbu4/0gzIzExlqVtjfkO/DE74vN7ciLOtVRL/FP+lXj415dkYBqjo82J1Bhg1hoqFcLXd1bqRCtxfVgVmJlsWiKDHlS1cGCSpbIqKUODEgKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983334; c=relaxed/simple;
	bh=8O7jdvcHnqDHkCzIC6/aX5AuhZDUTvZfd+4BQcGKeFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrzQpKFCG+aqHN44MnYaagrf61mSZI5hKXSdewTyzH8lNbjpQ6cF8zaKM7pefuZM8Q4dt23WO76c9BnMIT1CmRo5FAtdZxGQdfri549lkEty5giGnBmwi4xPnh0XJU7M1aq4d+iVV4DUokCOmnTcIpZAjjHovWl+2wJH4m6Cdu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lYY4G67D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYY4G67D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DE1C116D0;
	Wed, 25 Feb 2026 01:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983334;
	bh=8O7jdvcHnqDHkCzIC6/aX5AuhZDUTvZfd+4BQcGKeFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lYY4G67DmFT8vxLy0WWDGdOrFEieGnRtFbtvLxLgEik7Ulm8s1gxdg19sqzWT+YFg
	 24qK44dp+IayaQnZ0LD1j2wgEJjg2sLrA3YFnib6wgMG/2Scwf8biMR/4ZhKt+VFCX
	 gw7j3zcWJvl7vsY/S0+SUgMCiTTlBIsEIyBCRQ88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malaya Kumar Rout <mrout@redhat.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 465/781] tools/power/x86/intel-speed-select: Fix file descriptor leak in isolate_cpus()
Date: Tue, 24 Feb 2026 17:19:34 -0800
Message-ID: <20260225012411.228290056@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 558138eea75e9..d00d15490a98c 100644
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



