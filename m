Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62461428FC;
	Thu, 13 Jun 2024 11:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279660; cv=none; b=fiJ8iFM88oToPX/VJRI0pW3i5eAZoJ5/UTCDuGn8lYSumFwuBF1poqctuwZXzpoxNgxUrbM1IzPxtKkAh+2Fp/tKIE76BjheYwnz4a0Nk9kLcJdny/N9zT691dVJ/p151HLYexW/B6fA9C2crhXjQG+tTVX3Dbvg0ckF4xNJMag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279660; c=relaxed/simple;
	bh=A/FmqPEmBvx9RrvMWPagQOCN4fwrSbS/CqKv81czy3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HyEn9PkV4ZwR0AbXkLu9kAh7NlgE0m+e+fD8x+tYbvJOKcwrylCkjT5FJSZfsUwKeuKlMQ8HJZonmddoaxLPgFC4tfhH8ewRC0ka5RBnaO2EzH0LyFDTtXVSBrFvDVmK58WOxalKEETrqxJCyXaLaok3hDAXavItlHGIrWICCHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cC0OYYYA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cC0OYYYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C158C2BBFC;
	Thu, 13 Jun 2024 11:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279660;
	bh=A/FmqPEmBvx9RrvMWPagQOCN4fwrSbS/CqKv81czy3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cC0OYYYAPnZlDgnC2EVmYsDPDf+DDF4E3LRDrSqWLHzFn3WX+eZ+5Nm/mJFCgo9CF
	 go3bBctvfyktcbscPXEG6pXYqUvL5Xx4XAuEamNcPGGxVi0BJHKhI2fXZPIULLY/6L
	 P965L70p95BhHREQJfnv19FqwomiDBO9ifeQbBfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.9 151/157] ALSA: seq: Fix incorrect UMP type for system messages
Date: Thu, 13 Jun 2024 13:34:36 +0200
Message-ID: <20240613113233.250863852@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit edb32776196afa393c074d6a2733e3a69e66b299 upstream.

When converting a legacy system message to a UMP packet, it forgot to
modify the UMP type field but keeping the default type (either type 2
or 4).  Correct to the right type for system messages.

Fixes: e9e02819a98a ("ALSA: seq: Automatic conversion of UMP events")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240529083800.5742-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/seq/seq_ump_convert.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/core/seq/seq_ump_convert.c
+++ b/sound/core/seq/seq_ump_convert.c
@@ -740,6 +740,7 @@ static int system_1p_ev_to_ump_midi1(con
 				     union snd_ump_midi1_msg *data,
 				     unsigned char status)
 {
+	data->system.type = UMP_MSG_TYPE_SYSTEM; // override
 	data->system.status = status;
 	data->system.parm1 = event->data.control.value & 0x7f;
 	return 1;
@@ -751,6 +752,7 @@ static int system_2p_ev_to_ump_midi1(con
 				     union snd_ump_midi1_msg *data,
 				     unsigned char status)
 {
+	data->system.type = UMP_MSG_TYPE_SYSTEM; // override
 	data->system.status = status;
 	data->system.parm1 = event->data.control.value & 0x7f;
 	data->system.parm2 = (event->data.control.value >> 7) & 0x7f;


