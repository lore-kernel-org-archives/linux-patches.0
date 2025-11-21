Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0814C2F6577;
	Fri, 21 Nov 2025 13:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731356; cv=none; b=omzUgoeMcduuHVD/Chmop3EygkbVM+vjPJPeu6n3wPqIQJp3yHjpB5NcuVJKj5doght6SyR1XKY88J96TyGBIOGWEBGm9Ou7vyQmbNUG9sJSuIiQHzpKeeXT+WFqKxbUPQb/AUVGyM4z7CAVKjqazTwCunUFQ0vl9inK03kAxas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731356; c=relaxed/simple;
	bh=K/RZwDBYl8eLEPVuGCKGFOaI2HqZsKxklQtiau6kxXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAt84Mrd6zaBIhgvIOeBmy2fRbt+SbqJLhHTQvRzbiEUCFBI9TBLjX3XdE8cJNRq9uVD9XPbMgvlfP1dH0o4K6m7FhgQPTMksS28C3a+Zv+SeOVhNMhpd0flmhW30/KF/o6fg7YkOv9z1N2Pp0J9277Abj+SPdthoHaOBK3rO/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I6LYvUiO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6LYvUiO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824F0C4CEF1;
	Fri, 21 Nov 2025 13:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731355;
	bh=K/RZwDBYl8eLEPVuGCKGFOaI2HqZsKxklQtiau6kxXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I6LYvUiO1uFZfKN5+wyFdsHiU2CjkgLlPs8DLrb1kPaSTS+t7ke00spokiyKNDomk
	 LYWPwWBpLFTmFGwb1G7Ni707BNR5p+xzjURPxlWvoWBOzVXl3bWBuwcUNn2YBSeLgL
	 cSlilbsxxhCLsdN7lA5po+3sFEvuCo4jY9HdNgaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.17 179/247] selftests/tracing: Run sample events to clear page cache events
Date: Fri, 21 Nov 2025 14:12:06 +0100
Message-ID: <20251121130201.146790716@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit dd4adb986a86727ed8f56c48b6d0695f1e211e65 upstream.

The tracing selftest "event-filter-function.tc" was failing because it
first runs the "sample_events" function that triggers the kmem_cache_free
event and it looks at what function was used during a call to "ls".

But the first time it calls this, it could trigger events that are used to
pull pages into the page cache.

The rest of the test uses the function it finds during that call to see if
it will be called in subsequent "sample_events" calls. But if there's no
need to pull pages into the page cache, it will not trigger that function
and the test will fail.

Call the "sample_events" twice to trigger all the page cache work before
it calls it to find a function to use in subsequent checks.

Cc: stable@vger.kernel.org
Fixes: eb50d0f250e96 ("selftests/ftrace: Choose target function for filter test from samples")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/ftrace/test.d/filter/event-filter-function.tc |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/testing/selftests/ftrace/test.d/filter/event-filter-function.tc
+++ b/tools/testing/selftests/ftrace/test.d/filter/event-filter-function.tc
@@ -20,6 +20,10 @@ sample_events() {
 echo 0 > tracing_on
 echo 0 > events/enable
 
+# Clear functions caused by page cache; run sample_events twice
+sample_events
+sample_events
+
 echo "Get the most frequently calling function"
 echo > trace
 sample_events


