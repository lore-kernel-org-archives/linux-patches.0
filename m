Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27591FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:18:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F076FC433D2;
	Fri,  3 Feb 2023 10:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419533;
	bh=2jQp1AqTaQVNTK5KV7qHirX/+99pKghYPpxMeYr39pE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=187EMVgzYh8PK3XVjfk4u0IaSo/4Iv2/v4rRqwD6yWt65Syu7+NCFa4BZ/+Iuqf7t
	 cqlYMZVIa3F5mDr0sS4zNjkQWwfOXmTGauLlOgq0/JW/6iotLKVNYEjcLX5/ysl9DP
	 W6JkxShvefK8mqhLfNcpPnQOukYEoTQyVztX5jzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.19 34/80] perf env: Do not return pointers to local variables
Date: Fri,  3 Feb 2023 11:12:28 +0100
Message-Id: <20230203101016.634095461@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit ebcb9464a2ae3a547e97de476575c82ece0e93e2 upstream.

It is possible to return a pointer to a local variable when looking up
the architecture name for the running system and no normalization is
done on that value, i.e. we may end up returning the uts.machine local
variable.

While this doesn't happen on most arches, as normalization takes place,
lets fix this by making that a static variable and optimize it a bit by
not always running uname(), only the first time.

Noticed in fedora rawhide running with:

  [perfbuilder@a5ff49d6e6e4 ~]$ gcc --version
  gcc (GCC) 10.0.1 20200216 (Red Hat 10.0.1-0.8)

Reported-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/env.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/perf/util/env.c
+++ b/tools/perf/util/env.c
@@ -163,11 +163,11 @@ static const char *normalize_arch(char *
 
 const char *perf_env__arch(struct perf_env *env)
 {
-	struct utsname uts;
 	char *arch_name;
 
 	if (!env || !env->arch) { /* Assume local operation */
-		if (uname(&uts) < 0)
+		static struct utsname uts = { .machine[0] = '\0', };
+		if (uts.machine[0] == '\0' && uname(&uts) < 0)
 			return NULL;
 		arch_name = uts.machine;
 	} else


