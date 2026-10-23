Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773989;
	b=ejXjUcrYf1acidPRhlzCrVRvsn6eZp44z52a5kWYpdI7EMPsi1PMWHJXz6OKErXirBIU
	 J0/Egqc1z1PoHx2VU3mVCJxqoqXaIlOaGUlshBPaGyRmx1NFdCNRfCR6jeNkQ3/voyWcU
	 h7WYyMebdMAJ0gJhSq2H04jL6yD0rGXMW5uNm+kFhZxQGoA8fzjJUimzelOF6aI1GWSR5
	 sPM1dLC0y89tekKbaCP84Gb/0DAkTQb1LnuacY1Ksq7kurxcenSEdczvP8JOWEJG8Xpcx
	 yjtYXTSokF69RtMYrgtycn8ZcHJRXA7UKDlzPcu1kMr6glz+pkCZ/ibvpUXcdlE05ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P9zZrkVmOo6noZn6WOHm5fM0oE8YWvOEhRViA/SVj9M=;
	b=Kb8rwpERtB/wdUY/IRMNmCe/7T973mti9jqlCO7AabqOzt681pftIpFvtXeLeShzwMjF
	 9jiH54i/+LSyoBfkN44mmd8nPR5HN40O25vWBzVBlgWT0kEwfZg+QbedrwwYMF6/iFQ3v
	 Ms+RBZ0S+6QAZkTDw2k4NuTZJmWyhwcXWmyMGxnUYfaNVAbw11vcbNcegGjms99gWw8qb
	 PKHmdzRhsr3kJ/6C1SFQZTWEzPk7HHTLexJyR5eWFyUbxd1fALhCcFqa1hPjb/jSA0yyK
	 M21r1d36OK/GxXBV5+d2TMfjr8hA6+dL94s0C5qDP6VwbAyOst0RzROLum1fFvy4y3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ToDxONnU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7DF606A31A;
	Fri, 23 Oct 2026 16:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ToDxONnU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85E11F01825;
	Fri, 23 Oct 2026 16:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773988;
	bh=P9zZrkVmOo6noZn6WOHm5fM0oE8YWvOEhRViA/SVj9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ToDxONnUIbGYCfILrSU8TE5XD4G+luyEuE4dPJpQ7an9/mYm99ru0PUfASTmw0Vpu
	 t3p3tFhM9+RL+e/ZvKzoDYHOJBnHV4CB9Y4VeDIFjk/Gov7PTRr63vuEk9eOFTWQx5
	 rsL3B942gFRijdSwnMIuYJuQqZIfNR3fTcHGu7t0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 082/193] namei: test for a negative dentry the way traverse_mounts() does
Date: Fri, 23 Oct 2026 18:35:59 +0200
Message-ID: <20261023163716.146929655@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 98b6cf102b35b2bb48d1fd74d5f664eb66fe83eb upstream.

lookup_fast_for_open() only hands an O_CREAT open a cached dentry if
it's positive. Otherwise the open goes on to lookup_open(), which takes
the directory lock and creates the file. It tests for that with
!dentry->d_inode, but traverse_mounts() later decides with the type in
d_flags. And when a dentry is instantiated __d_set_inode_and_type()
stores ->d_inode first and only then releases the type into ->d_flags.

So a refwalk that took its reference to a negative dentry right before
another task instantiates it can find ->d_inode already set in
lookup_fast_for_open(), go on to step_into(), and still find the
negative type in traverse_mounts(). The open then fails with -ENOENT,
which an O_CREAT open must never do. rcuwalk doesn't get that far, the
d_seq check in step_into() catches the instantiation.

Use d_is_negative() so both look at the type. While the type is still
negative the open takes lookup_open() and waits for the directory lock
like any other O_CREAT open of a negative dentry.

On its own the window is a couple of instructions in the creating task,
so it takes an interrupt or a preempted vcpu in exactly the right spot.
I haven't caught it without help in about 600 million racing O_CREAT
opens.

The debug patch below stalls the creating task between the two stores
for names starting with "ocrace", the way an interrupt landing there
would. The reproducer below opens "ocrace" with O_CREAT through
symlinks on a strictatime tmpfs: following them updates their atime,
which drops the walk out of rcuwalk, so the name is always looked up in
refwalk. With

  echo 20 > /proc/sys/fs/ocrace_instantiate_us
  ./ocreat_enoent -t 60

on a KASAN kernel open() failed with -ENOENT 43 times in 4.9 million
calls. With this patch it never failed in 4.8 million calls. Tracing
step_into_slowpath() during such a run, each of the 98 -ENOENTs it
returned came right after the same task had entered it with a dentry
that was still typed negative.

  // SPDX-License-Identifier: GPL-2.0
  /*
   * ocreat_enoent: open(O_CREAT) racing the creation of the same name.
   *
   * Writers unlink "ocrace" and create it again. Readers open it with
   * O_CREAT through a symlink of their own on a strictatime tmpfs.
   * Following the symlink updates its atime, which drops the walk out of
   * rcu mode, so the name is always looked up in refwalk. An O_CREAT open
   * must never fail with ENOENT.
   *
   * -p arms a cpu-clock perf timer with that period in ns on every writer,
   * so that interrupts land at random points in it.
   *
   *   usage: ocreat_enoent [-t secs] [-w writers] [-r readers] [-p ns]
   */
  #define _GNU_SOURCE
  #include <errno.h>
  #include <fcntl.h>
  #include <pthread.h>
  #include <stdatomic.h>
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <sys/mount.h>
  #include <sys/stat.h>
  #include <sys/syscall.h>
  #include <unistd.h>
  #include <linux/perf_event.h>

  #define DIR "/tmp/oc"

  static atomic_int stop;
  static atomic_long opens, creates, enoent, other;
  static long period;

  static void die(const char *what)
  {
  	fprintf(stderr, "FATAL %s: %s\n", what, strerror(errno));
  	exit(2);
  }

  static void *writer(void *arg)
  {
  	(void)arg;
  	if (period) {
  		struct perf_event_attr attr = {
  			.type = PERF_TYPE_SOFTWARE,
  			.size = sizeof(attr),
  			.config = PERF_COUNT_SW_CPU_CLOCK,
  			.sample_period = period,
  		};

  		if (syscall(SYS_perf_event_open, &attr, 0, -1, -1, 0) < 0)
  			die("perf_event_open");
  	}
  	while (!atomic_load(&stop)) {
  		int fd;

  		unlink(DIR "/ocrace");
  		fd = open(DIR "/ocrace", O_CREAT | O_RDWR | O_CLOEXEC, 0644);
  		if (fd >= 0)
  			close(fd);
  		atomic_fetch_add(&creates, 1);
  	}
  	return NULL;
  }

  static void *reader(void *arg)
  {
  	char lnk[64];

  	snprintf(lnk, sizeof(lnk), DIR "/lnk.%ld", (long)arg);
  	while (!atomic_load(&stop)) {
  		int fd = open(lnk, O_CREAT | O_RDWR | O_CLOEXEC, 0644);

  		if (fd >= 0)
  			close(fd);
  		else if (errno == ENOENT)
  			atomic_fetch_add(&enoent, 1);
  		else
  			atomic_fetch_add(&other, 1);
  		atomic_fetch_add(&opens, 1);
  	}
  	return NULL;
  }

  int main(int argc, char **argv)
  {
  	int secs = 60, nw = 4, nr = 12, c, n = 0;
  	pthread_t t[256];

  	while ((c = getopt(argc, argv, "t:w:r:p:")) != -1) {
  		switch (c) {
  		case 't': secs = atoi(optarg); break;
  		case 'w': nw = atoi(optarg); break;
  		case 'r': nr = atoi(optarg); break;
  		case 'p': period = atol(optarg); break;
  		default: return 2;
  		}
  	}
  	if (nw + nr > 256)
  		return 2;
  	mkdir(DIR, 0755);
  	if (mount("oc", DIR, "tmpfs", MS_STRICTATIME, "mode=0755"))
  		die("tmpfs");
  	for (long i = 0; i < nr; i++) {
  		char lnk[64];

  		snprintf(lnk, sizeof(lnk), DIR "/lnk.%ld", i);
  		if (symlink("ocrace", lnk))
  			die("symlink");
  	}
  	for (long i = 0; i < nw; i++)
  		if (pthread_create(&t[n++], NULL, writer, NULL))
  			die("writer");
  	for (long i = 0; i < nr; i++)
  		if (pthread_create(&t[n++], NULL, reader, (void *)i))
  			die("reader");
  	sleep(secs);
  	atomic_store(&stop, 1);
  	for (int i = 0; i < n; i++)
  		pthread_join(t[i], NULL);
  	printf("%ds: %ld opens, %ld creates, ENOENT %ld, other errors %ld\n",
  	       secs, atomic_load(&opens), atomic_load(&creates),
  	       atomic_load(&enoent), atomic_load(&other));
  	umount2(DIR, MNT_DETACH);
  	return atomic_load(&enoent) ? 1 : 0;
  }

#  diff --git a/fs/dcache.c b/fs/dcache.c
#  --- a/fs/dcache.c
#  +++ b/fs/dcache.c
#  @@ -32,9 +32,13 @@
#   #include <linux/bit_spinlock.h>
#   #include <linux/rculist_bl.h>
#   #include <linux/list_lru.h>
#  +#include <linux/delay.h>
#   #include "internal.h"
#   #include "mount.h"
#
#  +/* debug: stall "ocrace*" names between ->d_inode and the type */
#  +static int sysctl_ocrace_instantiate_us;
#  +
#   #include <asm/runtime-const.h>
#
#   /*
#  @@ -200,6 +204,13 @@
#   }
#
#   static const struct ctl_table fs_dcache_sysctls[] = {
#  +	{
#  +		.procname	= "ocrace_instantiate_us",
#  +		.data		= &sysctl_ocrace_instantiate_us,
#  +		.maxlen		= sizeof(int),
#  +		.mode		= 0644,
#  +		.proc_handler	= proc_dointvec,
#  +	},
#   	{
#   		.procname	= "dentry-state",
#   		.data		= &dentry_stat,
#  @@ -405,6 +416,10 @@
#   	unsigned flags;
#
#   	dentry->d_inode = inode;
#  +	/* debug: an interrupt landing right here */
#  +	if (unlikely(READ_ONCE(sysctl_ocrace_instantiate_us)) &&
#  +	    !strncmp(dentry->d_name.name, "ocrace", 6))
#  +		udelay(READ_ONCE(sysctl_ocrace_instantiate_us));
#   	flags = READ_ONCE(dentry->d_flags);
#   	flags &= ~DCACHE_ENTRY_TYPE;
#   	flags |= type_flags;

Fixes: e747e15156b7 ("fs: try an opportunistic lookup for O_CREAT opens too")
Cc: stable@vger.kernel.org # v6.12+
Link: https://patch.msgid.link/20261012-work-namei-ocreate-v1-1-c7883b17ee28@kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namei.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3864,8 +3864,7 @@ static struct dentry *lookup_fast_for_op
 		return dentry;
 
 	if (open_flag & O_CREAT) {
-		/* Discard negative dentries. Need inode_lock to do the create */
-		if (!dentry->d_inode) {
+		if (d_is_negative(dentry)) {
 			if (!(nd->flags & LOOKUP_RCU))
 				dput(dentry);
 			dentry = NULL;


