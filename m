Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941943B9930;
	Tue, 21 Jul 2026 21:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670792; cv=none; b=cgP/PZPJzI9l9ci0HSvK0eqDLlkDuu4fr5rvSVHHlFMyn3QSvaFk/dRrSOvYoyLttqCr8DW1XcQRVLckbVTjs6rN/1Sek1fv5LNqXK6qwvFQy4FERDtzRkIRThpy5JqXX1jb24k+F4pzJuljY6VyQAqgW+X4o2/vGsRJRTULfZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670792; c=relaxed/simple;
	bh=ONv+1uMgSQQkrfIWE+RlVAVmDRI+SvHaOCwSVLL2aXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nrGyTa6lTmMTsKpAT5G7KB8uit88qXAPxht1Ft/4DMmVW2QNjddjpe7mtpCk95foHt4xvUtxBhNKnaaeXlW/jHeokWvyMBtCIzG1qn2M6CLRDsvc9rowws8U1pcbf8aax5zMWUh54ekaAuzuXKGQ1bpunfSHliNzDfAo2o3fnnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gt8scJzT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gt8scJzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A7B1F000E9;
	Tue, 21 Jul 2026 21:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670791;
	bh=tIrgnUiUY2w6Lv0jFOy4X9tyRkqafD15Cksc81rXCQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gt8scJzTTukl1mb0Ebsf52ksd3Mclrb2Mhpf0K9qrzHDP7iu5qbq/NaSjA7Ll5jyt
	 OQYTtwXF9LrWHYGnI3RStaq4TaA/ltirs1rCco/Xt2QUnd6zekSs3E+4hppDvcvIp+
	 O0zEkKtuPu+i/zSC3Gr+Dc10CJKnRlbwxhDUxLHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 1064/1067] ALSA: seq: Skip event type filtering for UMP events
Date: Tue, 21 Jul 2026 17:27:45 +0200
Message-ID: <20260721152448.389089680@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 32108c22ac619c32dd6db594319e259b63bfb387 upstream.

UMP events don't use the event type field, hence it's invalid to apply
the filter, which may drop the events unexpectedly.
Skip the event filtering for UMP events, instead.

Fixes: 46397622a3fa ("ALSA: seq: Add UMP support")
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240819084156.10286-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/seq/seq_clientmgr.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -528,6 +528,9 @@ static struct snd_seq_client *get_event_
 		return NULL;
 	if (! dest->accept_input)
 		goto __not_avail;
+	if (snd_seq_ev_is_ump(event))
+		return dest; /* ok - no filter checks */
+
 	if ((dest->filter & SNDRV_SEQ_FILTER_USE_EVENT) &&
 	    ! test_bit(event->type, dest->event_filter))
 		goto __not_avail;


