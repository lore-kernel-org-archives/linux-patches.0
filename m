Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD8711C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E9DC433C8;
	Mon, 28 Aug 2023 10:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218209;
	bh=1XxHwvnLNu+sQgWZEDJauhnfbDQ3H6UmhsMhK3qDiNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HSpVeliPeuyGLy5W3H2SH1d9XGBs1ls4YpxDIGx0hqN3qQZvTTLMvmLJKhNappg2n
	 Wx+AK2Cz7pEfXYGhM9SIBDoF8HY0nFPE08VErEerYWk85ndDa1Sl0Vyu56Lj84NNIP
	 f6OZSNLKP06GQ8zQB2PWhHZhWMSJ5Bdek06Q5Tmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanath S <Sanath.S@amd.com>,
	Sanjay R Mehta <sanju.mehta@amd.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.4 108/129] thunderbolt: Fix Thunderbolt 3 display flickering issue on 2nd hot plug onwards
Date: Mon, 28 Aug 2023 12:13:07 +0200
Message-ID: <20230828101200.949726065@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanjay R Mehta <sanju.mehta@amd.com>

commit 583893a66d731f5da010a3fa38a0460e05f0149b upstream.

Previously, on unplug events, the TMU mode was disabled first
followed by the Time Synchronization Handshake, irrespective of
whether the tb_switch_tmu_rate_write() API was successful or not.

However, this caused a problem with Thunderbolt 3 (TBT3)
devices, as the TSPacketInterval bits were always enabled by default,
leading the host router to assume that the device router's TMU was
already enabled and preventing it from initiating the Time
Synchronization Handshake. As a result, TBT3 monitors experienced
display flickering from the second hot plug onwards.

To address this issue, we have modified the code to only disable the
Time Synchronization Handshake during TMU disable if the
tb_switch_tmu_rate_write() function is successful. This ensures that
the TBT3 devices function correctly and eliminates the display
flickering issue.

Co-developed-by: Sanath S <Sanath.S@amd.com>
Signed-off-by: Sanath S <Sanath.S@amd.com>
Signed-off-by: Sanjay R Mehta <sanju.mehta@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
[ USB4v2 introduced support for uni-directional TMU mode as part of
  d49b4f043d63 ("thunderbolt: Add support for enhanced uni-directional TMU mode")
  This is not a stable candidate commit, so adjust the code for backport. ]
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tmu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/thunderbolt/tmu.c
+++ b/drivers/thunderbolt/tmu.c
@@ -415,7 +415,8 @@ int tb_switch_tmu_disable(struct tb_swit
 		 * uni-directional mode and we don't want to change it's TMU
 		 * mode.
 		 */
-		tb_switch_tmu_rate_write(sw, TB_SWITCH_TMU_RATE_OFF);
+		ret = tb_switch_tmu_rate_write(sw, TB_SWITCH_TMU_RATE_OFF);
+			return ret;
 
 		tb_port_tmu_time_sync_disable(up);
 		ret = tb_port_tmu_time_sync_disable(down);


