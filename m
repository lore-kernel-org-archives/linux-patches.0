Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B272DE702;
	Sat, 12 Sep 2026 13:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219469; cv=none; b=MDd64pujsu/XHy/4L+BfW+g8J5uZV97jP9Fi0ZxiFz7G/7JzUkK9KgMkzN5Z85UQQ3pWQTQ9bg+ieNq34k2EGB3ywqcZSNwPttnqMGiVixkxpZSQbuUaraMZE3aA/vWbszxks8gaqgXIvX6YF8j/5Hs3FJwEifU9XsIk2p6wVOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219469; c=relaxed/simple;
	bh=8iuEnXzbqELnCHLbXVoUtbqC+9ghx5c57RBwgQ0/QN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9ibzDK4iI+1xXUIOyd2jlVmEZgoLUrYAxsV490SkUpbmnaDdg9QLRn0gauomeFbuNgcGK6Ty2WqJcsLYJbxM/6wDK+3SVjffdBYv3t8aZvtFwl0mV74++6aHa9ZoS+etwpDSR6rn+1+4BNoBlzNoZm39M9i8aNVajSzixOUcGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iBxXl7+u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iBxXl7+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB661F000FF;
	Sat, 12 Sep 2026 13:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219468;
	bh=C8cshYqsAEWBgvVf7mdIVGaj8Nxh4/Omhs4ntAcJ7Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iBxXl7+uhRPELHU+OpK7ZGRjJrEOVY50jIoTUiEywyhdgpDfU2ckkX2+MDQnHAvBt
	 Og3a8nK2nCa8saObQ3yZwVG04e8C2+4r71Y3ouQ3g48voVwjCDT8N3D3XdeTdHN7gb
	 Eil0cOEY/n11CsFJw9yIK36faNt6nvh87kOxczM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eryk Kubanski <e.kubanski@partner.samsung.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1358/1376] xsk: Fix offset calculation in unaligned mode
Date: Sat, 12 Sep 2026 09:03:04 +0200
Message-ID: <20260912065637.800724685@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: e.kubanski <e.kubanski@partner.samsung.com>

[ Upstream commit bf20af07909925ec0ae6cd4f3b7be0279dfa8768 ]

Bring back previous offset calculation behaviour
in AF_XDP unaligned umem mode.

In unaligned mode, upper 16 bits should contain
data offset, lower 48 bits should contain
only specific chunk location without offset.

Remove pool->headroom duplication into 48bit address.

Signed-off-by: Eryk Kubanski <e.kubanski@partner.samsung.com>
Fixes: bea14124bacb ("xsk: Get rid of xdp_buff_xsk::orig_addr")
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://patch.msgid.link/20250416112925.7501-1-e.kubanski@partner.samsung.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xsk_buff_pool.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 0b6d6cd16e3b3..53da7697d0096 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -231,8 +231,8 @@ static inline u64 xp_get_handle(struct xdp_buff_xsk *xskb,
 		return orig_addr;
 
 	offset = xskb->xdp.data - xskb->xdp.data_hard_start;
-	orig_addr -= offset;
 	offset += pool->headroom;
+	orig_addr -= offset;
 	return orig_addr + (offset << XSK_UNALIGNED_BUF_OFFSET_SHIFT);
 }
 
-- 
2.53.0



