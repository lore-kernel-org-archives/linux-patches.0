Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7C432BF24;
	Sat, 30 May 2026 16:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160231; cv=none; b=YxTSds3vLp5+A30X8EE2+iKZ1jL1guRIDGiOKbgOSSFKP24RVpBzpGFapiECfyRp4NbZJLPYD6cN2/3DjNY6WjgImUIFel1P0nwWRk2dOqig8pxNcgPykgSbidhy4YvXofvqZDjIrkFbAS0Ynr6THn7/huYsiE6qQmGTW5wy1Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160231; c=relaxed/simple;
	bh=+Ty66//CuJElMKyAldqD70OeYfpl5B/3nErHpHQyPAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8BxKy2yyybf1yOoUySD1DO0xpIIhyAPJ7d4ovcXLLWGJaOs7qG/XigiOpMzT9URgEEn77gc5l4JTCW1+qqC9j9lJ4noLEXjGHGcOzHvZzg+Hg3/zBr9AuK3/y3JLCAeojmsH2SjyiuhM54KIJ8htei08puyBBz8WG7MsUQ3VBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=plAVjEfe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="plAVjEfe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8C61F00893;
	Sat, 30 May 2026 16:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160230;
	bh=0NpthxVCdsy2MRPX9Tzd9fDF4XM4FrIAjdpt8hKmjmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=plAVjEfePzf1ZN5kW/GAfTXQXwPsLvEDdYkYCzgdmhXwipDDRYfaPiGuTGp88GYMG
	 r0RH+tlLE6LduNJdmkK6M6e9eNGqoXLxdCIW6c/oG2hZpaJfOlI4M1S93Cx888cxaZ
	 QAbG1riQPz7BK2R76KivWyZysmU5hdmeKrp8ewUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 6.1 282/969] ipmi:si: Return state to normal if message allocation fails
Date: Sat, 30 May 2026 17:56:46 +0200
Message-ID: <20260530160308.255895001@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corey Minyard <corey@minyard.net>

commit 09dd798270ff582d7309f285d4aaf5dbebae01cb upstream.

There were places where nothing would get started if a message
allocation failed, so the driver needs to return to normal state.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: <stable@vger.kernel.org>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_si_intf.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -481,15 +481,19 @@ retry:
 	} else if (smi_info->msg_flags & RECEIVE_MSG_AVAIL) {
 		/* Messages available. */
 		smi_info->curr_msg = alloc_msg_handle_irq(smi_info);
-		if (!smi_info->curr_msg)
+		if (!smi_info->curr_msg) {
+			smi_info->si_state = SI_NORMAL;
 			return;
+		}
 
 		start_getting_msg_queue(smi_info);
 	} else if (smi_info->msg_flags & EVENT_MSG_BUFFER_FULL) {
 		/* Events available. */
 		smi_info->curr_msg = alloc_msg_handle_irq(smi_info);
-		if (!smi_info->curr_msg)
+		if (!smi_info->curr_msg) {
+			smi_info->si_state = SI_NORMAL;
 			return;
+		}
 
 		start_getting_events(smi_info);
 	} else if (smi_info->msg_flags & OEM_DATA_AVAIL &&


