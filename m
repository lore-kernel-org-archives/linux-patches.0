Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC6D29D288;
	Sat, 12 Sep 2026 19:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242900; cv=none; b=NMArwGPY2en9BPc+bSL7Q8zf3WMczvjO7Uw+hXRyWK3DRbb3HB/i9Z6A7Vf9axohRHqkCRklxUkX7TF8ieQBk6xgTRqzCK9mF0MukaUzkaBTPj2TPJMjIi4nvz1goWyF9jPanaCGSsWGxKe2PXmnhQHLPiRMCyaxs1LWgVPVkRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242900; c=relaxed/simple;
	bh=EEH2rSu/o3SV7ygQXCo5VJ53FRZMMYYmeUxQH6nXTHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQrpcxa3oqBcYwxsIvKVtRJd+UdKNm5U3R5wxPgP0lmvlyDD2qFGZ1NnNc/3F+TndpcHJzMsZ70sJfbo50M6YFwH3Aim77q6d5eKwcC3uWfwtVVHStpkBlT9kwG/rrAGxsHR438/U0P7xtckIv/u4DCXhuuPT0NVKGJzh/Ls5Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cvyzFnWD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cvyzFnWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7800D1F000FF;
	Sat, 12 Sep 2026 19:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242899;
	bh=9gwv1yJt7Mkcw6ljP0410KSsh+i81EpDrkUgfdAQyYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cvyzFnWDtFkAsI0SnuOmcZ1KsKC0rD9l+IjvMfP4uHEUrCEKVMXbVyqkBFfKIAnix
	 VE8VZDJgk3jZIqkBcRYouRnc72Wv7KGeAtK/dqYLwLw+vCQodQg79TfFdD7OwVJ65/
	 pupKPxvcrpLryTSw5BigPQJyt+EkOeBl3/USigFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 567/798] perf machine: Free scandir entries in guest kernel map creation
Date: Sat, 12 Sep 2026 09:03:15 +0200
Message-ID: <20260912065530.125055019@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit f53bf58dcd11e1cb088d3b91a035fef77062094b ]

machines__create_guest_kernel_maps() calls scandir() which allocates
both the namelist array and each individual dirent entry.  The code
frees the namelist array but not the individual entries, leaking memory
proportional to the number of directories under guestmount.

Free each namelist[i] after it is no longer needed.

Fixes: a1645ce12adb ("perf: 'perf kvm' tool for monitoring guest performance from host")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 7cea0827a27bc..f0a3c454b7870 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1227,6 +1227,7 @@ int machines__create_guest_kernel_maps(struct machines *machines)
 		for (i = 0; i < items; i++) {
 			if (!isdigit(namelist[i]->d_name[0])) {
 				/* Filter out . and .. */
+				free(namelist[i]);
 				continue;
 			}
 			errno = 0;
@@ -1236,6 +1237,7 @@ int machines__create_guest_kernel_maps(struct machines *machines)
 			    (errno == ERANGE)) {
 				pr_debug("invalid directory (%s). Skipping.\n",
 					 namelist[i]->d_name);
+				free(namelist[i]);
 				continue;
 			}
 			snprintf(path, sizeof(path), "%s/%s/proc/kallsyms",
@@ -1243,9 +1245,11 @@ int machines__create_guest_kernel_maps(struct machines *machines)
 				 namelist[i]->d_name);
 			if (access(path, R_OK)) {
 				pr_debug("Can't access file %s\n", path);
+				free(namelist[i]);
 				continue;
 			}
 			machines__create_kernel_maps(machines, pid);
+			free(namelist[i]);
 		}
 		free(namelist);
 	}
-- 
2.53.0



