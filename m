Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED99C1F63CD;
	Sun,  7 Sep 2025 20:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277826; cv=none; b=VovgW5O+GQA7/Hg/55M+29U1jec9SGh4SQU7wQBcDXSxNvBFRH4U9IQ9IqjNRMVyXyhNNzPV3UvzhuryCUrW82wDJlHxxJKaI7gcECBJuFmYaiibQ9X6nkF8N++McM4ElCdY3YBONvSlnPIjMBfbys5nnowlhm1VdkX5FVXU5as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277826; c=relaxed/simple;
	bh=AVpvz9iepwxd1Dmv1PJlwGvbn7XOaZPUwHOEcHLhAIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6+H687iHFeZRmHljTOtrr7+NDAdva/I2Q+FF916l003PYrhGLV/1kXta+rUqUu346XlOS/+9B+ETyg1xPz7XdX0pnzT8UIc4HURMZMu4yIsm5ug/E6X3fWHWt75s8OEFXoQIi3bsg1DHxGsBvBIVWTCoxwao32uwqdOD/Cls9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qEt2V91t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qEt2V91t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4906DC4CEF0;
	Sun,  7 Sep 2025 20:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277825;
	bh=AVpvz9iepwxd1Dmv1PJlwGvbn7XOaZPUwHOEcHLhAIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qEt2V91tTEz5ooo1yS3fi+NpuMqfqaOk28pHZ1lYEU2kmnzgnYoNNu3NCRuL3WB3f
	 GZHG7lrt7iE/iTfAHpWetrGiT0QCkABTtT6/qcWcUz5Cuud2gac1ArDqnC5Z9i4c6u
	 lARsbqrXWM7+l/po1YdgVTjpih42j4KNl5RA+zSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Fort <disclosure@aisle.com>,
	Stanislav Fort <stanislav.fort@aisle.com>,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 6.16 135/183] batman-adv: fix OOB read/write in network-coding decode
Date: Sun,  7 Sep 2025 21:59:22 +0200
Message-ID: <20250907195619.001388227@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Fort <stanislav.fort@aisle.com>

commit d77b6ff0ce35a6d0b0b7b9581bc3f76d041d4087 upstream.

batadv_nc_skb_decode_packet() trusts coded_len and checks only against
skb->len. XOR starts at sizeof(struct batadv_unicast_packet), reducing
payload headroom, and the source skb length is not verified, allowing an
out-of-bounds read and a small out-of-bounds write.

Validate that coded_len fits within the payload area of both destination
and source sk_buffs before XORing.

Fixes: 2df5278b0267 ("batman-adv: network coding - receive coded packets and decode them")
Cc: stable@vger.kernel.org
Reported-by: Stanislav Fort <disclosure@aisle.com>
Signed-off-by: Stanislav Fort <stanislav.fort@aisle.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/network-coding.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/batman-adv/network-coding.c
+++ b/net/batman-adv/network-coding.c
@@ -1687,7 +1687,12 @@ batadv_nc_skb_decode_packet(struct batad
 
 	coding_len = ntohs(coded_packet_tmp.coded_len);
 
-	if (coding_len > skb->len)
+	/* ensure dst buffer is large enough (payload only) */
+	if (coding_len + h_size > skb->len)
+		return NULL;
+
+	/* ensure src buffer is large enough (payload only) */
+	if (coding_len + h_size > nc_packet->skb->len)
 		return NULL;
 
 	/* Here the magic is reversed:


