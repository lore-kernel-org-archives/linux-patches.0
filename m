Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE7647B425;
	Sat, 12 Sep 2026 12:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217962; cv=none; b=jA92Ob1gQoHNVr8p/kF1/EVSUPjim8Plr82xbhrfMGBp3JdwwfvlDZucKLiGaGJdQcQPUzUr0hkPUAIfw5kEjzzLmWyS5QMnbl3ddFckjXBJUuUSvJOMJasVM9fh/hkJGOhwOOBLTHcgiuY3opGYsdL9kJ8Tm4T/KhAXdplM7Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217962; c=relaxed/simple;
	bh=/SdhOpsY9rR9Md/6uWRRgdS0pRS8FfFrWRTGw5Is+A4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPvHDr3dSaNurGKV0/0i+pUZmweTs3ifHRy/R9byEFEO8exO2Q4rUTnXBV7be4JuKNKgBg/t9AIootyaJABYn3SIyytXaB7WUR7ldZZ++SACffxUARZ0N4cI1qC95ScYooXfHYm3ONAzPIeSWBy1mTdsqfeQKz82MX/86xXPWcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wEpl80Qa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wEpl80Qa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B17F1F000FF;
	Sat, 12 Sep 2026 12:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217961;
	bh=opSAxoa0wren9JDxO6HxnqWR1xyzD3Rubk30oTuiYvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wEpl80Qars2mUOiwrpToWTaefJUMfNUM8GaOoKOcoGnfKlW59+79LjZfOCdzm+8pI
	 C4ss2ha4cxsJRvS8SBDe6Ujr4GhWrQsvF6vokqb3P+3bLnk36Dk/PVFzNyv54BoJOs
	 YkP2B8dLFQh/UIeKKSsqJvGRn8Lb2kWIZ/DdZUEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1020/1376] perf python: Check counts_values size in set_values
Date: Sat, 12 Sep 2026 08:57:26 +0200
Message-ID: <20260912065630.296426238@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 612aca22a978d43f6e6765272676a17afdba8572 ]

The set_values function incorrectly assumed the list contained exactly
5 elements. Add a check to prevent out-of-bounds access.

Fixes: 877108e42b1b ("perf tools: Initial python binding")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/python.c | 38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 17e393bcc7b94..6614c2303bb97 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -655,11 +655,11 @@ static void pyrf_counts_values__delete(struct pyrf_counts_values *pcounts_values
 	  0, help }
 
 static PyMemberDef pyrf_counts_values_members[] = {
-	counts_values_member_def(val, T_ULONG, "Value of event"),
-	counts_values_member_def(ena, T_ULONG, "Time for which enabled"),
-	counts_values_member_def(run, T_ULONG, "Time for which running"),
-	counts_values_member_def(id, T_ULONG, "Unique ID for an event"),
-	counts_values_member_def(lost, T_ULONG, "Num of lost samples"),
+	counts_values_member_def(val, T_ULONGLONG, "Value of event"),
+	counts_values_member_def(ena, T_ULONGLONG, "Time for which enabled"),
+	counts_values_member_def(run, T_ULONGLONG, "Time for which running"),
+	counts_values_member_def(id, T_ULONGLONG, "Unique ID for an event"),
+	counts_values_member_def(lost, T_ULONGLONG, "Num of lost samples"),
 	{ .name = NULL, },
 };
 
@@ -669,8 +669,15 @@ static PyObject *pyrf_counts_values_get_values(struct pyrf_counts_values *self,
 
 	if (!vals)
 		return NULL;
-	for (int i = 0; i < 5; i++)
-		PyList_SetItem(vals, i, PyLong_FromLong(self->values.values[i]));
+	for (int i = 0; i < 5; i++) {
+		PyObject *val = PyLong_FromUnsignedLongLong(self->values.values[i]);
+
+		if (!val) {
+			Py_DECREF(vals);
+			return NULL;
+		}
+		PyList_SetItem(vals, i, val);
+	}
 
 	return vals;
 }
@@ -681,19 +688,34 @@ static int pyrf_counts_values_set_values(struct pyrf_counts_values *self, PyObje
 	Py_ssize_t size;
 	PyObject *item = NULL;
 
+	if (list == NULL) {
+		PyErr_SetString(PyExc_TypeError, "cannot delete attribute");
+		return -1;
+	}
+
 	if (!PyList_Check(list)) {
 		PyErr_SetString(PyExc_TypeError, "Value assigned must be a list");
 		return -1;
 	}
 
 	size = PyList_Size(list);
+	if (size != 5) {
+		PyErr_SetString(PyExc_ValueError, "List must have exactly 5 entries");
+		return -1;
+	}
+
 	for (Py_ssize_t i = 0; i < size; i++) {
+		unsigned long long val;
+
 		item = PyList_GetItem(list, i);
 		if (!PyLong_Check(item)) {
 			PyErr_SetString(PyExc_TypeError, "List members should be numbers");
 			return -1;
 		}
-		self->values.values[i] = PyLong_AsLong(item);
+		val = PyLong_AsUnsignedLongLong(item);
+		if (val == (unsigned long long)-1 && PyErr_Occurred())
+			return -1;
+		self->values.values[i] = val;
 	}
 
 	return 0;
-- 
2.53.0



