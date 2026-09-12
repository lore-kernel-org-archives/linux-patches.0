Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A2B20ED;
	Sat, 12 Sep 2026 08:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202949; cv=none; b=d8HtWbEnLaTFi9lVdU0h47b+hlh8hR/uaR4S2jIgPMb14bcVHqVZoB+qzHt3b3sNf52TcuwwvCBWFm7ZV7Rr1GqQH1CJm6jwGbZwsbnnTYLSsplKH5Lbo4FrVEM6M1nXffgnxb4EWVylyfgnJaGk4O/9+KlF3M05vVXUHLJgPvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202949; c=relaxed/simple;
	bh=VkFFWIjdRpyRuyGUIsX3p05f+AzhVhQbGQ56n/5btJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lc5E2a6mH9bPbocW35/jHt3eQBNtHkehYveLS7Y5rUj2wxDRFv5A0A9AGZsypLl0Ky03ajhYQGW0Kv53cHg3Etz6Ii826phDqYk47h8JE3GEzDypT14g8MmjUWp73r2TvgvOLp+s/AtZZE9abtfRCS0igsPiCWUU0JeLTm5pdIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lBnFxRJK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lBnFxRJK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8777C1F000FF;
	Sat, 12 Sep 2026 08:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202947;
	bh=YEmOp9S8X7lx3xgaaXodZZPscu0UtE+b0FNcMIVcZQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lBnFxRJKsOWbOMtBU3KSlOo3Zi7lAE6I07i0Wjy0DAhh5zAqYPTp7V/pkcfQCjGhR
	 JheL8r4RRFAoxqC5p1YR1xLJXhhhyq2kjGxT3O1ZpU4DRCIsZmnlmeVENDIFkxWYuG
	 k1mJnUN39fJTwW0P7L86eO8WWf9MqSQaZja9e3bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1281/1815] perf python: Validate attribute setters in pyrf_evsel
Date: Sat, 12 Sep 2026 08:50:31 +0200
Message-ID: <20260912065719.089568672@linuxfoundation.org>
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

[ Upstream commit 0b274050c4d427828595c12c2e4e53d98612b4f9 ]

If val is NULL when setting an attribute, PyErr_SetString should be
called as deleting the attribute isn't supported. In addition, ensure
PyErr_Occurred is checked before setting the attribute to avoid setting
a garbage value.

Fixes: 877108e42b1b ("perf tools: Initial python binding")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/python.c | 89 ++++++++++++++++++++++++++++++++++------
 1 file changed, 77 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 5713e54437f0e..86a3fcb5b5e83 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -1295,6 +1295,11 @@ static int pyrf_evsel__set_tracking(PyObject *self, PyObject *val, void *closure
 
 	CHECK_INITIALIZED_INT(pevsel->evsel, "evsel");
 
+	if (val == NULL) {
+		PyErr_SetString(PyExc_TypeError, "cannot delete attribute");
+		return -1;
+	}
+
 	is_true = PyObject_IsTrue(val);
 	if (is_true < 0)
 		return -1;
@@ -1306,11 +1311,21 @@ static int pyrf_evsel__set_tracking(PyObject *self, PyObject *val, void *closure
 static int pyrf_evsel__set_attr_config(PyObject *self, PyObject *val, void *closure __maybe_unused)
 {
 	struct pyrf_evsel *pevsel = (void *)self;
+	unsigned long long new_val;
 
 	CHECK_INITIALIZED_INT(pevsel->evsel, "evsel");
 
-	pevsel->evsel->core.attr.config = PyLong_AsUnsignedLongLong(val);
-	return PyErr_Occurred() ? -1 : 0;
+	if (val == NULL) {
+		PyErr_SetString(PyExc_TypeError, "cannot delete attribute");
+		return -1;
+	}
+
+	new_val = PyLong_AsUnsignedLongLong(val);
+	if (PyErr_Occurred())
+		return -1;
+
+	pevsel->evsel->core.attr.config = new_val;
+	return 0;
 }
 
 static PyObject *pyrf_evsel__get_attr_config(PyObject *self, void *closure __maybe_unused)
@@ -1325,11 +1340,21 @@ static PyObject *pyrf_evsel__get_attr_config(PyObject *self, void *closure __may
 static int pyrf_evsel__set_attr_read_format(PyObject *self, PyObject *val, void *closure __maybe_unused)
 {
 	struct pyrf_evsel *pevsel = (void *)self;
+	unsigned long long new_val;
 
 	CHECK_INITIALIZED_INT(pevsel->evsel, "evsel");
 
-	pevsel->evsel->core.attr.read_format = PyLong_AsUnsignedLongLong(val);
-	return PyErr_Occurred() ? -1 : 0;
+	if (val == NULL) {
+		PyErr_SetString(PyExc_TypeError, "cannot delete attribute");
+		return -1;
+	}
+
+	new_val = PyLong_AsUnsignedLongLong(val);
+	if (PyErr_Occurred())
+		return -1;
+
+	pevsel->evsel->core.attr.read_format = new_val;
+	return 0;
 }
 
 static PyObject *pyrf_evsel__get_attr_read_format(PyObject *self, void *closure __maybe_unused)
@@ -1344,11 +1369,21 @@ static PyObject *pyrf_evsel__get_attr_read_format(PyObject *self, void *closure
 static int pyrf_evsel__set_attr_sample_period(PyObject *self, PyObject *val, void *closure __maybe_unused)
 {
 	struct pyrf_evsel *pevsel = (void *)self;
+	unsigned long long new_val;
 
 	CHECK_INITIALIZED_INT(pevsel->evsel, "evsel");
 
-	pevsel->evsel->core.attr.sample_period = PyLong_AsUnsignedLongLong(val);
-	return PyErr_Occurred() ? -1 : 0;
+	if (val == NULL) {
+		PyErr_SetString(PyExc_TypeError, "cannot delete attribute");
+		return -1;
+	}
+
+	new_val = PyLong_AsUnsignedLongLong(val);
+	if (PyErr_Occurred())
+		return -1;
+
+	pevsel->evsel->core.attr.sample_period = new_val;
+	return 0;
 }
 
 static PyObject *pyrf_evsel__get_attr_sample_period(PyObject *self, void *closure __maybe_unused)
@@ -1363,11 +1398,21 @@ static PyObject *pyrf_evsel__get_attr_sample_period(PyObject *self, void *closur
 static int pyrf_evsel__set_attr_sample_type(PyObject *self, PyObject *val, void *closure __maybe_unused)
 {
 	struct pyrf_evsel *pevsel = (void *)self;
+	unsigned long long new_val;
 
 	CHECK_INITIALIZED_INT(pevsel->evsel, "evsel");
 
-	pevsel->evsel->core.attr.sample_type = PyLong_AsUnsignedLongLong(val);
-	return PyErr_Occurred() ? -1 : 0;
+	if (val == NULL) {
+		PyErr_SetString(PyExc_TypeError, "cannot delete attribute");
+		return -1;
+	}
+
+	new_val = PyLong_AsUnsignedLongLong(val);
+	if (PyErr_Occurred())
+		return -1;
+
+	pevsel->evsel->core.attr.sample_type = new_val;
+	return 0;
 }
 
 static PyObject *pyrf_evsel__get_attr_sample_type(PyObject *self, void *closure __maybe_unused)
@@ -1391,11 +1436,21 @@ static PyObject *pyrf_evsel__get_attr_size(PyObject *self, void *closure __maybe
 static int pyrf_evsel__set_attr_type(PyObject *self, PyObject *val, void *closure __maybe_unused)
 {
 	struct pyrf_evsel *pevsel = (void *)self;
+	unsigned long new_val;
 
 	CHECK_INITIALIZED_INT(pevsel->evsel, "evsel");
 
-	pevsel->evsel->core.attr.type = PyLong_AsUnsignedLong(val);
-	return PyErr_Occurred() ? -1 : 0;
+	if (val == NULL) {
+		PyErr_SetString(PyExc_TypeError, "cannot delete attribute");
+		return -1;
+	}
+
+	new_val = PyLong_AsUnsignedLong(val);
+	if (PyErr_Occurred())
+		return -1;
+
+	pevsel->evsel->core.attr.type = new_val;
+	return 0;
 }
 
 static PyObject *pyrf_evsel__get_attr_type(PyObject *self, void *closure __maybe_unused)
@@ -1410,11 +1465,21 @@ static PyObject *pyrf_evsel__get_attr_type(PyObject *self, void *closure __maybe
 static int pyrf_evsel__set_attr_wakeup_events(PyObject *self, PyObject *val, void *closure __maybe_unused)
 {
 	struct pyrf_evsel *pevsel = (void *)self;
+	unsigned long new_val;
 
 	CHECK_INITIALIZED_INT(pevsel->evsel, "evsel");
 
-	pevsel->evsel->core.attr.wakeup_events = PyLong_AsUnsignedLong(val);
-	return PyErr_Occurred() ? -1 : 0;
+	if (val == NULL) {
+		PyErr_SetString(PyExc_TypeError, "cannot delete attribute");
+		return -1;
+	}
+
+	new_val = PyLong_AsUnsignedLong(val);
+	if (PyErr_Occurred())
+		return -1;
+
+	pevsel->evsel->core.attr.wakeup_events = new_val;
+	return 0;
 }
 
 static PyObject *pyrf_evsel__get_attr_wakeup_events(PyObject *self, void *closure __maybe_unused)
-- 
2.53.0



