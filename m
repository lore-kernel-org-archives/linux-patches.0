Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664CF146A79;
	Mon, 16 Sep 2024 12:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488701; cv=none; b=dW6pUJJRrC4DIATHPUYahVeyXYN5QrttjDGotf2rciMASVQcCAdXf9O+w3xokeqqW/XYifhzkOYa+JqAcefcebHKo5VfMyP9mN3qoeKJo7Kz04jnQ/QCoLU/5R5Z6ADuW67XMfsbaqBpAAtnoKN/OnLE4kXyadlGlxyVXLSFTcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488701; c=relaxed/simple;
	bh=MRPZvCFTQYxZBQQHQjPCATzYs19vvjWS47MhC+AF5Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4DTMJLD0sAqgqfrM9rgkMAKibGVDXGTSMuEDxmTlqYREM2B85hB/XOjDF2Lr4U+jPegsNygeqlPqfLEYlhPLOHwi8bvhOzNFN6J2EBr8ZrQrCPiis9bYxjH4nyEgWzip8PUZ2ki/QVSI80O5FD8r93RsuQ///IXrUGQeCPWD5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mSkGBfuh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSkGBfuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CA2C4CEC4;
	Mon, 16 Sep 2024 12:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488701;
	bh=MRPZvCFTQYxZBQQHQjPCATzYs19vvjWS47MhC+AF5Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mSkGBfuhYYaqrEBqm53QarSRWku6Tk0zvCVsrnFOqXDGRvAK1rlUc6GArU8Ff9tXe
	 uhPd3JtHbpipLGT7HqPbz/25fP4xSMtD3m9v0IblUQCrbRykeogRKvgFEJr3T5vFn0
	 TzgdOckHKIJeqZDYpkyI2m+T57ecp/aZVao+Sfmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Helena Anna" <helena.anna.dubel@intel.com>,
	"Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	"Bityutskiy, Artem" <artem.bityutskiy@intel.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 76/91] tracing/osnoise: Fix build when timerlat is not enabled
Date: Mon, 16 Sep 2024 13:44:52 +0200
Message-ID: <20240916114226.980226511@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Steven Rostedt <rostedt@goodmis.org>

commit af178143343028fdec9d5960a22d17f5587fd3f5 upstream.

To fix some critical section races, the interface_lock was added to a few
locations. One of those locations was above where the interface_lock was
declared, so the declaration was moved up before that usage.
Unfortunately, where it was placed was inside a CONFIG_TIMERLAT_TRACER
ifdef block. As the interface_lock is used outside that config, this broke
the build when CONFIG_OSNOISE_TRACER was enabled but
CONFIG_TIMERLAT_TRACER was not.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Helena Anna" <helena.anna.dubel@intel.com>
Cc: "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Cc: Tomas Glozar <tglozar@redhat.com>
Link: https://lore.kernel.org/20240909103231.23a289e2@gandalf.local.home
Fixes: e6a53481da29 ("tracing/timerlat: Only clear timer if a kthread exists")
Reported-by: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_osnoise.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index bbe47781617e..7e75c1214b36 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -228,6 +228,11 @@ static inline struct osnoise_variables *this_cpu_osn_var(void)
 	return this_cpu_ptr(&per_cpu_osnoise_var);
 }
 
+/*
+ * Protect the interface.
+ */
+static struct mutex interface_lock;
+
 #ifdef CONFIG_TIMERLAT_TRACER
 /*
  * Runtime information for the timer mode.
@@ -252,11 +257,6 @@ static inline struct timerlat_variables *this_cpu_tmr_var(void)
 	return this_cpu_ptr(&per_cpu_timerlat_var);
 }
 
-/*
- * Protect the interface.
- */
-static struct mutex interface_lock;
-
 /*
  * tlat_var_reset - Reset the values of the given timerlat_variables
  */
-- 
2.46.0



