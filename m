Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F085F3B7B98;
	Sat, 12 Sep 2026 20:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243558; cv=none; b=gcRQZHBRcivqr2Ov5oiBAFjD+sXoXSZP7BHiw5PI+fGSlPBm+/ScgwPr0W321Bp2TEF6g1xwyGPWMGf65eIovWiLcuOpZ7t/9KrSQzXlEahhG490mVgv4802HCkzgD41rRSWrhzv3xLWVRt2XYzEca7oHRNznP8UON1Aawf1ttw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243558; c=relaxed/simple;
	bh=6df8S8873ui2OlDKQXuxnnMlsY5C0spRrym3facaNQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2dmdj9mqMhiSCzvTmnpyGS4X+G2Lr6fS6jX4uKn85bNUcuLF3QxkVg1DiiKG63wMJFm1ifxsgkk1v9xvsmFuJPUrps3bgvJ0qZLfQ1pfCTjmKCngbOowuFUgWQVWF3MXhG1f+NUSghzy0oVgaAcxK6b9J4yPPV/7DCK8or1BAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlaslRhB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlaslRhB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931301F00893;
	Sat, 12 Sep 2026 20:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243555;
	bh=cR496ZSpNMJVRd5ZNt7dGLw2f93O+cNloNw3HcLfNQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vlaslRhBCYMP1wolH3c300DBJGj6i9RduKjQnfrKHvzNZN+RYdU2C3CEP5jEixhKI
	 g++wAO6WCoew+N2PefZFi8lhsu7sSvjRFMtE/HPPFLzqF5XPi1o7p4zmRiTOFukqhs
	 Fx7ICTh8IjRAAb6EyBnz8BFGfBMzQtGyTCo7NJXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever III <chuck.lever@oracle.com>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 797/798] tracing: Handle %.*s in trace_check_vprintf()
Date: Sat, 12 Sep 2026 09:07:05 +0200
Message-ID: <20260912065535.328163177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

[ Upstream commit eb01f5353bdaa59600b29d864819056a0e3de24d ]

If a trace event uses the %*.s notation, the trace_check_vprintf() will
fail and will warn about a bad processing of strings, because it does not
take into account the length field when processing the star (*) part.
Have it handle this case as well.

Link: https://lore.kernel.org/linux-nfs/238C0E2D-C2A4-4578-ADD2-C565B3B99842@oracle.com/

Reported-by: Chuck Lever III <chuck.lever@oracle.com>
Fixes: 9a6944fee68e2 ("tracing: Add a verifier to check string pointers for trace events")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index bfa6e2fe984b1..6c8f9a401fe0b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3708,6 +3708,9 @@ void trace_check_vprintf(struct trace_iterator *iter, const char *fmt,
 		goto print;
 
 	while (*p) {
+		bool star = false;
+		int len = 0;
+
 		j = 0;
 
 		/* We only care about %s and variants */
@@ -3729,13 +3732,17 @@ void trace_check_vprintf(struct trace_iterator *iter, const char *fmt,
 				/* Need to test cases like %08.*s */
 				for (j = 1; p[i+j]; j++) {
 					if (isdigit(p[i+j]) ||
-					    p[i+j] == '*' ||
 					    p[i+j] == '.')
 						continue;
+					if (p[i+j] == '*') {
+						star = true;
+						continue;
+					}
 					break;
 				}
 				if (p[i+j] == 's')
 					break;
+				star = false;
 			}
 			j = 0;
 		}
@@ -3748,6 +3755,9 @@ void trace_check_vprintf(struct trace_iterator *iter, const char *fmt,
 		iter->fmt[i] = '\0';
 		trace_seq_vprintf(&iter->seq, iter->fmt, ap);
 
+		if (star)
+			len = va_arg(ap, int);
+
 		/* The ap now points to the string data of the %s */
 		str = va_arg(ap, const char *);
 
@@ -3766,8 +3776,18 @@ void trace_check_vprintf(struct trace_iterator *iter, const char *fmt,
 			int ret;
 
 			/* Try to safely read the string */
-			ret = strncpy_from_kernel_nofault(iter->fmt, str,
-							  iter->fmt_size);
+			if (star) {
+				if (len + 1 > iter->fmt_size)
+					len = iter->fmt_size - 1;
+				if (len < 0)
+					len = 0;
+				ret = copy_from_kernel_nofault(iter->fmt, str, len);
+				iter->fmt[len] = 0;
+				star = false;
+			} else {
+				ret = strncpy_from_kernel_nofault(iter->fmt, str,
+								  iter->fmt_size);
+			}
 			if (ret < 0)
 				trace_seq_printf(&iter->seq, "(0x%px)", str);
 			else
@@ -3779,7 +3799,10 @@ void trace_check_vprintf(struct trace_iterator *iter, const char *fmt,
 			strncpy(iter->fmt, p + i, j + 1);
 			iter->fmt[j+1] = '\0';
 		}
-		trace_seq_printf(&iter->seq, iter->fmt, str);
+		if (star)
+			trace_seq_printf(&iter->seq, iter->fmt, len, str);
+		else
+			trace_seq_printf(&iter->seq, iter->fmt, str);
 
 		p += i + j + 1;
 	}
-- 
2.53.0



