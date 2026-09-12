Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3715633F59A;
	Sat, 12 Sep 2026 12:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216950; cv=none; b=DTb6e3DAPTZhc2yTI6ZoPqQXMV2LCc8MMuGenjYN3dQDfxyZ6xWOATSwEbutzCIXKVG4/k2R7z6FtJSZ78qnwOExI5gsF37Oal0bHOQcwfDBvfKsTo1t1gj4bOPlKeKXGkdyjKejIWhjwNrcZmiDGUZubqN6CBFlshp6f/+/FrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216950; c=relaxed/simple;
	bh=Z9RbFND4vGG+iutJ2unpRXpnbtS8FR73WaKb0vG0ZDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9STSz0OJISAWGLsqawH2jhkQ0Y0WczxAUuK3IUst75AV9bCGrR0Un3KK/kcw+3l8PcKj+DxtHOPLLBDcV3d/ABmduyAy869q0o5V5C91v4DhCyc90CSN55tthmz992DGZuKz13SGPwuyiMlt7c+CoenDF99dh8G4dWaBN/cVO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ykFZty+b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ykFZty+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316E31F000FF;
	Sat, 12 Sep 2026 12:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216949;
	bh=Ncs+GaBXfqb1x1bdtMsLuRFddA8lcsvxgayja3RUYbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ykFZty+bxxqUGDDjA4ElfAxG/9Oxm0ybsLCuq590UVFoCXYZbOiOJ+OYIV5N9iPO+
	 Dtcm28ezfd6qxmD9pfHU3d8Q2KHFjU4xJR7OidQBfByMOpAF9pX4XyzE+U0VyfvefJ
	 ZB3RVlmesNza+8EKG0ze3jxALe1RJbxQkrwHVn7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0834/1376] perf machine: Reset errno before strtol in guest kernel map creation
Date: Sat, 12 Sep 2026 08:54:20 +0200
Message-ID: <20260912065626.133651817@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 073ab47bd5678..1cef434b3c8dc 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1212,6 +1212,7 @@ int machines__create_guest_kernel_maps(struct machines *machines)
 				/* Filter out . and .. */
 				continue;
 			}
+			errno = 0;
 			pid = (pid_t)strtol(namelist[i]->d_name, &endp, 10);
 			if ((*endp != '\0') ||
 			    (endp == namelist[i]->d_name) ||
-- 
2.53.0



