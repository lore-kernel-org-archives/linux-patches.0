Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990CF368D40;
	Tue, 21 Jul 2026 19:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662112; cv=none; b=p2pwf/8lfhHKxbkki/2qui0AaxEBA8Qfkxks8xYubSfacqYv6dXuGmwFiSvZfLfDiJSq0i+e4b+S+sL72eKTcL/EgE/CvYb8cwWvxlCgiYy8PjSfvCKgN2YK/hhWZDbqQ6ZFkrGTf9JcNbaKmVVUekCPoBAp1gVnsYIY/yDRe7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662112; c=relaxed/simple;
	bh=GGzHSKlPR2vwWUXFOoGs6WEIc8cdJkwwo21HUZ6cKhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1rGsrIb4pZ5PDJ1daCTnXB29qKYnX1I3uLrxkkoNwoj3/D5K42aRvkWU5nTYdqiwocrqrt259w4lTsOxoalJhOiakYaCm/d7xbslK9FA71W4K2+Mm0Fis/Ds24e3QJgmz2bQwXHQoQg1CJsInD5RtJuGEy5iLXL8rOm49H6gs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=icNL6rGT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="icNL6rGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE9F1F00A3A;
	Tue, 21 Jul 2026 19:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662111;
	bh=Rjg4R6+WN4D1BBp1ddTS/fF3fAGxnS7MBf5W/5YUQa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=icNL6rGTKTOSs4wKk7zI4FP2Q8KURsinYd2nuG50Xdp1EV6h/ABxFzD/qCpi9lqeB
	 8Qj+MJmdMW9LKXhvkG902gP52Jey9GRDqMliMPNGKgy8A2s+mzgRT+G0Y694LkrHnw
	 mlkj/y7U36/H/DJuah8OBijqUb3NqjPs/TqMgg3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0319/1276] Bluetooth: eir: Fix stack OOB write when prepending the Flags AD
Date: Tue, 21 Jul 2026 17:12:42 +0200
Message-ID: <20260721152453.236161655@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 6f5fb689fdf80bdd143f22a502f9eb1f3c85e286 ]

eir_create_adv_data() builds the advertising data into a fixed-size
buffer ("size", 31 for the legacy path). It may prepend a 3-byte "Flags"
AD structure (LE_AD_NO_BREDR on an LE-only controller) and then copies
the per-instance data without checking that it still fits:

	memcpy(ptr, adv->adv_data, adv->adv_data_len);

tlv_data_max_len() only reserves those 3 bytes when the user-supplied
flags carry a managed-flags bit, so an instance added with flags == 0 is
accepted with adv_data_len up to the full buffer. At advertise time the
flags are still prepended, and the memcpy() writes 3 + adv_data_len
bytes into the size-byte buffer:

  BUG: KASAN: stack-out-of-bounds in eir_create_adv_data (net/bluetooth/eir.c:301)
  Write of size 31 at addr ffff88800a547bdc by task kworker/u9:0/65
  Workqueue: hci0 hci_cmd_sync_work
   __asan_memcpy (mm/kasan/shadow.c:106)
   eir_create_adv_data (net/bluetooth/eir.c:301)
   hci_update_adv_data_sync (net/bluetooth/hci_sync.c:1310)
   hci_schedule_adv_instance_sync (net/bluetooth/hci_sync.c:1817)
   hci_cmd_sync_work (net/bluetooth/hci_sync.c:332)
  This frame has 1 object:
   [32, 64) 'cp'

The "Flags" structure is added by the kernel, not requested by
userspace, so only prepend it when it fits together with the instance
advertising data; when there is no room for both, drop the flags rather
than the user-provided data.

Reachable by a local user with CAP_NET_ADMIN owning an LE-only
controller on the legacy advertising path.

Fixes: b44133ff03be ("Bluetooth: Support the "discoverable" adv flag")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/eir.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/eir.c b/net/bluetooth/eir.c
index 3f72111ba651f9..1de5f9df6eec00 100644
--- a/net/bluetooth/eir.c
+++ b/net/bluetooth/eir.c
@@ -283,10 +283,12 @@ u8 eir_create_adv_data(struct hci_dev *hdev, u8 instance, u8 *ptr, u8 size)
 		if (!flags)
 			flags |= mgmt_get_adv_discov_flags(hdev);
 
-		/* If flags would still be empty, then there is no need to
-		 * include the "Flags" AD field".
+		/* Only add the "Flags" if it fits together with the instance
+		 * advertising data; drop it rather than overflow the buffer.
 		 */
-		if (flags && (ad_len + eir_precalc_len(1) <= size)) {
+		if (flags &&
+		    (ad_len + eir_precalc_len(1) +
+		     (adv ? adv->adv_data_len : 0) <= size)) {
 			ptr[0] = 0x02;
 			ptr[1] = EIR_FLAGS;
 			ptr[2] = flags;
-- 
2.53.0



