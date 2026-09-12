Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58502AD37;
	Sat, 12 Sep 2026 10:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209386; cv=none; b=lruMpEc37KYVNavsYDkRXfsVDjBa4jMTtyrANHN4rCjWn635685B1Pb7GbmndohcV5QpgEwI/+KQ3wh4DgaWq7POPzlxYGMO82wHrViLuznp1+wsQ/DPFf0edLud4TNcqNJHhxUWuSp/BlVNRYxNluGTWE0/0fw6AmNYOnj7VeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209386; c=relaxed/simple;
	bh=6Lif0QNQL5/GtTGs3uuH+L+TwK0trJzMOAfVmAeD23E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j10hyc8DjkFUwoVyykkz6btXZHUCNrqUWqCdG44Q6/rTnPxQBcfO7/wYgwrdyV8pYjtr20IbK3j6VcqRFQADnX9zArKIMsCh36cQs2UcZg/3VoZ/TnvM7ei8VnM/0P72PgbQFbPbUXus7qdoHkgNu8dyRTpOtTOJnZeudXl1B4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yix2FMr7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yix2FMr7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7801F000FF;
	Sat, 12 Sep 2026 10:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209385;
	bh=W3fiQfHXhNdfltC4bnni/YGc6tnWR2QDUQovg+6bdWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yix2FMr7wliMKeLZCG7pOC90qAkb1L2OlGEVs+Wb0I3NRzeGo1+tcYWW33Q/3ZePj
	 kgZAB9AAVsv/eNd49oVfXhC3amfEbU+mlfhD3tP3DVBXnccRY+2z4fkVMBp6hb6lKX
	 oXwHl0iC9iubV5vAMjOS7HWfbzJK7WscaTIcgk8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0783/1518] perf machine: Dont abort guest map creation on first inaccessible dir
Date: Sat, 12 Sep 2026 08:49:12 +0200
Message-ID: <20260912065641.151096208@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit b687e1a418fb819ef83c362d84c216a6a841e3b0 ]

machines__create_guest_kernel_maps() jumps to the failure label when one
guest directory's kallsyms file fails access(), skipping all remaining
valid guest directories.  An inaccessible directory is not fatal — other
guests may still be reachable.

Replace 'goto failure' with 'continue' so the loop processes all
directories, and remove the now-unreferenced failure label.

Fixes: a1645ce12adb ("perf: 'perf kvm' tool for monitoring guest performance from host")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 8455cd94756e1..b35c73618ea02 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1248,14 +1248,12 @@ int machines__create_guest_kernel_maps(struct machines *machines)
 			snprintf(path, sizeof(path), "%s/%s/proc/kallsyms",
 				 symbol_conf.guestmount,
 				 namelist[i]->d_name);
-			ret = access(path, R_OK);
-			if (ret) {
+			if (access(path, R_OK)) {
 				pr_debug("Can't access file %s\n", path);
-				goto failure;
+				continue;
 			}
 			machines__create_kernel_maps(machines, pid);
 		}
-failure:
 		free(namelist);
 	}
 
-- 
2.53.0



