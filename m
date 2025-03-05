Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C49D2571A8;
	Wed,  5 Mar 2025 18:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198596; cv=none; b=Z6/LSJTnpVwfwuHlSk6nU6h+AeweFTZGp4e3ZWhlIJXzteuUhz67rsxt3OWuPlmpiIsdDxvC13Fr28RlubWpS9kyvJw8aYkqZxK/2apV3zB6mKz2LOPzupLpOUVaNNPHxO66tpdIQ+qai1g7rloVwrG06ukxkDFftdgApGWLbqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198596; c=relaxed/simple;
	bh=hAjq3KaoG77IJ+DH3whJOuckz0uXV5r95wAr/pC7JII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkfDkKPt8MlVh9H1HQOwLJBwc+zb5G7m9KGX+iKMiV5dI08vH1bAlTj9Osdtffj6Hj2s0KlR9FJDXkj+kjDTasZounb7N5ZZ9vjpezGvcTb/sloZ69XnF25Em/mIGwAR3UTD5x4iwM+nLRxUB5oB4VCphFgu6E5SsJ9wKAo3qEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dQmnkAzm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dQmnkAzm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8029C4CEE0;
	Wed,  5 Mar 2025 18:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198596;
	bh=hAjq3KaoG77IJ+DH3whJOuckz0uXV5r95wAr/pC7JII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQmnkAzmSfWtwIzAB/Kvz3HHH9l0EM/3qxCU3z7cYTl0wxusX4gjJWxuoCB95Hbbt
	 PmFRcRblaAepW+2GljlWlMc7HMJdPsrvsgZo7bpteoyeHXJcbO8NsuxNPgBqnCnv7q
	 GNQFbR4sdGnT7gIumLPxQZmeN2iH3x8aX95Go18o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wen Yang <wenyang@linux.alibaba.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Nikolay Kuratov <kniv@yandex-team.ru>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.13 082/157] ftrace: Avoid potential division by zero in function_stat_show()
Date: Wed,  5 Mar 2025 18:48:38 +0100
Message-ID: <20250305174508.604815876@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Kuratov <kniv@yandex-team.ru>

commit a1a7eb89ca0b89dc1c326eeee2596f263291aca3 upstream.

Check whether denominator expression x * (x - 1) * 1000 mod {2^32, 2^64}
produce zero and skip stddev computation in that case.

For now don't care about rec->counter * rec->counter overflow because
rec->time * rec->time overflow will likely happen earlier.

Cc: stable@vger.kernel.org
Cc: Wen Yang <wenyang@linux.alibaba.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20250206090156.1561783-1-kniv@yandex-team.ru
Fixes: e31f7939c1c27 ("ftrace: Avoid potential division by zero in function profiler")
Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -541,6 +541,7 @@ static int function_stat_show(struct seq
 	static struct trace_seq s;
 	unsigned long long avg;
 	unsigned long long stddev;
+	unsigned long long stddev_denom;
 #endif
 	mutex_lock(&ftrace_profile_lock);
 
@@ -562,23 +563,19 @@ static int function_stat_show(struct seq
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	seq_puts(m, "    ");
 
-	/* Sample standard deviation (s^2) */
-	if (rec->counter <= 1)
-		stddev = 0;
-	else {
-		/*
-		 * Apply Welford's method:
-		 * s^2 = 1 / (n * (n-1)) * (n * \Sum (x_i)^2 - (\Sum x_i)^2)
-		 */
+	/*
+	 * Variance formula:
+	 * s^2 = 1 / (n * (n-1)) * (n * \Sum (x_i)^2 - (\Sum x_i)^2)
+	 * Maybe Welford's method is better here?
+	 * Divide only by 1000 for ns^2 -> us^2 conversion.
+	 * trace_print_graph_duration will divide by 1000 again.
+	 */
+	stddev = 0;
+	stddev_denom = rec->counter * (rec->counter - 1) * 1000;
+	if (stddev_denom) {
 		stddev = rec->counter * rec->time_squared -
 			 rec->time * rec->time;
-
-		/*
-		 * Divide only 1000 for ns^2 -> us^2 conversion.
-		 * trace_print_graph_duration will divide 1000 again.
-		 */
-		stddev = div64_ul(stddev,
-				  rec->counter * (rec->counter - 1) * 1000);
+		stddev = div64_ul(stddev, stddev_denom);
 	}
 
 	trace_seq_init(&s);


