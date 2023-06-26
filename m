Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2025711CAB
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91AE8C433C0;
	Mon, 26 Jun 2023 18:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804746;
	bh=8gHV8AHvNYiogcKy7vhbDKr7kWbDaNO9tY2+/KsbvMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzq6P/cht3Uaoh5GK0tJL2B98/2sMaLvmfy4ShHi3gypJ3+sevfxdrPM7I8zW6Ry+
	 PwP1gRV5ocOIxnxGAIdkHkKj8AcwbydmOO5HG9E+0mVXZjv9srzEq9QVt6LNHmLVzX
	 ASByx5bifkoG8HL6+Stu4FrjKzkZAxPBHGxZsyFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yann Gautier <yann.gautier@foss.st.com>,
	Christophe Kerello <christophe.kerello@foss.st.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 27/96] mmc: mmci: stm32: fix max busy timeout calculation
Date: Mon, 26 Jun 2023 20:11:42 +0200
Message-ID: <20230626180748.068776247@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180746.943455203@linuxfoundation.org>
References: <20230626180746.943455203@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe Kerello <christophe.kerello@foss.st.com>

commit 47b3ad6b7842f49d374a01b054a4b1461a621bdc upstream.

The way that the timeout is currently calculated could lead to a u64
timeout value in mmci_start_command(). This value is then cast in a u32
register that leads to mmc erase failed issue with some SD cards.

Fixes: 8266c585f489 ("mmc: mmci: add hardware busy timeout feature")
Signed-off-by: Yann Gautier <yann.gautier@foss.st.com>
Signed-off-by: Christophe Kerello <christophe.kerello@foss.st.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230613134146.418016-1-yann.gautier@foss.st.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mmci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -1729,7 +1729,8 @@ static void mmci_set_max_busy_timeout(st
 		return;
 
 	if (host->variant->busy_timeout && mmc->actual_clock)
-		max_busy_timeout = ~0UL / (mmc->actual_clock / MSEC_PER_SEC);
+		max_busy_timeout = U32_MAX / DIV_ROUND_UP(mmc->actual_clock,
+							  MSEC_PER_SEC);
 
 	mmc->max_busy_timeout = max_busy_timeout;
 }


