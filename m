Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BD8305680;
	Sat, 12 Sep 2026 14:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224444; cv=none; b=qb++iWgVqRVSfQHunMb06SMrwA/6j1UU6ABtPUbWWB8Yyet1z0cnGrAheoOtvCtU/+5TxgXYDDc9X56Nja2kcIVnpHZbeNjLi1YEx21V+yT0Dfs6rCR7y14oPDp5oSG5oxkzifafDRIh6ybiL/RAcxFjWOlo4CBm00gKjHXXK7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224444; c=relaxed/simple;
	bh=sNMMHsLRL9FqOpZ3ltdXxSwigK0ssr5F6LJ/ABDNpYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCvjRe/WNqgP8fWbFTxAOthJr07vqVVxagYcy7/Rdgd6OvHKxOEfx2e2EwCUr3kOXcfjiX20y3SecPlg2nrrlbgupOd9grGQ7oeowlHlEmDrCW6H15LoDaqpQVuguMKRKIcPmwbUWYDgTzSbIkB2e5LjbMsvC2CE2f7IWx0mcAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yhA+CMKX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yhA+CMKX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E5431F000FF;
	Sat, 12 Sep 2026 14:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224443;
	bh=qVQBno9n5GyMRZAOe3MfGIwMVOmKKbyGWJF/N7TwK5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yhA+CMKXIQaAYHKtQMvN5iz5tPqaje6SVPLGwhsv0QW4MbXiJMIm3866OhaW8Q+lY
	 igtocWuRMXtm+R3yEUOoHPWDUoAKtt6nBLg9SuM4MbZAaFLIC+iEGxumG+hFDqq6nV
	 CusU80KZ6ruEDc6bCpDueLyyDKApCsXbl2rVNs10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0992/1424] perf machine: Reset errno before strtol in guest kernel map creation
Date: Sat, 12 Sep 2026 08:57:04 +0200
Message-ID: <20260912065629.530932440@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 29ec46e43f6ca7d6a6651db724d4ffd820f46e8b ]

machines__create_guest_kernel_maps() checks errno == ERANGE after
strtol() to detect overflow, but does not clear errno first.  A stale
ERANGE from an earlier library call (e.g. scandir internals) causes
valid numeric directory names to be incorrectly skipped.

Set errno = 0 before strtol() so only the current conversion can
trigger the ERANGE check.

Fixes: a1645ce12adb ("perf: 'perf kvm' tool for monitoring guest performance from host")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 7cc97c3ef2249..7539cff1ecd32 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1413,6 +1413,7 @@ int machines__create_guest_kernel_maps(struct machines *machines)
 				/* Filter out . and .. */
 				continue;
 			}
+			errno = 0;
 			pid = (pid_t)strtol(namelist[i]->d_name, &endp, 10);
 			if ((*endp != '\0') ||
 			    (endp == namelist[i]->d_name) ||
-- 
2.53.0



