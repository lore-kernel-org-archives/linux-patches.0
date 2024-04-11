Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1C379FD;
	Thu, 11 Apr 2024 10:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832575; cv=none; b=ngxuW2W3kQw3XGiU9IRf7m4XQ46DB+gd8j9UkAEHN/nlcLH6EDsr/RfYgFI80F6ysjH1HBN4dt/UCNASjB7DRYZS9YTVIgetpMz6KaRg0wRJyDBtrDMazPFuWx6x7+8wnvXXwH434k4qLksb6jiE/kvZV8v+DOh5/16CI4+zjiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832575; c=relaxed/simple;
	bh=sUa6lNXxHs4kgE3GviXBqI7p5RhXOvxwSfP9F6SwaW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7yN97e7Fo/8gat7EBqloa06fBb5d7sF71Pr0C6J6vWastSxTCZiuWVCAZYLnyw9kSM44HLcVQILkRknx9hUE3sELvzDw1pP9m+a79rdQe9/u2Nb7yKml6UiGz04LUHmtrPSsACP9Kevdb2/7gybMQMNSGqlgqWZFfcl6JwWg6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r1YsSXqW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1YsSXqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26BC0C433C7;
	Thu, 11 Apr 2024 10:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832575;
	bh=sUa6lNXxHs4kgE3GviXBqI7p5RhXOvxwSfP9F6SwaW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r1YsSXqWHLV3LGU4LvOkP3w6EkubOfR0H5AG06CPtd7RV6CiG+wvnUNkBoAWhF05Z
	 eP3IyCDjnXiIditcqB4JA8qgXereibBtdWeMpqRKp7Jh/7hM2wetTk4EREOJgkZBFH
	 e3Qio5R1EkmAxtg3Jeurj7NjeEVY5QVZDBAY9xyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 12/57] tools/power x86_energy_perf_policy: Fix file leak in get_pkg_num()
Date: Thu, 11 Apr 2024 11:57:20 +0200
Message-ID: <20240411095408.364038765@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>

[ Upstream commit f85450f134f0b4ca7e042dc3dc89155656a2299d ]

In function get_pkg_num() if fopen_or_die() succeeds it returns a file
pointer to be used. But fclose() is never called before returning from
the function.

Signed-off-by: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
index 5fd9e594079cf..ebda9c366b2ba 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -1241,6 +1241,7 @@ unsigned int get_pkg_num(int cpu)
 	retval = fscanf(fp, "%d\n", &pkg);
 	if (retval != 1)
 		errx(1, "%s: failed to parse", pathname);
+	fclose(fp);
 	return pkg;
 }
 
-- 
2.43.0



