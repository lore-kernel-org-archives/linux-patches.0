Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B43535CB60;
	Fri,  7 Aug 2026 15:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115967; cv=none; b=LcYk04PogP6XDvNXGok+Vf4deH+08PwT8vdJ3HFSJ6knq1AQhH+IMwNUV/v3OIiOaRjXW4cFcwiu8ZFF0VWnUi6Ne0Z4FMKOJfVxBgqcMpZhPyQGJaPfmSXnDILARF41I4IktbZFN3m+qQEc1siuZsDlDiwpQw/CNtFHEMlnZIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115967; c=relaxed/simple;
	bh=wY3uqxZb9+hYjlSVY3hu9AANkqnFIc9uZPIl0i2jZoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7lTUkancb7rgE/HrUGcRnre/Z/4zIQbTTKbfd10eAfTvYPW4zbnCq686t1gTX2g6VIt5F1kI5/NFjHKf0MOKI9H8sjDD3sJ4SS+Fkqnm5R3reeFoWkCIXV3yQnuH1QCe/KeugysPxe8Mw4tcY9Kx23epiYdZZ78SpxY593SSDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/i4QmHY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/i4QmHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877F51F00A3A;
	Fri,  7 Aug 2026 15:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115966;
	bh=FrNFU1h7TURcC3PwAF8X8iE3ZLXmsTpuWFymzPWkP9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F/i4QmHYjbjDaMmrmGWKt7ga8m1dtbnFRA/sH69AK+xztjX7Iosim+0zWgg42BCPk
	 82IkMsVHCtrUziiPY1dAprPvOt+Q3ok06bx94YX8JEcearujF+yKJOcfbShBijd0gF
	 IC99EiSS26s5wrMyTad/Dx2esptrQCrVcNQw/qXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/261] Bluetooth: ISO: clear iso_data always when detaching conn from hcon
Date: Fri,  7 Aug 2026 16:37:00 +0200
Message-ID: <20260807143416.743472609@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit d57e506f6a1e3929611340fae87c1e4823f4d85c ]

When setting conn->hcon = NULL, also conn->hcon->iso_data = NULL is
necessary, otherwise later iso_conn_free() will UAF.

Fix clearing of iso_data in iso_sock_disconn()

Fixes KASAN: slab-use-after-free in iso_conn_hold_unless_zero on
iso_sock_release() followed by hci_abort_conn_sync().

Fixes: fbdc4bc47268 ("Bluetooth: ISO: Use defer setup to separate PA sync and BIG sync")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 189b719669924..51d0065f058c1 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -767,6 +767,7 @@ static void iso_sock_disconn(struct sock *sk)
 	iso_sock_set_timer(sk, ISO_DISCONN_TIMEOUT);
 	iso_conn_lock(iso_pi(sk)->conn);
 	hci_conn_drop(iso_pi(sk)->conn->hcon);
+	iso_pi(sk)->conn->hcon->iso_data = NULL;
 	iso_pi(sk)->conn->hcon = NULL;
 	iso_conn_unlock(iso_pi(sk)->conn);
 }
-- 
2.53.0



