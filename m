Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C672533A6F2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302182; cv=none; b=pR+Rk8fP2WPhgHbImXVTkUk8T2V3ZtuNADUg+ERdSI9JPRlT3Pp3t2W2lFPB6lKtgiohf70Cmxjfo33iQCE1bYojNrUORs8Ba7nGTTSU+8yoZ69ZL0xlpYC97tugVpurj/nKBxgzgtWpQrxvKhwA99UO14qhqiLyzJKjreRRqGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302182; c=relaxed/simple;
	bh=3PQUdqoppMWCEw/60LrWWv9pqIA1R9CbJojKcAgy/Rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgKNAPUKB8fbukBM/CILOu3nu9jMZi1fg6Kpzmb9TJdQMAs8BdhsCcavipN3LpMT7WvMEpZxZTbUOJXOYnNMOp0Bl0LyNTJTFAJRjK4ywRGl0wgDsWOm7aAXGLEC1e1kOM4ugZ3w/CwyX+PJn75O+ViDq0hB/e1AYf/JS88rfSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g8DmFVXQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g8DmFVXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A51C116D0;
	Sat, 28 Feb 2026 18:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302182;
	bh=3PQUdqoppMWCEw/60LrWWv9pqIA1R9CbJojKcAgy/Rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g8DmFVXQst6rqP1hTsa2s8GVKjTviYAL3w9eiBQNb9UDspAtVklCqlz1gpTzOv+1H
	 jmcs9O4cMeTU0g2q8o0/tguhEzjUY7vv75F3yeCxXNrmw5O5RMh4sFqrZKxQ3N/Oup
	 N5r9x64moPrLkC4kpeokdDtuKvZ8UxQDkWUH8fuzOjKXuAPYSKUxHp66PZtb1hmyXD
	 Gt5VkUn1lLHEilbPOz9I1PWKCOAQtp2oRmQWdKnpAZ4qII/3OAx+y0wwbK7oojZBzD
	 algz7ptluQFU3woaVZdVBtHg0zsFE2Q2iQFTqn9EAJRupgkGpC/LpWUGPZugbM9OCP
	 +RHKcNNdlpr+A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Malaya Kumar Rout <mrout@redhat.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 183/283] tools/power/x86/intel-speed-select: Fix file descriptor leak in isolate_cpus()
Date: Sat, 28 Feb 2026 13:05:25 -0500
Message-ID: <20260228180709.1583486-183-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 5fcc2a92957e7..a5d512866a940 100644
--- a/tools/power/x86/intel-speed-select/isst-config.c
+++ b/tools/power/x86/intel-speed-select/isst-config.c
@@ -936,9 +936,11 @@ int isolate_cpus(struct isst_id *id, int mask_size, cpu_set_t *cpu_mask, int lev
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

