Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF202DF40
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B5EC433D2;
	Mon, 15 May 2023 16:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168750;
	bh=oEMH0GuCs9QAYViycUDZjVaQXdbcl4Ln81QzGh77Wi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qazKRCEpUPLQmBUwVUcvyM5DTLIoaHDnnzX9ezdq7ImsDoZ6WFgjgmGmMS9+CLJ9b
	 WivVkCAcvfnm6aNL/XUIc5FSIxLm7uLOJXCmJAlC3O2fpi9W7C2ZUeQGcddx4HQJzF
	 tiPN1RSPz8LqCsIkHnymG/Mv3qhK+wbf7f5g4fls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.19 009/191] perf sched: Cast PTHREAD_STACK_MIN to int as it may turn into sysconf(__SC_THREAD_STACK_MIN_VALUE)
Date: Mon, 15 May 2023 18:24:06 +0200
Message-Id: <20230515161707.540646506@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
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
@@ -659,7 +659,7 @@ static void create_tasks(struct perf_sch
 	err = pthread_attr_init(&attr);
 	BUG_ON(err);
 	err = pthread_attr_setstacksize(&attr,
-			(size_t) max(16 * 1024, PTHREAD_STACK_MIN));
+			(size_t) max(16 * 1024, (int)PTHREAD_STACK_MIN));
 	BUG_ON(err);
 	err = pthread_mutex_lock(&sched->start_work_mutex);
 	BUG_ON(err);


