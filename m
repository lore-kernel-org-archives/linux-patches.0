Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551E538AC9A;
	Sat, 12 Sep 2026 13:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220365; cv=none; b=Ahuu6giKMgIyJMmtqjQPJZy52ctDRUvMvlyiv9ZGWy2vokQW145/2rkT4HoTnMHFlE8dDIQr3OANbsSwf4JED7gVFWmOzMs72nsgJoQ5TWsnMN9nvekGiW0exdCTkk4ebj/Wt6+MfrxlfGCjn+v3do6KXQDFH3cjHFP/BGLayK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220365; c=relaxed/simple;
	bh=YmGwG8xmnMReG+/If443BV89hwQMtMqNb5O/vBAkJYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGxIIcwFTzsJa1va0JV7mij0ZMGnn0aIbKH1M0y2axP03zoRTIICfoFMlfu+BMzlSBevjK/vwxgvhRXRYeqS0OYsV/i0LKfoumqiCHv3fg0MAYlDAuMvdJw7UDlUwi8T5agkBcyA393bEbd0AnWF8CVI5sSmeCSwKxWBN6Gi7wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sIBl01dY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sIBl01dY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289141F000FF;
	Sat, 12 Sep 2026 13:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220364;
	bh=Tnpf3EdvPV+5ArFQWhRsAe92hQ1m3nCqOGblqfHcUlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sIBl01dYuZaZ4DQmNVDjVgQkv48l8nRcILxu0TVPcz/FqJxUxsp5AMQ8eeqnn90i+
	 e2S9xF4Z0kvV2vzbYl2BS71VxhoDyE+GSfcSeNFEr+wrWwUWxzkJI/I0Ngpa0AKU8x
	 6vF6eS/PsbiFMlbq3CgjuDNijQ7Xr36RX7y2823o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 0120/1424] Bluetooth: eir: Fix OOB read in eir_get_service_data()
Date: Sat, 12 Sep 2026 08:42:32 +0200
Message-ID: <20260912065609.990001234@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

commit 4beb198bc59b242404a47c21990bc84165052c8a upstream.

eir_get_service_data() walks the advertising data for a Service Data
field with a matching UUID.  On a mismatch it advances:

    eir += dlen;
    eir_len -= dlen;

eir_get_data() reports dlen as the field's data length, but the field
spans dlen + 2 bytes once its length and type bytes count, and more
when non-Service-Data fields were skipped to reach it.  The pointer
lands correctly on the next field.  eir_len does not, and the shortfall
compounds across fields until eir_get_data() reads the length and type
bytes of a "field" past the end of the buffer.

For an ISO broadcast sink that buffer is hcon->le_per_adv_data[], filled
from the periodic advertising reports of a remote broadcaster.  A PA
payload packed with mismatching Service Data fields walks off the array
into the rest of struct hci_conn.  A drifted field that matches the BAA
UUID puts those bytes in iso_pi(sk)->base, where user space reads them
back with getsockopt(BT_ISO_BASE).

Recompute eir_len from the end of the buffer each iteration.

Fixes: 8f9ae5b3ae80 ("Bluetooth: eir: Add helpers for managing service data")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/eir.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/bluetooth/eir.c
+++ b/net/bluetooth/eir.c
@@ -366,6 +366,7 @@ u8 eir_create_scan_rsp(struct hci_dev *h
 
 void *eir_get_service_data(u8 *eir, size_t eir_len, u16 uuid, size_t *len)
 {
+	const u8 *eir_end = eir + eir_len;
 	size_t dlen;
 
 	while ((eir = eir_get_data(eir, eir_len, EIR_SERVICE_DATA, &dlen))) {
@@ -378,7 +379,7 @@ void *eir_get_service_data(u8 *eir, size
 		}
 
 		eir += dlen;
-		eir_len -= dlen;
+		eir_len = eir_end - eir;
 	}
 
 	return NULL;


