Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670D539A7FD;
	Tue, 21 Jul 2026 18:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658568; cv=none; b=U0eCw9VOH4vY1inOD+66+VI3xn6qAYq9U0ozS4IxIlyplnm8O1JuXaIdK6G/zIh54/VlmrnUeMKCcBIuVGv9mHbZeKRdJJxCaOb2kutoaWWBJghIJkeHY6+bfrDHr+Q3uoknQoQF8/okb1JEsbAQWdB++Qb0R3cTjqi89fp2Cq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658568; c=relaxed/simple;
	bh=0mITuGnIW2cxh4iSM1NITfN1JbIuSDbtcFCXs2vzgXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNNXIiCCgtcqbZoePzkf8GCLyIzb6IH0eWDn7nlsbGlq8DV6nA2SUVxiXJPyuUvH6hJJfXw+aO8fRblYtJuywyxYDo2iu4UVaTsd/NlX/XdOTVpEXuuXT/8eFufHT3f9+YnXaDHlTqAMmjmPXDGk3EVvpXKSsRnLT7zzuglri10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uhGdOJ9l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uhGdOJ9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC8C1F00A3A;
	Tue, 21 Jul 2026 18:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658566;
	bh=yAGzQ3+duL7fMlozm9AkHaXdvavY23Gv8LTTCrFwQug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uhGdOJ9lfCScpG02x1KfzU318+l7Mqa+sTgJXfSgF14QzfprHzSQuX98LK5b9LuhH
	 gXmX1P9++rqaI1AyvKM70+xk2y/DwZoJZXucs99eLRSreflGmID2TCtKM+R8iEXkrT
	 tK/EL+WWpw06b4G7mg0BbCrNpxWWkEC3VRMk2npo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Hongyan Xia <hongyan.xia@transsion.com>,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.18 1191/1611] cpufreq: schedutil: Fix uncleared need_freq_update on the .adjust_perf() path
Date: Tue, 21 Jul 2026 17:21:47 +0200
Message-ID: <20260721152542.222568905@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>

commit 9ef450ca74e43dacf9a2a15db7a851052c78dcf0 upstream.

The need_freq_update flag makes sugov_should_update_freq() return true
regardless of the rate_limit_us throttling, and is cleared in
sugov_update_next_freq(). sugov_update_single_freq() and
sugov_update_shared() go through that helper, so the flag does not
persist there.

However, sugov_update_single_perf(), used by drivers implementing the
.adjust_perf() callback (e.g. intel_pstate or amd-pstate in passive
mode) calls cpufreq_driver_adjust_perf() directly and never goes through
sugov_update_next_freq(), so the need_freq_update flag is not cleared in
that path.

Before commit 75da043d8f88 ("cpufreq/sched: Set need_freq_update in
ignore_dl_rate_limit()"), this was effectively harmless because
sugov_should_update_freq() still honored the rate limit even when
need_freq_update was set. After that change, the flag forces
sugov_should_update_freq() to always return true, so once set, it
stays effective indefinitely on the .adjust_perf() path.

As a result, cpufreq_driver_adjust_perf() gets called on every scheduler
utilization update (with the runqueue lock held) rather than being
throttled by rate_limit_us, even if the driver itself may skip redundant
hardware updates.

Clear need_freq_update at the end of the adjust_perf path as well.

Fixes: 75da043d8f88 ("cpufreq/sched: Set need_freq_update in ignore_dl_rate_limit()")
Signed-off-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Reviewed-by: Hongyan Xia <hongyan.xia@transsion.com>
Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Cc: All applicable <stable@vger.kernel.org>
[ rjw: Subject and changelog edits ]
Link: https://patch.msgid.link/20260616154733.2405236-1-zhongqiu.han@oss.qualcomm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/cpufreq_schedutil.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -486,6 +486,7 @@ static void sugov_update_single_perf(str
 	cpufreq_driver_adjust_perf(sg_policy->policy, sg_cpu->bw_min,
 				   sg_cpu->util, max_cap);
 
+	sg_policy->need_freq_update = false;
 	sg_policy->last_freq_update_time = time;
 }
 


