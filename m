Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8070D65192;
	Wed, 30 Sep 2026 18:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791940; cv=none; b=b8wkp4jKqUTc0kqdWUuSkwpkJA7qpQg2uW9L9LTprGyxfl4aIaTlFFpv9u2+pksV33T01t/oBw/NLlm314F0nhZ4vWE4hbqZSYz5kRzBnT/1eUYuKvqF7RIa5GrOKnXhx04uf4LEaJhEGDN9UhQIYTKwOkGM9vMblIwu83W4RHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791940; c=relaxed/simple;
	bh=eHsInNzT6WWL+DVNPmSUwrgLEvWwlph2NaDE37sWCYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3ULaygdoYcHdSrShrReN61xPdAl6tSEXSTLiMEGxdOFx/2zI5EKFkjoRTujoCoDoscreQ7M6ShX8sm2XRXVCvDBw+BOEevXUVosXF2f8pWFlUxuzgdJ/HHNymeTKo1NctqZBypFD2a4g00mTmuduQOnta8E448ZaUY5pHLi5rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ajRm1Uss; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ajRm1Uss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6551F000FF;
	Wed, 30 Sep 2026 18:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791939;
	bh=7e95OyPketQtZB3DGF3rPu5Jcx+AylBkGx8zWu2fvS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ajRm1UssvDo8sfPiDwOhhKOgvAblU9ga9ImNOydQgybUPhLqnfpUXXSUsKnAaMcNx
	 bk+aghL9qKUNqmJLniWdDbq79NQ+aT1JEa45kYLpwhFoTOHO1XpAiQeb0YhI5/9KuX
	 bNQh0rjgboweZn79/CJOjwrtO/l63sehkllMvxtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shmulik Cohen <anuk909@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 462/752] wifi: libipw: reject too-short beacon and probe responses
Date: Wed, 30 Sep 2026 17:25:32 +0200
Message-ID: <20260930152408.274027801@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 32efaba48a568..2c67c6e88ec70 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
@@ -1514,6 +1514,9 @@ static void libipw_process_probe_response(struct libipw_device
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



