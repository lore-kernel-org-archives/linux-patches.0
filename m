Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F052E718B;
	Sat, 12 Sep 2026 08:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203037; cv=none; b=AJAdpI4XMKMgoL1X5VaTmzozbBJR1qKXNjFU68Pe3IXPDwr0HsveXAfaEWD2+6vFeWxWZXHQt4+f44V/AOVD4el6cLUOq213TnYcggTzhleuhxw+POWtfkv/9moMNf8t91wmdJl6Pc5NJA4xYxKfLBo7gtaTZ7foFS/c/+MDamQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203037; c=relaxed/simple;
	bh=WAhVJFY6EyCXA7ToI/gzuLbTSFVFsJT1BKoaaPDskTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDHCi0ObQgfMBDXFvtoC/OXpZ+NExKIKST66brfdVm3S2yNJvGX3n7vRzn7JdLONmbX04KF0BB6FH4Te6Pd5zz3hMt3tv6Qo8GKQyK67HwxmSbM/wQiGlbBhxrM5Pvpn4ZBwbuaZFHxKmUOnUivPXyeCCysY36GwXOtaY65ND9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OoVgF7hG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OoVgF7hG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4531F000FF;
	Sat, 12 Sep 2026 08:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203034;
	bh=zcgS0EOqRjPlUbONAIT3H87URnUNlC63MIl2PXspfFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OoVgF7hGP7AuHIPzhbRCJ5cTOhRmu7LZZYawkF4HiQptQ7VdAFDdlcpzfQ0vhYvDB
	 YJTMWddHCmLdDpzyFv/26AeMco42muIOUrKym9tkvRFn1n/93byJHcgtGPErXb7s92
	 tnrxVe6eKzoPMEyudkZEysdtak2tviKofUWPLETg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1283/1815] perf python: Fix memory leak in pyrf__metrics_cb
Date: Sat, 12 Sep 2026 08:50:33 +0200
Message-ID: <20260912065719.135530340@linuxfoundation.org>
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

[ Upstream commit 1ec13016ba36f1bf7dc61e054068fe00f2f628c7 ]

In pyrf__metrics_cb, PyDict_SetItem does not steal the reference of the
key and value, so they need to be decref'ed after successful insertion
to avoid memory leaks.

Fixes: 47b3e95728eb ("perf python: Add metrics function")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/python.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index dc1e19f5eddf3..38944a886c1fd 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -2508,6 +2508,8 @@ static int pyrf__metrics_cb(const struct pmu_metric *pm,
 		Py_XDECREF(dict);
 		return -ENOMEM;
 	}
+	Py_DECREF(key);
+	Py_DECREF(value);
 
 	if (!add_to_dict(dict, "MetricName", pm->metric_name) ||
 	    !add_to_dict(dict, "PMU", pm->pmu) ||
-- 
2.53.0



