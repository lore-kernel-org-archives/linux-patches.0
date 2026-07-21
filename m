Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D693314D05;
	Tue, 21 Jul 2026 17:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655149; cv=none; b=fmOgT5Z0thUxIoskUpY9trlzg6Pj8p1Qu9wraiUfoKLQXm8kNyMsGx20+Gq1QLF8H5Yn8wXwal7qEGhYbZAJj6EpDm4CE6n/JJgjZeMlaBRYG0pcruJzd+wXDzMkzoumH+/CfcnKou5i0rQndCvrVlRlul4GHIjmkJopSew7YdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655149; c=relaxed/simple;
	bh=Ttm0ybvf0u9hXYAxkdh346rEwM7m5LkMimJtmra4BpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sY8/Kp+imuqq0M6LYXY4+dj4eDofrDzJuqOci3fNejFUtQci2i4ADxaJ/JmJGBClvhqmvQqGwyXTmSwi/SEkhMCkc8i8iatA1IAWjG94ZNBVoFg5mxgnik/JIE9Qd9GX+h3t5Y9GCfN1VFE63a1tytEmlYz1lzFQWm/x2XbCykc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ecck8x80; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ecck8x80"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A461B1F000E9;
	Tue, 21 Jul 2026 17:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655148;
	bh=R5ui6KsD3ySvvsdW+OgvrqwkshFGp3TXJPfRFWShhk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ecck8x80WftBBdnBGveQ4aA29XPleVPyvsJMI4oGOWKr5jACh05hfNcRKRs12c2QY
	 D8IBacWKmQHZXm/3I79F/J0OLzzncEfJZWu0RoV+hUqlyg1Yc1lbfIqVAVoKvpt6DY
	 X0X6xbL8ScMlfaGXXsysocQ0ctYZo2zY90xTXkSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nirmoy Das <nirmoyd@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.1 1973/2077] selftests: net: make busywait timeout clock portable
Date: Tue, 21 Jul 2026 17:27:26 +0200
Message-ID: <20260721152639.239962971@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirmoy Das <nirmoyd@nvidia.com>

commit dd6a23bac306b7aa322e0aaccb60c6e32a198fb3 upstream.

loopy_wait() expects millisecond timestamps. However, Ubuntu Resolute
can use uutils date, where `date -u +%s%3N` returns seconds plus full
nanoseconds instead of a 3-digit millisecond field. This makes
busywait expire too early and can make vlan_bridge_binding.sh read a
stale operstate.

Fixes: 25ae948b4478 ("selftests/net: add lib.sh")
Cc: stable@vger.kernel.org # 6.8+
Link: https://github.com/uutils/coreutils/issues/11658
Signed-off-by: Nirmoy Das <nirmoyd@nvidia.com>
Link: https://patch.msgid.link/20260630165157.3814871-1-nirmoyd@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/lib.sh |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/lib.sh
+++ b/tools/testing/selftests/net/lib.sh
@@ -70,12 +70,33 @@ ksft_exit_status_merge()
 		$ksft_xfail $ksft_pass $ksft_skip $ksft_fail
 }
 
+timestamp_ms()
+{
+	local now
+	local seconds
+	local nanoseconds
+
+	now=$(date -u +%s:%N) || return
+	seconds=${now%:*}
+	nanoseconds=${now#*:}
+
+	if [[ $nanoseconds =~ ^[0-9]+$ ]]; then
+		nanoseconds=${nanoseconds:0:9}
+	else
+		nanoseconds=0
+	fi
+
+	echo $((seconds * 1000 + 10#$nanoseconds / 1000000))
+}
+
 loopy_wait()
 {
 	local sleep_cmd=$1; shift
 	local timeout_ms=$1; shift
+	local start_time
+	local current_time
 
-	local start_time="$(date -u +%s%3N)"
+	start_time=$(timestamp_ms) || return
 	while true
 	do
 		local out
@@ -84,7 +105,7 @@ loopy_wait()
 			return 0
 		fi
 
-		local current_time="$(date -u +%s%3N)"
+		current_time=$(timestamp_ms) || return
 		if ((current_time - start_time > timeout_ms)); then
 			echo -n "$out"
 			return 1


