Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519D3322754;
	Tue, 26 Aug 2025 11:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207221; cv=none; b=ZqVTcw+hlhdul/kAF9XbLVRpdzIGsu9Z+tHrgy+C1v+GnomoheBbUgsudLERYD2C+WozWW1F+L0sKKZJWPC7+QEHjwwJbocpEQwwCT5sisaoO8JPT0jIKUv3NJlDq/2LWaFnnDvJJUtnWMYivI6/q3G/vh3P0jSHLddXL1M4I+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207221; c=relaxed/simple;
	bh=P8u1w9aEgoRfCGagmp8ZK/RMTdcusCfIESvJOugv+Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bnwN5YvNMu3xmyK+oCP8OH0ygLAuiJCFeFe+QWJtEvBiZIEP1JqpDpr6EtR487TlYQbv+j4JRaUAJ6G1Mwha2ys5vT81eWdB24hd0hkcU7woDejg00EdXQAH3PCagDLuNiRzFNq+2e1+R8Y8kYdjxyXp4VdFKKAgwbIJOQaiZLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=husSf+oM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="husSf+oM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02D1C4CEF1;
	Tue, 26 Aug 2025 11:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207221;
	bh=P8u1w9aEgoRfCGagmp8ZK/RMTdcusCfIESvJOugv+Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=husSf+oMQjt6n+TQAUSESlp3dZmYf3zB0tmrbg0bvgpZ8rGA+AnjCu9Xqn7IwKLHq
	 GlHxLwyJo357RO8Rt5cbx872+uweUxFSHjnn5MnAzvJrnkVBRGuNhslbLlCGWS/GHB
	 jTqPOJvkgrZidzR8wLPEpue6vc3au9nwLI6o4bIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 6.16 080/457] wifi: brcmsmac: Remove const from tbl_ptr parameter in wlc_lcnphy_common_read_table()
Date: Tue, 26 Aug 2025 13:06:04 +0200
Message-ID: <20250826110939.353474197@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

commit 81284e86bf8849f8e98e8ead3ff5811926b2107f upstream.

A new warning in clang [1] complains that diq_start in
wlc_lcnphy_tx_iqlo_cal() is passed uninitialized as a const pointer to
wlc_lcnphy_common_read_table():

  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:2728:13: error: variable 'diq_start' is uninitialized when passed as a const pointer argument here [-Werror,-Wuninitialized-const-pointer]
   2728 |                                                      &diq_start, 1, 16, 69);
        |                                                       ^~~~~~~~~

The table pointer passed to wlc_lcnphy_common_read_table() should not be
considered constant, as wlc_phy_read_table() is ultimately going to
update it. Remove the const qualifier from the tbl_ptr to clear up the
warning.

Cc: stable@vger.kernel.org
Closes: https://github.com/ClangBuiltLinux/linux/issues/2108
Fixes: 5b435de0d786 ("net: wireless: add brcm80211 drivers")
Link: https://github.com/llvm/llvm-project/commit/00dacf8c22f065cb52efb14cd091d441f19b319e [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>>
Link: https://patch.msgid.link/20250715-brcmsmac-fix-uninit-const-pointer-v1-1-16e6a51a8ef4@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -919,7 +919,7 @@ void wlc_lcnphy_read_table(struct brcms_
 
 static void
 wlc_lcnphy_common_read_table(struct brcms_phy *pi, u32 tbl_id,
-			     const u16 *tbl_ptr, u32 tbl_len,
+			     u16 *tbl_ptr, u32 tbl_len,
 			     u32 tbl_width, u32 tbl_offset)
 {
 	struct phytbl_info tab;


