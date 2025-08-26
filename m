Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25826286881;
	Tue, 26 Aug 2025 14:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217309; cv=none; b=JNIzJNq3iQg1nKsJixlVVbZDWAesHI8t0gLwfspE9No9hvBRDyOlKxgvNodjOQF6yQULo7uweL4GuDeZZh/B9KocYdRuRlGWxthRiXEim9kLryfUg7QK7Aos3/taL3OLepsyVrrrZUcXwtwIzlCY9t1C0TqKaBZq/PSYRe9K/rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217309; c=relaxed/simple;
	bh=qoHc4H2alG9tr+b5dJlgvd2E7Af+ikPtn6Jom3dyzkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THhkofp6hnTSrJT9xBpLkWp0jALZQQk8HQCVkRCMuPAVelJLRFUnzfqyzjR2V9HKN80RuP/PSZGydqedXspOV9ocs/lqxp5Pagkg1bq3nb4lQGJ9QQNkcogPgu4c0NI7Vk8FIqpw91Pj+pzKbGSbseVaEQXH5ya/5kHUf3S3ONw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gn9WkWfc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gn9WkWfc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E661C4CEF1;
	Tue, 26 Aug 2025 14:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217308;
	bh=qoHc4H2alG9tr+b5dJlgvd2E7Af+ikPtn6Jom3dyzkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gn9WkWfcUtx5dpGb4jADAESFn+R23smeIlHHHAulu2jpngt2cvZoITPJYGZNO3CGb
	 82iClU6UEYmHa+SRMgNeY0v3TyYOvgRPN/OZ0esbck86RxoQX+6tQCxG4ctrvDKADV
	 vHi841lS/bkm/VSNIPCuSnI7yTXqrDM0sjttdNfE=
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
Subject: [PATCH 5.10 067/523] e1000e: ignore uninitialized checksum word on tgp
Date: Tue, 26 Aug 2025 13:04:37 +0200
Message-ID: <20250826110926.229254832@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


