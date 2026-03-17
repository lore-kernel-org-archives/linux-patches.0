Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAB63F54DC;
	Tue, 17 Mar 2026 16:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766334; cv=none; b=Ut+T5qUT7Dk+fR3ccSohXyQpgrI55lgAAvLsmXNUDLIWeZmtfkI5uOELRlFR8QCo19h0JBLcTB9HhbDyKAibLB9/fbANleBPl/BMrRJXrnzXy0iE8Mplp8aHNvOaZ5i2AlnXtFTa034BlO/t/wMkA0NSgnxjMujS8VEH3B92tbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766334; c=relaxed/simple;
	bh=EwqpOrOrrz8vo6g/yCZasGGu8T48+Y4Jq7N73XitQQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5hFdW4vRKj5KwM76mDx7XNY1jIVw05eCDDPiG1sARGoUSU3ehS6DVoA5cKtvodo5N1i+MdUzp9FW95l3RVCWFmCcwG7qgKqKMPaAthPYthZlSEUJ5NIVKCHQDWas89rO5hHhlOA0O/Qp3WynkUYpnEwdNFUjv5lszHgkFNyw9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x1tQmEx8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x1tQmEx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03948C19424;
	Tue, 17 Mar 2026 16:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766334;
	bh=EwqpOrOrrz8vo6g/yCZasGGu8T48+Y4Jq7N73XitQQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x1tQmEx8Fg6DuWKA1sMNHC040sBWID4hKjcu2Js4vvDI3FlprNdZ0EFL7wZQcUlJj
	 vS+ArrGWe77gNW8/9VNll6YB3Q8Vpku0ECLkruzPk5rjiw8KiLrF1diff50oUbJ2S3
	 jfNyI5JxED92ZL9Q4OwMWkz6KnfyE+KLE5QncOEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 6.19 221/378] ipmi:si: Dont block module unload if the BMC is messed up
Date: Tue, 17 Mar 2026 17:32:58 +0100
Message-ID: <20260317163015.141249585@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corey Minyard <corey@minyard.net>

commit f895e5df80316a308c2f7d64d13a78494630ea05 upstream.

If the BMC is in a bad state, don't bother waiting for queues messages
since there can't be any.  Otherwise the unload is blocked until the
BMC is back in a good state.

Reported-by: Rafael J. Wysocki <rafael@kernel.org>
Fixes: bc3a9d217755 ("ipmi:si: Gracefully handle if the BMC is non-functional")
Cc: stable@vger.kernel.org # 4.18
Signed-off-by: Corey Minyard <corey@minyard.net>
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_si_intf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2226,7 +2226,8 @@ static void wait_msg_processed(struct sm
 	unsigned long jiffies_now;
 	long time_diff;
 
-	while (smi_info->curr_msg || (smi_info->si_state != SI_NORMAL)) {
+	while (smi_info->si_state != SI_HOSED &&
+		    (smi_info->curr_msg || (smi_info->si_state != SI_NORMAL))) {
 		jiffies_now = jiffies;
 		time_diff = (((long)jiffies_now - (long)smi_info->last_timeout_jiffies)
 		     * SI_USEC_PER_JIFFY);


