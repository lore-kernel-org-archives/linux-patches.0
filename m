Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1AE51EE1A;
	Wed, 23 Sep 2026 14:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172752; cv=none; b=VrfJ0uOD7LP0RUFHDuZZ/aMmoWb6QDTlD++8hpyarf0JLerSnYzi5erCKE+pWBMfHxn3GXN6oJ1+yiNv22ciM276ztZRjmNdKSLRdtUd4zblCBeZxINNmp1ZEjz5/uRd27AFImoVfTnKEKnhIrBsoXYNY6sJaDyI7NNTtXUWVxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172752; c=relaxed/simple;
	bh=nss/hKUHDTYCpsmwN2tPAOU/BawKqlojWpbDuCZe8QE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYKNdcB+W/U19Ps0aRMrOYFGXOL34aBUVktUT5n2mR0GsbshBOnExd9+387urTMzMe5dm5rIeyFMxqfBwKOGNtmrnLlQHYnFSsVxNdEFB7SpyuaYDX10z6zXWNuE4IPjoq73iyA09bqiWs7nAHzdZWbMWT7N6PS0qnkI1eXwB6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TWtDe5wR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TWtDe5wR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A4C1F000FF;
	Wed, 23 Sep 2026 14:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172751;
	bh=6iUIZy48vicz6dPEIUgkD/tNFuYsGGfJQzLArUHZHk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TWtDe5wRXxzRKmzGPJ24fXyf7zVAEY/n9g9qYq9CyIzkQQpEwl0uPmlb7GkXeiKON
	 9y5YGLku2lFhHgrmQ4Hn443i811U6szWIfGSnuq6YDeske6jAxw/vqbfskJHXGIKCP
	 v3ARYzD0RkxMIwsb/lp9eBwlB5q6qVzwR2j6Wy3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shmulik Cohen <anuk909@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 051/438] wifi: libipw: reject too-short beacon and probe responses
Date: Wed, 23 Sep 2026 16:01:12 +0200
Message-ID: <20260923140646.111124574@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shmulik Cohen <anuk909@gmail.com>

[ Upstream commit 5ce5721e8cbe3e80db8f43851cc2a2a92485ef4b ]

libipw_process_probe_response() and the libipw_network_init() call it
makes assume the frame contains the full 36-byte beacon and probe
response prefix, but the ipw2100 and ipw2200 receive paths only
establish that a management frame carries the generic 24-byte
three-address header.

libipw_network_init() then computes the information element length as

	stats->len - sizeof(*beacon)

stats->len is a u16 and sizeof() has type size_t, so the subtraction is
evaluated as size_t and wraps instead of going negative.  Truncating
that to the u16 length parameter of libipw_parse_info_param() yields
65524 for a 24-byte beacon, and the parser then walks the receive
buffer as if it held almost 64 KiB of information elements, reading
past the allocation.

Reject the frame before any fixed field is touched.

Found by an AI-assisted review of length arithmetic in management frame
parsers.  Verified with a KUnit case under Generic KASAN on arm64 under
QEMU; I do not have the hardware, so it is not tested on a real device.

Fixes: b453872c35cf ("[NET] ieee80211 subsystem")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Shmulik Cohen <anuk909@gmail.com>
Link: https://patch.msgid.link/20260812190412.18333-2-anuk909@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
index c8841f9b9ad91..2661dac6985e4 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
@@ -1421,6 +1421,9 @@ static void libipw_process_probe_response(struct libipw_device
 #endif
 	unsigned long flags;
 
+	if (stats->len < sizeof(*beacon))
+		return;
+
 	LIBIPW_DEBUG_SCAN("'%*pE' (%pM): %c%c%c%c %c%c%c%c-%c%c%c%c %c%c%c%c\n",
 		     info_element->len, info_element->data,
 		     beacon->header.addr3,
-- 
2.53.0



