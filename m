Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE5C429CEE;
	Mon, 17 Aug 2026 13:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975169; cv=none; b=n0OzSDet2ISRJFa9YnyEf/2yOFM0LgITd+3aZqn+r36IiJTdfVPZDb6ygEEm0WGxZbQeyVdV43yvF3o4+4JGohRffBvqPSxt6+eXPUrqR+YLTjeV2IDyuoxXwFlmxda36zB9+f0eWfdr+6abZgyrwg7pSBlAMCWhv6bqclblQ0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975169; c=relaxed/simple;
	bh=cNKtEzggInuMGRTJg30A/yaflWClHwoEEfiltVer67Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JwctV0aYiHKSjy7Wz1X68D+Zaf9Q59FH/l1GqzHyl6SrgFzq/Rm1jwLB6f0bjTq4eobidGt/AxxRgyoKJ74eQf1ceNUAmpweeZ8/xIS0KL1Z03YCD2YZXOtfZfNDLv05tjvNQAg1IxccNqMflsYiIyk2LthyOC750Z+93mrf9QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CpoaZn3Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CpoaZn3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E162E1F000E9;
	Mon, 17 Aug 2026 13:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975168;
	bh=iJPAsvzaskKuMvypjE/nqkUj2ul26q4MBm9SJNYhlHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CpoaZn3ZMQFs0fVntdSBXO59UH4DmOs4mdo0uvHvHmkOWV0JI4jI2i0d+KyQ+YZPk
	 Xp8SwffVtrl0HYrq2hv4B270vckVeptzo3WnYDhxEfDqi5GPyhJxWw2bHPpR15hXWr
	 vPXh3lrKajGuogtOr/yjuFIZlOKGkO9O73EKb2WA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Baul Lee <baul.lee@xbow.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 185/250] ALSA: FCP: fix OOB write in fcp_meter_ctl_get()
Date: Mon, 17 Aug 2026 15:32:26 +0200
Message-ID: <20260817132544.143549916@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Baul Lee <baul.lee@xbow.com>

commit 620f1e52a46f604635efd0fb78138afd6a513b5d upstream.

fcp_ioctl_set_meter_map() bounds the user-supplied Level Meter map size
by the driver's own limit of 255

	if (map.map_size < 1 || map.map_size > 255 ||
	    map.meter_slots < 1 || map.meter_slots > 255)
		return -EINVAL;

and passes it to fcp_add_new_ctl() as the control's channel count, where
it is stored as elem->channels.

Every control read writes into struct snd_ctl_elem_value, whose integer
array is declared long value[128], so the limit is 128, not 255.
fcp_meter_ctl_get() stores one 64-bit word per channel into that array
with no bound of its own:

	for (i = 0; i < elem->channels; i++) {
		int idx = private->meter_level_map[i];
		int value = idx < 0 ? 0 : le32_to_cpu(resp[idx]);

		ucontrol->value.integer.value[i] = value;
	}

snd_ctl_elem_read_user() serves that object from
memdup_user(_control, sizeof(*control)), 1224 bytes on LP64 out of
kmalloc-2048.  offsetof(struct snd_ctl_elem_value, value) is 72, so
element i is written at byte 72 + 8 * i and element 144 already lands
past the allocation.  At map_size 255 the last store ends at byte 2112,
888 bytes past the object and 64 bytes into the adjacent slab object.
The stored words come from the device and meter_level_map[] selects
which word lands in which slot, so extent and contents are both
controlled.

The core does not catch this.  snd_ctl_check_elem_info() is reached only
from __snd_ctl_elem_info(), which snd_ctl_elem_read() calls under
CONFIG_SND_CTL_DEBUG; without that option snd_ctl_skip_validation() is a
compile-time true.  __snd_ctl_add_replace() validates kcontrol->count and
never inspects elem->channels.

Installing an oversized map needs CAP_SYS_RAWIO, but the control outlives
the hwdep descriptor that created it, so the out-of-bounds stores are
issued by any process able to read controls on /dev/snd/controlC0.

KASAN on 7.2.0-rc5 (arm64), triggered by an unprivileged control read:

  BUG: KASAN: slab-out-of-bounds in fcp_meter_ctl_get
  Write of size 8 at addr ffff000017af04c8 by task fcp_trigger/185
   __asan_store8
   fcp_meter_ctl_get
   snd_ctl_elem_read
   snd_ctl_ioctl
  Allocated by task 185:
   memdup_user
   snd_ctl_ioctl
  The buggy address is located 0 bytes to the right of
   allocated 1224-byte region [ffff000017af0000, ffff000017af04c8)

Bound the map size by the ABI limit rather than by 255, and bound the
store loop at the sink so it cannot run past the value array whatever
elem->channels holds.

Discovered by XBOW, triaged by Baul Lee <baul.lee@xbow.com>

Fixes: 46757a3e7d50 ("ALSA: FCP: Add Focusrite Control Protocol driver")
Reported-by: Federico Kirschbaum <federico.kirschbaum@xbow.com>
Reported-by: Baul Lee <baul.lee@xbow.com>
Cc: stable@vger.kernel.org
Signed-off-by: Baul Lee <baul.lee@xbow.com>
Link: https://patch.msgid.link/20260804123611.91715-1-baul.lee@xbow.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/fcp.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/sound/usb/fcp.c
+++ b/sound/usb/fcp.c
@@ -129,6 +129,10 @@ struct fcp_data {
 
 #define FCP_SEGMENT_APP_GOLD 0
 
+#define FCP_MAX_METER_MAP_SIZE \
+	(sizeof_field(struct snd_ctl_elem_value, value.integer.value) / \
+	 sizeof(long))
+
 /* Forward declarations */
 static int fcp_init(struct usb_mixer_interface *mixer,
 		    void *step0_resp, void *step2_resp);
@@ -409,6 +413,9 @@ static int fcp_meter_ctl_get(struct snd_
 	if (err < 0)
 		return err;
 
+	if (WARN_ON_ONCE(elem->channels > FCP_MAX_METER_MAP_SIZE))
+		return -EINVAL;
+
 	/* copy & translate from resp[] using meter_level_map[] */
 	for (i = 0; i < elem->channels; i++) {
 		int idx = private->meter_level_map[i];
@@ -636,7 +643,8 @@ static int fcp_ioctl_set_meter_map(struc
 	}
 
 	/* Validate the map size */
-	if (map.map_size < 1 || map.map_size > 255 ||
+	if (map.map_size < 1 ||
+	    map.map_size > FCP_MAX_METER_MAP_SIZE ||
 	    map.meter_slots < 1 || map.meter_slots > 255)
 		return -EINVAL;
 


