Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451AC130E42;
	Tue, 23 Jan 2024 00:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969067; cv=none; b=H1d1i/V0fBbFUiJqfuoJOOtYDu88MinAC5q6CR7LNkmuBNvcatqVOHP/vHQEJG0jZQjz6S8YgNr83YAWPuOPLrDt0scmFfWV8VK7CEJmHB6TvZAOsXBQ3xiq59aMDhInaMtXM21bSPMghpHAqxcsgXU29yO6wT1UuUCQv885odk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969067; c=relaxed/simple;
	bh=0BxysecvMJUz0eJjzO9DKzkzou+3djF2U696aJ9wrxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTuiqnTllYcylmMxifIC/BfH3CoFUdqVPWAuaXUsiVUZEKQt++TBVsbYEi2g9TFgQCukNaYEeisI5wY2DJh1J6mdo2BXSvQdZIiN755jMAlZ/v7IufCcCjZw5B0OeMW99DXV8bzgmRqwu22NogslEltW9ILiNFvabyEWWPNceDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iUTuTtck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iUTuTtck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08661C43390;
	Tue, 23 Jan 2024 00:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969067;
	bh=0BxysecvMJUz0eJjzO9DKzkzou+3djF2U696aJ9wrxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iUTuTtckQJoaDTG60+5s8LONosgersHCz2rf5nl58L5QO253b37ayc3XLX6i0iylD
	 1l7MqXeEyJw8heXDZe99Gx7DBAWuskxtwpUkCuVLWb9pNimcC6zUGFQfXqfciP3qP+
	 IRBP5GJPXKuHrCuqHcAntY/sk7hqfE8hjgycu/vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Xuefeng Li <lixuefeng@loongson.cn>
Subject: [PATCH 5.4 194/194] perf top: Skip side-band event setup if HAVE_LIBBPF_SUPPORT is not set
Date: Mon, 22 Jan 2024 15:58:44 -0800
Message-ID: <20240122235727.540585480@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit 0c5f1acc2a14416bf30023f373558d369afdbfc8 upstream.

When I execute 'perf top' without HAVE_LIBBPF_SUPPORT, there exists the
following segmentation fault, skip the side-band event setup to fix it,
this is similar with commit 1101c872c8c7 ("perf record: Skip side-band
event setup if HAVE_LIBBPF_SUPPORT is not set").

  [yangtiezhu@linux perf]$ ./perf top
  <SNIP>
  perf: Segmentation fault
  Obtained 6 stack frames.
  ./perf(sighandler_dump_stack+0x5c) [0x12011b604]
  [0xffffffc010]
  ./perf(perf_mmap__read_init+0x3e) [0x1201feeae]
  ./perf() [0x1200d715c]
  /lib64/libpthread.so.0(+0xab9c) [0xffee10ab9c]
  /lib64/libc.so.6(+0x128f4c) [0xffedc08f4c]
  Segmentation fault
  [yangtiezhu@linux perf]$

I use git bisect to find commit b38d85ef49cf ("perf bpf: Decouple
creating the evlist from adding the SB event") is the first bad commit,
so also add the Fixes tag.

Committer testing:

First build perf explicitely disabling libbpf:

  $ make NO_LIBBPF=1 O=/tmp/build/perf -C tools/perf install-bin && perf test python

Now make sure it isn't linked:

  $ perf -vv | grep -w bpf
                   bpf: [ OFF ]  # HAVE_LIBBPF_SUPPORT
  $
  $ nm ~/bin/perf | grep libbpf
  $

And now try to run 'perf top':

  # perf top
  perf: Segmentation fault
  -------- backtrace --------
  perf[0x5bcd6d]
  /lib64/libc.so.6(+0x3ca6f)[0x7fd0f5a66a6f]
  perf(perf_mmap__read_init+0x1e)[0x5e1afe]
  perf[0x4cc468]
  /lib64/libpthread.so.0(+0x9431)[0x7fd0f645a431]
  /lib64/libc.so.6(clone+0x42)[0x7fd0f5b2b912]
  #

Applying this patch fixes the issue.

Fixes: b38d85ef49cf ("perf bpf: Decouple creating the evlist from adding the SB event")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Xuefeng Li <lixuefeng@loongson.cn>
Link: http://lore.kernel.org/lkml/1597753837-16222-1-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/builtin-top.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1682,6 +1682,7 @@ int cmd_top(int argc, const char **argv)
 		goto out_delete_evlist;
 	}
 
+#ifdef HAVE_LIBBPF_SUPPORT
 	if (!top.record_opts.no_bpf_event) {
 		top.sb_evlist = evlist__new();
 
@@ -1695,6 +1696,7 @@ int cmd_top(int argc, const char **argv)
 			goto out_delete_evlist;
 		}
 	}
+#endif
 
 	if (perf_evlist__start_sb_thread(top.sb_evlist, target)) {
 		pr_debug("Couldn't start the BPF side band thread:\nBPF programs starting from now on won't be annotatable\n");


