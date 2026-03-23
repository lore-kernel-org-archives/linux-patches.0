Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4209040DFC4;
	Mon, 23 Mar 2026 14:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275469; cv=none; b=sj61hD5fhc40bHN4URT01mSGRUTFy6OGscQMHJA7U/Wy9MkTPQkGUeW7m5WGKAHaHynBRH/PQWS9vsgMFt7tKEtkx62hjMq7ciSCnTha7h1SYlsfsbQwA2S39hlv6QdOwbfeQfN0zp0bHLUBOtKO69xAgULKUllGsW4ko/MY5pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275469; c=relaxed/simple;
	bh=TQ6Tvd4BLX17GrrhPXcuja2/Hl3WRK9RZmMIkyxFE1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unEjrDvEk6808TtdetQYcNgrFAO92mwHmoWF+wkpk301hyfrkE9TPD9NuOz7cBwruG1jEWB+GAtl7HkCmykHED7gtBFejswGEU+MVmefGxqnAVNrNqpNJ5V7droy5k8123Tn2k04A8QzfibLDlmnRg/HkdJGZdJdoHAtm3slftc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rhrQyO+y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rhrQyO+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1319C4CEF7;
	Mon, 23 Mar 2026 14:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275469;
	bh=TQ6Tvd4BLX17GrrhPXcuja2/Hl3WRK9RZmMIkyxFE1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rhrQyO+y4Js1UkgiEsQamFfB5Wr9CunRs5Yo3RFBUdT1SZ5gNRM9yiAqMl2VtGYYR
	 wHAN4j3mTWgPUCjYLHZmiDB4OWHF8f6jVPMDIOw9SmGU1iWXepprpapXl9NQBNwHNP
	 TNAMvi4DuwxZ6Vmjg5PVrARTAf5V3WGKP4Hn/0eU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>,
	Gui-Dong Han <hanguidong02@gmail.com>
Subject: [PATCH 6.12 113/460] usb: class: cdc-wdm: fix reordering issue in read code path
Date: Mon, 23 Mar 2026 14:41:49 +0100
Message-ID: <20260323134529.413756527@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit 8df672bfe3ec2268c2636584202755898e547173 upstream.

Quoting the bug report:

Due to compiler optimization or CPU out-of-order execution, the
desc->length update can be reordered before the memmove. If this
happens, wdm_read() can see the new length and call copy_to_user() on
uninitialized memory. This also violates LKMM data race rules [1].

Fix it by using WRITE_ONCE and memory barriers.

Fixes: afba937e540c9 ("USB: CDC WDM driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Closes: https://lore.kernel.org/linux-usb/CALbr=LbrUZn_cfp7CfR-7Z5wDTHF96qeuM=3fO2m-q4cDrnC4A@mail.gmail.com/
Reported-by: Gui-Dong Han <hanguidong02@gmail.com>
Reviewed-by: Gui-Dong Han <hanguidong02@gmail.com>
Link: https://patch.msgid.link/20260304130116.1721682-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-wdm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -225,7 +225,8 @@ static void wdm_in_callback(struct urb *
 		/* we may already be in overflow */
 		if (!test_bit(WDM_OVERFLOW, &desc->flags)) {
 			memmove(desc->ubuf + desc->length, desc->inbuf, length);
-			desc->length += length;
+			smp_wmb(); /* against wdm_read() */
+			WRITE_ONCE(desc->length, desc->length + length);
 		}
 	}
 skip_error:
@@ -533,6 +534,7 @@ static ssize_t wdm_read
 		return -ERESTARTSYS;
 
 	cntr = READ_ONCE(desc->length);
+	smp_rmb(); /* against wdm_in_callback() */
 	if (cntr == 0) {
 		desc->read = 0;
 retry:


