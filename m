Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFAF2376;
	Wed,  5 Feb 2025 14:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766787; cv=none; b=nyM7bVNuH9fOFsO0sDmeaFh+kR7HFpzD5P4FS6h+Wvsp3FhDscbi6ytmD3iZOJ5NdYpmv1bGjtYuugZvLZ9LUkoPynziM9pbOkVbFZ+pnUpoHO6iRZk66yHZ4ZlcGV8uIDP5qEItQSAhOE4FHLbHy1bOvpsATEB6clFStTPmw0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766787; c=relaxed/simple;
	bh=XEWG0sLqoXr7D4BDMtLvv5neATqzFVNiZGIIKduHlzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPo3oUuVAMUVJ7z8sk1dehjD9WKI6Zl9spUwoank6bACULbjcQEeTHEo0Q8ny8CFvouC4yDP8K//UYxxoQw7ClNHCVoI7XMYHxj/kLGDxQtcTDEgjwQ3cA/EwJPDqIWdE7xbqij2VTjY29B4HFkcQUiVELf+C6nIIcikHHSKw88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p1URCQoh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p1URCQoh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E280C4CED1;
	Wed,  5 Feb 2025 14:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766786;
	bh=XEWG0sLqoXr7D4BDMtLvv5neATqzFVNiZGIIKduHlzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p1URCQohncJ+63CAxTuggZwEwzU9+3k/RWaIcBVS+9rqG2+plnBAr3/bYHoWz0v4G
	 6UtE0n1EIeVX1KOBKGvp/mTt8dXBa94K8x8fB9sxl8kAXVavTDq3uAs7x0N1WWDTwe
	 sZkjmIVj3dAQBSrSj9bdskgcJsHnX9FMSjrxz9dA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 308/623] selftests/bpf: Fix undefined UINT_MAX in veristat.c
Date: Wed,  5 Feb 2025 14:40:50 +0100
Message-ID: <20250205134508.010346619@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit a8d1c48d0720140b53063ff23507845bb2078e92 ]

Include <limits.h> in 'veristat.c' to provide a UINT_MAX definition and
avoid multiple compile errors against mips64el/musl-libc:

veristat.c: In function 'max_verifier_log_size':
veristat.c:1135:36: error: 'UINT_MAX' undeclared (first use in this function)
 1135 |         const int SMALL_LOG_SIZE = UINT_MAX >> 8;
      |                                    ^~~~~~~~
veristat.c:24:1: note: 'UINT_MAX' is defined in header '<limits.h>'; did you forget to '#include <limits.h>'?
   23 | #include <math.h>
  +++ |+#include <limits.h>
   24 |

Fixes: 1f7c33630724 ("selftests/bpf: Increase verifier log limit in veristat")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250116075036.3459898-1-tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/veristat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/veristat.c b/tools/testing/selftests/bpf/veristat.c
index e12ef953fba85..b174c013485cd 100644
--- a/tools/testing/selftests/bpf/veristat.c
+++ b/tools/testing/selftests/bpf/veristat.c
@@ -21,6 +21,7 @@
 #include <gelf.h>
 #include <float.h>
 #include <math.h>
+#include <limits.h>
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
-- 
2.39.5



