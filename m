Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EEDF34752E;
	Sat, 12 Sep 2026 10:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210671; cv=none; b=Ef65+stxrCsby1rDIUeWG8V6wXkyPpD1797yUyxg6TS3gExP4KnVvPVxo1JShyBnKRBAz5fCVoJipAy8iAnBb4Z+ke8vEqf4/MlVJmKqIdUlzHU4EjM8TP9Rf8w5nDcsDJxqPTHduJCr0JOICO8SLGTqV/1yrYs5l7rDtT41Fho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210671; c=relaxed/simple;
	bh=T6LPQiDEH1HPpc9cWhkk8tH7vRn3esJlTzYG8TGOjKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpj7+TOI9IjFiMsGdSArUMCS9l7BiPmKhrN5OVPBy/RLoNEEN5d72Y0UPcc0pfDAnYV6Ascm98aM3RhBRSpVzygvOZHjxM69iz4Gq7q9FY3DCOHAlDoGiLot5FDdqEf5kiLS5hyOMzPitNO3+ayDpo2HcyLg0xcZu2GS4gJNnYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rZ916FyF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rZ916FyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973B91F000FF;
	Sat, 12 Sep 2026 10:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210670;
	bh=cKcte+1I59oBZsb8ACuSMTwdHNeXcQSl7854MfIetbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rZ916FyF9aO9rRzJMwjmXfvWyIJfPHHpvy8pkM2MI6ZqnstTQOPtz9Tup486Nrguf
	 DO3IayeNXZupsEjKpPZk6w5+O8p5crr6aiUgtv2Y78JikmZn9g+fEL5szc7ljF0WRf
	 mB49IJ6yr/Qdhvw3D8sqHuCGNtD9S1Q8iJLptMpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1057/1518] perf python: Fix memory leak in pyrf__metrics_cb
Date: Sat, 12 Sep 2026 08:53:46 +0200
Message-ID: <20260912065647.362133809@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index cf840804592fb..a65a4d9f8cc83 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -2159,6 +2159,8 @@ static int pyrf__metrics_cb(const struct pmu_metric *pm,
 		Py_XDECREF(dict);
 		return -ENOMEM;
 	}
+	Py_DECREF(key);
+	Py_DECREF(value);
 
 	if (!add_to_dict(dict, "MetricName", pm->metric_name) ||
 	    !add_to_dict(dict, "PMU", pm->pmu) ||
-- 
2.53.0



