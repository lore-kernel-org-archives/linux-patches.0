Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DFE443E26;
	Tue, 21 Jul 2026 22:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672363; cv=none; b=A4mNMH7fjFE3Zsby4AjqtbvnXKXIIkJJHlTlFqnd38Xtw1NMTgGIn3e/iyG01nqigBPa9mTvvbcnoPELe3YCaaAx9qzNxq6TlQX9XkGi2bv2lpt0psdF6yHpCYxAhnftACIQEU+aJRaWEgdbG0XSS4qeMGZyHnSk6PZ66t37PD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672363; c=relaxed/simple;
	bh=PAtVKiDvfsv/0IvTrj1NefmKwerltMkKv+Py3vIA//s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvgfFMeRl+Iro5c4653s5ctqtUw8OgGERoCJLsWASm5CazeVpz8hEFGoO3NlVySUYmvMD98Q35uNmhUVeIhwi9qa4ecr3dsX89BnGu9nwe5x95hCHg/aouYtmaVKHJJlM3vHteX/zZyPYQx9ExnZ3u0kSvA92ClSiJTQjIRLejo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PVQY/TAU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PVQY/TAU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A971F000E9;
	Tue, 21 Jul 2026 22:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672362;
	bh=Dl4CEOr3jTwMXlEgDLVb2ZSsvVb2PH1VkztQLmSNXLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PVQY/TAULwIgEhktCTU7H7MIYLjQjNMZa9/FgyaYk7vsFMui2Wm1m6adaREPTn+29
	 nlE5ngJ0T5rPekMOQ/Myw2/1VplobFWJmOYGcGPKG7tla4KVRDdeOSS8XmKXowuIBx
	 MP/6CrCR9F2V1nVGO6POzZaDJwavTMDzHM0OPSOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.15 597/843] batman-adv: tt: prevent TVLV OOB check overflow
Date: Tue, 21 Jul 2026 17:23:52 +0200
Message-ID: <20260721152419.477390179@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 7a581d9aaba8c82bd6177fa36b2588eea77f6e2b upstream.

A TT unicast TVLV contains the number of VLANs stored in it. This number is
an u16 and gets multiplied by the size of the struct
batadv_tvlv_tt_vlan_data (8 bytes). The size can therefore overflow the u16
used to store the tt_vlan_len. All additional safety checks to prevent
out-of-bounds access of the TVLV buffer are invalid due to this overflow.

Using size_t prevents this overflow and ensures that the safety checks
compare against the actual buffer requirements.

Cc: stable@vger.kernel.org
Fixes: 7ea7b4a14275 ("batman-adv: make the TT CRC logic VLAN specific")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/translation-table.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -4101,7 +4101,8 @@ static int batadv_tt_tvlv_unicast_handle
 					     u16 tvlv_value_len)
 {
 	struct batadv_tvlv_tt_data *tt_data;
-	u16 tt_vlan_len, tt_num_entries;
+	u16 tt_num_entries;
+	size_t tt_vlan_len;
 	char tt_flag;
 	bool ret;
 


