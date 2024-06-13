Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA4F13D881;
	Thu, 13 Jun 2024 12:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280673; cv=none; b=u7MuXQSBN9129zA75KKPb6BrZ7Tf9YpoBqrbC/z+TWzgcFBX0qnN1Cd7LluzS/yVch/QguwLXH6UZpkTOMkAO1LqJXEaUbKL2RIDQTpWkkOeTNs631F5DjnBoVoOg9zLpqSyaaLiorgY6EFEzTnFdgXdGxbIcgIlcitvXXdrN84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280673; c=relaxed/simple;
	bh=io9KLWkJs92ZQL04O7fu1KgxnpppGGb1TiUyohlCh3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RNsHuol95syLonwTynpXB8Mu3IF4vudyqixiae1R84wXQ/31K9WLTv8e2ZRi87RP97UP7kHhoVb1hjl5PKDrXN4MWZyxEWdUEqqyaI1Jj26tWVFjeOHmhpuJS3NmWUtSQiQCROdYGrPTVcLfMg82ftGUNw9utbLoz0gyybnnLbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SSudPLhj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SSudPLhj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51DABC2BBFC;
	Thu, 13 Jun 2024 12:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280673;
	bh=io9KLWkJs92ZQL04O7fu1KgxnpppGGb1TiUyohlCh3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SSudPLhjKSdKey9Ca1hFeOkAUHEdwJMyodR/5XjdsYyc/04DIcJiqNTvRX4oOJ2B0
	 yolAg16rdU1EyKeYLZ8bUql3Ku5tXQ43NsqY7vXwxBw1mbuEC9CACWJA3t11yCjxGm
	 U33PIOEuaxKIs3x7Lf4GKHdue8lBfeUu42pEeor4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 133/137] ALSA: seq: Fix incorrect UMP type for system messages
Date: Thu, 13 Jun 2024 13:35:13 +0200
Message-ID: <20240613113228.461510302@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


