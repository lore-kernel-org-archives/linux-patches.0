Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0374D2EA168;
	Tue, 22 Jul 2025 14:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193330; cv=none; b=Fn18bSftX5aWJOWj4UzZUeFXzvD9O10378JolLYepUC+YdTdRf+lUseAzBJL/adkYut2L8P6n2ipJuDA4Q4Z8Ln2I0nX0mh4XU8OD18K1QTeBFK9REqmf3R06dBFDsSzoQQdCuNs5VZGtX1xKv9LoxN6n2YP9s5PTTd9tJopRxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193330; c=relaxed/simple;
	bh=i9i5iVfxChQUOii5fR19u7sl6VXN9j1npg8FDggYaFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fL2Jv9+Ai7Z+H1wsTn64rHy8nf+QNbXh5AkeInGgqbKQ34Zl6enmZAh1Cil7bb4MEVs/j0lgJxPkxD1jp6e680cphJFFGl2wX9eU8/Rrvo3HSSGBssMCEv9kUIyRvDn8nOQfeFpHYY9qJHZvs1RBcoE8+b4GZoC2COnLd7y0Fjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Ictcbov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Ictcbov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCFEC4CEEB;
	Tue, 22 Jul 2025 14:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193329;
	bh=i9i5iVfxChQUOii5fR19u7sl6VXN9j1npg8FDggYaFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Ictcbov6+p94TbYSCenmbe9H07kJIDiuEduMNKxoS5lkgvMuh1g8pGBvLjTcJRC3
	 f9cdkDa9yCXfJyzz0KmQRoMclIaAAULhqnrqJAXHPAcobLnhRmb0N+CH6cI8oYzlry
	 /B77DgrxtMJI5G/2SBfYKfV/sBQB54OkQN8GiW2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sean Rhodes <sean@starlabs.systems>
Subject: [PATCH 6.15 059/187] Bluetooth: btintel: Check if controller is ISO capable on btintel_classify_pkt_type
Date: Tue, 22 Jul 2025 15:43:49 +0200
Message-ID: <20250722134347.958060874@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 6ec3185fbc3528f2284c347fb9bd8be6fa672ed4 upstream.

Due to what seem to be a bug with variant version returned by some
firmwares the code may set hdev->classify_pkt_type with
btintel_classify_pkt_type when in fact the controller doesn't even
support ISO channels feature but may use the handle range expected from
a controllers that does causing the packets to be reclassified as ISO
causing several bugs.

To fix the above btintel_classify_pkt_type will attempt to check if the
controller really supports ISO channels and in case it doesn't don't
reclassify even if the handle range is considered to be ISO, this is
considered safer than trying to fix the specific controller/firmware
version as that could change over time and causing similar problems in
the future.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=219553
Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2100565
Link: https://github.com/StarLabsLtd/firmware/issues/180
Fixes: f25b7fd36cc3 ("Bluetooth: Add vendor-specific packet classification for ISO data")
Cc: stable@vger.kernel.org
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Tested-by: Sean Rhodes <sean@starlabs.systems>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btintel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -2670,7 +2670,7 @@ static u8 btintel_classify_pkt_type(stru
 	 * Distinguish ISO data packets form ACL data packets
 	 * based on their connection handle value range.
 	 */
-	if (hci_skb_pkt_type(skb) == HCI_ACLDATA_PKT) {
+	if (iso_capable(hdev) && hci_skb_pkt_type(skb) == HCI_ACLDATA_PKT) {
 		__u16 handle = __le16_to_cpu(hci_acl_hdr(skb)->handle);
 
 		if (hci_handle(handle) >= BTINTEL_ISODATA_HANDLE_BASE)


