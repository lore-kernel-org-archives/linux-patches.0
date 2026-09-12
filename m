Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121533803E3;
	Sat, 12 Sep 2026 08:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202801; cv=none; b=NcOjxEr+Dal2C1ZtopVAPmWdU2cSVtNI0Uq7qslUltWhq2QuVYYHqW+lfji1h4PLWJdX9i7ndOgmZUmzl4kbaFr7GtkNmc9Hb7r/v34vx1qbou+IdMl56+hF7U7XscIjjvw4X8SsAtMrOBZj0XQJ4n9BjSQC+VMTfsmV7T9mVYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202801; c=relaxed/simple;
	bh=1T6IrT3hJHCx4m3gtRn1ijV5OuP8tEMh8qjPtgTMir0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGOLyKpuYgIap1W8DP1oTp2/q8UkFxB7Dfz1MAZtEQLheDzGOXF76vxuwj2tFkKHUqD8JWwYdnEC+Pze5KM6NkuOC742XNDaBaUbLXrIX7Tix+GoZACOtK0Qg+5Um2mHmlBMTMvSDt6keLqaAtcQ52ynwGcLSIzSMCeIkh7qXm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=skXgXH3X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="skXgXH3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DC61F000FF;
	Sat, 12 Sep 2026 08:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202796;
	bh=qzY4F63EAgEQ+5fV9JkfIaboeqKd76KRpGavU0qzEpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=skXgXH3XHWqwkfbmmPVejglhSkkH9USsMg5CyTLFPR0nHLRkljFZvt6TWrwOtIVfx
	 GFYhy31I1qGKrEAtIYxCM/+xifsmz0lxRBi+6BpqFugv/WXtSnxWfKjnrMdg6Reg5/
	 vGn0qfInbsY/zbG1okq8Zxe/u0vB/jZePxpPpHus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1275/1815] perf python: Fix memory leak in pyrf_evlist__get_pollfd
Date: Sat, 12 Sep 2026 08:50:25 +0200
Message-ID: <20260912065718.948382145@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 38d778acbee3ee96c14e33863b747e674d975eae ]

Fix a Python list object leak in pyrf_evlist__get_pollfd() by adding
a missing Py_DECREF on the error exit path.

Assisted-by: Antigravity:gemini-3.1-pro
Fixes: 877108e42b1b ("perf tools: Initial python binding")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/python.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index f020f541b47e7..43359fd2a891e 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -1781,6 +1781,8 @@ static PyObject *pyrf_evlist__get_pollfd(struct pyrf_evlist *pevlist,
 
 	evlist = pevlist->evlist;
 	list = PyList_New(0);
+	if (!list)
+		return NULL;
 
 	for (i = 0; i < evlist__core(evlist)->pollfd.nr; ++i) {
 		PyObject *file;
@@ -1799,6 +1801,7 @@ static PyObject *pyrf_evlist__get_pollfd(struct pyrf_evlist *pevlist,
 
 	return list;
 free_list:
+	Py_XDECREF(list);
 	return PyErr_NoMemory();
 }
 
-- 
2.53.0



