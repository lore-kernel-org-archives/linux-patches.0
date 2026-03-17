Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474F9225A38;
	Tue, 17 Mar 2026 17:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767912; cv=none; b=szMIXiYLboc5kZlkmJLJAZnIBzAsKn88Mx2XLIkgnal+neLWOMBZItn6920BxlYpeTHrOg4Opvjmu1fUJOCepf4oCgv/WJsqGDSWPDKMwoKKpNWC3yKmkcphAEbTsW6iTLhcMlEwxzHpxE5bOsCKL5oocPaMN7etP60W3lmelLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767912; c=relaxed/simple;
	bh=jHwUB1fSc9fHLTwnOHfZqP2IOSTaBMFV57vAP9BNhjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NIJDSWd6cWYTvF4hn2/nw8hmTTXta06hG1Tqtw3BHYcdFlyRtkGaCzFTJgmUDAZMMiuzSoMzQuvnJ/RgQZNdGTamF0zpugC4l5bnvkzXaqZJRkxFvDfkYapd/kXxWFNUsBDYqTwvR2yetnFr0g+clzSW45Y9wy/b20M+gP0Ns+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wBXM8lWq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wBXM8lWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC433C4CEF7;
	Tue, 17 Mar 2026 17:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767912;
	bh=jHwUB1fSc9fHLTwnOHfZqP2IOSTaBMFV57vAP9BNhjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wBXM8lWqpJb2dHWWtmqcNneJYKUQU0OrwkeeVO2ZK29C+9qVKIs886FaHhkDJIXPv
	 6PeXkf4Xc6ctwU8bUsTTs2B586aE8cAVfOfXCyzdtkTTD7z3KKMJzoVuY+9r2D70gj
	 zOQJin+ARMzLav6N5XXR2xfrXCjO+d+xQ6bXE92s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Raits <igor@gooddata.com>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 6.18 188/333] ipmi:si: Use a long timeout when the BMC is misbehaving
Date: Tue, 17 Mar 2026 17:33:37 +0100
Message-ID: <20260317163006.326524901@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Corey Minyard <corey@minyard.net>

commit c3bb3295637cc9bf514f690941ca9a385bf30113 upstream.

If the driver goes into HOSED state, don't reset the timeout to the
short timeout in the timeout handler.

Reported-by: Igor Raits <igor@gooddata.com>
Closes: https://lore.kernel.org/linux-acpi/CAK8fFZ58fidGUCHi5WFX0uoTPzveUUDzT=k=AAm4yWo3bAuCFg@mail.gmail.com/
Fixes: bc3a9d217755 ("ipmi:si: Gracefully handle if the BMC is non-functional")
Cc: stable@vger.kernel.org # 4.18
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_si_intf.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -1114,7 +1114,9 @@ static void smi_timeout(struct timer_lis
 		     * SI_USEC_PER_JIFFY);
 	smi_result = smi_event_handler(smi_info, time_diff);
 
-	if ((smi_info->io.irq) && (!smi_info->interrupt_disabled)) {
+	if (smi_info->si_state == SI_HOSED) {
+		timeout = jiffies + SI_TIMEOUT_HOSED;
+	} else if ((smi_info->io.irq) && (!smi_info->interrupt_disabled)) {
 		/* Running with interrupts, only do long timeouts. */
 		timeout = jiffies + SI_TIMEOUT_JIFFIES;
 		smi_inc_stat(smi_info, long_timeouts);


