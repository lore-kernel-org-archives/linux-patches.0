Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213714;
	b=FPHvgWBEdnq3td8eFLm7nP2zXWShPxVEeovS1dqdemCTHLJ0j8JACh/3+z2a6ONONhOe
	 rAPP9QIBxcuDHnbZ6922fvEBuFH6TBYqc+aQIpsnlc9s9fWPXa7P4u5MkNejVbsQl3W9M
	 qzGmaVGqMmQqXxPBTXC4YxUfvK3knZrKzcRgTg8o5AzkXscUJdOx4rzTFHqAP8gIRUy0g
	 H8YJJ2zghngFj6HSEBfd72cDo1OJKGItlPKYFxsBoHBMG93IeGdx1oIKeZx6G3xvx9saP
	 dZkEydKkJyRIKPSY6lEXFI9rTxfhRStKuTfUUmBj87dtiLgPQkbdQyKCA+1C6WkvpxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213714;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hf/HQlORiu9HgssmWnn6xaMbhxifVSmE8caMFW4MMs0=;
	b=J8QI2m4U24jap7R9PF9ziFlrDw6J19SAyF3Z8ep9+1f5KQwwAGcgIJJRr4XzglpZN4ps
	 2a3v4nLb6nV5gz7T7ARk4+L8Ef2eYpsCrcMmbsN51WFe7x0CNS6BjG3CeG/31Kq9KjWN+
	 uGaek9c/h0cK/abPMUyWoc/zUq+nx4B3ImqRFvV6FLo81VRa3PwgQs00QUXArTbkMwXyV
	 JnSTUH2rWiUF5grbz2WMNjpluk84R9VovBH19jI0xJG1BEJucYcvfnR/YOTqeCXTS03Wz
	 xK6P224oY2GvSs+fkBzn2EEmkMA4dwy4ds4Y/xD4ZR6Er32iOKOInY+xiQAP+ZStMjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g09rZh+F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDB7606A31A;
	Wed, 28 Oct 2026 18:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g09rZh+F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2421F01825;
	Wed, 28 Oct 2026 18:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213713;
	bh=Hf/HQlORiu9HgssmWnn6xaMbhxifVSmE8caMFW4MMs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g09rZh+FlsAneRqOPJV8cKd5oJjN9344mkS099P5GZ7nPpSFs7YeqDrbFmygt9vim
	 +PXGiWnURC2ztZVVa49c414fUPoS3AiMmPzGhsqTiYT9HKEAB/kKJ2JPvhM4NH76iD
	 rpUqwO6GV1D4HBb8iMqCFZDrXCaErFXnNVi76di0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0603/1887] nouveau: lock the client object tree.
Date: Wed, 28 Oct 2026 17:44:59 +0100
Message-ID: <20261028170513.138805529@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Transfer-Encoding: quoted-printable

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

[ Upstream commit b7cc4ff787a572edf2c55caeffaa88cd801eb135 ]

It appears the client object tree has no locking unless I've missed
something else. Fix races around adding/removing client objects,
mostly vram bar mappings.

 4562.099306] general protection fault, probably for non-canonical address =
0x6677ed422bceb80c: 0000 [#1] PREEMPT SMP PTI
[ 4562.099314] CPU: 2 PID: 23171 Comm: deqp-vk Not tainted 6.8.0-rc6+ #27
[ 4562.099324] Hardware name: Gigabyte Technology Co., Ltd. Z390 I AORUS PR=
O WIFI/Z390 I AORUS PRO WIFI-CF, BIOS F8 11/05/2021
[ 4562.099330] RIP: 0010:nvkm_object_search+0x1d/0x70 [nouveau]
[ 4562.099503] Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f 1f 00 0f =
1f 44 00 00 48 89 f8 48 85 f6 74 39 48 8b 87 a0 00 00 00 48 85 c0 74 12 <48=
> 8b 48 f8 48 39 ce 73 15 48 8b 40 10 48 85 c0 75 ee 48 c7 c0 fe
[ 4562.099506] RSP: 0000:ffffa94cc420bbf8 EFLAGS: 00010206
[ 4562.099512] RAX: 6677ed422bceb814 RBX: ffff98108791f400 RCX: ffff9810f26=
b8f58
[ 4562.099517] RDX: 0000000000000000 RSI: ffff9810f26b9158 RDI: ffff9810879=
1f400
[ 4562.099519] RBP: ffff9810f26b9158 R08: 0000000000000000 R09: 00000000000=
00000
[ 4562.099521] R10: ffffa94cc420bc48 R11: 0000000000000001 R12: ffff9810f02=
a7cc0
[ 4562.099526] R13: 0000000000000000 R14: 00000000000000ff R15: 00000000000=
00007
[ 4562.099528] FS:  00007f629c5017c0(0000) GS:ffff98142c700000(0000) knlGS:=
0000000000000000
[ 4562.099534] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4562.099536] CR2: 00007f629a882000 CR3: 000000017019e004 CR4: 00000000003=
706f0
[ 4562.099541] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[ 4562.099542] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[ 4562.099544] Call Trace:
[ 4562.099555]  <TASK>
[ 4562.099573]  ? die_addr+0x36/0x90
[ 4562.099583]  ? exc_general_protection+0x246/0x4a0
[ 4562.099593]  ? asm_exc_general_protection+0x26/0x30
[ 4562.099600]  ? nvkm_object_search+0x1d/0x70 [nouveau]
[ 4562.099730]  nvkm_ioctl+0xa1/0x250 [nouveau]
[ 4562.099861]  nvif_object_map_handle+0xc8/0x180 [nouveau]
[ 4562.099986]  nouveau_ttm_io_mem_reserve+0x122/0x270 [nouveau]
[ 4562.100156]  ? dma_resv_test_signaled+0x26/0xb0
[ 4562.100163]  ttm_bo_vm_fault_reserved+0x97/0x3c0 [ttm]
[ 4562.100182]  ? __mutex_unlock_slowpath+0x2a/0x270
[ 4562.100189]  nouveau_ttm_fault+0x69/0xb0 [nouveau]
[ 4562.100356]  __do_fault+0x32/0x150
[ 4562.100362]  do_fault+0x7c/0x560
[ 4562.100369]  __handle_mm_fault+0x800/0xc10
[ 4562.100382]  handle_mm_fault+0x17c/0x3e0
[ 4562.100388]  do_user_addr_fault+0x208/0x860
[ 4562.100395]  exc_page_fault+0x7f/0x200
[ 4562.100402]  asm_exc_page_fault+0x26/0x30
[ 4562.100412] RIP: 0033:0x9b9870
[ 4562.100419] Code: 85 a8 f7 ff ff 8b 8d 80 f7 ff ff 89 08 e9 18 f2 ff ff =
0f 1f 84 00 00 00 00 00 44 89 32 e9 90 fa ff ff 0f 1f 84 00 00 00 00 00 <44=
> 89 32 e9 f8 f1 ff ff 0f 1f 84 00 00 00 00 00 66 44 89 32 e9 e7
[ 4562.100422] RSP: 002b:00007fff9ba2dc70 EFLAGS: 00010246
[ 4562.100426] RAX: 0000000000000004 RBX: 000000000dd65e10 RCX: 000000fff00=
00000
[ 4562.100428] RDX: 00007f629a882000 RSI: 00007f629a882000 RDI: 00000000000=
00066
[ 4562.100432] RBP: 00007fff9ba2e570 R08: 0000000000000000 R09: 0000000123d=
df000
[ 4562.100434] R10: 0000000000000001 R11: 0000000000000246 R12: 000000007ff=
fffff
[ 4562.100436] R13: 0000000000000000 R14: 0000000000000000 R15: 00000000000=
00000
[ 4562.100446]  </TASK>
[ 4562.100448] Modules linked in: nf_conntrack_netbios_ns nf_conntrack_broa=
dcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_rej=
ect_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack=
 nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables libcrc32c nfnetlink cmac bn=
ep sunrpc iwlmvm intel_rapl_msr intel_rapl_common snd_sof_pci_intel_cnl x86=
_pkg_temp_thermal intel_powerclamp snd_sof_intel_hda_common mac80211 corete=
mp snd_soc_acpi_intel_match kvm_intel snd_soc_acpi snd_soc_hdac_hda snd_sof=
_pci snd_sof_xtensa_dsp snd_sof_intel_hda_mlink snd_sof_intel_hda snd_sof k=
vm snd_sof_utils snd_soc_core snd_hda_codec_realtek libarc4 snd_hda_codec_g=
eneric snd_compress snd_hda_ext_core vfat fat snd_hda_intel snd_intel_dspcf=
g irqbypass iwlwifi snd_hda_codec snd_hwdep snd_hda_core btusb btrtl mei_hd=
cp iTCO_wdt rapl mei_pxp btintel snd_seq iTCO_vendor_support btbcm snd_seq_=
device intel_cstate bluetooth snd_pcm cfg80211 intel_wmi_thunderbolt wmi_bm=
of intel_uncore snd_timer mei_me snd ecdh_generic i2c_i801
[ 4562.100541]  ecc mei i2c_smbus soundcore rfkill intel_pch_thermal acpi_p=
ad zram nouveau drm_ttm_helper ttm gpu_sched i2c_algo_bit drm_gpuvm drm_exe=
c mxm_wmi drm_display_helper drm_kms_helper drm crct10dif_pclmul crc32_pclm=
ul nvme e1000e crc32c_intel nvme_core ghash_clmulni_intel video wmi pinctrl=
_cannonlake ip6_tables ip_tables fuse
[ 4562.100616] ---[ end trace 0000000000000000 ]---

Signed-off-by: Dave Airlie <airlied@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/nouveau/include/nvkm/core/client.h    |  1 +
 drivers/gpu/drm/nouveau/nvkm/core/client.c    |  1 +
 drivers/gpu/drm/nouveau/nvkm/core/object.c    | 26 ++++++++++++++-----
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/include/nvkm/core/client.h b/drivers/g=
pu/drm/nouveau/include/nvkm/core/client.h
index 2f86606e708c9..e0d79bb7a1d8b 100644
--- a/drivers/gpu/drm/nouveau/include/nvkm/core/client.h
+++ b/drivers/gpu/drm/nouveau/include/nvkm/core/client.h
@@ -12,6 +12,7 @@ struct nvkm_client {
=20
 	struct nvkm_client_notify *notify[32];
 	struct rb_root objroot;
+	spinlock_t obj_lock;
=20
 	void *data;
 	int (*ntfy)(const void *, u32, const void *, u32);
diff --git a/drivers/gpu/drm/nouveau/nvkm/core/client.c b/drivers/gpu/drm/n=
ouveau/nvkm/core/client.c
index 0c8c55c73b122..db96699c5b2bd 100644
--- a/drivers/gpu/drm/nouveau/nvkm/core/client.c
+++ b/drivers/gpu/drm/nouveau/nvkm/core/client.c
@@ -300,6 +300,7 @@ nvkm_client_new(const char *name, u64 device, const cha=
r *cfg,
 	client->device =3D device;
 	client->debug =3D nvkm_dbgopt(dbg, "CLIENT");
 	client->objroot =3D RB_ROOT;
+	spin_lock_init(&client->obj_lock);
 	client->ntfy =3D ntfy;
 	INIT_LIST_HEAD(&client->umem);
 	spin_lock_init(&client->lock);
diff --git a/drivers/gpu/drm/nouveau/nvkm/core/object.c b/drivers/gpu/drm/n=
ouveau/nvkm/core/object.c
index 301a5e5b5f7f9..4c038d5715b92 100644
--- a/drivers/gpu/drm/nouveau/nvkm/core/object.c
+++ b/drivers/gpu/drm/nouveau/nvkm/core/object.c
@@ -30,8 +30,10 @@ nvkm_object_search(struct nvkm_client *client, u64 handl=
e,
 		   const struct nvkm_object_func *func)
 {
 	struct nvkm_object *object;
+	unsigned long flags;
=20
 	if (handle) {
+		spin_lock_irqsave(&client->obj_lock, flags);
 		struct rb_node *node =3D client->objroot.rb_node;
 		while (node) {
 			object =3D rb_entry(node, typeof(*object), node);
@@ -40,9 +42,12 @@ nvkm_object_search(struct nvkm_client *client, u64 handl=
e,
 			else
 			if (handle > object->object)
 				node =3D node->rb_right;
-			else
+			else {
+				spin_unlock_irqrestore(&client->obj_lock, flags);
 				goto done;
+			}
 		}
+		spin_unlock_irqrestore(&client->obj_lock, flags);
 		return ERR_PTR(-ENOENT);
 	} else {
 		object =3D &client->object;
@@ -57,30 +62,39 @@ nvkm_object_search(struct nvkm_client *client, u64 hand=
le,
 void
 nvkm_object_remove(struct nvkm_object *object)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&object->client->obj_lock, flags);
 	if (!RB_EMPTY_NODE(&object->node))
 		rb_erase(&object->node, &object->client->objroot);
+	spin_unlock_irqrestore(&object->client->obj_lock, flags);
 }
=20
 bool
 nvkm_object_insert(struct nvkm_object *object)
 {
-	struct rb_node **ptr =3D &object->client->objroot.rb_node;
+	struct rb_node **ptr;
 	struct rb_node *parent =3D NULL;
+	unsigned long flags;
=20
+	spin_lock_irqsave(&object->client->obj_lock, flags);
+	ptr =3D &object->client->objroot.rb_node;
 	while (*ptr) {
 		struct nvkm_object *this =3D rb_entry(*ptr, typeof(*this), node);
 		parent =3D *ptr;
-		if (object->object < this->object)
+		if (object->object < this->object) {
 			ptr =3D &parent->rb_left;
-		else
-		if (object->object > this->object)
+		} else if (object->object > this->object) {
 			ptr =3D &parent->rb_right;
-		else
+		} else {
+			spin_unlock_irqrestore(&object->client->obj_lock, flags);
 			return false;
+		}
 	}
=20
 	rb_link_node(&object->node, parent, ptr);
 	rb_insert_color(&object->node, &object->client->objroot);
+	spin_unlock_irqrestore(&object->client->obj_lock, flags);
 	return true;
 }
=20
--=20
2.53.0



