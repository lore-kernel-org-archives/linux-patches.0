Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D23729E0E5;
	Mon, 13 Apr 2026 16:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096285; cv=none; b=i83jme6rocksWcb7/3s+oQAaL35kbe0WAV9Vm/zNPk4MyS8Ar2TxiJJsblYGJ9ndHEb0jTWbIEQ9Qf1Vho7UPSYR09TgRjym/nQlgHmlV2N5GAJX2AN82hSNark9o9VGkTXW4DrclyQx0yc811grezTUXqt26EWfCOEREb0/QrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096285; c=relaxed/simple;
	bh=3XE5lO/knNMiAdpDag5uRq3JiX4hVFy0LQwn0OKEGWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s83Pw97UibhzSG+P0zJl2J/lmIOI4j8a34sNfivoXbWJdfnwNzSkhM7x0uWJeU1uFyJJOYgk12BZvHxPwwO5/SWd+Oj+CrEnhh3eDSEA8EN51xhf1D4Tu4TO466sERscFFQfrKg3hIfEwQ95MtecPXhHxMDOuAp0XGMNX/vax6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rc05SDHd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rc05SDHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76AE0C2BCB0;
	Mon, 13 Apr 2026 16:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096284;
	bh=3XE5lO/knNMiAdpDag5uRq3JiX4hVFy0LQwn0OKEGWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rc05SDHdbQ/sg3EdnOTHXEb663n3zOn6iz5m2OOXs5pY2AyDoHLZ+W1+Twcy9nNom
	 23jHiaZQqH4rFr6JBfPsrszFIQuJEge05pDk+7RaAHlw7WqhA5n5LD5x+gz85EaoOh
	 gPGAgiweg470okyt/vM+MHMRdIi09DIfFNTzEQq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ren Wei <enjou1224z@gmail.com>,
	Ruide Cao <caoruide123@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 6.19 39/86] batman-adv: reject oversized global TT response buffers
Date: Mon, 13 Apr 2026 17:59:46 +0200
Message-ID: <20260413155733.027847401@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

From: Ruide Cao <caoruide123@gmail.com>

commit 3a359bf5c61d52e7f09754108309d637532164a6 upstream.

batadv_tt_prepare_tvlv_global_data() builds the allocation length for a
global TT response in 16-bit temporaries. When a remote originator
advertises a large enough global TT, the TT payload length plus the VLAN
header offset can exceed 65535 and wrap before kmalloc().

The full-table response path still uses the original TT payload length when
it fills tt_change, so the wrapped allocation is too small and
batadv_tt_prepare_tvlv_global_data() writes past the end of the heap object
before the later packet-size check runs.

Fix this by rejecting TT responses whose TVLV value length cannot fit in
the 16-bit TVLV payload length field.

Fixes: 7ea7b4a14275 ("batman-adv: make the TT CRC logic VLAN specific")
Cc: stable@vger.kernel.org
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Ruide Cao <caoruide123@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/translation-table.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -798,8 +798,8 @@ batadv_tt_prepare_tvlv_global_data(struc
 {
 	u16 num_vlan = 0;
 	u16 num_entries = 0;
-	u16 change_offset;
-	u16 tvlv_len;
+	u16 tvlv_len = 0;
+	unsigned int change_offset;
 	struct batadv_tvlv_tt_vlan_data *tt_vlan;
 	struct batadv_orig_node_vlan *vlan;
 	u8 *tt_change_ptr;
@@ -816,6 +816,11 @@ batadv_tt_prepare_tvlv_global_data(struc
 	if (*tt_len < 0)
 		*tt_len = batadv_tt_len(num_entries);
 
+	if (change_offset > U16_MAX || *tt_len > U16_MAX - change_offset) {
+		*tt_len = 0;
+		goto out;
+	}
+
 	tvlv_len = *tt_len;
 	tvlv_len += change_offset;
 


