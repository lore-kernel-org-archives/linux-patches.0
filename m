Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4203352FFE;
	Tue, 26 Aug 2025 13:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216609; cv=none; b=VkIlkjh1lj9RFIazl+QW9V36vzdxyzl78OpB7HyIiiGhRRBtATkrH5tEH9YWyZipH+qRICp7UTaGEZqu+yYe5G77KS8HqnajMcOPxKEWXmUlB3uubOQeZ9nkJIDyIv5HkWEjAo3EL6/GiuC/CZNvOtkTqc5/8+vAhOnSitFluzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216609; c=relaxed/simple;
	bh=Pwn7QalGwXgy82kICuMdI353EzukxSlrQOwIt71su2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgA0shvZKwJXu0hrP8HfFx7ttg4cRBiiFTtXOq69sDxUnHEsoD742exPIUaioMr27KSN8tDjt4fE9gUPFJQR/ghLg3q8gHEPNnH2543CuM1JaLZ8pKmgdlxW2MwgdP/YnpPZ+JdWEOeraNN9rZh4Xa2EiDN9X0ITGAMvEzaq+MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OXlN/fX8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OXlN/fX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7CBC113CF;
	Tue, 26 Aug 2025 13:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216608;
	bh=Pwn7QalGwXgy82kICuMdI353EzukxSlrQOwIt71su2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OXlN/fX8ZEzgHS83tkdGUGq6JA5Ekh/idkJJLJVnyxEtJlM5o9rSlR9i0j3ZLNW9O
	 pnnEQn+9nYBsB60wK+hceF2vkrdQetwZUrVWT6gxSjaGj0BSXnPRxwWCL4/evsTnlD
	 VCOO2qZ7eJYP/rTy/drkoYEOKuXwbhLpJSf13MRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 5.15 476/644] wifi: brcmsmac: Remove const from tbl_ptr parameter in wlc_lcnphy_common_read_table()
Date: Tue, 26 Aug 2025 13:09:27 +0200
Message-ID: <20250826110958.279014905@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


