Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEF33F23DD;
	Tue, 17 Mar 2026 16:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766367; cv=none; b=sy8yL8ZMxn9Zst9ePilFUxfm4AIH5gN+T7Qm757Wmeu76BxT6zban2WT4ORCXn3PW3btdB6uUENFIVtu3SQnmr+7TnNrwxJbWMUxYl3ZPU2bMq9iqNOmrcn6bFRvpLdZsJrYdX+r/KSvxPr05zp2B016BK+S5axX3Ungg3+o8lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766367; c=relaxed/simple;
	bh=+mjiSNr9CtjXVCe2kW/k3H9jvxMB4Z5PuxPRT1jIryE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLtHoWTfEmAPiVqkzGDaosAauq81jc0DtpZ9jevg7vQEqvco4TOthzw29Ih7G6xBDQ6gwqs7DLYPQAboyj+0JJ0F0LfeVSO4vIAPz00C5ok/ApzxAOcp2GTnWc7rx7PVHfTj7r6Q4Ft/0EkvCY378RcT8VC97llpLpgFCEfybRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RbqyHDZv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RbqyHDZv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB31C4CEF7;
	Tue, 17 Mar 2026 16:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766367;
	bh=+mjiSNr9CtjXVCe2kW/k3H9jvxMB4Z5PuxPRT1jIryE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RbqyHDZvYhcglG4Khbk5ILdvp5oSce9ZepcuLmflOwfKld/DD/gpfer6QaV2zGXOH
	 HPGoqE6UcenTHJfrHYw2LcV7ZQzDdNRmShZ/oUyYfVhi/tjXy6IKvdJiZSzvGjF9Kk
	 dLG0WmMhPopNcF00Vx796RuM6XDjubEliR5Symvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 6.19 229/378] ipmi:si: Fix check for a misbehaving BMC
Date: Tue, 17 Mar 2026 17:33:06 +0100
Message-ID: <20260317163015.433953805@linuxfoundation.org>
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

commit cae66f1a1dcd23e17da5a015ef9d731129f9d2dd upstream.

There is a race on checking the state in the sender, it needs to be
checked under a lock.  But you also need a check to avoid issues with
a misbehaving BMC for run to completion mode.  So leave the check at
the beginning for run to completion, and add a check under the lock
to avoid the race.

Reported-by: Rafael J. Wysocki <rafael@kernel.org>
Fixes: bc3a9d217755 ("ipmi:si: Gracefully handle if the BMC is non-functional")
Cc: stable@vger.kernel.org # 4.18
Signed-off-by: Corey Minyard <corey@minyard.net>
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_si_intf.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -924,9 +924,14 @@ static int sender(void *send_info, struc
 {
 	struct smi_info   *smi_info = send_info;
 	unsigned long     flags;
+	int rv = IPMI_CC_NO_ERROR;
 
 	debug_timestamp(smi_info, "Enqueue");
 
+	/*
+	 * Check here for run to completion mode.  A check under lock is
+	 * later.
+	 */
 	if (smi_info->si_state == SI_HOSED)
 		return IPMI_BUS_ERR;
 
@@ -940,18 +945,15 @@ static int sender(void *send_info, struc
 	}
 
 	spin_lock_irqsave(&smi_info->si_lock, flags);
-	/*
-	 * The following two lines don't need to be under the lock for
-	 * the lock's sake, but they do need SMP memory barriers to
-	 * avoid getting things out of order.  We are already claiming
-	 * the lock, anyway, so just do it under the lock to avoid the
-	 * ordering problem.
-	 */
-	BUG_ON(smi_info->waiting_msg);
-	smi_info->waiting_msg = msg;
-	check_start_timer_thread(smi_info);
+	if (smi_info->si_state == SI_HOSED) {
+		rv = IPMI_BUS_ERR;
+	} else {
+		BUG_ON(smi_info->waiting_msg);
+		smi_info->waiting_msg = msg;
+		check_start_timer_thread(smi_info);
+	}
 	spin_unlock_irqrestore(&smi_info->si_lock, flags);
-	return IPMI_CC_NO_ERROR;
+	return rv;
 }
 
 static void set_run_to_completion(void *send_info, bool i_run_to_completion)


