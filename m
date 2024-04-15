Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E802433AD;
	Mon, 15 Apr 2024 14:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192208; cv=none; b=NI+fGBuTk+sxKAtfjcqXfQ+Ms9SiAUChY0lnXjpNWN4TPjl3eBLgGLeq7KLH9yfKnqbKqzUJKmCwd2RdtMFdgYnRh6flhbgc3Yug0d1anzVDze6tQctjHw8+1W73lxOUM5D3Eme2d151G6h6rLReS0H0ppDCxIAsdSO4dsRJlzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192208; c=relaxed/simple;
	bh=M27LJLe1qAYnAUBOIGbzfiQXDmVlqK8SrTQM3kc4Hu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A6mNG6c+2uIsVGrcut2n/nwnfHNXcEpoPvD+xHUSNEUE9M0oec8iGHSNbS4spC76IiYn5XqwQ0XAMVUxJxLYsMwUOn7UqQhoTdsgqBtQjclUuyAXcmaEnvcLA3oUIzY9AcsWDKcj7SoQZCIrLuXso5KHcDxqfYw0Mx71zk0wys4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QGd5m+BR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QGd5m+BR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F60C2BD10;
	Mon, 15 Apr 2024 14:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192208;
	bh=M27LJLe1qAYnAUBOIGbzfiQXDmVlqK8SrTQM3kc4Hu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QGd5m+BRgO4IiAkzx4rjA9lsqYcB++0YaHPAwGf5Y2BWNm5vALbwZTlgx7uUyaSWF
	 a4zY+eZBXf46akxEhvCw5EwybsZkVWywVd6pTG4cU2KM1BuTfAk5TaGROC+5vcsuEe
	 g0bIMDf31jx0M6Wy388zZdw4e6feR67bIUKAymu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>
Subject: [PATCH 5.15 32/45] perf/x86: Fix out of range data
Date: Mon, 15 Apr 2024 16:21:39 +0200
Message-ID: <20240415141943.209031108@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141942.235939111@linuxfoundation.org>
References: <20240415141942.235939111@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

commit dec8ced871e17eea46f097542dd074d022be4bd1 upstream.

On x86 each struct cpu_hw_events maintains a table for counter assignment but
it missed to update one for the deleted event in x86_pmu_del().  This
can make perf_clear_dirty_counters() reset used counter if it's called
before event scheduling or enabling.  Then it would return out of range
data which doesn't make sense.

The following code can reproduce the problem.

  $ cat repro.c
  #include <pthread.h>
  #include <stdio.h>
  #include <stdlib.h>
  #include <unistd.h>
  #include <linux/perf_event.h>
  #include <sys/ioctl.h>
  #include <sys/mman.h>
  #include <sys/syscall.h>

  struct perf_event_attr attr = {
  	.type = PERF_TYPE_HARDWARE,
  	.config = PERF_COUNT_HW_CPU_CYCLES,
  	.disabled = 1,
  };

  void *worker(void *arg)
  {
  	int cpu = (long)arg;
  	int fd1 = syscall(SYS_perf_event_open, &attr, -1, cpu, -1, 0);
  	int fd2 = syscall(SYS_perf_event_open, &attr, -1, cpu, -1, 0);
  	void *p;

  	do {
  		ioctl(fd1, PERF_EVENT_IOC_ENABLE, 0);
  		p = mmap(NULL, 4096, PROT_READ, MAP_SHARED, fd1, 0);
  		ioctl(fd2, PERF_EVENT_IOC_ENABLE, 0);

  		ioctl(fd2, PERF_EVENT_IOC_DISABLE, 0);
  		munmap(p, 4096);
  		ioctl(fd1, PERF_EVENT_IOC_DISABLE, 0);
  	} while (1);

  	return NULL;
  }

  int main(void)
  {
  	int i;
  	int n = sysconf(_SC_NPROCESSORS_ONLN);
  	pthread_t *th = calloc(n, sizeof(*th));

  	for (i = 0; i < n; i++)
  		pthread_create(&th[i], NULL, worker, (void *)(long)i);
  	for (i = 0; i < n; i++)
  		pthread_join(th[i], NULL);

  	free(th);
  	return 0;
  }

And you can see the out of range data using perf stat like this.
Probably it'd be easier to see on a large machine.

  $ gcc -o repro repro.c -pthread
  $ ./repro &
  $ sudo perf stat -A -I 1000 2>&1 | awk '{ if (length($3) > 15) print }'
       1.001028462 CPU6   196,719,295,683,763      cycles                           # 194290.996 GHz                       (71.54%)
       1.001028462 CPU3   396,077,485,787,730      branch-misses                    # 15804359784.80% of all branches      (71.07%)
       1.001028462 CPU17  197,608,350,727,877      branch-misses                    # 14594186554.56% of all branches      (71.22%)
       2.020064073 CPU4   198,372,472,612,140      cycles                           # 194681.113 GHz                       (70.95%)
       2.020064073 CPU6   199,419,277,896,696      cycles                           # 195720.007 GHz                       (70.57%)
       2.020064073 CPU20  198,147,174,025,639      cycles                           # 194474.654 GHz                       (71.03%)
       2.020064073 CPU20  198,421,240,580,145      stalled-cycles-frontend          #  100.14% frontend cycles idle        (70.93%)
       3.037443155 CPU4   197,382,689,923,416      cycles                           # 194043.065 GHz                       (71.30%)
       3.037443155 CPU20  196,324,797,879,414      cycles                           # 193003.773 GHz                       (71.69%)
       3.037443155 CPU5   197,679,956,608,205      stalled-cycles-backend           # 1315606428.66% backend cycles idle   (71.19%)
       3.037443155 CPU5   198,571,860,474,851      instructions                     # 13215422.58  insn per cycle

It should move the contents in the cpuc->assign as well.

Fixes: 5471eea5d3bf ("perf/x86: Reset the dirty counter to prevent the leak for an RDPMC task")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240306061003.1894224-1-namhyung@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -1649,6 +1649,7 @@ static void x86_pmu_del(struct perf_even
 	while (++i < cpuc->n_events) {
 		cpuc->event_list[i-1] = cpuc->event_list[i];
 		cpuc->event_constraint[i-1] = cpuc->event_constraint[i];
+		cpuc->assign[i-1] = cpuc->assign[i];
 	}
 	cpuc->event_constraint[i-1] = NULL;
 	--cpuc->n_events;


