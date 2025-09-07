Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F22D4315A;
	Sun,  7 Sep 2025 20:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277612; cv=none; b=oHIGT6qpZBd60t/d2BZ06QLstpzrBfyuomMwt9pAfWX0ndY9sFSAP+PKqE1sU98Q//HxyJzKJRXm8XySWmEiv5ULyNeZXNiOzhpHojLb7I+17FXs/Sgx4AjQnCqKuXV/CHSeHVBbL0BZTEno4czU5GTlX7OeRVFoZbzsW0p1LxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277612; c=relaxed/simple;
	bh=ho54NgqyZjkjWOoRUaTPB2T5rQ8iNQNyysN3GaJOcVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PR8HeSojkDFEgoOP/HDnlol2ZhI6SUMgnxz7TCGOaABzvhME6TudcM0Cm00/WsWPh4JTYt30BHG6AZpnmVuU6YdNcDmgG4mGYHgMPa0RcVvyNSwBEEflqhfuO//hdgCnH4jOlfEFtskNHquG8Xn9A6PQNIEbID+gPPTPSYwVfxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fDRuKs2/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fDRuKs2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1845CC4CEF0;
	Sun,  7 Sep 2025 20:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277612;
	bh=ho54NgqyZjkjWOoRUaTPB2T5rQ8iNQNyysN3GaJOcVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fDRuKs2/f9PQEvEpYWWoDc29mOYe4HOIbr8lLscSR9/zofRP+Xxy29kTKdw1Hpz9q
	 FfvhhaBCAAIP1DtNYaW4+dJ3ZqEakY6jaSClCKD1Wx+7M65Stsz1dY6iHna52qkW7x
	 iZynakJLA20GqGXT/WKplcgldgIo6Q5NRMd/zR+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Liu <jianliu@redhat.com>,
	Emil Tantilov <emil.s.tantilov@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Simon Horman <horms@kernel.org>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 067/183] idpf: set mac type when adding and removing MAC filters
Date: Sun,  7 Sep 2025 21:58:14 +0200
Message-ID: <20250907195617.386542393@linuxfoundation.org>
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

From: Emil Tantilov <emil.s.tantilov@intel.com>

[ Upstream commit acf3a5c8be80fe238c1a7629db1c21c74a1f9dd4 ]

On control planes that allow changing the MAC address of the interface,
the driver must provide a MAC type to avoid errors such as:

idpf 0000:0a:00.0: Transaction failed (op 535)
idpf 0000:0a:00.0: Received invalid MAC filter payload (op 535) (len 0)
idpf 0000:0a:00.0: Transaction failed (op 536)

These errors occur during driver load or when changing the MAC via:
ip link set <iface> address <mac>

Add logic to set the MAC type when sending ADD/DEL (opcodes 535/536) to
the control plane. Since only one primary MAC is supported per vport, the
driver only needs to send an ADD opcode when setting it. Remove the old
address by calling __idpf_del_mac_filter(), which skips the message and
just clears the entry from the internal list. This avoids an error on DEL
as it attempts to remove an address already cleared by the preceding ADD
opcode.

Fixes: ce1b75d0635c ("idpf: add ptypes and MAC filter support")
Reported-by: Jian Liu <jianliu@redhat.com>
Signed-off-by: Emil Tantilov <emil.s.tantilov@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_lib.c      |  9 ++++++---
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c | 12 ++++++++++++
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index e9f8da9f7979b..5fc6147ecd93c 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -2277,6 +2277,7 @@ static int idpf_set_mac(struct net_device *netdev, void *p)
 	struct idpf_netdev_priv *np = netdev_priv(netdev);
 	struct idpf_vport_config *vport_config;
 	struct sockaddr *addr = p;
+	u8 old_mac_addr[ETH_ALEN];
 	struct idpf_vport *vport;
 	int err = 0;
 
@@ -2300,17 +2301,19 @@ static int idpf_set_mac(struct net_device *netdev, void *p)
 	if (ether_addr_equal(netdev->dev_addr, addr->sa_data))
 		goto unlock_mutex;
 
+	ether_addr_copy(old_mac_addr, vport->default_mac_addr);
+	ether_addr_copy(vport->default_mac_addr, addr->sa_data);
 	vport_config = vport->adapter->vport_config[vport->idx];
 	err = idpf_add_mac_filter(vport, np, addr->sa_data, false);
 	if (err) {
 		__idpf_del_mac_filter(vport_config, addr->sa_data);
+		ether_addr_copy(vport->default_mac_addr, netdev->dev_addr);
 		goto unlock_mutex;
 	}
 
-	if (is_valid_ether_addr(vport->default_mac_addr))
-		idpf_del_mac_filter(vport, np, vport->default_mac_addr, false);
+	if (is_valid_ether_addr(old_mac_addr))
+		__idpf_del_mac_filter(vport_config, old_mac_addr);
 
-	ether_addr_copy(vport->default_mac_addr, addr->sa_data);
 	eth_hw_addr_set(netdev, addr->sa_data);
 
 unlock_mutex:
diff --git a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
index 24febaaa8fbb8..cb9a27307670e 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
@@ -3507,6 +3507,16 @@ u32 idpf_get_vport_id(struct idpf_vport *vport)
 	return le32_to_cpu(vport_msg->vport_id);
 }
 
+static void idpf_set_mac_type(struct idpf_vport *vport,
+			      struct virtchnl2_mac_addr *mac_addr)
+{
+	bool is_primary;
+
+	is_primary = ether_addr_equal(vport->default_mac_addr, mac_addr->addr);
+	mac_addr->type = is_primary ? VIRTCHNL2_MAC_ADDR_PRIMARY :
+				      VIRTCHNL2_MAC_ADDR_EXTRA;
+}
+
 /**
  * idpf_mac_filter_async_handler - Async callback for mac filters
  * @adapter: private data struct
@@ -3636,6 +3646,7 @@ int idpf_add_del_mac_filters(struct idpf_vport *vport,
 			    list) {
 		if (add && f->add) {
 			ether_addr_copy(mac_addr[i].addr, f->macaddr);
+			idpf_set_mac_type(vport, &mac_addr[i]);
 			i++;
 			f->add = false;
 			if (i == total_filters)
@@ -3643,6 +3654,7 @@ int idpf_add_del_mac_filters(struct idpf_vport *vport,
 		}
 		if (!add && f->remove) {
 			ether_addr_copy(mac_addr[i].addr, f->macaddr);
+			idpf_set_mac_type(vport, &mac_addr[i]);
 			i++;
 			f->remove = false;
 			if (i == total_filters)
-- 
2.50.1



