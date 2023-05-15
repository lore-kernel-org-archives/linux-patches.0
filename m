Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26C8FC00
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC3AC433EF;
	Mon, 15 May 2023 17:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172036;
	bh=0sHig8OLTxrRpDAVtoiHxEPFeUB3uN8t5cIY8ebs8yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tH3TijglBt1ijRaIJ87SKrm8zTZyytcGV8lUBLu71SJJAN2Qy4Iu8YNt2s5PTIXhE
	 v+HMtOvpcewQv2N1Bz1Xgsrey37OmVibxSOsyRyMm2zZPb+GdI9JH8DVuzBx49uoav
	 RTSar3ZjrbIP8mJg77i9j/e7q6NLrfo+W0uB4AaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 023/381] perf sched: Cast PTHREAD_STACK_MIN to int as it may turn into sysconf(__SC_THREAD_STACK_MIN_VALUE)
Date: Mon, 15 May 2023 18:24:34 +0200
Message-Id: <20230515161737.825232395@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
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

commit d08c84e01afa7a7eee6badab25d5420fa847f783 upstream.

In fedora rawhide the PTHREAD_STACK_MIN define may end up expanded to a
sysconf() call, and that will return 'long int', breaking the build:

    45 fedora:rawhide                : FAIL gcc version 11.1.1 20210623 (Red Hat 11.1.1-6) (GCC)
      builtin-sched.c: In function 'create_tasks':
      /git/perf-5.14.0-rc1/tools/include/linux/kernel.h:43:24: error: comparison of distinct pointer types lacks a cast [-Werror]
         43 |         (void) (&_max1 == &_max2);              \
            |                        ^~
      builtin-sched.c:673:34: note: in expansion of macro 'max'
        673 |                         (size_t) max(16 * 1024, PTHREAD_STACK_MIN));
            |                                  ^~~
      cc1: all warnings being treated as errors

  $ grep __sysconf /usr/include/*/*.h
  /usr/include/bits/pthread_stack_min-dynamic.h:extern long int __sysconf (int __name) __THROW;
  /usr/include/bits/pthread_stack_min-dynamic.h:#   define PTHREAD_STACK_MIN __sysconf (__SC_THREAD_STACK_MIN_VALUE)
  /usr/include/bits/time.h:extern long int __sysconf (int);
  /usr/include/bits/time.h:# define CLK_TCK ((__clock_t) __sysconf (2))	/* 2 is _SC_CLK_TCK */
  $

So cast it to int to cope with that.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/builtin-sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -670,7 +670,7 @@ static void create_tasks(struct perf_sch
 	err = pthread_attr_init(&attr);
 	BUG_ON(err);
 	err = pthread_attr_setstacksize(&attr,
-			(size_t) max(16 * 1024, PTHREAD_STACK_MIN));
+			(size_t) max(16 * 1024, (int)PTHREAD_STACK_MIN));
 	BUG_ON(err);
 	err = pthread_mutex_lock(&sched->start_work_mutex);
 	BUG_ON(err);


