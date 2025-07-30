Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D5C1714B7;
	Wed, 30 Jul 2025 09:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868707; cv=none; b=Tol3ZY/6ebWeJ8noxZnXUCOtBU13yI8c8gx03VWT/1tWrrb3Xe0yCj2VYBFnGzSdH8Ty8jA65szJMqZf5hSfNDkeqzDok3cxv+aG8P7GUGT/2Vk44sGCgS/N3PFF8ci2q65YccvAn8815ytIFfny3Cge/F575Ic/gSbPefDQIMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868707; c=relaxed/simple;
	bh=OnQLw46G/mpdiZZBR4evvp2Exn9BcyJILdjShvaP+UM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YjLTPqDoqzIPwLo9+BNe257U1D9U+o+P/HW0IyEWpsxGYHKtTqiJXxIJSiGaEufhaUnCU2yYX4dT5WICA+rKmem+FN0iznpZJejdIxkYXutH49NMne8cqyyD+N7Z1l2Xr9hSq211jSGlZAqolJHpL2SCRvk+azageuQq8Q/kr78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YMLAJ2aV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YMLAJ2aV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465E5C4CEF5;
	Wed, 30 Jul 2025 09:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868707;
	bh=OnQLw46G/mpdiZZBR4evvp2Exn9BcyJILdjShvaP+UM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YMLAJ2aVcJHbxKA1ZVSNnsnvOXUjPdNLgTx3AUHgubLer0V4MPvpbsjskyIqAenic
	 TtCpnKlPoYio3ow3jOudVmhpn7pr7SeJr+cqAiup5v+lUPfDvcc7mmMWuvvAVzTzRF
	 XSr7J4opRjJ7mHN88Bo+ek39Q8ruSh9GbVAkpsmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacek Kowalski <jacek@jacekk.info>,
	Vlad URSU <vlad@ursu.me>,
	Simon Horman <horms@kernel.org>,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.12 057/117] e1000e: ignore uninitialized checksum word on tgp
Date: Wed, 30 Jul 2025 11:35:26 +0200
Message-ID: <20250730093235.774690049@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacek Kowalski <jacek@jacekk.info>

commit 61114910a5f6a71d0b6ea3b95082dfe031b19dfe upstream.

As described by Vitaly Lifshits:

> Starting from Tiger Lake, LAN NVM is locked for writes by SW, so the
> driver cannot perform checksum validation and correction. This means
> that all NVM images must leave the factory with correct checksum and
> checksum valid bit set.

Unfortunately some systems have left the factory with an uninitialized
value of 0xFFFF at register address 0x3F (checksum word location).
So on Tiger Lake platform we ignore the computed checksum when such
condition is encountered.

Signed-off-by: Jacek Kowalski <jacek@jacekk.info>
Tested-by: Vlad URSU <vlad@ursu.me>
Fixes: 4051f68318ca9 ("e1000e: Do not take care about recovery NVM checksum")
Cc: stable@vger.kernel.org
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Tested-by: Mor Bar-Gabay <morx.bar.gabay@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/e1000e/defines.h |    3 +++
 drivers/net/ethernet/intel/e1000e/nvm.c     |    6 ++++++
 2 files changed, 9 insertions(+)

--- a/drivers/net/ethernet/intel/e1000e/defines.h
+++ b/drivers/net/ethernet/intel/e1000e/defines.h
@@ -638,6 +638,9 @@
 /* For checksumming, the sum of all words in the NVM should equal 0xBABA. */
 #define NVM_SUM                    0xBABA
 
+/* Uninitialized ("empty") checksum word value */
+#define NVM_CHECKSUM_UNINITIALIZED 0xFFFF
+
 /* PBA (printed board assembly) number words */
 #define NVM_PBA_OFFSET_0           8
 #define NVM_PBA_OFFSET_1           9
--- a/drivers/net/ethernet/intel/e1000e/nvm.c
+++ b/drivers/net/ethernet/intel/e1000e/nvm.c
@@ -558,6 +558,12 @@ s32 e1000e_validate_nvm_checksum_generic
 		checksum += nvm_data;
 	}
 
+	if (hw->mac.type == e1000_pch_tgp &&
+	    nvm_data == NVM_CHECKSUM_UNINITIALIZED) {
+		e_dbg("Uninitialized NVM Checksum on TGP platform - ignoring\n");
+		return 0;
+	}
+
 	if (checksum != (u16)NVM_SUM) {
 		e_dbg("NVM Checksum Invalid\n");
 		return -E1000_ERR_NVM;


