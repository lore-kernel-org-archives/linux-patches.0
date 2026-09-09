Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9316D568521;
	Wed,  9 Sep 2026 14:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963968; cv=none; b=t9KdlYgK+Uk6/qEP3r8fc1lxNQSanEhSqD6V0ow/UvVgZQgggdbY/UNlmV7Ct+wlckhuCHi197oa+H27GnqS8naghfzhQmijf3cH/tlaEblQmZ93Ni7ewWJjIsg8L5UFg6+zewKadXls3wc4BgWjjSIoG8dsbm5GJxhytBsJIHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963968; c=relaxed/simple;
	bh=YTBzqTQD8eJe2c3+vM5JvAXW7k5+6M3xVUPgTTDgxRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=haBClLim6irLSuaaYqoqRgsy4lPQOug7gFcSpd7na4VIwtxYBRN5mqoPNSust6HUQn8GosXheZkuPeWJz8/zdlMUzjS+075EsGb8N4ZqDeXkWa3BNej2WAc4njEdW+/m25BMQoKboOyZVOPVv+POHWsftXyZm3i8vN0QRmT+1Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kFpib0tA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kFpib0tA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86001F00A3A;
	Wed,  9 Sep 2026 14:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963967;
	bh=VODYAMehSHc2MyVQ+pABuQydwJwxNff3WgLYU9SxPyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kFpib0tAoa0aRgOhxSzbrEyZ6Em/Be8OorG0Lm55f16rJQogvrWhvOvIyXPYPgcLf
	 li5aqa53+/Lt9MtL0HfsOgmzUxdZCS8HpJHgIXwxqFr/5i3S56CMtmq0JNITF+PRiH
	 +/lf77UXPBb8EVT2G+s45bgCfOQ2xqWOIKWDWbI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 6.18 260/583] KVM: arm64: vgic-its: Dont dereference a NULL collection on ITT save
Date: Wed,  9 Sep 2026 15:39:05 +0200
Message-ID: <20260909134247.112281899@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Fuad Tabba <fuad.tabba@linux.dev>

commit c6c156d931c33b92362383cf76f6d6e1291dcbfe upstream.

MAPC with V=0 drops ite->collection but leaves the ITE on the device's
ITT list, and vgic_its_save_ite() dereferences it unconditionally. A
guest that issues MAPD, MAPTI and then MAPC(V=0) therefore oopses the
host when the VMM issues KVM_DEV_ARM_ITS_SAVE_TABLES to migrate it.
That sequence is UNPREDICTABLE per the architecture, but KVM already
handles the resulting state in the translate, MOVI and DISCARD paths.

Save a zeroed entry, which vgic_its_restore_ite() reads back as
invalid. Skipping the ITE instead would leave the ITT slot holding
whatever is in guest memory, and restore rejects an entry naming a
collection the restored collection table does not have.

Fixes: eff484e0298da ("KVM: arm64: vgic-its: ITT save and restore")
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20260807104102.2410744-2-fuad.tabba@linux.dev
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-its.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2112,6 +2112,14 @@ static int vgic_its_save_ite(struct vgic
 	u32 next_offset;
 	u64 val;
 
+	/*
+	 * MAPC with V=0 keeps the ITEs mapped but drops their collection,
+	 * and with it the ICID. Save a zeroed entry, which the restore path
+	 * reads back as invalid.
+	 */
+	if (!ite->collection)
+		return vgic_its_write_entry_lock(its, gpa, 0ULL, ite);
+
 	next_offset = compute_next_eventid_offset(&dev->itt_head, ite);
 	val = ((u64)next_offset << KVM_ITS_ITE_NEXT_SHIFT) |
 	       ((u64)ite->irq->intid << KVM_ITS_ITE_PINTID_SHIFT) |


