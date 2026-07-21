Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5528472557;
	Tue, 21 Jul 2026 17:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656697; cv=none; b=BnCswdDRfAj88G/iHN0HPMZUa/dzWY74+ZLv4xEF41nhBFHu6McetuiNvJFOk5DF9ue3jBgz34JYFbsc7Mn/iUfjPmEhFyJlZq52qWZEbxBtRu6BM6r3OvqquvfFMoKj+y/xXllxdH3Rs4150i25JJCI7SE8dEPRRkSC1Jrz1vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656697; c=relaxed/simple;
	bh=Jb4uD89IX1WfH2o01TBqs9Cml0qyoAo9OgLklYHRnVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/wi6AQnPr5VxMMwFz5ZJbNzqrAMgjvKOmvv06TgGF/aq5wsJuXZXzCkwQUSwJ/O1l4ppMYhvut4OEDREW3zFYiHU2kgaSsqG7r+HIGVJHOfS2oE+x6y2cxbJMzV/WECsmUjkUwccbK2kBJBouI/fb/PO+DShlKE7V3ukQLP++U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KYppJ13q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KYppJ13q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C128E1F00A3A;
	Tue, 21 Jul 2026 17:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656692;
	bh=aFRAAh4U1oJabCfQQgjjytTztHifFpQoPziJc3gVz/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KYppJ13qYYJQq0ele7OnWlycF04Ij/Rux4umfi318I+PJePYLTDd+sXlshEy1jhgH
	 r6NEZ/W3uFUoCIAn6KoikGI6VDE58JGA/3x6opsz4WjMvrCOH4v6/0PUBNGCv94lc7
	 4xSGJpEw87rcoEWh97pFJ2OJJNqHITpgPSEcOgOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0466/1611] Bluetooth: eir: Fix stack OOB write when prepending the Flags AD
Date: Tue, 21 Jul 2026 17:09:42 +0200
Message-ID: <20260721152525.797847983@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



