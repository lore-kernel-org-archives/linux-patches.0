Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F2B1AC887;
	Mon, 14 Oct 2024 15:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919278; cv=none; b=HUdYiAEh7aD2Q4l9wlYKTkawCBkk60caFSgceFRD2+QUFU8IzSDdGweZwtMSvsXLI7A6Rq0vnBSDBZYJOZ+XLy0ydOuWr/I99NQmCOKI9i3B5RoZkCE16znKFkmT6y2brc0y8tss2CXn/0z64/st9GdirnY6JNeB12PNFe6rG9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919278; c=relaxed/simple;
	bh=EtgrlQ9VJMmk5R4cV6vIqXMfR8IwFD/U6OWZ5R9Pf+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYIY21V0Rlh2XFpMgJapOMptBoiCjyccVFerYnzrWtUpf8jsGLL55CudJz7biMSKdmE78LzHrvyqDdk+O/RzpuC4s74/3Fh+WNmcNYy2JhiULuFkkMlEE6OqLlhkqjHwtyMgx4yFzL58/Le8XRpxAf24TcJZDFS4Wd4er9xknbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rF5tw+lU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rF5tw+lU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73A0C4CEC3;
	Mon, 14 Oct 2024 15:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919278;
	bh=EtgrlQ9VJMmk5R4cV6vIqXMfR8IwFD/U6OWZ5R9Pf+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rF5tw+lU3/6/RIaRc6HKXp6rCuNeJ6KnEUF3MM5J7wsYsw+KBiJdIbY9eV77te4Sg
	 H1OKuoCOdN5gh80IK1VmPhr0WoApODCwoXe4yBeOWNy7vt6Urm+cKfH40chwC2ZUZ/
	 pLGbm1q85koH10HjXhyhLUxFNrvpnGEh6M8kkKjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Gengkun <luogengkun@huaweicloud.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>
Subject: [PATCH 6.1 532/798] perf/core: Fix small negative period being ignored
Date: Mon, 14 Oct 2024 16:18:06 +0200
Message-ID: <20241014141238.890297525@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luo Gengkun <luogengkun@huaweicloud.com>

commit 62c0b1061593d7012292f781f11145b2d46f43ab upstream.

In perf_adjust_period, we will first calculate period, and then use
this period to calculate delta. However, when delta is less than 0,
there will be a deviation compared to when delta is greater than or
equal to 0. For example, when delta is in the range of [-14,-1], the
range of delta = delta + 7 is between [-7,6], so the final value of
delta/8 is 0. Therefore, the impact of -1 and -2 will be ignored.
This is unacceptable when the target period is very short, because
we will lose a lot of samples.

Here are some tests and analyzes:
before:
  # perf record -e cs -F 1000  ./a.out
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.022 MB perf.data (518 samples) ]

  # perf script
  ...
  a.out     396   257.956048:         23 cs:  ffffffff81f4eeec schedul>
  a.out     396   257.957891:         23 cs:  ffffffff81f4eeec schedul>
  a.out     396   257.959730:         23 cs:  ffffffff81f4eeec schedul>
  a.out     396   257.961545:         23 cs:  ffffffff81f4eeec schedul>
  a.out     396   257.963355:         23 cs:  ffffffff81f4eeec schedul>
  a.out     396   257.965163:         23 cs:  ffffffff81f4eeec schedul>
  a.out     396   257.966973:         23 cs:  ffffffff81f4eeec schedul>
  a.out     396   257.968785:         23 cs:  ffffffff81f4eeec schedul>
  a.out     396   257.970593:         23 cs:  ffffffff81f4eeec schedul>
  ...

after:
  # perf record -e cs -F 1000  ./a.out
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.058 MB perf.data (1466 samples) ]

  # perf script
  ...
  a.out     395    59.338813:         11 cs:  ffffffff81f4eeec schedul>
  a.out     395    59.339707:         12 cs:  ffffffff81f4eeec schedul>
  a.out     395    59.340682:         13 cs:  ffffffff81f4eeec schedul>
  a.out     395    59.341751:         13 cs:  ffffffff81f4eeec schedul>
  a.out     395    59.342799:         12 cs:  ffffffff81f4eeec schedul>
  a.out     395    59.343765:         11 cs:  ffffffff81f4eeec schedul>
  a.out     395    59.344651:         11 cs:  ffffffff81f4eeec schedul>
  a.out     395    59.345539:         12 cs:  ffffffff81f4eeec schedul>
  a.out     395    59.346502:         13 cs:  ffffffff81f4eeec schedul>
  ...

test.c

int main() {
        for (int i = 0; i < 20000; i++)
                usleep(10);

        return 0;
}

  # time ./a.out
  real    0m1.583s
  user    0m0.040s
  sys     0m0.298s

The above results were tested on x86-64 qemu with KVM enabled using
test.c as test program. Ideally, we should have around 1500 samples,
but the previous algorithm had only about 500, whereas the modified
algorithm now has about 1400. Further more, the new version shows 1
sample per 0.001s, while the previous one is 1 sample per 0.002s.This
indicates that the new algorithm is more sensitive to small negative
values compared to old algorithm.

Fixes: bd2b5b12849a ("perf_counter: More aggressive frequency adjustment")
Signed-off-by: Luo Gengkun <luogengkun@huaweicloud.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20240831074316.2106159-2-luogengkun@huaweicloud.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4067,7 +4067,11 @@ static void perf_adjust_period(struct pe
 	period = perf_calculate_period(event, nsec, count);
 
 	delta = (s64)(period - hwc->sample_period);
-	delta = (delta + 7) / 8; /* low pass filter */
+	if (delta >= 0)
+		delta += 7;
+	else
+		delta -= 7;
+	delta /= 8; /* low pass filter */
 
 	sample_period = hwc->sample_period + delta;
 


