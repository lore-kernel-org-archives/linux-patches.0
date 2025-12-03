Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3DE31ED6C;
	Wed,  3 Dec 2025 16:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779664; cv=none; b=jnzBsfDd4YdKy2OMmaN3rd0lQJeytGvFEf3Srx8AR6KTulFzVOn5lh91tib3FJApbgSLvMY0GNCehTQhs+g0JIUFfmrk2fDVdRsoICvHFPwKX1OieVWHKNR9YWXjd6zXk1CzjanC2c4Mi4HYR+4+RM2gqoFVQtELIX0IuV8SgW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779664; c=relaxed/simple;
	bh=wVwvVH3ut1rDbywlbtpbAhmRU2/OJxXHN2u7qf4z9w0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wp1+aV+CWz5gPhNd7vaVY8GBbD6FS27R9kJBxKP2CTLCTJLdmry3rrqlwMGNL1sbPYlXD+QMrR4U9bYUoaapfA//Gz0i9lcqzDogj3sHI5gecokpsxSf8vc8HxSLhT+5HF0RvRhqhbmAsjkZFcDnfoDOh/U6Lbgeu0UxFxI2ZBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DhIJH0zV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DhIJH0zV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0832C4CEF5;
	Wed,  3 Dec 2025 16:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779664;
	bh=wVwvVH3ut1rDbywlbtpbAhmRU2/OJxXHN2u7qf4z9w0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DhIJH0zVPwLhQi0OYQEVw8exXmZqwwvijp/H1k1ru0Z0JpRohvyLSKdp2qObM9Kpc
	 MCBA6GnA5qOiq/8dMv1lKKOXzYKzTlmxjO8RFTN9lj836IBRZry8vjX+stEt+1qnz5
	 xiVlyyt1+uj58ZcQf30g8kfZafjuwq5hPXmX58zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 325/568] Bluetooth: MGMT: Fix OOB access in parse_adv_monitor_pattern()
Date: Wed,  3 Dec 2025 16:25:27 +0100
Message-ID: <20251203152452.614748285@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>

commit 8d59fba49362c65332395789fd82771f1028d87e upstream.

In the parse_adv_monitor_pattern() function, the value of
the 'length' variable is currently limited to HCI_MAX_EXT_AD_LENGTH(251).
The size of the 'value' array in the mgmt_adv_pattern structure is 31.
If the value of 'pattern[i].length' is set in the user space
and exceeds 31, the 'patterns[i].value' array can be accessed
out of bound when copied.

Increasing the size of the 'value' array in
the 'mgmt_adv_pattern' structure will break the userspace.
Considering this, and to avoid OOB access revert the limits for 'offset'
and 'length' back to the value of HCI_MAX_AD_LENGTH.

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with SVACE.

Fixes: db08722fc7d4 ("Bluetooth: hci_core: Fix missing instances using HCI_MAX_AD_LENGTH")
Cc: stable@vger.kernel.org
Signed-off-by: Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/mgmt.h |    2 +-
 net/bluetooth/mgmt.c         |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -772,7 +772,7 @@ struct mgmt_adv_pattern {
 	__u8 ad_type;
 	__u8 offset;
 	__u8 length;
-	__u8 value[31];
+	__u8 value[HCI_MAX_AD_LENGTH];
 } __packed;
 
 #define MGMT_OP_ADD_ADV_PATTERNS_MONITOR	0x0052
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -5436,9 +5436,9 @@ static u8 parse_adv_monitor_pattern(stru
 	for (i = 0; i < pattern_count; i++) {
 		offset = patterns[i].offset;
 		length = patterns[i].length;
-		if (offset >= HCI_MAX_EXT_AD_LENGTH ||
-		    length > HCI_MAX_EXT_AD_LENGTH ||
-		    (offset + length) > HCI_MAX_EXT_AD_LENGTH)
+		if (offset >= HCI_MAX_AD_LENGTH ||
+		    length > HCI_MAX_AD_LENGTH ||
+		    (offset + length) > HCI_MAX_AD_LENGTH)
 			return MGMT_STATUS_INVALID_PARAMS;
 
 		p = kmalloc(sizeof(*p), GFP_KERNEL);


