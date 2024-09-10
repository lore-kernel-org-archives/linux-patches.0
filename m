Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C9A18FC93;
	Tue, 10 Sep 2024 10:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962645; cv=none; b=atADmxytF0ZQV6v1jhCAw9aKGwiUwlIbqa+36olmRq/MaUZgt+bZ0VWxiP/m4ldw86Zbd7GP3iDQel8ulfQX5pAEk1rndVI5zSkfy7rNfUSNtXXsWTXPDGt5iWf7SrX0v4XhriJm3tO857K9Bcj8lo74ljm5UgMB8ssvO57U/BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962645; c=relaxed/simple;
	bh=L452W43noKNMrGN5wK2TN5tx5BZsVTGd9rmpG8UdAuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iL+I4Vr7Lg1SNc8yN9NcuxnWcpesmT5TRBDOWBC8qOSmhXlz4nTmz5RRSjNjNiR/NyBG1AS8wp2dHviS2CCSlNv7cJDghE7zzLlfK1JznatwX1XW2+LD/xrEWfP9uGb7iuPcVK0ulm7mQUY4jEkuuvu3m+X0nLxjE97ctaEbJfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JSMZ9B5L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JSMZ9B5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18126C4CECE;
	Tue, 10 Sep 2024 10:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962645;
	bh=L452W43noKNMrGN5wK2TN5tx5BZsVTGd9rmpG8UdAuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JSMZ9B5LAnJmvviQ6rXTTqlG5EhXIfOFk4RCHnXIQbfO0e/LovuwHtQ/ElpuEZzd6
	 d4+k2SzKS69pf+rLZCGoytvl0L3WD8+8851hj2NSXIqPa5P/FzdawpQH0q1Q8PRofV
	 iL8C/blsiKwVwiO3tL1UDYdEJ2BevvWoh7qAJZsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Bai <ping.bai@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Ye Li <ye.li@nxp.com>,
	Jason Liu <jason.hui.liu@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.4 104/121] clocksource/drivers/imx-tpm: Fix return -ETIME when delta exceeds INT_MAX
Date: Tue, 10 Sep 2024 11:32:59 +0200
Message-ID: <20240910092550.762554187@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacky Bai <ping.bai@nxp.com>

commit 5b8843fcd49827813da80c0f590a17ae4ce93c5d upstream.

In tpm_set_next_event(delta), return -ETIME by wrong cast to int when delta
is larger than INT_MAX.

For example:

tpm_set_next_event(delta = 0xffff_fffe)
{
        ...
        next = tpm_read_counter(); // assume next is 0x10
        next += delta; // next will 0xffff_fffe + 0x10 = 0x1_0000_000e
        now = tpm_read_counter();  // now is 0x10
        ...

        return (int)(next - now) <= 0 ? -ETIME : 0;
                     ^^^^^^^^^^
                     0x1_0000_000e - 0x10 = 0xffff_fffe, which is -2 when
                     cast to int. So return -ETIME.
}

To fix this, introduce a 'prev' variable and check if 'now - prev' is
larger than delta.

Cc: stable@vger.kernel.org
Fixes: 059ab7b82eec ("clocksource/drivers/imx-tpm: Add imx tpm timer support")
Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Ye Li <ye.li@nxp.com>
Reviewed-by: Jason Liu <jason.hui.liu@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20240725193355.1436005-1-Frank.Li@nxp.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clocksource/timer-imx-tpm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/clocksource/timer-imx-tpm.c
+++ b/drivers/clocksource/timer-imx-tpm.c
@@ -83,10 +83,10 @@ static u64 notrace tpm_read_sched_clock(
 static int tpm_set_next_event(unsigned long delta,
 				struct clock_event_device *evt)
 {
-	unsigned long next, now;
+	unsigned long next, prev, now;
 
-	next = tpm_read_counter();
-	next += delta;
+	prev = tpm_read_counter();
+	next = prev + delta;
 	writel(next, timer_base + TPM_C0V);
 	now = tpm_read_counter();
 
@@ -96,7 +96,7 @@ static int tpm_set_next_event(unsigned l
 	 * of writing CNT registers which may cause the min_delta event got
 	 * missed, so we need add a ETIME check here in case it happened.
 	 */
-	return (int)(next - now) <= 0 ? -ETIME : 0;
+	return (now - prev) >= delta ? -ETIME : 0;
 }
 
 static int tpm_set_state_oneshot(struct clock_event_device *evt)


