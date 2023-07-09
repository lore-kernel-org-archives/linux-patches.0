Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D048522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F451C433C7;
	Sun,  9 Jul 2023 11:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901701;
	bh=RUnDs38rEXzt4nBIUhcjnV7MnUM6Lf5+ejGIqcpVrpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yDYTVhyDE8+rsjC3nrtyygSTxx7an6V52gj4RlqoJLS5PD1cg8iLCV1SSnVwcPRAL
	 0TrKYj6GQ9RDJU3t8PhDHRQH6TChWkRoNb0QcsSQ98ghfMj7f38OkT7Lj6UFpn1Wt+
	 /AcOWvV58CKDOgWauEpXMoPbN02iWEYjCMakPla0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Andi Kleen <ak@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Colin Cross <ccross@android.com>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Guenter Roeck <groeck@chromium.org>,
	Ian Rogers <irogers@google.com>,
	Lecopzer Chen <lecopzer.chen@mediatek.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Masayoshi Mizuma <msys.mizuma@gmail.com>,
	Matthias Kaehlcke <mka@chromium.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Petr Mladek <pmladek@suse.com>,
	Pingfan Liu <kernelfans@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Ravi V. Shankar" <ravi.v.shankar@intel.com>,
	Ricardo Neri <ricardo.neri@intel.com>,
	Stephane Eranian <eranian@google.com>,
	Stephen Boyd <swboyd@chromium.org>,
	Sumit Garg <sumit.garg@linaro.org>,
	Tzung-Bi Shih <tzungbi@chromium.org>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 113/431] watchdog/perf: more properly prevent false positives with turbo modes
Date: Sun,  9 Jul 2023 13:11:01 +0200
Message-ID: <20230709111453.804312418@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 4379e59fe5665cfda737e45b8bf2f05321ef049c ]

Currently, in the watchdog_overflow_callback() we first check to see if
the watchdog had been touched and _then_ we handle the workaround for
turbo mode.  This order should be reversed.

Specifically, "touching" the hardlockup detector's watchdog should avoid
lockups being detected for one period that should be roughly the same
regardless of whether we're running turbo or not.  That means that we
should do the extra accounting for turbo _before_ we look at (and clear)
the global indicating that we've been touched.

NOTE: this fix is made based on code inspection.  I am not aware of any
reports where the old code would have generated false positives.  That
being said, this order seems more correct and also makes it easier down
the line to share code with the "buddy" hardlockup detector.

Link: https://lkml.kernel.org/r/20230519101840.v5.2.I843b0d1de3e096ba111a179f3adb16d576bef5c7@changeid
Fixes: 7edaeb6841df ("kernel/watchdog: Prevent false positives with turbo modes")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen-Yu Tsai <wens@csie.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Colin Cross <ccross@android.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: Matthias Kaehlcke <mka@chromium.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Pingfan Liu <kernelfans@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: "Ravi V. Shankar" <ravi.v.shankar@intel.com>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: Sumit Garg <sumit.garg@linaro.org>
Cc: Tzung-Bi Shih <tzungbi@chromium.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/watchdog_hld.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/watchdog_hld.c b/kernel/watchdog_hld.c
index 247bf0b1582ca..1e8a49dc956e2 100644
--- a/kernel/watchdog_hld.c
+++ b/kernel/watchdog_hld.c
@@ -114,14 +114,14 @@ static void watchdog_overflow_callback(struct perf_event *event,
 	/* Ensure the watchdog never gets throttled */
 	event->hw.interrupts = 0;
 
+	if (!watchdog_check_timestamp())
+		return;
+
 	if (__this_cpu_read(watchdog_nmi_touch) == true) {
 		__this_cpu_write(watchdog_nmi_touch, false);
 		return;
 	}
 
-	if (!watchdog_check_timestamp())
-		return;
-
 	/* check for a hardlockup
 	 * This is done by making sure our timer interrupt
 	 * is incrementing.  The timer interrupt should have
-- 
2.39.2



