Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5553F1ED41
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:52:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB04C433C7;
	Fri, 21 Jul 2023 18:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965539;
	bh=+JsoD3/Ew/MrNiybiQTDdd2DhUln0RvweiKORh5LQ/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sh24sO9JPeegIHiBc5zcQFBSr/UdZp81B8OGyF0Vvl4VHptDYod1QPXFlwk9rmbwI
	 wbmJNh8aMsttKgIYrAxl7UMRdwS/a/GLzwANZeHYA7XGBW5UwTw7ilU3OmBrDfK0w3
	 WAnpv/ZwlVG5cUEL8+Jsl5xy9645rBPEq9MgCg14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/532] kselftest: vDSO: Fix accumulation of uninitialized ret when CLOCK_REALTIME is undefined
Date: Fri, 21 Jul 2023 17:58:50 +0200
Message-ID: <20230721160616.083765895@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 375b9ff53cb6f9c042817b75f2be0a650626dc4f ]

In the unlikely case that CLOCK_REALTIME is not defined, variable ret is
not initialized and further accumulation of return values to ret can leave
ret in an undefined state. Fix this by initialized ret to zero and changing
the assignment of ret to an accumulation for the CLOCK_REALTIME case.

Fixes: 03f55c7952c9 ("kselftest: Extend vDSO selftest to clock_getres")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vDSO/vdso_test_clock_getres.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/vDSO/vdso_test_clock_getres.c b/tools/testing/selftests/vDSO/vdso_test_clock_getres.c
index 15dcee16ff726..38d46a8bf7cba 100644
--- a/tools/testing/selftests/vDSO/vdso_test_clock_getres.c
+++ b/tools/testing/selftests/vDSO/vdso_test_clock_getres.c
@@ -84,12 +84,12 @@ static inline int vdso_test_clock(unsigned int clock_id)
 
 int main(int argc, char **argv)
 {
-	int ret;
+	int ret = 0;
 
 #if _POSIX_TIMERS > 0
 
 #ifdef CLOCK_REALTIME
-	ret = vdso_test_clock(CLOCK_REALTIME);
+	ret += vdso_test_clock(CLOCK_REALTIME);
 #endif
 
 #ifdef CLOCK_BOOTTIME
-- 
2.39.2



