Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621790;
	b=EMpeGUxbVTvbHTkfxtExEtjVKYNzjwGV0h85g89BqHZlsgv+nAMuuO0dz3sH19EmGqYC
	 AGi1nIq4hRELxQS/lhvHVVmOc5QcRTA81CmzyzT4npbWLfCWi3/mrumn3usgeIwvrfEBg
	 aqjiuLyZmGNu9Zo3S+/vz0yJITY0tC5FPjVtURrb6VvXXKm/6qKi/1UPn+z2wmT4Pe+jb
	 R8qRpQKNnttyNJcDbzu2evtbxdaqAubUTipOMxUxXJIW8uBll2zrsQ4nitJHBm2qBNf2V
	 LEchnW05JRi3aTPJlNrmDUyNOK/03fyzFWqFio4znmL4m4wlOKT0qmwnAIDnWBRoDgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U2NqUag6Oh0on7N71A3juZZrfNCZt8RHJOJcehUbHX0=;
	b=vbywc27L8lcnihhAiI9s5m0B4F7N27pmBvvhQ4pez50eoVjBpOGi/jTFljEaDDmxXdxn
	 tH+KjVFoS9UOrH9zUbe3+AL0ruIjkDnw6rdmWYDs8DASDGy4UlkDBnWxZ6yHr16vjEidY
	 AQHG6Bee236qMi9OMwG8brxs2yAfBfwvt7IybBusXcys8inR6/iV8nE1/vWKTCbnDK+uX
	 kKqOyRfi+Bw/29WT++glnrTkvMlzKTWXRcu+axGFWJyNUAKzra6XbEkoj8vE05NyLevub
	 JPL3zsE9NLgBcc6u3FWt8AlJ1a8uOfbJWSTkLAsoAx7fB7ALTYmRWnrstcGMFbIgDdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="YQql5i/3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2194E606A327;
	Wed, 25 Nov 2026 15:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YQql5i/3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6011F000C0;
	Wed, 25 Nov 2026 15:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621789;
	bh=U2NqUag6Oh0on7N71A3juZZrfNCZt8RHJOJcehUbHX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YQql5i/3emlc31HCdbmnJ2+yE5afMTxpcP3mgSF+bdESev2k+GDpes7HE3MiAc8ka
	 dreLkBcHuEKiPo6api9kVgEjNAR03Lk3K7hPThK5gsnILVLFO35IFb9Blgt6e9MC6y
	 mZdlRUoQPMZyG7o+UuPKxcDcYyLEHkgnY/k0WQJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 336/990] ata: libata-scsi: fix MODE SELECT field pointer for block descriptor length
Date: Wed, 25 Nov 2026 15:28:23 +0100
Message-ID: <20261125143829.959235330@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit a3e52dcf0fbaa1a103accef3e8861cdc250ee5d6 ]

ata_scsi_mode_select_xlat() only accepts MODE SELECT parameter lists
without block descriptors or with a single 8 byte block descriptor. For
any other BLOCK DESCRIPTOR LENGTH, it terminates the command with
INVALID FIELD IN PARAMETER LIST, and the FIELD POINTER should point at
the BLOCK DESCRIPTOR LENGTH field, i.e. at byte 3 of the mode parameter
header(6) or at byte 6 of the mode parameter header(10), as SPC requires
the FIELD POINTER of a multiple-byte field to point at its first byte.

However, the mode parameter header length and the BLOCK DESCRIPTOR
LENGTH are added to the offset of the field, so the FIELD POINTER points
3 or 6 bytes after the end of the block descriptors instead. For
example, a MODE SELECT(10) with a BLOCK DESCRIPTOR LENGTH of 16 reports
byte 30 instead of byte 6.

Do not add the mode parameter header length and the BLOCK DESCRIPTOR
LENGTH to the offset of the BLOCK DESCRIPTOR LENGTH field.

Fixes: 7780081c1f04 ("libata-scsi: Set information sense field for invalid parameter")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20261103205448.931471-15-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index ce85f1dc69569..e408071208018 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4302,7 +4302,6 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 		goto invalid_param_len;
 	if (bd_len != 0 && bd_len != 8) {
 		fp = (six_byte) ? 3 : 6;
-		fp += bd_len + hdr_len;
 		goto invalid_param;
 	}
 
-- 
2.53.0



