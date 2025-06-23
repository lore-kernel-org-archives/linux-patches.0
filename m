Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8049119D084;
	Mon, 23 Jun 2025 21:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714924; cv=none; b=XgX4rEECXxHBJccJoTlcH4dJ69tvnLjVRzusvPPftb+B0AyC4fnFQth9mzJIpP6jpBSALWS6QFGeWRUI7Owns9IQ8okTGSUOODUO5boPh7pleArcR+lsP0wtglviQjA2YBzQcrL6XFo1hKa8l9oKJuBDV+o/JCgaD3NOunN8emA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714924; c=relaxed/simple;
	bh=kZf3SKoKzEgRUkfdKXxL48LWIK2vL/c1OVI2zE++OpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYD/OxTRFXicy7SC3rs92F6sYw1V2ilfGaTMhuN3xsFAFX9GaA9Kt66lqYei+2OfnRDuV+Qmb8pY6AEVZcIhUVCRvLNJtJzte4Y+v6j981hUVDb+5ai2WAFVQbJtsDrwAN+apYiRoyfSYeM+8qLDG2gPGo5UU94X2v7TCpGkxkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ALXlSD1b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ALXlSD1b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB597C4CEEA;
	Mon, 23 Jun 2025 21:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714924;
	bh=kZf3SKoKzEgRUkfdKXxL48LWIK2vL/c1OVI2zE++OpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ALXlSD1bSlfEe8MWiRHhwKMQI7ilWukq9tPRVD3mYmri4hYn2QgGcZYbjyJRiwblr
	 TupeCiNoXCxL1Irnr6mPffwVA/zIT39WlW81WeMSTQ4VPcDKoqjp1+ZCOogvj3UzIr
	 aYFVfHzy5koJhc771PZELVGZyHE771G3jL9KDJRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 426/592] wifi: iwlwifi: mld: Work around Clang loop unrolling bug
Date: Mon, 23 Jun 2025 15:06:24 +0200
Message-ID: <20250623130710.567963820@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit 368556dd234dc4a506a35a0c99c0eee2ab475c77 ]

The nested loop in iwl_mld_send_proto_offload() confuses Clang into
thinking there could be a final loop iteration past the end of the
"nsc" array (which is only 4 entries). The FORTIFY checking in memcmp()
(via ipv6_addr_cmp()) notices this (due to the available bytes in the
out-of-bounds position of &nsc[4] being 0), and errors out, failing
the build. For some reason (likely due to architectural loop unrolling
configurations), this is only exposed on ARM builds currently. Due to
Clang's lack of inline tracking[1], the warning is not very helpful:

include/linux/fortify-string.h:719:4: error: call to '__read_overflow' declared with 'error' attribute: detected read beyond size of object (1st parameter)
  719 |                         __read_overflow();
      |                         ^
1 error generated.

But this was tracked down to iwl_mld_send_proto_offload()'s
ipv6_addr_cmp() call.

An upstream Clang bug has been filed[2] to track this. For now fix the
build by explicitly bounding the inner loop by "n_nsc", which is what
"c" is already limited to.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://github.com/ClangBuiltLinux/linux/issues/2076
Link: https://github.com/llvm/llvm-project/pull/73552 [1]
Link: https://github.com/llvm/llvm-project/issues/136603 [2]
Link: https://lore.kernel.org/r/20250421204153.work.935-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/d3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/d3.c b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
index ee99298eebf59..7ce01ad3608e1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
@@ -1757,7 +1757,7 @@ iwl_mld_send_proto_offload(struct iwl_mld *mld,
 
 		addrconf_addr_solict_mult(&wowlan_data->target_ipv6_addrs[i],
 					  &solicited_addr);
-		for (j = 0; j < c; j++)
+		for (j = 0; j < n_nsc && j < c; j++)
 			if (ipv6_addr_cmp(&nsc[j].dest_ipv6_addr,
 					  &solicited_addr) == 0)
 				break;
-- 
2.39.5



