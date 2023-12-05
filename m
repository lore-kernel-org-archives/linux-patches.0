Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05CD6FAF;
	Tue,  5 Dec 2023 03:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qtMN/SpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42057C433C7;
	Tue,  5 Dec 2023 03:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746921;
	bh=qGxUxpE9rqJ1OcIDe2JkOEoGH3Aq9Bznd2dRRkRBrGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qtMN/SpPV9U+1GZqg/WXiqok31jCebMqC50uxnUwfo3oidQ5ozEsthy5h8U0N+C2+
	 HVX6qmgfDf9ZM76Y6YrfrbRXFXCuifolbcWltRnvePXyKmRY+HGxT/0WCX73Tbd4VP
	 3v61AZvBvGVaiSCejIiYX7zl/FXoVjJoiWqYcfnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Avri Altman <avri.altman@wdc.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 67/71] mmc: cqhci: Increase recovery halt timeout
Date: Tue,  5 Dec 2023 12:17:05 +0900
Message-ID: <20231205031521.765687826@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031517.859409664@linuxfoundation.org>
References: <20231205031517.859409664@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit b578d5d18e929aa7c007a98cce32657145dde219 ]

Failing to halt complicates the recovery. Additionally, unless the card or
controller are stuck, which is expected to be very rare, then the halt
should succeed, so it is better to wait. Set a large timeout.

Fixes: a4080225f51d ("mmc: cqhci: support for command queue enabled host")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Link: https://lore.kernel.org/r/20231103084720.6886-3-adrian.hunter@intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/cqhci.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/cqhci.c b/drivers/mmc/host/cqhci.c
index 495a09b5a8e78..773941a92649d 100644
--- a/drivers/mmc/host/cqhci.c
+++ b/drivers/mmc/host/cqhci.c
@@ -926,10 +926,10 @@ static bool cqhci_halt(struct mmc_host *mmc, unsigned int timeout)
 /*
  * After halting we expect to be able to use the command line. We interpret the
  * failure to halt to mean the data lines might still be in use (and the upper
- * layers will need to send a STOP command), so we set the timeout based on a
- * generous command timeout.
+ * layers will need to send a STOP command), however failing to halt complicates
+ * the recovery, so set a timeout that would reasonably allow I/O to complete.
  */
-#define CQHCI_START_HALT_TIMEOUT	5
+#define CQHCI_START_HALT_TIMEOUT	500
 
 static void cqhci_recovery_start(struct mmc_host *mmc)
 {
-- 
2.42.0



