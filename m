Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74FD46F4A9;
	Tue, 21 Jul 2026 19:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662099; cv=none; b=GHk6Qbc4RejfE2yfU+O8Q9wwkd3pz6Hychzmor9I9H8f8gGJmwL5VzMOE/12cvAXI963lwyJOBQXO/ROMhe0erIZ/8W/xfSWmy73PO2cHYxAOMorhP2uSWnA+86CbO2Mo0/Ehk6yIVCQKbZ85YwunXwT7L2Ph4m1z/4npWFa9gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662099; c=relaxed/simple;
	bh=1LYQA34mVtj/tW8XhW1vdVLeiLnjF7ljl162yMruBcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aldQFELZqkEvJ/wGzyc23pTsDSOwyfIW10vz4J5wMYQg4rg0N3Zg9VvQO8pUANBHt8hU+w8QKM9MVWFwtXp4iEC1C85GwjVQJOpEcSky0TniLbZOw4G4My2J10wLFwn1/zP9PxOhr/E1uWyFI6XjxKb2/9HstW0USEgHTmdtH2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ol9bElRO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ol9bElRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C4C1F00A3D;
	Tue, 21 Jul 2026 19:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662092;
	bh=0xo2ybPT67NfHiutGO/0KKthRAXPZKMwU1PbNO9OoE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ol9bElROHWrYWZxlvturSZfCI4b5CV6QmLVtWXH8ANsIfC5QDY8/BOhhYSzyLtKTN
	 Dog2+Dc+cGlB/TpIa2Z18iVXus+RPep53RHa667djSw1fvhkJN6mOoOEwj1+Q9rz8Z
	 OGwSO7F3JvNarhTTpwMC+5hcDzJCzyzGBBzP+6AQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Zhu <zhuhui@kylinos.cn>,
	Dev Jain <dev.jain@arm.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0277/1276] vmalloc: fix NULL pointer dereference in is_vm_area_hugepages()
Date: Tue, 21 Jul 2026 17:12:00 +0200
Message-ID: <20260721152452.277715720@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Hui Zhu <zhuhui@kylinos.cn>

[ Upstream commit c55dd3b46c1208d6d2ea737a8aefef4aa4c70cb8 ]

find_vm_area() can return NULL if the given address is not a valid vmalloc
area.  Check the return value before dereferencing it to avoid a kernel
crash.

Link: https://lore.kernel.org/20260529014130.671291-1-hui.zhu@linux.dev
Fixes: 121e6f3258fe ("mm/vmalloc: hugepage vmalloc mappings")
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/vmalloc.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 1fce4f60677066..cb6fd04c6a510d 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -245,7 +245,9 @@ static inline bool is_vm_area_hugepages(const void *addr)
 	 * allocated in the vmalloc layer.
 	 */
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
-	return find_vm_area(addr)->page_order > 0;
+	struct vm_struct *area = find_vm_area(addr);
+
+	return area && area->page_order > 0;
 #else
 	return false;
 #endif
-- 
2.53.0



