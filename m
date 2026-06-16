Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C367447A0D4;
	Tue, 16 Jun 2026 17:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630920; cv=none; b=ungTtlXNnRS5GCr8G2OTdHl4zAIX7XUtk2pKnfXxRBgzpuq4s6WVESDTZE0OSoyOzfNofq9PREgGygebnxr4V74TfSZutHpgxqUU+48fujpQp3yQGvrChDew8/wuYaC3kBJus7lmVlRhn0QutDj6xc8FRO2hwGyqTB1t2wgh8b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630920; c=relaxed/simple;
	bh=r6fRQyekDmpTXpE3Fsdmg1nOjSr9xLSam1gVD/beFqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZqfT/BXRrM7odPvOoK1telRVgS2pIIYzWi3KHdQIhLgEIsiv8JUSn1uzXfhiG1DH32BGpmdssjV8BhMNEXO1AY5pr6BTH5pOtv/95Vp+ye6ePHPUXHkCkLUapcOOzfG30+mXeBuj3euY4ykFPW0dxMPZB/IIsDRovmf4mzxAxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iWK0YXS7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iWK0YXS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563511F000E9;
	Tue, 16 Jun 2026 17:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630917;
	bh=ZZiYPaNt0Q/+9l2JjJUhX0R2zJ6tnHugcKwQYU0UPtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iWK0YXS7LVNjE0VLcx6gT8J+zjJ9J+m3UDpM9GFIs3aHHsw2jz3afxK3n7lUyaYcX
	 dDEeZ/TrBPVHODprrJVpeRbrsLimHy8ZR7Hf4XjFOtEbDptjMwvAwAYuanBe0gH9BX
	 C9t0L/f5VLXeAtgVm3/QT2QNRRoCJosyiO0Al6bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 121/522] ipv6: exthdrs: refresh nh pointer after ipv6_hop_jumbo()
Date: Tue, 16 Jun 2026 20:24:28 +0530
Message-ID: <20260616145131.643065024@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Iurman <justin.iurman@gmail.com>

commit d47548a36639095939f4747d4c43f2271366f565 upstream.

ipv6_hop_jumbo() calls pskb_trim_rcsum(), which can change skb pointers.
Let's recompute nh pointer to make sure any change won't mess things up.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Justin Iurman <justin.iurman@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260522112013.12342-1-justin.iurman@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/exthdrs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -186,6 +186,8 @@ static bool ip6_parse_tlv(bool hopbyhop,
 				case IPV6_TLV_JUMBO:
 					if (!ipv6_hop_jumbo(skb, off))
 						return false;
+
+					nh = skb_network_header(skb);
 					break;
 				case IPV6_TLV_CALIPSO:
 					if (!ipv6_hop_calipso(skb, off))


