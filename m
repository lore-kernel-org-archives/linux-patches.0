Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503251FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915CBC433D2;
	Fri,  3 Feb 2023 10:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419660;
	bh=/VgTckNen0NoZp3QkraZBalffdZWyEDO/GFqKXBbjzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2UsKDAgOdKmrnYVaGx8QTiPvphAiZXc1PLFJQ0QK/Sxkmss0OskLZeImq736FypTa
	 TPmANKdaASkXR82JTNH2O0HUpafrxAyQcZ/vPV8uwIYXkJ45p6PALlGSkJf4GJqAfE
	 xEvEWv9CbMaMgABw9z27QJUGdq//TUAg15eMCSLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@google.com>,
	Huang Ying <ying.huang@intel.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Arnd Bergmann <arnd@arndb.de>,
	linux-doc@vger.kernel.org,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 4.19 73/80] exit: Allow oops_limit to be disabled
Date: Fri,  3 Feb 2023 11:13:07 +0100
Message-Id: <20230203101018.358100986@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

commit de92f65719cd672f4b48397540b9f9eff67eca40 upstream.

In preparation for keeping oops_limit logic in sync with warn_limit,
have oops_limit == 0 disable checking the Oops counter.

Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-doc@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/sysctl/kernel.txt |    5 +++--
 kernel/exit.c                   |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -559,8 +559,9 @@ scanned for a given scan.
 oops_limit:
 
 Number of kernel oopses after which the kernel should panic when
-``panic_on_oops`` is not set. Setting this to 0 or 1 has the same effect
-as setting ``panic_on_oops=1``.
+``panic_on_oops`` is not set. Setting this to 0 disables checking
+the count. Setting this to  1 has the same effect as setting
+``panic_on_oops=1``. The default value is 10000.
 
 ==============================================================
 
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -986,7 +986,7 @@ void __noreturn make_task_dead(int signr
 	 * To make sure this can't happen, place an upper bound on how often the
 	 * kernel may oops without panic().
 	 */
-	if (atomic_inc_return(&oops_count) >= READ_ONCE(oops_limit))
+	if (atomic_inc_return(&oops_count) >= READ_ONCE(oops_limit) && oops_limit)
 		panic("Oopsed too often (kernel.oops_limit is %d)", oops_limit);
 
 	do_exit(signr);


