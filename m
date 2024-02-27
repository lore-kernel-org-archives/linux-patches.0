Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAC216423;
	Tue, 27 Feb 2024 14:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042677; cv=none; b=ZMpwzD6Qm+vIRE23E8VzVJYmlBcpf0IRvCFzovWQk73X1aFRq+yzAvjGsOkljlfviuW8ctGWxwBHFk1l1dwxKDXIyHTi8/iogjJOYeV7sZC3R3VX7w174K2LBGyMAz3b9qvcHe5+sA9eaa355UI2eo2R7/QT+NpSwL2V+BILq6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042677; c=relaxed/simple;
	bh=5uC5ZH4koqk12EyOBPODbdBqWLjB3ywjJSMBu3ObZ3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tuoannOJsRaTYllFvzDTEdAu4sDXVW2u0SML08rMVOXLnWvugv/KbXtLfhc1PWEwStNMXVrk453sxuyWRSTJNEtq9DmaGzSlcjhQmM7Ox68dSP+pIuG+Veq7OYeBC129ZASa2h/FY41940zmMZfZpz+wSgmCokEl0ZBzxe3U0v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YT3CgTRw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YT3CgTRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F46C433C7;
	Tue, 27 Feb 2024 14:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042676;
	bh=5uC5ZH4koqk12EyOBPODbdBqWLjB3ywjJSMBu3ObZ3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YT3CgTRwI4ftqcXzlDrzfWrZjMbRC0vbiO4ExaSZBGndceplUSA1+yBY6Noi3eOsD
	 4Rvk+5EPD7OQnISj090Pt2W0prXuRLAAZwrb/JTK3SCRVrRUOxyUSD4gt1ACciMtzW
	 CWW3XWxXHnBqiWIwsZrebU2p8vE3dIbu8W2xyPmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Kobel <a-kobel@a-kobel.de>,
	regressions@lists.linux.dev,
	Arnold Gozum <arngozum@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.15 080/245] platform/x86: intel-vbtn: Stop calling "VBDL" from notify_handler
Date: Tue, 27 Feb 2024 14:24:28 +0100
Message-ID: <20240227131617.839986631@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 84c16d01ff219bc0a5dca5219db6b8b86a6854fb upstream.

Commit 14c200b7ca46 ("platform/x86: intel-vbtn: Fix missing
tablet-mode-switch events") causes 2 issues on the ThinkPad X1 Tablet Gen2:

1. The ThinkPad will wake up immediately from suspend
2. When put in tablet mode SW_TABLET_MODE reverts to 0 after about 1 second

Both these issues are caused by the "VBDL" ACPI method call added
at the end of the notify_handler.

And it never became entirely clear if this call is even necessary to fix
the issue of missing tablet-mode-switch events on the Dell Inspiron 7352.

Drop the "VBDL" ACPI method call again to fix the 2 issues this is
causing on the ThinkPad X1 Tablet Gen2.

Fixes: 14c200b7ca46 ("platform/x86: intel-vbtn: Fix missing tablet-mode-switch events")
Reported-by: Alexander Kobel <a-kobel@a-kobel.de>
Closes: https://lore.kernel.org/platform-driver-x86/295984ce-bd4b-49bd-adc5-ffe7c898d7f0@a-kobel.de/
Cc: regressions@lists.linux.dev
Cc: Arnold Gozum <arngozum@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Alexander Kobel <a-kobel@a-kobel.de>
Link: https://lore.kernel.org/r/20240216203300.245826-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/vbtn.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/platform/x86/intel/vbtn.c b/drivers/platform/x86/intel/vbtn.c
index 210b0a81b7ec..084c355c86f5 100644
--- a/drivers/platform/x86/intel/vbtn.c
+++ b/drivers/platform/x86/intel/vbtn.c
@@ -200,9 +200,6 @@ static void notify_handler(acpi_handle handle, u32 event, void *context)
 	autorelease = val && (!ke_rel || ke_rel->type == KE_IGNORE);
 
 	sparse_keymap_report_event(input_dev, event, val, autorelease);
-
-	/* Some devices need this to report further events */
-	acpi_evaluate_object(handle, "VBDL", NULL, NULL);
 }
 
 /*
-- 
2.44.0



