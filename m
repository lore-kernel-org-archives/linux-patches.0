Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BB538DC7B;
	Sat, 12 Sep 2026 14:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224449; cv=none; b=oB2zdVBcabrr+sJuY7L5Mhfbq7IsTauosr+fF3J22Hud1TYEjPnuZRVfmHEyeabOsUS65oiNqAMhMJtwwzTvF6/XkdfwVsm5CO1dLsiBJ7N1aLcSkAUQBgx3oiK5fXFKFdweqUEjP24qAQqMXhF1JXLRcCU9Lo+AZU2jDBRcvTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224449; c=relaxed/simple;
	bh=v4vVbN38ihNshg/zy4YHpwTVi1EX8oHuObXufPRHik8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLc/c8oCAvLFaDq8CH9niJOP4qjBDzxlj7u+0ucGoG/MIdMlCdVeqy5fupqH/6dQHdiFMnodnFeYlSiO3TTSwdFwDkdorvwYWrVu/q0EkATRQpwT2oSTlObfZEByWDchzuPA32i2DakWIwEGksuSsI4TALHMkfKkLm3Tqj5VOXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Au1cLm6H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Au1cLm6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018BD1F000FF;
	Sat, 12 Sep 2026 14:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224448;
	bh=ILmEtqezOKZLxUDAqktoKSjGf2uUva/l/qMf8o+3coI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Au1cLm6HWeMek/qAyQ6+Sy4j9G9kHomciFYltBQwgFOg6IcncU2cjvTcSOY8Kw0+h
	 gnSWzLAP0Vg2kriyJI4vD3Z0hrCqs18f1mJp9gfhU1gHC6XJo/DtFvwBgln/WWMakk
	 WiAB8ynUow9Z2TnEY9DrooOLlBOsMH+mxPWfaPDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0993/1424] perf machine: Free scandir entries in guest kernel map creation
Date: Sat, 12 Sep 2026 08:57:05 +0200
Message-ID: <20260912065629.553928056@linuxfoundation.org>
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
index 7539cff1ecd32..e1fd1c35816c3 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1411,6 +1411,7 @@ int machines__create_guest_kernel_maps(struct machines *machines)
 		for (i = 0; i < items; i++) {
 			if (!isdigit(namelist[i]->d_name[0])) {
 				/* Filter out . and .. */
+				free(namelist[i]);
 				continue;
 			}
 			errno = 0;
@@ -1420,6 +1421,7 @@ int machines__create_guest_kernel_maps(struct machines *machines)
 			    (errno == ERANGE)) {
 				pr_debug("invalid directory (%s). Skipping.\n",
 					 namelist[i]->d_name);
+				free(namelist[i]);
 				continue;
 			}
 			snprintf(path, sizeof(path), "%s/%s/proc/kallsyms",
@@ -1427,9 +1429,11 @@ int machines__create_guest_kernel_maps(struct machines *machines)
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



